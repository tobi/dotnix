---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git reset:*), Bash(git add:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*)
description: Create a git commit
---

## resetting staged

`!git reset HEAD .`

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a series (stack) of logical git commits, make sure that each commit is holistic, don't commit a new library separately from the code that uses it. Aim for no more than 3 commits unless is definitely makes sense to go beyond it.

## Reminders

- write a good commit message with excellent first line, bullet point list in summary.
- Under no circumstances commit binaries or large (1mb+) files, please stop the process and warn of those first and wait for me to decide what to do.

