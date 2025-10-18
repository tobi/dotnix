{ config, lib, pkgs, ... }:

{
  # WirePlumber automatic audio device priority configuration
  # Devices are automatically selected based on priority when connected
  # Higher priority number = preferred device

  xdg.configFile."wireplumber/main.lua.d/51-device-priority.lua".text = ''
    -- Audio device priority rules
    -- When multiple devices are available, WirePlumber routes to highest priority

    input_rule = {
      matches = {
        {
          { "node.name", "matches", "alsa_input.*" },
        },
      },
      apply_properties = {
        ["priority.session"] = 500,  -- default priority
      },
    }

    output_rule = {
      matches = {
        {
          { "node.name", "matches", "alsa_output.*" },
        },
      },
      apply_properties = {
        ["priority.session"] = 500,  -- default priority
      },
    }

    -- High priority input devices (microphones)
    high_priority_input = {
      matches = {
        {
          { "node.description", "matches", "CM-15" },
        },
        {
          { "node.description", "matches", "Shure MV7+" },
        },
        {
          { "node.description", "matches", "Shure MV7" },
        },
      },
      apply_properties = {
        ["priority.session"] = 1000,
      },
    }

    medium_priority_input = {
      matches = {
        {
          { "node.description", "matches", "Scarlett Solo" },
        },
      },
      apply_properties = {
        ["priority.session"] = 800,
      },
    }

    -- High priority output devices (speakers/headphones)
    high_priority_output = {
      matches = {
        {
          { "node.description", "matches", "Audioengine" },
        },
      },
      apply_properties = {
        ["priority.session"] = 1000,
      },
    }

    medium_priority_output = {
      matches = {
        {
          { "node.description", "matches", "Scarlett Solo" },
        },
      },
      apply_properties = {
        ["priority.session"] = 800,
      },
    }

    -- Register all rules with the ALSA monitor
    table.insert(alsa_monitor.rules, input_rule)
    table.insert(alsa_monitor.rules, output_rule)
    table.insert(alsa_monitor.rules, high_priority_input)
    table.insert(alsa_monitor.rules, medium_priority_input)
    table.insert(alsa_monitor.rules, high_priority_output)
    table.insert(alsa_monitor.rules, medium_priority_output)
  '';
}
