{ config, ... }:

let
  palette = import ./palette.nix;
in
{
  programs.rofi = {
    font = "SF Pro 12";
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          border-col = mkLiteral "@blue";
          bg-col = mkLiteral "${palette.base}bf";
          bg-col-light = mkLiteral "${palette.surface0}b3";
          fg-col = mkLiteral palette.text;
          highlight = mkLiteral palette.red;
          blue = mkLiteral palette.blue;
          accent = mkLiteral "${palette.lavender}cc";
          text = mkLiteral palette.overlay0;
          width = 800;
        };

        "element-text, element-icon , mode-switcher" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };

        window = {
          height = mkLiteral "480px";
          border = mkLiteral "2px";
          border-radius = mkLiteral "12px";
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };

        mainbox = {
          background-color = mkLiteral "transparent";
        };

        inputbar = {
          children = mkLiteral "[prompt,entry]";
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "inherit";
          margin = mkLiteral "12px 12px 0px";
        };

        prompt = {
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "@blue";
          text-color = mkLiteral "@bg-col";
          padding = mkLiteral "10px";
        };

        entry = {
          placeholder = "Type to search";
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col";
          padding = mkLiteral "13px 10px";
          margin = mkLiteral "0px 0px 0px 8px";
        };

        listview = {
          background-color = mkLiteral "inherit";
          columns = 2;
          spacing = mkLiteral "4px";
          margin = mkLiteral "8px 12px 0px";
        };

        element = {
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "@fg-col";
          padding = mkLiteral "8px";
        };

        "element selected" = {
          text-color = mkLiteral "@bg-col";
          background-color = mkLiteral "@accent";
        };

        element-icon = {
          border-radius = mkLiteral "8px";
          size = mkLiteral "32px";
          padding = mkLiteral "5px";
          margin = mkLiteral "0px 5px 0px 0px";
        };

        element-text = {
          border-radius = mkLiteral "8px";
          vertical-align = mkLiteral "0.5";
          text-color = mkLiteral "inherit";
          padding = mkLiteral "4px";
        };

        "element-text selected, element-icon selected" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };

        mode-switcher = {
          spacing = mkLiteral "4px";
          margin = mkLiteral "8px 12px 12px";
        };

        button = {
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@text";
          padding = mkLiteral "10px";
        };

        "button selected" = {
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@blue";
        };

        message = {
          background-color = mkLiteral "inherit";
          margin = mkLiteral "8px 12px 0px";
        };

        textbox = {
          border-radius = mkLiteral "8px";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@accent";
          padding = mkLiteral "10px";
        };
      };
  };
}
