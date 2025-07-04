---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a series (stack) of logical git commits, make sure that each commit is holistic, don't commit a new library separately from the code that uses it.

Write a good commit message with excellent first line, bullet point list in summary.