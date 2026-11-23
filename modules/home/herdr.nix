{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.system;
    config.allowUnfree = true;
  };
in
{
  # Three separate programs that do not share running agents:
  # herdr  = Herdr TUI; herdr-core = `hc` backend the desktop app drives;
  # herdr-desktop = the Herdr desktop app (`herdr-app`).
  home.packages = [
    unstable.herdr
    unstable.herdr-core
    unstable.herdr-desktop
  ];
}
