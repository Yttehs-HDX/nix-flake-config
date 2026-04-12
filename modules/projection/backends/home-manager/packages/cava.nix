{ input, ... }:
{ lib, ... }:
let
  palette = if input.theme != null then input.theme.palette or { } else { };
  usesCatppuccin = input.theme != null && (input.theme.name or null)
    == "catppuccin";
in {
  programs.cava = {
    enable = true;
    settings = lib.optionalAttrs usesCatppuccin {
      color = {
        gradient = 1;
        gradient_color_1 = "'${palette.teal or "#94e2d5"}'";
        gradient_color_2 = "'${palette.sky or "#89dceb"}'";
        gradient_color_3 = "'${palette.sapphire or "#74c7ec"}'";
        gradient_color_4 = "'${palette.blue or "#89b4fa"}'";
        gradient_color_5 = "'${palette.mauve or "#cba6f7"}'";
        gradient_color_6 = "'${palette.pink or "#f5c2e7"}'";
        gradient_color_7 = "'${palette.maroon or "#eba0ac"}'";
        gradient_color_8 = "'${palette.red or "#f38ba8"}'";
      };
    };
  };
}
