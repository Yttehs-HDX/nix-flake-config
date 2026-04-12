{ lib }:
let
  normalizeEntry = packageId: definition:
    let
      attrs = if builtins.isAttrs definition then
        definition
      else {
        enable = definition;
      };
      explicitSettings = attrs.settings or { };
      implicitSettings = builtins.removeAttrs attrs [ "enable" "settings" ];
    in {
      inherit packageId;
      enable = attrs.enable or true;
      settings = lib.recursiveUpdate implicitSettings explicitSettings;
    };

  mergeDefinitions = definitions:
    lib.foldl' lib.recursiveUpdate { } definitions;

  normalizeUserPackages = user:
    let
      merged = mergeDefinitions [ user.programs user.services user.packages ];
      hasNixvim = builtins.hasAttr "nixvim" merged;
      hasNeovim = builtins.hasAttr "neovim" merged;
      withAlias = if hasNixvim && !hasNeovim then
        merged // { neovim = merged.nixvim; }
      else
        merged;
      canonical = builtins.removeAttrs withAlias [ "nixvim" ];
      normalized = lib.mapAttrs normalizeEntry canonical;
      usesZsh = user.preferences.shell == "zsh";
      hasNixIndex = builtins.hasAttr "nix-index" normalized
        && normalized."nix-index".enable;
      hasCommandNotFound = builtins.hasAttr "command-not-found" normalized
        && normalized."command-not-found".enable;
    in if usesZsh && hasNixIndex && hasCommandNotFound then
      throw ''
        User declarations must not enable both `packages.nix-index` and `packages.command-not-found` for zsh.
        Choose exactly one command-not-found integration package.
      ''
    else
      normalized;
in {
  user = user: normalizeUserPackages user;

  host = host: lib.mapAttrs normalizeEntry host.packages;
}
