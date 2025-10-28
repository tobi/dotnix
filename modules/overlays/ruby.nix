# overlays/ruby-jemalloc-auto.nix
_final: prev:
let
  lib = prev.lib;
  enable =
    rb:
    rb.override {
      # enable jemalloc support (requires a manual build)
      jemallocSupport = true;
    };
  rubies = lib.mapAttrs (_: rb: enable rb) (lib.filterAttrs (n: _: lib.hasPrefix "ruby_" n) prev);
in
rubies
// {
  ruby = enable prev.ruby;
}
