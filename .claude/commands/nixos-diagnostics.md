---
allowed-tools: Bash(hostname), Bash(lsblk), Bash(lshw:*), Bash(journalctl:*), Bash(cat:*), Bash(ls:*), Bash(lspci:*), Bash(lsusb:*),Bash(nix-shell:*), Bash(systemctl:*), Bash/uname, Bash/wc, Bash/grep, Bash/find, Bash(nix:*), Bash/pwd, Bash/realpath, mcp__mcp-nixos__nixos_search, mcp__mcp-nixos__nixos_search, mcp__mcp-nixos__home_manager_search, mcp__mcp-(nixos:*)
description: Collect and summarize NixOS hardware, configuration, and log metadata for LLM-based diagnostics, including flake directory, rebuild logs, and flake check.
---

<system_message>
You are an expert NixOS and Linux system diagnostician. Analyze the following system metadata and logs. Look for and enumerate:

- Hardware compatibility issues (missing drivers, unsupported devices, kernel mismatches)
- Boot problems (initrd/init issues, missing bootloader configs, kernel panics)
- Errors or warnings in logs (journalctl, dmesg, nixos-rebuild) that could indicate hardware, driver, or service failures
- NixOS configuration problems (deprecated options, syntax errors, infinite recursion, non-standard patterns, missing or misconfigured modules)
- Package issues (unavailable, broken, or outdated packages)
- Potential security misconfigurations (open ports, weak passwords, outdated software)
- Performance bottlenecks (high CPU/memory usage, swap usage, slow disk)
- Window manager or graphical issues (Wayland/X11, niri-specific problems, missing dependencies)
- Audio, network, or peripheral device issues
- Documentation gaps or non-standard configuration patterns that could hinder maintainability or reproducibility
- Any other warnings, errors, or anti-patterns that could impact system stability, usability, or maintainability

For each issue, explain the likely cause and suggest concrete, actionable improvements or best practices. If the configuration is healthy, note areas for potential optimization or modernization.

Begin your analysis afterwards and structure your response clearly.
</system_message>

<host>
Hostname: !`hostname`
Current directory: !`pwd`
User: !`whoami`
Home directory: !`realpath ~`
Flake directory (realpath): !`realpath ~/dotnix`
Kernel: !`uname -a`
</host>

<hardware>
- CPU summary: !`grep 'model name' /proc/cpuinfo | uniq`
- Memory total: !`grep MemTotal /proc/meminfo`
- Block devices: !`lsblk`
- Short hardware summary: !`sudo lshw -short 2>/dev/null || echo 'lshw not available'`
</hardware>

<nix_files>

<tree>
!`exa --tree ~/dotnix`
</tree>

- @flake.nix - root flake
- @home/home.nix - home-manager flake
- @desktop/desktop.nix - desktop flake
- @machines/frameling/configuration.nix - frameling machine configuration
- @machines/frameling/hardware-configuration.nix - frameling machine hardware configuration

</nix_files>

<flake_check>
nix flake check output: !`nix flake check --no-build 2>&1 | tail -n 250`
</flake_check>

<disk_usage>
!`df -h`
</disk_usage>

<memory_usage>
!`free -h`
</memory_usage>

<lscpu>
!`lscpu`
</lscpu>

<lspci>
!`lspci`
</lspci>

<lsusb>
!`lsusb`
</lsusb>

<mounts>
!`mount`
</mounts>

<services-failed>
!`systemctl list-units --state=failed`
</services-failed>

<services-running>
!`systemctl list-units --state=running`
</services-running>


<logs>
Ignore everything that isn't from the current boot.

<journalctl>
!`journalctl -b 0 -p warning --no-pager -n2000`
</journalctl>

<kernel_logs>
!`journalctl -k`
</kernel_logs>

<rebuild_logs>
Most recent nixos-rebuild log (if available): !`find /var/log -type f -iname '*nixos-rebuild*' -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2- | xargs -r tail -n 250`
</rebuild_logs>

<dmesg>
!`dmesg  tail -n 250`
</dmesg>

</logs>


<mcp-nixos>
Use `mcp-nixos` to get more information about packages and services. If present, ask mcp-nixos for its tools.
</mcp-nixos>



You are an expert NixOS and Linux system diagnostician. Analyze the above system metadata and logs. Look for and enumerate all possible issues, explain likely causes, and suggest concrete, actionable improvements or best practices. If the configuration is healthy, note areas for potential optimization or modernization.
