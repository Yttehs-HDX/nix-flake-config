{ input, definition, ... }:
{ config, lib, ... }:
let
  firstNonNull = values:
    let filtered = builtins.filter (value: value != null) values;
    in if filtered == [ ] then null else builtins.head filtered;
  desktopTheme =
    if input.theme != null then input.theme.desktop or null else null;
  rofiTheme =
    if desktopTheme != null then desktopTheme.consumers.rofi or null else null;
  fontFamily = firstNonNull [
    (definition.settings.fontFamily or null)
    (if rofiTheme != null then rofiTheme.font.family or null else null)
    "DejaVu Sans"
  ];
  preferredTerminal = input.current.user.preferences.terminal;
  terminalCmd =
    if preferredTerminal != null then preferredTerminal else "kitty";
in {
  programs.rofi = {
    enable = true;
    modes = [ "run" "drun" "window" "filebrowser" ];
    terminal = terminalCmd;

    extraConfig = {
      show-icons = true;
      drun-display-format = "{icon} {name}";
      hide-scrollbar = false;
      display-drun = "󰵆  Apps ";
      display-run = "  Run ";
      display-window = "󰕰  Window";
      display-filebrowser = "󰉋  File";
      sidebar-mode = true;
    };
  } // lib.optionalAttrs (rofiTheme != null) {
    font = "${fontFamily} ${toString (rofiTheme.font.size or 12)}";
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        border-col = mkLiteral "@blue";
        bg-col = mkLiteral rofiTheme.colors.background;
        bg-col-light = mkLiteral rofiTheme.colors.backgroundLight;
        fg-col = mkLiteral rofiTheme.colors.foreground;
        highlight = mkLiteral rofiTheme.colors.highlight;
        blue = mkLiteral rofiTheme.colors.blue;
        accent = mkLiteral rofiTheme.colors.accent;
        text = mkLiteral rofiTheme.colors.text;
        width = rofiTheme.window.width or 800;
      };

      "element-text, element-icon , mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      window = {
        height = mkLiteral (rofiTheme.window.height or "480px");
        border = mkLiteral "2px";
        border-radius = mkLiteral "15px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
      };

      mainbox = { background-color = mkLiteral "transparent"; };

      inputbar = {
        children = mkLiteral "[prompt,entry]";
        border-radius = mkLiteral "5px";
        background-color = mkLiteral "inherit";
        margin = mkLiteral "10px 10px 0px";
      };

      prompt = {
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "@blue";
        text-color = mkLiteral "@bg-col";
        padding = mkLiteral "10px";
      };

      entry = {
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@fg-col";
        padding = mkLiteral "13px 10px";
        margin = mkLiteral "0px 0px 0px 5px";
      };

      listview = {
        background-color = mkLiteral "inherit";
        columns = 3;
        margin = mkLiteral "10px 10px 0px";
      };

      element = {
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "@fg-col";
        padding = mkLiteral "10px";
      };

      "element selected" = {
        text-color = mkLiteral "@bg-col";
        background-color = mkLiteral "@accent";
      };

      element-icon = {
        border-radius = mkLiteral "10px";
        size = mkLiteral "32px";
        padding = mkLiteral "5px";
        margin = mkLiteral "0px 5px 0px 0px";
      };

      element-text = {
        border-radius = mkLiteral "10px";
        vertical-align = mkLiteral "0.5";
        text-color = mkLiteral "0.5";
        padding = mkLiteral "10px";
      };

      "element-text selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "inherit";
      };

      mode-switcher = { spacing = 0; };

      button = {
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@text";
        padding = mkLiteral "10px";
      };

      "button selected" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@blue";
      };

      message = {
        background-color = mkLiteral "inherit";
        margin = mkLiteral "10px 10px 0px";
      };

      textbox = {
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@accent";
        padding = mkLiteral "10px";
      };
    };
  };
}
