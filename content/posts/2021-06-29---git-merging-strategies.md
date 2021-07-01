---
title: Git Merging Strategies
date: "2021-06-30T18:23:03.000Z"
template: "post"
draft: false
slug: "git-merging-strategies"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "Git is a great tool for managing your code version. It is also a tool where we can easily draw figures such as triangles, trapezoids, and other figures. How to find yourself on a railroad crossing? Try not to get lost at our train station?"
socialImage: "media/server-2.jpg"
---
Git is a great tool for managing your code version. It is also a tool where we can easily draw figures such as triangles, trapezoids, and other figures. How to find yourself on a railroad crossing? Try not to get lost at our train station?

## Simpler branches with `git rebase`

When creating the code, we don't pay attention to what our branch looks like. It is logical, after all, the code and changes are only ours, even if we have many commits - and you know, it's better to have changes saved in the cloud than locally on the disk. On the other hand, at the time of merging, it causes some kind of discomfort for the committer and the code merger. In order not to bury ourselves in a thousand commits, before sending our final changes, we can use some useful commands that will improve the visibility of our branch
The appearance of the tree after merging, depending on the method used

![Merge strategies](/media/git-merging-strategies/merge-strategies.png)

The most classic method of combining changes is classic merge. Executing a simple command is an ideal option for projects carried out by one-person teams. However, it has one problem, when detecting conflicts between two branches, it forces checking the data on both sides for each commit that the user committed and comparing the changes since disconnected from the parent branch.

```shell
git checkout master
git merge topic
```

To limit the number of visible changes after merging branches, you can use the squash method when merging branches. It causes that all the commits that we have done so far on the branch topic will be rewritten and merged as one new commit. this means that the displayed history of our changes will have only one summary commit in the tree.

```shell
git checkout master
git merge topic --squash
```

The last operation requires slightly more effort, but its result in the change tree looks the clearest. Especially in repositories with a lot of changes and more people working on it. This method is to overwrite the commit and the entire branch topic before submitting the changes for merge request/pull request/code review. First of all, in this method, we are sure that the uploaded changes are the latest from the branch we use as a parent. Secondly, it gives us control over the content of the commits by enabling them to be edited and arranged appropriately. The third argument is a very short tree branch that we will create after merging. At best, this branch will create a clear triangle of changes - that is, reading the changes from the parent's latest commit, uploading our changes, and confirming the branch connection. Building such a branch is much clearer than scrolling through the entire page of a trapezoidal merged branch changes _(changes that started, for example, 18 commits ago, but adding only one line of code in today's commit)_. In addition to readability, the committing person is also sure that the changes he/she uploaded are up-to-date and will not have conflicts with the parent branch, because we already have the latest changes.

```shell
git checkout topic
git rebase --interactive HEAD~X # X is the number of commits that we want to rewrite (to be squashed or message edited)
# more about rebase and its use-cases https://git-scm.com/docs/git-rebase#_interactive_mode
git fetch origin/master # get lastest master commit without checking out to it
git rebase origin/master # rebase (rewrite) all commits on a branch to a new place above the lastest master changes
git push topic --force # rewritten branch must be pushed with force because it has whole new history and parent ID
```
