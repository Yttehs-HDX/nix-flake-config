{ pkgs, inputs, ... }:

{
  home.packages = [ inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
