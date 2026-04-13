{ definition, ... }:
{ pkgs, ... }:
let
  packageName = definition.settings.package or "qt";
  package = if packageName == "cli" then pkgs.wireshark else pkgs.wireshark-qt;
in {
  environment.systemPackages = [ package ];

  warnings = [
    "Package `wireshark` on nix-darwin installs the application, but packet capture permissions and any required BPF access still need to be configured manually on macOS."
  ];
}
