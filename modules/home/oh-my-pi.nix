{ pkgs, inputs, ... }:

{
  home.packages = [ inputs.oh-my-pi.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
