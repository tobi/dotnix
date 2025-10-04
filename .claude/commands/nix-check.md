---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git reset:*), Bash(git add:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(nix flake check:*)
description: Check nix flake for errors
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`


```bash
$ pwd
!`pwd`
$ nix flake check --no-build
!`nix flake check --no-build`
```

## Your task

fix errors in the output if any