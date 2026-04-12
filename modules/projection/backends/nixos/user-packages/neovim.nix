{ definition, ... }:
{ ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = definition.settings.defaultEditor or true;
    viAlias = definition.settings.viAlias or true;
    vimAlias = definition.settings.vimAlias or true;
  };
}
