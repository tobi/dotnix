{ config, lib, pkgs, ... }:

{
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "alsa-monitor.conf" = {
          "monitor.alsa.rules" = [
            {
              matches = [{ "node.name" = "~alsa_input.*"; }];
              actions = { "update-props" = { "priority.session" = 500; }; };
            }
            {
              matches = [{ "node.name" = "~alsa_output.*"; }];
              actions = { "update-props" = { "priority.session" = 500; }; };
            }
            # High priority input devices
            {
              matches = [{ "node.description" = "~.*CM-15.*"; }];
              actions = { "update-props" = { "priority.session" = 1000; }; };
            }
            {
              matches = [{ "node.description" = "~.*Shure MV7.*"; }];
              actions = { "update-props" = { "priority.session" = 1000; }; };
            }
            # Medium priority input devices
            {
              matches = [{ "node.description" = "~.*Scarlett.*"; }];
              actions = { "update-props" = { "priority.session" = 800; }; };
            }
            # High priority output devices
            {
              matches = [
                { "node.description" = "~.*Audioengine.*"; }
                { "node.description" = "~.*Mpow HC5.*"; }
              ];

              actions = { "update-props" = { "priority.session" = 1000; }; };
            }
            # Medium priority output devices
            {
              matches = [{ "node.description" = "~.*Scarlett.*"; }];
              actions = { "update-props" = { "priority.session" = 800; }; };
            }
            {
              matches = [
                { "node.description" = "~.*Apple Display.*"; }
                { "node.description" = "~.*Studio Display.*"; }
              ];
              actions = { "update-props" = { "priority.session" = 700; }; };
            }

          ];
        };
      };
    };
  };
}
