{ pkgs, inputs, ... }:

{
  # magpie: one local gateway (127.0.0.1:3425) that lets Claude Code, Codex,
  # oh-my-pi and the rest use any provider/model, with failover between
  # accounts. The desktop build also contains the TUI, web UI and CLI.
  home.packages = [ inputs.magpie.packages.${pkgs.stdenv.hostPlatform.system}.magpie ];
}
