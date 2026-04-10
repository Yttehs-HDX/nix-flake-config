{ lib, input }:
let
  registry = {
    btop = import ./btop.nix;
    direnv = import ./direnv.nix;
    git = import ./git.nix;
    hello = import ./hello.nix;
    jq = import ./jq.nix;
    kitty = import ./kitty.nix;
  };

  resolve = softwareId: definition:
    if builtins.hasAttr softwareId registry then
      registry.${softwareId} { inherit input definition; }
    else
      throw
      "Unsupported Home Manager software `${softwareId}` on `${input.relationId}`.";
in map (softwareId: resolve softwareId input.software.home.${softwareId})
(lib.sort lib.lessThan (builtins.attrNames input.software.home))
