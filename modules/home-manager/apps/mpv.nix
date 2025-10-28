/*
  MPV Video Player Configuration

  Features:
  - Modern video player with hardware acceleration
  - Theme-integrated OSD styling
  - MIME type associations for all common video formats
*/

{ theme, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      # Video settings
      profile = "gpu-hq";
      vo = "gpu";
      hwdec = "auto-safe";
      gpu-context = "wayland";

      # OSD and interface
      osd-font = theme.systemFont;
      osd-font-size = 32;
      osd-color = "#${theme.foreground}";
      osd-border-color = "#${theme.background}";
      osd-bar-align-y = 0.9;
      osd-bar-h = 2;
      osd-bar-w = 60;
      osd-border-size = 2;
      osd-duration = 2000;

      # Playback
      keep-open = true;
      save-position-on-quit = true;

      # Window
      title = "\${media-title}";
      force-window = "immediate";

      # Screenshots
      screenshot-format = "png";
      screenshot-png-compression = 8;
      screenshot-directory = "~/Pictures/Screenshots";
      screenshot-template = "%F-%P";

      # Audio
      volume = 50;
      volume-max = 150;

      # Subtitles
      sub-auto = "fuzzy";
      sub-font = theme.systemFont;
      sub-font-size = 36;
      sub-color = "#${theme.foreground}";
      sub-border-color = "#${theme.background}";
      sub-border-size = 2;
      sub-shadow-offset = 1;
      sub-shadow-color = "#${theme.background}";
    };

    bindings = {
      # Volume
      "WHEEL_UP" = "add volume 2";
      "WHEEL_DOWN" = "add volume -2";

      # Seeking
      "RIGHT" = "seek 6";
      "LEFT" = "seek -2";

      # Volume
      "UP" = "add volume 5";
      "DOWN" = "add volume -5";

      # Playback speed
      "[" = "multiply speed 0.9091";
      "]" = "multiply speed 1.1";
      "{" = "multiply speed 0.5";
      "}" = "multiply speed 2.0";
      "BS" = "set speed 1.0";

      # Screenshots
      "s" = "screenshot";
      "S" = "screenshot video";

      # Subtitles
      "v" = "cycle sub-visibility";
      "j" = "cycle sub";
      "J" = "cycle sub down";

      # Audio
      "#" = "cycle audio";
    };
  };

  # MIME type associations for video files
  xdg.mimeApps.defaultApplications = {
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/avi" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/mpeg" = "mpv.desktop";
    "video/x-flv" = "mpv.desktop";
    "video/x-theora+ogg" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";
    "video/3gpp" = "mpv.desktop";
    "video/3gpp2" = "mpv.desktop";
    "video/x-ogm+ogg" = "mpv.desktop";
    "video/mp2t" = "mpv.desktop";
  };
}
