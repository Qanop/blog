---
title: "Setting Up a Terragrunt with tfEnv, SOPS, TFLint, and pre-commit"
date: "2024-08-04T17:49:09.000Z"
template: "post"
draft: false
slug: "setting-up-a-terragrunt"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "Setting up a Terragrunt repository effectively maybe it's hard, but it's crucial for maintaining a clean, secure, and efficient infrastructure-as-code workflow."
socialImage: "media/server-4.jpg"
---
Setting up a Terragrunt repository effectively maybe it's hard, but it's crucial for maintaining a clean, secure, and efficient infrastructure-as-code workflow. With this post, I wanted to share a quick tips, how in project maintained by me, through few years of experimentation I was able to structuring Terragrunt repository and configuring it with SOPS for secrets management, TFLint for Terraform linting, Pre-commit hooks for maintaining code quality, Tofuutils/Tenv for environment management and more.

## Repository Structure
First things, firsts. Before we start going through entire process of setting up full scale Terraform project, I want to point, what additional programs and wrappers I use in my daily projects.

![Setting Up a Terragrunt with tfEnv, SOPS, TFLint, and pre-commit](/media/server-4.jpg)

Recommended stack at start of the project:
- [tfenv](https://github.com/tfutils/tfenv) / [tenv](https://github.com/tofuutils/tenv) for keeping same version of terraform in entire project
- [terragrunt](https://github.com/gruntwork-io/terragrunt) is a state and variables maintaining terraform wrapper
- [tflint](https://github.com/terraform-linters/tflint) for Terraform modules linting
- [tfsec](https://github.com/aquasecurity/tfsec) to keep the eye for any dangerous missed/misused resource configuration
- [sops](https://github.com/getsops/sops) because nobody is perfect and some variables can't be stored in plain-text
- [pre-commit](https://github.com/pre-commit/pre-commit) to make sure, that pushed changes are not malformed or need correcting after upload

Having that in mind, here's an overview of the recommended repository structure:

```terraform
. (root)
├── .pre-commit-config.yaml
├── .tflint.hcl
├── modules
│   ├── resource-group
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── output.tf
├── subscriptions
│   ├── .terraform-version
│   ├── global.hcl
│   ├── sops.global.enc.yml
│   ├── terragrunt.hcl
│   ├── nonprd
│   │   ├── sub.hcl
│   │   ├── sops.sub.enc.yml
│   │   ├── dev
│   │   │   ├── environment.hcl
│   │   │   ├── sops.environment.enc.yml
│   │   │   └── resource-group
│   │   │       └── terragrunt.hcl
│   │   └── tst
│   │       ├── environment.hcl
│   │       ├── sops.environment.enc.yml
│   │       └── resource-group
│   │           └── terragrunt.hcl
```

## Setting up basics
For start we need to create few files and folders to ensure, that future state maintaining through Terragrunt and sorted by folders tree will reflect future project structure, used regions, environments and other splits of used infrastructure.

```terraform
. (root)
├── modules
│   ├── resource-group
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── output.tf
├── subscriptions
│   ├── global.hcl
│   ├── terragrunt.hcl
│   ├── nonprd
│   │   ├── sub.hcl
│   │   └── dev
│   │       ├── environment.hcl
│   │       └── resource-group
│   │            └── terragrunt.hcl
```

## First, and most important file
The most important file is surely `subscriptions/terragrunt.hcl`. This file store all necessary information about project, build variable, connect to right cloud provider and keep connect to a state files holding information about current IaC.

File itself is split into four parts, each providing different purpose.
- `locals` take care of finding and using variables spread through project structure
- `provider` take care of the connection to the right project subscription
- `remote_state` is the set of the instructions, where and how to store project terraform state files
- `inputs` provide all read variables as default inputs to simplifies future use of modules in the project

```hcl
locals {
  global_vars      = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  sub_vars         = read_terragrunt_config(find_in_parent_folders("sub.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  sops_global_map      = try(yamldecode(sops_decrypt_file(find_in_parent_folders("sops.global.enc.yml"))), {})
  sops_sub_map         = try(yamldecode(sops_decrypt_file(find_in_parent_folders("sops.sub.enc.yml"))), {})
  sops_environment_map = try(yamldecode(sops_decrypt_file(find_in_parent_folders("sops.environment.enc.yml"))), {})

  resource_name_prefix = "${local.global_vars.locals.project_name}-${local.environment_vars.environment}"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
  subscription_id = "${local.sub_vars.locals.subscription_id}"
}
EOF
}

remote_state {
  backend = "azurerm"
  generate = { path = "backend.tf", if_exists = "overwrite_terragrunt" }
  config = {
    subscription_id      = local.sub_vars.locals.subscription_id
    resource_group_name  = local.sub_vars.locals.terraform_resource_group
    storage_account_name = local.sub_vars.locals.storage_account
    container_name       = "terraform"
    key = "${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = merge(
  local.global_vars.locals, local.sub_vars.locals, local.environment_vars.locals,
  local.sops_global_map, local.sops_sub_map, local.sops_environment_map,
  {
    resource_name_prefix        = local.resource_name_prefix
    project_tags = merge({
        Environment   = local.environment_vars.environment
        IaC           = "Terraform"
      },
      lookup(local.subscription_vars.locals, "subscription_project_tags", {}),
      lookup(local.environment_vars.locals, "environment_project_tags", {}),
    )
  }
)
```

## Specify the Terraform version
To ensure consistency across different environments, the best approach is to set one version of used program in the project. For this, it's recommended to use tfenv or tenv (Fork of tfenv, supporting also OpenTOFU and Windows system). Setting of it is pretty simple. In the `subscriptions` folder, we need to create file `.terraform-version`. This file contains version, that is recommended to use in project. Everytime, that terragrunt use terraform version control, it look at this file and pick up right binary.

```
1.10.0
```

## Variable files
To keep repeating variables in one place, we need to create those files:
- `subscriptions/global.hcl` keep configurations that apply to all environments within the repository.
- `subscriptions/nonprd/sub.hcl` Specific configurations for the non-production subscription.
- `subscriptions/nonprd/dev/environment.hcl` Specific configurations for the only this environment.

After loading them into main `subscriptions/terragrunt.hcl`, they are generally viable in every default inputs field of used module. By this case, only additional inputs, that are required for working module are dependencies ones.

## Using SOPS for Secrets Management
SOPS is used to manage secrets securely. Encrypted files like `sops.global.enc.yml`, `sops.sub.enc.yml`, and `sops.environment.enc.yml` store sensitive data. To decrypt and use these files, user should usually have permissions to read keyvault keys on provided cloud or could verify its GPG fingerprint registered in SOPS files.

## Maintain code quality with pre-commit
To ensure that code quality checks are performed before any commits, it's good to setup right git hooks. Provided configuration below ensure, that code is formatted, keep good code structure and integrity, fixing minor git problems, and finally cleaning up cache so even other systems used in projects like ARM, x32, x86 could still run terragrunt commands without any additional added compiler steps.

```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: 1.92.1 # Get the latest from: https://github.com/antonbabenko/pre-commit-terraform/releases
    hooks:
      - id: terraform_fmt
      - id: terragrunt_fmt
#      - id: terraform_tfsec # Can be turned on later, in advanced stage of infrastructure
      - id: terraform_tflint
        args:
          - >
            --args=
            --color
            --config=__GIT_WORKING_DIR__/.tflint.hcl
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: fix-encoding-pragma
      - id: destroyed-symlinks
      - id: check-yaml
        args: [--allow-multiple-documents]
      - id: sort-simple-yaml
      - id: end-of-file-fixer
      - id: trailing-whitespace
  - repo: local
    hooks:
      - id: cache-clean-up
        name: cache-clean-up
        entry: bash -c 'find . -name ".terragrunt-cache" -type d -print0 | xargs -0 /bin/rm -fR && find . -name ".terraform.lock.hcl" -type f -print0 | xargs -0 /bin/rm -fR && exit 0'
        language: system
        types: [file]
        pass_filenames: false
        always_run: true
```

Later, to simply start using it, we can tun this command
```bash
pre-commit install
```

## Lint your Terraform code according to best practices
TFLint is a great tool to keep code in good shape. There is a lot of guides how to set and use it, but for me this `.tflint.hcl` settings holding the most sense and not restricting writer too much.

```hcl
config {
  force = false
}

plugin "azurerm" {
  enabled = true
  version = "0.20.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Disallow deprecated (0.11-style) interpolation
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Disallow legacy dot index syntax.
rule "terraform_deprecated_index" {
  enabled = true
}

# Disallow variables, data sources, and locals that are declared but never used.
rule "terraform_unused_declarations" {
  enabled = true
}

# Disallow // comments in favor of #.
rule "terraform_comment_syntax" {
  enabled = false
}

# Disallow output declarations without description.
rule "terraform_documented_outputs" {
  enabled = true
}

# Disallow variable declarations without description.
rule "terraform_documented_variables" {
  enabled = true
}

# Disallow variable declarations without type.
rule "terraform_typed_variables" {
  enabled = true
}

# Disallow specifying a git or mercurial repository as a module source without pinning to a version.
rule "terraform_module_pinned_source" {
  enabled = true
}

# Enforces naming conventions
rule "terraform_naming_convention" {
  enabled = true

  variable {
    format = "snake_case"
  }

  locals {
    format = "snake_case"
  }

  output {
    format = "snake_case"
  }

  resource {
    format = "snake_case"
  }

  module {
    format = "snake_case"
  }

  data {
    format = "snake_case"
  }
}

# Require that all providers have version constraints through required_providers.
rule "terraform_required_providers" {
  enabled = true
}

# Require that all providers are used.
rule "terraform_unused_required_providers" {
  enabled = true
}

# Ensure that a module complies with the Terraform Standard Module Structure
rule "terraform_standard_module_structure" {
  enabled = true
}

# terraform.workspace should not be used with a "remote" backend with remote execution.
rule "terraform_workspace_remote" {
  enabled = true
}

# Disallow terraform declarations without require_version.
rule "terraform_required_version" {
  enabled = false
}
```

## Conclusion
By following this structure and using the specified tools, it's easier to maintain a clean, secure, and efficient Terragrunt repository.
Pre-commit hooks ensure code quality, tfEnv keep eye on use of correct terraform version, TFLint enforces best practices, and SOPS manages secrets securely.