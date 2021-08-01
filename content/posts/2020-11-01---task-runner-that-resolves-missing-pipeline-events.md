---
title: Task runner that resolves missing pipeline events
date: "2020-11-01T17:01:53.000Z"
template: "post"
draft: false
slug: "task-runner-that-resolves-missing-pipeline-events"
category: "Technology"
tags:
  - "Technology"
  - "Dev"
  - "CI / CD"
description: "When creating pipelines for releasing things to the environment, we may run into the problem of handling too few events. By searching the internet, we can find a quite interesting task runner library that will help us in missing pipelines events"
socialImage: "media/server-2.jpg"
---
When creating pipelines for releasing things to the environment, we may run into the problem of handling too few events. While searching the internet, I encountered an interesting task runner library. Upon closer acquaintance with the library, it will be possible to supplement the missing functions of pipelines offered in cloud solutions.

## Makefile, bash or something different?
Bash or Makefile files are most often used when building commands to improve the output. While this solution runs all scripts and allows for a large management of functions, it lacks error handling or API communication. [Pypyr](https://pypyr.io/) is a task runner for automation pipelines script as sequential task workflow steps in yaml. 

It has many functions, thanks to which we can properly automate the work of tasks. Most importantly, it has been quite successful at capturing and working on exceptions. Steps of activities can be combined, tasks described in detail, and also modified using environmental variables and data stored in the middle of the task. Additionally, as a basic functionality, we can also write logical conditions and even run python code. This solution gives a lot of possibilities for code actions. It is certainly easier to manage in already typical Python projects, where the work of publishing tasks does not have to be done by bash itself. While the first meeting on the website with the library may scare you off with its structure at the beginning, further delving into the topic shows that complex tasks can be much clearer for future activities in the project.

```yaml
# This is an example showing the anatomy of a pypyr pipeline
# A pipeline should be saved as {working dir}/mypipelinename.yaml.
# Run the pipeline from {working dir} like this: pypyr mypipelinename

# optional. set this to pass cli arguments to the pipeline.
context_parser: my.custom.parser

# mandatory.
steps: # step-group. every pipeline starts with steps unless you tell pypyr differently.
  - my.package.my.module # simple step pointing at a python module in a package
  - mymodule # simple step pointing at a python file
  - name: pypyr.steps.default
    in:
      defaults:
        ifConinue: False # optional. Check if command have set on ifContinue variable, if not, set default.
  - name: my.package.another.module # complex step. It contains a description and in parameters.
    description: Optional description is for humans. It's any text that makes your life easier.
    in: # optional. Set these key-value pairs in context for this step.
      parameter1: value1
      parameter2: value2
    run: {ifContinue} # optional. Runs this step if True, skips step if False. Defaults True if not specified.
    skip: False # optional. Skips this step if True, runs step if False. Defaults False if not specified.
    swallow: False # optional. Swallows any errors raised by the step. Defaults False if not specified.

# optional.
on_success: # step-group
  - my.first.success.step
  - my.second.success.step

# optional.
on_failure: # step-group
  - my.failure.handler.step
  - my.failure.handler.notifier
  ```

  ## Summary
  The options provided by the pipeline configured in this way allow you to control the issue and with the appropriate status of a task or individual steps, we can even send an appropriate notification or withdraw changes from the server. [Pypyr](https://pypyr.io/) is a nice tool that can come in handy for more complex project steps and can become a good alternative to the Makefile's all-in-one tasks.