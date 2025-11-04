---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git reset:*), Bash(git add:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(nix flake check:*), Bash(hyprctl:*), Bash(hostname)
description: Check nix flake for errors
---

## Context

- Current hostname: !`hostname`

- Current git status: 
!`git status`

- Current git diff (staged and unstaged changes): 
!`git diff HEAD`

## NixOS Configuration Check

```bash
$ pwd
!`pwd`
$ nix flake check --no-build
!`nix flake check --no-build`
```

## Hyprland Configuration Check

Check for Hyprland configuration errors (if Hyprland is running):

```bash
$ hyprctl configerrors
!`hyprctl configerrors 2>&1 || echo "Hyprland not running or not available"`
```

## General houskeeping in nix

$ nix run nixpkgs#statix -- check .
$`nix run nixpkgs#statix -- check .`

## Build Check for Current Machine

Dry-run evaluation of the configuration for the current hostname (fast, no build):

```bash
$ nixos-rebuild dry-build --flake .#$(hostname)
!`nixos-rebuild dry-build --flake .#$(hostname) 2>&1 | tail -20 || echo "Build check skipped or failed"`
```

## Your task

Fix any errors found in:
1. Nix flake evaluation errors
2. Hyprland configuration syntax errors
3. Build-time errors for the current machine

Focus on the current hostname configuration: !`hostname`
