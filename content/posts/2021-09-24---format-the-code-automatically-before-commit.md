---
title: Format the code automatically before commit
date: "2021-09-24T14:56:53.000Z"
template: "post"
draft: false
slug: "format-the-code-automatically-before-commit"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
  - "CI / CD"
description: "There is a situation where we forget to format our code before submitting changes. But what if git does it for us?"
socialImage: "media/server-8.jpg"
---
There is a situation where we forget to format our code to one standard before submitting changes. But what if git does it for us?

There are a couple of solutions, like plugging directly into git hooks commands, or using a framework like [https://pre-commit.com/](https://pre-commit.com/) which will visually help us check out the project, and add code checking plugins for us.

```shell
# Format code with terraform & terragrunt standard
terragrunt hclfmt
terraform fmt --recursive

# Add missing new-line in files
git ls-files -z | while IFS= read -rd '' f; do tail -c1 < "$f" | read -r _ || echo >> "$f"; done
```

It's especially useful when we need to run a lot of commands responsible for testing, linter code and checking integration
