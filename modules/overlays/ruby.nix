# overlays/ruby-jemalloc-auto.nix
final: prev:
let
  lib = prev.lib;
  enable = rb: rb.override { jemallocSupport = true; };
  rubies =
    lib.mapAttrs
      (_: rb: enable rb)
      (lib.filterAttrs (n: _: lib.hasPrefix "ruby_" n) prev);
in
rubies // {
  ruby = enable prev.ruby;
}
