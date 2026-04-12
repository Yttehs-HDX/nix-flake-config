{ definition, ... }:
{ ... }: {
  programs.onlyoffice = {
    enable = true;
    settings = {
      UITheme = "theme-night";
      editorWindowMode = false;
      locale = "zh-CN";
    } // (definition.settings or { });
  };
}
