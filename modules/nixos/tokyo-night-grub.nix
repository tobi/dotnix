{ stdenv, lib, fetchFromGitHub }:

let
  theme = stdenv.mkDerivation rec {
    pname = "tokyo-night-grub";
    version = "2025-07-07";

    src = fetchFromGitHub {
      owner = "mino29";
      repo = "tokyo-night-grub";
      rev = "master";
      sha256 = "sha256-l+H3cpxFn3MWvarTJvxXzTA+CwX0SwvP+/EnU8tDUEk="; # <-- Update this!
    };

    installPhase = ''
      mkdir -p $out/share/grub/themes
      cp -r tokyo-night $out/share/grub/themes/
    '';

    meta = {
      description = "Tokyo Night theme for GRUB2 bootloader";
      homepage = "https://github.com/mino29/tokyo-night-grub";
      license = lib.licenses.mit;
    };
  };
in
{
  # The full derivation
  inherit theme;

  # Direct path to the theme directory for GRUB
  tokyo-night = "${theme}/share/grub/themes/tokyo-night";
}

