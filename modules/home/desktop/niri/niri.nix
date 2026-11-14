{ pkgs, ... }:

let
  configKDL = ''
    // Niri configuration for the Dux desktop.
    // Dux owns ~/.config/niri/dms/*.kdl; this file only provides compositor
    // defaults. Includes are textual, so later definitions override earlier ones.

    // ── Input ────────────────────────────────────────────────────────────────
    input {
        keyboard {
            xkb {
                layout "us"
            }
            numlock
        }
        touchpad {
            tap
            dwt
            natural-scroll
        }
        workspace-auto-back-and-forth
    }

    prefer-no-csd

    // ── Cursor ────────────────────────────────────────────────────────────────
    cursor {
        hide-when-typing
    }

    // ── Hotkey Overlay ────────────────────────────────────────────────────────
    hotkey-overlay {
        skip-at-startup
    }

    // ── Environment ──────────────────────────────────────────────────────────
    environment {
        XDG_CURRENT_DESKTOP "niri"
        XDG_SESSION_DESKTOP "niri"
        XDG_SESSION_TYPE "wayland"
        GDK_BACKEND "wayland,x11,*"
        GDK_SCALE "1"
        GDK_DPI_SCALE "1"
        NIXOS_OZONE_WL "1"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        MOZ_ENABLE_WAYLAND "1"
        OZONE_PLATFORM "wayland"
        EGL_PLATFORM "wayland"
        CLUTTER_BACKEND "wayland"
        SDL_VIDEODRIVER "wayland"
        QT_QPA_PLATFORM "wayland;xcb"
        QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
        QT_AUTO_SCREEN_SCALE_FACTOR "1"
    }

    // ── Xwayland Satellite ────────────────────────────────────────────────────
    xwayland-satellite {
        path "xwayland-satellite"
    }

    // ── Dux defaults ─────────────────────────────────────────────────────────
    config-notification {
        disable-failed
    }

    gestures {
        hot-corners {
            off
        }
    }

    layout {
        background-color "transparent"
        center-focused-column "never"
        default-column-width { proportion 0.5; }
        border {
            off
            width 4
        }
        focus-ring {
            off
        }
        shadow {
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
        }
        struts {
        }
    }

    overview {
        workspace-shadow {
            off
        }
    }

    // ── Window Rules ──────────────────────────────────────────────────────────
    window-rule {
        open-maximized true
    }

    window-rule {
        match app-id=r#"^org\.wezfurlong\.wezterm$"#
        default-column-width {}
    }

    window-rule {
        match app-id=r#"^org\.gnome\."#
        draw-border-with-background false
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match app-id=r#"^gnome-control-center$"#
        match app-id=r#"^pavucontrol$"#
        match app-id=r#"^nm-connection-editor$"#
        default-column-width { proportion 0.5; }
        open-floating false
    }

    window-rule {
        match app-id=r#"^org\.gnome\.Calculator$"#
        match app-id=r#"^gnome-calculator$"#
        match app-id=r#"^galculator$"#
        match app-id=r#"^blueman-manager$"#
        match app-id=r#"^xdg-desktop-portal$"#
        open-floating true
    }

    window-rule {
        match app-id=r#"^steam$"# title=r#"^notificationtoasts_\d+_desktop$"#
        default-floating-position x=10 y=10 relative-to="bottom-right"
        open-focused false
    }

    window-rule {
        match app-id=r#"^org\.wezfurlong\.wezterm$"#
        match app-id="Alacritty"
        match app-id="zen"
        match app-id="com.mitchellh.ghostty"
        match app-id="kitty"
        draw-border-with-background false
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        match app-id="zoom"
        open-floating true
    }

    // Dux file dialogs float above the application that opened them.
    window-rule {
        match app-id=r#"^dev\.duxlabs\.files$"# title=r#"^(Open|Save|Select|Upload|Export|Import)"#
        open-floating true
    }

    // ── Animations ───────────────────────────────────────────────────────────
    animations {
        workspace-switch {
            spring damping-ratio=0.80 stiffness=523 epsilon=0.0001
        }
        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }
        window-close {
            duration-ms 150
            curve "ease-out-quad"
        }
        horizontal-view-movement {
            spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=0.75 stiffness=323 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
        }
        config-notification-open-close {
            spring damping-ratio=0.65 stiffness=923 epsilon=0.001
        }
        screenshot-ui-open {
            duration-ms 200
            curve "ease-out-quad"
        }
        overview-open-close {
            spring damping-ratio=0.85 stiffness=800 epsilon=0.0001
        }
    }

    debug {
        honor-xdg-activation-with-invalid-serial
    }

    recent-windows {
        binds {
            Alt+Tab         { next-window scope="output"; }
            Alt+Shift+Tab   { previous-window scope="output"; }
            Alt+grave       { next-window filter="app-id"; }
            Alt+Shift+grave { previous-window filter="app-id"; }
        }
    }

    // ── Startup ──────────────────────────────────────────────────────────────
    spawn-at-startup "fcitx5" "-d"

    // Dux's version-dependent defaults; dms/binds.kdl (included last) overrides.
    include optional=true "dms/binds-next.kdl"

    // ── Keybindings (Dux stock map) ──────────────────────────────────────────
    binds {
        // === System & Overview ===
        Mod+O repeat=false { toggle-overview; }
        Mod+Tab repeat=false { toggle-overview; }

        // === Application Launchers ===
        Mod+T hotkey-overlay-title="Open Terminal" { spawn "kitty"; }
        Mod+Return hotkey-overlay-title="Open Terminal" { spawn "kitty"; }
        Mod+Space hotkey-overlay-title="Application Launcher" {
            spawn "dms" "ipc" "call" "spotlight" "toggle";
        }
        Alt+Space hotkey-overlay-title="Spotlight Bar" {
            spawn "dms" "ipc" "call" "spotlight-bar" "toggle";
        }
        Mod+V hotkey-overlay-title="Clipboard Manager" {
            spawn "dms" "ipc" "call" "clipboard" "toggle";
        }
        Mod+M hotkey-overlay-title="Media" {
            spawn "dms" "ipc" "call" "dash" "toggle" "media";
        }

        Mod+X hotkey-overlay-title="Power Menu: Toggle" { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
        Mod+A hotkey-overlay-title="Control Center" { spawn "dms" "ipc" "call" "control-center" "toggle"; }
        Mod+D hotkey-overlay-title="Dash" { spawn "dms" "ipc" "call" "dash" "toggle" ""; }
        Mod+Shift+C hotkey-overlay-title="Color Picker" { spawn "dms" "ipc" "call" "color-picker" "toggle"; }
        Mod+Alt+N hotkey-overlay-title="Night Mode" { spawn "dms" "ipc" "call" "night" "toggle"; }
        Mod+Alt+I hotkey-overlay-title="Idle Inhibit" { spawn "dms" "ipc" "call" "inhibit" "toggle"; }
        Mod+Comma hotkey-overlay-title="Settings" {
            spawn "dms" "ipc" "call" "settings" "focusOrToggle";
        }
        Mod+Y hotkey-overlay-title="Browse Wallpapers" {
            spawn "dms" "ipc" "call" "dash" "toggle" "wallpaper";
        }
        Mod+N hotkey-overlay-title="Notepad" { spawn "dms" "ipc" "call" "notepad" "toggle"; }
        Mod+Shift+N hotkey-overlay-title="Notepad: Expand" { spawn "dms" "ipc" "call" "notepad" "toggleExpand"; }
        Mod+Ctrl+N hotkey-overlay-title="Notification Center" { spawn "dms" "ipc" "call" "notifications" "toggle"; }

        // === Security ===
        Mod+Alt+L hotkey-overlay-title="Lock Screen" {
            spawn "dms" "ipc" "call" "lock" "lock";
        }
        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete hotkey-overlay-title="Task Manager" {
            spawn "dms" "ipc" "call" "processlist" "focusOrToggle";
        }
        Ctrl+Alt+M hotkey-overlay-title="Task Manager" {
            spawn "dms" "ipc" "call" "processlist" "focusOrToggle";
        }

        // === Audio Controls ===
        XF86AudioRaiseVolume allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "increment" "3";
        }
        XF86AudioLowerVolume allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "decrement" "3";
        }
        XF86AudioMute allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "mute";
        }
        XF86AudioMicMute allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "micmute";
        }
        XF86AudioPause allow-when-locked=true {
            spawn "dms" "ipc" "call" "mpris" "playPause";
        }
        XF86AudioPlay allow-when-locked=true {
            spawn "dms" "ipc" "call" "mpris" "playPause";
        }
        XF86AudioPrev allow-when-locked=true {
            spawn "dms" "ipc" "call" "mpris" "previous";
        }
        XF86AudioNext allow-when-locked=true {
            spawn "dms" "ipc" "call" "mpris" "next";
        }
        Ctrl+XF86AudioRaiseVolume allow-when-locked=true {
            spawn "dms" "ipc" "call" "mpris" "increment" "3";
        }
        Ctrl+XF86AudioLowerVolume allow-when-locked=true {
            spawn "dms" "ipc" "call" "mpris" "decrement" "3";
        }

        // === Brightness Controls ===
        XF86MonBrightnessUp allow-when-locked=true {
            spawn "dms" "ipc" "call" "brightness" "increment" "5" "";
        }
        XF86MonBrightnessDown allow-when-locked=true {
            spawn "dms" "ipc" "call" "brightness" "decrement" "5" "";
        }

        // === Input ===
        XF86TouchpadToggle allow-when-locked=true repeat=false {
            spawn "niri" "msg" "action" "toggle-touchpad";
        }
        XF86TouchpadOn allow-when-locked=true repeat=false {
            spawn "dms" "ipc" "call" "niri" "showTouchpadOsd" "true";
        }
        XF86TouchpadOff allow-when-locked=true repeat=false {
            spawn "dms" "ipc" "call" "niri" "showTouchpadOsd" "false";
        }

        // === Window Management ===
        Mod+Q repeat=false { close-window; }
        Alt+F4 repeat=false { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Shift+T { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        Mod+W { toggle-column-tabbed-display; }
        Mod+Shift+W hotkey-overlay-title="Create window rule" { spawn "dms" "ipc" "call" "window-rules" "toggle"; }

        // === Focus Navigation ===
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        // === Window Movement ===
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }

        // === Column Navigation ===
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        // === Monitor Navigation ===
        Mod+Ctrl+Left  { focus-monitor-left; }
        Mod+Ctrl+Right { focus-monitor-right; }
        Mod+Ctrl+H     { focus-monitor-left; }
        Mod+Ctrl+J     { focus-monitor-down; }
        Mod+Ctrl+K     { focus-monitor-up; }
        Mod+Ctrl+L     { focus-monitor-right; }

        // === Move to Monitor ===
        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        // === Workspace Navigation ===
        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Ctrl+Down { move-column-to-workspace-down; }
        Mod+Ctrl+Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }

        // === Workspace Management ===
        Mod+Alt+R hotkey-overlay-title="Rename Workspace" {
            spawn "dms" "ipc" "call" "workspace-rename" "open";
        }

        // === Move Workspaces ===
        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }
        Mod+Shift+I         { move-workspace-up; }

        // === Mouse Wheel Navigation ===
        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        // === Numbered Workspaces ===
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        // === Move to Numbered Workspaces ===
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // === Column Management ===
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+Period { expel-window-from-column; }

        // === Sizing & Layout ===
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+C { center-column; }
        Mod+Ctrl+C { center-visible-columns; }

        // === Manual Sizing ===
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // === Screenshots ===
        XF86Launch1 hotkey-overlay-title="Screenshot: Region" { spawn "dms" "screenshot"; }
        Ctrl+XF86Launch1 hotkey-overlay-title="Screenshot: Full Screen" { spawn "dms" "screenshot" "full"; }
        Alt+XF86Launch1 hotkey-overlay-title="Screenshot: Window" { spawn "dms" "screenshot" "window"; }
        Print hotkey-overlay-title="Screenshot: Region" { spawn "dms" "screenshot"; }
        Ctrl+Print hotkey-overlay-title="Screenshot: Full Screen" { spawn "dms" "screenshot" "full"; }
        Alt+Print hotkey-overlay-title="Screenshot: Window" { spawn "dms" "screenshot" "window"; }

        // === Display Profiles ===
        Mod+P hotkey-overlay-title="Cycle Display Profile" {
            spawn "dms" "ipc" "call" "outputs" "cycleProfile";
        }

        // === System Controls ===
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        Mod+Shift+P { power-off-monitors; }
        Mod+Shift+question hotkey-overlay-title="Keyboard Shortcuts" {
            spawn "dms" "ipc" "call" "keybinds" "toggle" "niri";
        }

        // === Laptop / Dux extras ===
        xf86KbdBrightnessUp   { spawn "brightnessctl" "-d" "*::kbd_backlight" "set" "33%+"; }
        xf86KbdBrightnessDown { spawn "brightnessctl" "-d" "*::kbd_backlight" "set" "33%-"; }
        Mod+Alt+F hotkey-overlay-title="File Manager" { spawn "dfiles" "open"; }
        Mod+E hotkey-overlay-title="Emoji Search" { spawn "dms" "ipc" "call" "spotlight" "openQuery" ":e "; }
    }

    // Dux-managed fragments. binds-next is included above so these GUI-editable
    // files take precedence over the defaults in this file.
    include optional=true "dms/colors.kdl"
    include optional=true "dms/layout.kdl"
    include optional=true "dms/alttab.kdl"
    include optional=true "dms/binds.kdl"
    include optional=true "dms/outputs.kdl"
    include optional=true "dms/cursor.kdl"
    include optional=true "dms/input.kdl"
    include optional=true "dms/windowrules.kdl"
    include optional=true "dms/wpblur.kdl"
  '';
in
{
  home.packages = with pkgs; [ niri ];

  xdg.configFile."niri/config.kdl".text = configKDL;
}
