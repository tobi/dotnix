---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git reset:*), Bash(git add:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(git rebase:*)
description: Create a git commit
---

# resetting staged

`!git reset HEAD .`

## Context

Current branch: !`git branch --show-current`

Current git status:
<status>
!`git status`
</status>

Recent commits:
<log>
!`git log --oneline -10`
</log>

## Your task

Based on the local changes, take one of these two options:

* if the local changes are roughly of one logical task and unit of work, create a single commit and go ahead and commit it.
* if there are multiple seemingly unrelated units of work present, first ask and give a bullet point per commit you are planning to do in the stack. Very very rarely should there be more than 3 commits in the stack. Don't make commits before you asked and presented the plan of the stack.

## Reminders

* write a good commit message with excellent first line, bullet point list in summary.
* Under no circumstances commit binaries or large (1mb+) files, please stop the process and warn of those first and wait for me to decide what to do.
* Do not mention claude or any ai in the commit message. Do not add yourself to the Co-Authored-By trailer.
