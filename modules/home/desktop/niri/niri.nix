{ pkgs, ... }:

let
  palette = import ../../theme/catppuccin-mocha/palette.nix;

  configKDL = ''
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

    // ── Screenshots ───────────────────────────────────────────────────────────
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

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

    // ── Blur ──────────────────────────────────────────────────────────────────
    blur {
        passes 3
        offset 3.0
        noise 0.02
        saturation 1.5
    }

    // ── Layout ───────────────────────────────────────────────────────────────
    layout {
        gaps 8
        center-focused-column "never"
        default-column-width {
            proportion 1.0;
        }
        focus-ring {
            width 2
            active-color "${palette.lavender}"
            inactive-color "${palette.pink}"
        }
        border {
            width 2
            active-color "${palette.lavender}"
            inactive-color "${palette.pink}"
            urgent-color "${palette.red}"
        }
        // Drop shadows for windows.
        shadow {
            on
            softness 30
            spread 5
            offset x=0 y=5
            color "#00000070"
        }
        // Tab indicator for tabbed columns (Mod+Shift+W to toggle).
        tab-indicator {
            hide-when-single-tab
            width 3
            gap 2
            active-color "${palette.lavender}"
            inactive-color "${palette.pink}"
            urgent-color "${palette.red}"
        }
        // Insert hint shown during interactive window moves.
        insert-hint {
            color "${palette.lavender}80"
        }
        struts {
            left -7
            right -7
            top -4
            bottom -7
        }
        // Background color for workspaces (visible when no background tool is running).
        background-color "${palette.base}"
    }

    // ── Overview ──────────────────────────────────────────────────────────────
    overview {
        zoom 0.5
        backdrop-color "${palette.base}"
        workspace-shadow {
            softness 40
            spread 10
            offset x=0 y=10
            color "#00000050"
        }
    }

    // ── Window Rules ──────────────────────────────────────────────────────────
    // Global: rounded corners for all windows.
    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    // Dux file dialogs should float above the application that opened them.
    window-rule {
        match app-id=r#"^dev\.duxlabs\.files$"# title=r#"^(Open|Save|Select|Upload|Export|Import)"#
        open-floating true
    }

    // ── Animations ───────────────────────────────────────────────────────────
    animations {
        slowdown 1

        // Individual animation tuning.
        // Spring defaults for workspace switching and view movement.
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }
        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }
        window-close {
            duration-ms 150
            curve "ease-out-quad"
        }
        overview-open-close {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        screenshot-ui-open {
            duration-ms 200
            curve "ease-out-quad"
        }
    }

    // ── Startup ──────────────────────────────────────────────────────────────
    spawn-at-startup "fcitx5" "-d"

    // ── Keybindings ──────────────────────────────────────────────────────────
    // Follows niri community conventions — primary nav via arrows + Home/End,
    // with vim keys as secondary.
    binds {
        // ── Launch ───────────────────────────────────────────────────────────
        Mod+Return { spawn "kitty"; }
        Mod+D hotkey-overlay-title="应用启动器" { spawn "dms" "ipc" "call" "spotlight" "toggleWith" "apps"; }
        Alt+Space hotkey-overlay-title="全局搜索" { spawn "dms" "ipc" "call" "spotlight" "toggleWith" "all"; }
        Mod+Escape hotkey-overlay-title="电源菜单" { spawn "dms" "ipc" "call" "powermenu" "toggle"; }

        // ── Window management ─────────────────────────────────────────────────
        Mod+Q repeat=false { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+M { maximize-window-to-edges; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+C { center-column; }
        Mod+Ctrl+C { center-visible-columns; }
        Mod+O repeat=false { toggle-overview; }
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-column-width-back; }
        Mod+V { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        Mod+Shift+W { toggle-column-tabbed-display; }
        Mod+Shift+E { quit; }
        Mod+Slash repeat=false hotkey-overlay-title="快捷键速查" { spawn "dms" "ipc" "call" "keybinds" "toggle" "niri"; }
        Mod+Shift+Slash { show-hotkey-overlay; }

        // ── Fine width / height adjustments ───────────────────────────────────
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }
        Mod+Ctrl+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }

        // ── Column ops (niri's scrollable-tiling paradigm) ───────────────────
        Mod+Comma  { consume-or-expel-window-left; }
        Mod+Period { consume-or-expel-window-right; }
        Mod+Shift+Comma  { consume-window-into-column; }
        Mod+Shift+Period { expel-window-from-column; }

        // ── Focus: ribbon navigation ─────────────────────────────────────────
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up    { focus-window-up; }
        Mod+Down  { focus-window-down; }
        Mod+Home  { focus-column-first; }
        Mod+End   { focus-column-last; }

        // ── Focus: vim keys (secondary) ──────────────────────────────────────
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }

        // ── Focus: cross-workspace alternatives ───────────────────────────────
        // Uncomment these instead of the regular focus binds to allow crossing
        // workspace boundaries when reaching the first/last window in a column.
        // Mod+J { focus-window-or-workspace-down; }
        // Mod+K { focus-window-or-workspace-up; }

        // ── Move: ribbon reordering ──────────────────────────────────────────
        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Home  { move-column-to-first; }
        Mod+Ctrl+End   { move-column-to-last; }

        // ── Move: vim keys (secondary) ───────────────────────────────────────
        Mod+Ctrl+H { move-column-left; }
        Mod+Ctrl+L { move-column-right; }
        Mod+Ctrl+K { move-window-up; }
        Mod+Ctrl+J { move-window-down; }

        // ── Monitor navigation ────────────────────────────────────────────────
        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+L     { focus-monitor-right; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+J     { focus-monitor-down; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }

        // ── Workspaces ───────────────────────────────────────────────────────
        Mod+1 { focus-workspace 1; }
        Mod+Ctrl+1 { move-window-to-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+Ctrl+2 { move-window-to-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+Ctrl+3 { move-window-to-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+Ctrl+4 { move-window-to-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+Ctrl+5 { move-window-to-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+Ctrl+6 { move-window-to-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+Ctrl+7 { move-window-to-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+Ctrl+8 { move-window-to-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+9 { move-window-to-workspace 9; }
        Mod+0 { focus-workspace 10; }
        Mod+Ctrl+0 { move-window-to-workspace 10; }

        // Workspace up/down (alternative to numbered shortcuts).
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }
        Mod+Ctrl+U { move-column-to-workspace-down; }
        Mod+Ctrl+I { move-column-to-workspace-up; }
        Mod+Shift+U { move-workspace-down; }
        Mod+Shift+I { move-workspace-up; }

        // ── Scroll (mouse wheel) ──────────────────────────────────────────────
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

        // ── Media keys ───────────────────────────────────────────────────────
        XF86AudioNext       { spawn "dms" "ipc" "call" "mpris" "next"; }
        XF86AudioPause allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "playPause"; }
        XF86AudioPlay  allow-when-locked=true { spawn "dms" "ipc" "call" "mpris" "playPause"; }
        XF86AudioPrev       { spawn "dms" "ipc" "call" "mpris" "previous"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "increment" "5"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "decrement" "5"; }
        XF86AudioMute        repeat=false allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "mute"; }
        XF86AudioMicMute     repeat=false allow-when-locked=true { spawn "dms" "ipc" "call" "audio" "micmute"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "5" ""; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "5" ""; }
        xf86KbdBrightnessUp   { spawn "brightnessctl" "-d" "*::kbd_backlight" "set" "33%+"; }
        xf86KbdBrightnessDown { spawn "brightnessctl" "-d" "*::kbd_backlight" "set" "33%-"; }

        // ── Screenshots ───────────────────────────────────────────────────────
        Print { spawn "dms" "screenshot" "--no-confirm"; }
        Ctrl+Print { spawn "dms" "screenshot" "full"; }
        Alt+Print { spawn "dms" "screenshot" "window"; }
        Mod+Shift+S { spawn "dms" "screenshot" "--no-confirm"; }

        // ── Power ────────────────────────────────────────────────────────────
        Mod+Shift+P { power-off-monitors; }

        // ── Keyboard shortcuts inhibit escape hatch ───────────────────────────
        Mod+Shift+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // ── Utilities ────────────────────────────────────────────────────────
        Mod+W hotkey-overlay-title="剪贴板历史" { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
        Mod+E hotkey-overlay-title="Emoji 搜索" { spawn "dms" "ipc" "call" "spotlight" "openQuery" ":e "; }
        Mod+N hotkey-overlay-title="通知中心" { spawn "dms" "ipc" "call" "notifications" "toggle"; }
        Mod+A hotkey-overlay-title="控制中心" { spawn "dms" "ipc" "call" "control-center" "toggle"; }
        Mod+Alt+F hotkey-overlay-title="文件管理器" { spawn "dfiles" "open"; }
        Mod+Shift+O { spawn "ocr"; }
        Mod+Shift+T { spawn "ocr-trans"; }
        Mod+Alt+L { spawn "dms" "ipc" "call" "lock" "lock"; }
        Mod+Alt+Delete { spawn "dms" "color" "pick" "--autocopy"; }
    }

    // Dux settings can save monitor, window-rule and shortcut overrides here.
    include optional=true "dms/outputs.kdl"
    include optional=true "dms/windowrules.kdl"
    include optional=true "dms/binds.kdl"
  '';
in
{
  home.packages = with pkgs; [ niri ];

  xdg.configFile."niri/config.kdl".text = configKDL;
}
