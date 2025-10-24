---
name: nix-tooling
description: Expert guidance for using Nix CLI tools, nix repl, MCP NixOS server, and finding packages/options/documentation
tags: [nix, nixos, home-manager, packages, search, repl]
---

# Nix Tooling Expert Skill

You are now an expert at using Nix command-line tools and the MCP NixOS server to search packages, explore options, find documentation, and validate configurations. This skill provides comprehensive guidance on effectively using the Nix ecosystem's tooling.

## Core Capabilities

### 1. MCP NixOS Server Tools (PRIMARY TOOL)

The MCP NixOS server provides powerful tools that should be your FIRST choice for Nix-related searches:

#### Package Search
```
mcp__mcp-nixos__nixos_search - Search nixpkgs for packages
mcp__mcp-nixos__nixos_info - Get detailed info about a specific package
mcp__mcp-nixos__nixhub_package_versions - Find all available versions of a package
mcp__mcp-nixos__nixhub_find_version - Find a specific version of a package
```

**When to use:**
- User asks "how do I install X?"
- User needs a specific package or tool
- User wants to know what versions are available
- User asks "is there a package for Y?"

**Best practices:**
- Start with `nixos_search` to find packages by name or description
- Use `nixos_info` to get full details (description, homepage, license, options)
- Check `nixhub_package_versions` for version history and availability
- Search broadly first, then narrow down with specific terms

#### NixOS Options
```
mcp__mcp-nixos__nixos_search - Also searches NixOS options
mcp__mcp-nixos__nixos_info - Get detailed option documentation
```

**When to use:**
- User wants to configure a NixOS service
- User asks about system-level settings
- User needs to know valid values for an option

**Best practices:**
- Search for service names (e.g., "postgresql", "nginx")
- Check option types and default values
- Read example values to understand expected format

#### Home Manager Options
```
mcp__mcp-nixos__home_manager_search - Search Home Manager options
mcp__mcp-nixos__home_manager_info - Get detailed option documentation
mcp__mcp-nixos__home_manager_list_options - List all options (use sparingly)
mcp__mcp-nixos__home_manager_options_by_prefix - Get options by prefix (e.g., "programs.git")
```

**When to use:**
- User wants to configure user-level applications
- User asks about dotfile management
- User needs Home Manager module options

**Best practices:**
- Use `options_by_prefix` when you know the module (e.g., "programs.alacritty")
- Search for app names to find relevant modules
- Check examples to understand option structure

#### Flakes and Channels
```
mcp__mcp-nixos__nixos_flakes_search - Search for flakes
mcp__mcp-nixos__nixos_flakes_stats - Get flake statistics
mcp__mcp-nixos__nixos_channels - List available channels
```

**When to use:**
- User wants to add a flake input
- User asks about nixpkgs branches/channels
- User needs community flakes

### 2. Nix Command Line Tools

#### nix search - Package Discovery
```bash
# Search nixpkgs for packages
nix search nixpkgs firefox
nix search nixpkgs 'python.*pandas'

# Search with regex
nix search nixpkgs '^python3.*$'

# Show all details
nix search nixpkgs --json firefox | jq
```

**When to use:**
- Quick package name lookup
- Finding multiple related packages
- Regex-based searches

**Tips:**
- Use quotes for regex patterns
- Add `--json` for machine-readable output
- Search is case-insensitive by default

#### nix eval - Expression Evaluation
```bash
# Evaluate a simple expression
nix eval --expr '1 + 1'

# Evaluate from flake
nix eval .#nixosConfigurations.frameling.config.system.stateVersion

# Check option value
nix eval .#nixosConfigurations.frameling.config.services.openssh.enable

# Evaluate with JSON output
nix eval --json .#nixosConfigurations.frameling.config.environment.systemPackages --apply 'map (p: p.name)'

# Get attribute paths
nix eval --apply builtins.attrNames .#nixosConfigurations
```

**When to use:**
- Quickly test Nix expressions
- Check configuration values without rebuilding
- Validate that attributes exist
- Extract specific config values

**Tips:**
- Use `--json` for structured output
- Use `--apply` to transform results
- Combine with `jq` for complex queries
- Use `--raw` for string values without quotes

#### nix repl - Interactive Exploration
```bash
# Start repl with flake
nix repl
:lf .  # Load flake

# Explore configurations
outputs.nixosConfigurations.frameling.config.services
outputs.nixosConfigurations.frameling.options.services.openssh

# Tab completion works!
outputs.nixosConfigurations.<TAB>

# Load specific file
:l <nixpkgs>
:l ./flake.nix

# Useful repl commands
:?        # Help
:lf .     # Load flake
:l <path> # Load file
:r        # Reload
:t <expr> # Show type
:q        # Quit
```

**When to use:**
- Exploring option structures interactively
- Testing complex expressions
- Understanding package attributes
- Debugging evaluation issues

**Tips:**
- Use TAB completion extensively
- `:lf .` loads your flake into scope
- Access via `outputs.nixosConfigurations.<name>.config`
- Use `:t` to check types of values

#### nix flake check - Validation
```bash
# Check flake for errors (fast, no builds)
nix flake check --no-build

# Full check including builds
nix flake check

# Show detailed output
nix flake check --show-trace
```

**When to use:**
- After modifying flake.nix
- Before committing changes
- To catch evaluation errors

#### nix show-config - System Info
```bash
# Show all Nix configuration
nix show-config

# Find specific settings
nix show-config | grep experimental
nix show-config | grep trusted-users
```

**When to use:**
- Debugging Nix daemon issues
- Checking feature flags
- Verifying paths and settings

#### nix run - Quick Testing
```bash
# Test a package without installing
nix run nixpkgs#hello

# Run from flake
nix run .#somePackage

# Run specific version
nix run github:nixos/nixpkgs/nixos-23.11#firefox
```

**When to use:**
- Testing packages before adding to config
- Running one-off commands
- Trying different package versions

#### nix develop - Dev Shells
```bash
# Enter dev shell from flake
nix develop

# Run command in dev shell
nix develop -c bash
nix develop -c which gcc

# Show what's in the shell
nix develop --print-build-logs
```

**When to use:**
- Accessing build tools
- Testing in clean environment
- Running project-specific tools

### 3. Finding Documentation

#### Online Resources
```bash
# Use WebSearch for latest docs
WebSearch: "nixos options <service-name> site:nixos.org"
WebSearch: "home manager <program-name> options"
WebSearch: "nix expression language <concept>"

# Use WebFetch for specific pages
WebFetch: https://nixos.org/manual/nixos/stable/options.html
WebFetch: https://nix-community.github.io/home-manager/options.html
```

#### Package Documentation
```bash
# Get package meta info via MCP
mcp__mcp-nixos__nixos_info <package-name>

# Check package source
nix eval nixpkgs#<package>.meta.homepage
nix eval nixpkgs#<package>.meta.description

# Read package derivation
nix show-derivation nixpkgs#<package>
```

#### Man Pages (when available locally)
```bash
# NixOS options
man configuration.nix

# Home Manager (if installed)
man home-configuration.nix
```

### 4. Common Workflows

#### Finding a Package
1. Start with MCP search: `mcp__mcp-nixos__nixos_search "package-name"`
2. Check versions: `mcp__mcp-nixos__nixhub_package_versions "package-name"`
3. Get details: `mcp__mcp-nixos__nixos_info "package-name"`
4. Verify in repl: `:lf .` then `outputs.nixosConfigurations.frameling.pkgs.<package>`

#### Exploring Service Options
1. Search for service: `mcp__mcp-nixos__nixos_search "service-name"`
2. Get option docs: `mcp__mcp-nixos__nixos_info "services.<service>.<option>"`
3. Check in repl: `outputs.nixosConfigurations.frameling.options.services.<service>`
4. Test configuration: `nix eval .#nixosConfigurations.frameling.config.services.<service>`

#### Finding Home Manager Settings
1. Search module: `mcp__mcp-nixos__home_manager_search "program-name"`
2. List options: `mcp__mcp-nixos__home_manager_options_by_prefix "programs.<name>"`
3. Get details: `mcp__mcp-nixos__home_manager_info "programs.<name>.<option>"`
4. Verify: Check examples in search results

#### Validating Configuration
1. Quick check: `nix flake check --no-build`
2. Eval specific option: `nix eval .#nixosConfigurations.<machine>.config.<path>`
3. Test in repl: Load flake and explore interactively
4. Build test: `nixos-rebuild build --flake .#<machine>`

#### Debugging Evaluation Errors
1. Use `--show-trace` flag: `nix eval --show-trace`
2. Test in repl for better error messages
3. Break down complex expressions
4. Check imports and paths exist
5. Verify option names with MCP tools

### 5. Best Practices

#### Search Strategy
1. **Start broad, narrow down**: Search general terms first, then refine
2. **Use MCP first**: Faster and more reliable than web searches
3. **Check multiple sources**: Package search + option search + web docs
4. **Verify in repl**: Confirm attributes exist before using them

#### Performance Tips
- Use `--no-build` with `nix flake check` for fast validation
- Use `nix eval` to check values without full rebuild
- Cache search results - MCP searches are fast but not instant
- Use `options_by_prefix` instead of listing all options

#### Expression Testing
1. **Test in repl first**: Interactive feedback is faster
2. **Use eval for quick checks**: No need to rebuild
3. **Validate syntax**: `nix eval --expr` catches syntax errors
4. **Check types**: Use `:t` in repl to verify types

#### Documentation Workflow
1. **MCP for options**: Most reliable for option documentation
2. **WebFetch for manuals**: Official docs for concepts
3. **WebSearch for examples**: Community solutions and patterns
4. **Source code**: When in doubt, read the module source

### 6. Troubleshooting

#### "Attribute not found"
1. Check spelling in repl with TAB completion
2. Verify option exists: `mcp__mcp-nixos__nixos_search "<option>"`
3. Check if it's behind a feature flag or module import
4. Eval parent attribute to see what's available

#### "Infinite recursion"
1. Check for circular dependencies in imports
2. Look for self-references in overlay/override
3. Use `--show-trace` to find recursion point
4. Test smaller pieces in repl

#### "Cannot coerce X to Y"
1. Check option type: `mcp__mcp-nixos__nixos_info "<option>"`
2. Use `:t` in repl to verify types
3. Convert types explicitly (toString, toInt, etc.)
4. Check if value needs to be wrapped (list, attrset)

#### Package not found
1. Search variations: `mcp__mcp-nixos__nixos_search "<name>"`
2. Check package name vs attribute name
3. Try nixhub: `mcp__mcp-nixos__nixhub_find_version "<name>"`
4. Search in repl: `:lf .` then explore `outputs.nixosConfigurations.frameling.pkgs`

### 7. Quick Reference

#### Essential Commands
```bash
# Search packages
nix search nixpkgs <term>
mcp__mcp-nixos__nixos_search "<term>"

# Explore interactively
nix repl
:lf .

# Check config
nix flake check --no-build

# Evaluate expression
nix eval --expr '<expression>'
nix eval .#<attribute-path>

# Test package
nix run nixpkgs#<package>

# Get option docs
mcp__mcp-nixos__nixos_info "<option-path>"
mcp__mcp-nixos__home_manager_info "<option-path>"
```

#### MCP Tool Quick Reference
| Task | Tool |
|------|------|
| Find package | `mcp__mcp-nixos__nixos_search` |
| Package details | `mcp__mcp-nixos__nixos_info` |
| Package versions | `mcp__mcp-nixos__nixhub_package_versions` |
| NixOS option | `mcp__mcp-nixos__nixos_search` + `nixos_info` |
| HM option | `mcp__mcp-nixos__home_manager_search` + `home_manager_info` |
| HM module options | `mcp__mcp-nixos__home_manager_options_by_prefix` |
| Find flake | `mcp__mcp-nixos__nixos_flakes_search` |

## Usage Patterns

When a user asks about Nix packages or configuration:

1. **Identify the task type**:
   - Package search → Use MCP package search
   - NixOS option → Use MCP NixOS search/info
   - Home Manager option → Use MCP Home Manager tools
   - Configuration validation → Use nix flake check + nix eval
   - Expression testing → Use nix repl or nix eval

2. **Choose the right tool**:
   - Prefer MCP tools for searches (faster, better results)
   - Use nix repl for exploration and learning
   - Use nix eval for quick value checks
   - Use nix flake check for validation

3. **Provide complete answers**:
   - Show the search process
   - Include relevant documentation links
   - Give working configuration examples
   - Explain what each option does

4. **Validate before suggesting**:
   - Verify packages exist
   - Check option types match
   - Test expressions when possible
   - Confirm compatibility with user's setup

## Remember

- **MCP tools are your primary weapon** - use them liberally
- **nix repl is your exploration tool** - when in doubt, open repl
- **nix eval is your quick check** - validate without rebuilding
- **Always verify** - don't assume package/option names
- **Show your work** - explain the search process to help users learn
- **Test before suggesting** - use repl/eval to confirm it works

You are now equipped to expertly navigate the Nix ecosystem's tooling and help users find exactly what they need!
