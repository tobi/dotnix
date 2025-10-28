# Nix Code Linting and Quality Improvements

Run comprehensive code quality checks and apply automated fixes to the NixOS configuration.

## Required Permissions

This command requires the following tools to be allowed in `.claude/settings.local.json`:
- `Bash(nix run:*)` - to run statix and deadnix linters
- `Bash(nix flake check:*)` - to verify configuration validity
- `Bash(git add:*)` - to stage changes
- `Bash(git commit:*)` - to commit improvements
- `SlashCommand(/nix-lint)` - to enable this command

## Your Task

1. **Run Initial Checks**
   - Run `nix run nixpkgs#statix -- check .` to identify linting issues
   - Run `nix run nixpkgs#deadnix -- .` to find dead code
   - Count and categorize the issues found

2. **Apply Automated Fixes**
   - Run `nix run nixpkgs#statix -- fix .` to auto-fix statix warnings
   - This will automatically handle:
     - Empty function patterns `{ ... }:` → `_:`
     - Eta-reductions
     - Unnecessary parentheses
     - Some inherit patterns

3. **Manual Fixes for Repeated Keys**
   - Identify remaining "repeated keys in attribute sets" warnings
   - Manually merge scattered attribute declarations into unified blocks
   - Common patterns to fix:
     ```nix
     # Before (repeated keys)
     home.stateVersion = "25.05";
     home.username = "user";
     home.sessionVariables = { ... };

     # After (merged)
     home = {
       stateVersion = "25.05";
       username = "user";
       sessionVariables = { ... };
     };
     ```
   - Apply to: `home.*`, `programs.*`, `dotnix.*`, `boot.*`, `services.*`, etc.

4. **Verify All Changes**
   - Run `nix flake check --no-build` to ensure configuration is still valid
   - Run statix and deadnix checks again to confirm improvements
   - Show before/after statistics

5. **Commit Changes**
   - Stage all changes with `git add -A`
   - Create a descriptive commit with:
     - Summary of fixes applied
     - Number of files changed
     - Reduction in warning count
   - Use commit message format:
     ```
     style: apply Nix linting fixes across codebase

     Code quality improvements from statix and deadnix:
     - [List specific fix types applied]
     - [Show warning count reduction: X → Y]
     - [Mention file count and scope]
     ```

## Guidelines

- Always run flake check after making changes to catch any breaking modifications
- Remaining warnings in auto-generated files (like hardware-configuration.nix) can be ignored
- Focus on fixing issues in hand-written configuration files first
- If any manual fix breaks the build, revert that specific change and document it
- Show clear progress updates with before/after metrics

## Success Criteria

- Flake check passes ✅
- No dead code detected (deadnix returns 0 issues) ✅
- Statix warnings significantly reduced (ideally 50%+ reduction) ✅
- All changes committed with descriptive message ✅
