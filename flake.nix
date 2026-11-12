{
  description = "Shetty's Nix flake config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    latchshot = {
      url = "github:so1ve/latchshot/a65a6f85855d25aa859273b62265c03d89c034bf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:duxlabs-dev/dux-shell/v2.1.0";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dux-greeter = {
      url = "github:duxlabs-dev/dux-greeter/v2.1.2";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dux-files = {
      url = "github:duxlabs-dev/dux-files/v2.1.2";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dsearch = {
      url = "github:duxlabs-dev/dux-search/v2.1.1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dms-emoji-launcher = {
      url = "github:devnullvoid/dms-emoji-launcher/fc385900e6df292f0a7e5bdda4e3e37169897d7c";
      flake = false;
    };

    oh-my-pi.url = "github:can1357/oh-my-pi";

    openbot = {
      url = "github:nightly-labs/openbot";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hexecute = {
      url = "github:ThatOtherAndrew/Hexecute";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    asus-numberpad-driver = {
      url = "github:asus-linux-drivers/asus-numberpad-driver/v7.0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations."Shetty-Laptop" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/nixos/Shetty-Laptop
          inputs.asus-numberpad-driver.nixosModules.default
        ];
      };

      homeConfigurations."shetty@Shetty-Laptop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = { inherit inputs; };

        modules = [ ./home/shetty/laptop.nix ];
      };
    };
}
