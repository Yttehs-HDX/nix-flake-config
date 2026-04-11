{ pipeline }:
let
  current = pipeline.current."Shetty@Shetty-Laptop";
  input = pipeline.projectionInputs."Shetty@Shetty-Laptop";
in assert current.effectiveCapabilities.desktop.enable;
assert current.effectiveCapabilities.theme.enable;
assert current.packages.home.fcitx5.enable;
assert current.packages.home.hyprland.enable;
assert current.packages.home.kitty.enable;
assert current.packages.home.rofi.enable;
assert current.packages.home.waybar.enable;
assert current.packages.system.docker.enable;
assert input.identity.name == "shetty";
assert input.identity.homeDirectory == "/home/shetty";
assert input.account.initialHashedPassword
  == "$y$j9T$IbyB4U5AIUqcxol3JR60E0$/Wr3iDHuKpYBX7lkBSMJHGWlRS3quNv.DqQvkpKK4dD";
assert input.packages.home.kitty.settings.fontSize == 14.0;
assert input.packages.home.hyprland.enable;
assert input.packages.system.wireshark.settings.package == "qt";
assert input.theme.name == "catppuccin";
assert input.theme.palette.accentName == "lavender";
assert input.theme.desktop.provider == "catppuccin";
assert input.theme.desktop.resources.gtk.theme.name
  == "catppuccin-mocha-lavender-compact";
assert input.theme.desktop.resources.qt.kvantum.name
  == "catppuccin-mocha-lavender";
assert input.theme.desktop.consumers.rofi.font.family == "SF Pro";
assert !(builtins.hasAttr "auth" input);
true
