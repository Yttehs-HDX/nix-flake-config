{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.dux-greeter.nixosModules.default ];

  programs.dms-greeter = {
    enable = true;
    package = inputs.dux-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
    compositor.name = "niri";
    configHome = config.users.users.shetty.home;
    quickshell.package =
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.quickshell;
  };

  environment.systemPackages = [ config.programs.dms-greeter.package ];

  services.displayManager.defaultSession = "niri";
  security.pam.services.greetd.enableGnomeKeyring = true;
}
