let
  palette = import ./palette.nix;
in
{
  services.swaync.style = ''
    .floating-notifications,
    .floating-notifications * {
      all: unset;
      font-size: 14px;
      font-family: "SF Pro";
      transition: 200ms;
    }

    .floating-notifications trough highlight {
      background: ${palette.text};
    }

    .floating-notifications scale trough {
      margin: 0rem 1rem;
      background-color: ${palette.surface0};
      min-height: 8px;
      min-width: 70px;
    }

    .floating-notifications slider {
      background-color: ${palette.blue};
    }

    .floating-notifications.background .notification-row .notification-background {
      box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px ${palette.surface0};
      border-radius: 12.6px;
      margin: 18px;
      background-color: ${palette.base};
      color: ${palette.text};
      padding: 0;
    }

    .floating-notifications.background .notification-row .notification-background .notification {
      padding: 7px;
      border-radius: 12.6px;
    }

    .floating-notifications.background .notification-row .notification-background .notification.critical {
      box-shadow: inset 0 0 7px 0 ${palette.red};
    }

    .floating-notifications.background .notification-row .notification-background .notification .notification-content {
      margin: 7px;
    }

    .floating-notifications.background .notification-row .notification-background .notification .notification-content .summary {
      color: ${palette.text};
    }

    .floating-notifications.background .notification-row .notification-background .notification .notification-content .time {
      color: ${palette.subtext0};
    }

    .floating-notifications.background .notification-row .notification-background .notification .notification-content .body {
      color: ${palette.text};
    }

    .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
      min-height: 3.4em;
    }

    .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
      border-radius: 7px;
      color: ${palette.text};
      background-color: ${palette.surface0};
      box-shadow: inset 0 0 0 1px ${palette.surface1};
      margin: 7px;
    }

    .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
      box-shadow: inset 0 0 0 1px ${palette.surface1};
      background-color: ${palette.surface0};
      color: ${palette.text};
    }

    .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
      box-shadow: inset 0 0 0 1px ${palette.surface1};
      background-color: ${palette.sapphire};
      color: ${palette.text};
    }

    .floating-notifications.background .notification-row .notification-background .close-button {
      margin: 7px;
      padding: 2px;
      border-radius: 6.3px;
      color: ${palette.base};
      background-color: ${palette.red};
    }

    .floating-notifications.background .notification-row .notification-background .close-button:hover {
      background-color: ${palette.maroon};
      color: ${palette.base};
    }

    .floating-notifications.background .notification-row .notification-background .close-button:active {
      background-color: ${palette.red};
      color: ${palette.base};
    }

    .control-center {
      --text-color: ${palette.text};
      --text-color-disabled: ${palette.overlay2};
      --noti-border-color: ${palette.surface1};
      --noti-bg-hover: ${palette.surface1};
      --noti-bg-focus: ${palette.surface1};
      --border-radius: 12px;
      --notification-icon-size: 28px;
      --notification-app-icon-size: 14px;
      --notification-group-icon-size: 20px;
      --font-size-body: 14px;
      --font-size-summary: 14px;

      font-family: "SF Pro", "JetBrainsMono Nerd Font", "Noto Sans CJK SC", sans-serif;
      font-size: 15px;
      color: ${palette.text};
      background: ${palette.base};
      border: 2px solid ${palette.blue};
      border-radius: 20px;
      padding: 20px;
    }

    .control-center .widget {
      margin: 0;
      padding: 0;
    }

    .control-center .widget-label.clock {
      margin-bottom: 12px;
    }

    .control-center .widget-label.clock > label {
      color: ${palette.lavender};
      font-size: 28px;
      font-weight: 600;
    }

    .control-center .widget-dnd,
    .control-center .widget-volume {
      background: ${palette.surface0};
      padding: 12px 14px;
    }

    .control-center .widget-dnd {
      border-radius: 12px 12px 0 0;
    }

    .control-center .widget-volume {
      border-top: 1px solid ${palette.surface1};
      border-radius: 0 0 12px 12px;
    }

    .control-center .widget-dnd > label,
    .control-center .widget-volume > box > label {
      font-size: 15px;
      font-weight: 600;
    }

    .control-center .widget-dnd switch {
      min-width: 34px;
      min-height: 20px;
      padding: 3px;
      border: 1px solid ${palette.surface2};
      border-radius: 999px;
      background: ${palette.mantle};
      background-image: none;
      box-shadow: none;
    }

    .control-center .widget-dnd switch:checked {
      background: ${palette.sky};
      border-color: ${palette.sky};
    }

    .control-center .widget-dnd switch slider {
      min-width: 14px;
      min-height: 14px;
      margin: 0;
      background: ${palette.subtext0};
      background-image: none;
      border: none;
      border-radius: 999px;
      box-shadow: none;
    }

    .control-center .widget-dnd switch:checked slider {
      background: ${palette.base};
    }

    .control-center .widget-volume scale {
      margin: 0 12px;
      padding: 8px 0;
    }

    .control-center .widget-volume trough {
      background: ${palette.surface2};
      min-height: 6px;
      border-radius: 5px;
    }

    .control-center .widget-volume highlight {
      background: ${palette.sky};
      border-radius: 5px;
    }

    .control-center .widget-volume scale slider {
      margin: -4px;
      min-width: 14px;
      min-height: 14px;
      border: none;
      border-radius: 50%;
      background: ${palette.text};
    }

    .control-center .widget-volume .per-app-volume {
      margin: 8px 0 0;
      padding: 4px;
      background: ${palette.mantle};
      border-radius: 8px;
    }

    .control-center .widget-volume button,
    .control-center .widget-title button,
    .control-center .widget-buttons-grid button {
      background: ${palette.surface0};
      color: ${palette.text};
      border: 1px solid ${palette.surface1};
      border-radius: 9px;
      box-shadow: none;
      padding: 4px 10px;
      min-height: 24px;
    }

    .control-center .widget-buttons-grid {
      margin: 6px -6px 0;
    }

    .control-center .widget-buttons-grid flowboxchild {
      padding: 6px;
    }

    .control-center .widget-buttons-grid button {
      min-height: 28px;
      padding: 5px 14px;
      font-size: 15px;
      font-weight: 600;
    }

    .control-center .widget-volume button:hover,
    .control-center .widget-title button:hover,
    .control-center .widget-buttons-grid button:hover {
      background: ${palette.surface1};
    }

    .control-center button:focus-visible,
    .control-center scale:focus-visible {
      outline: 2px solid ${palette.sky};
      outline-offset: -2px;
    }

    .control-center .widget-mpris {
      margin-bottom: 12px;
    }

    .control-center .widget-mpris .widget-mpris-player {
      margin: 0;
      padding: 0;
      border-radius: 14px;
      background: ${palette.surface0};
      box-shadow: none;
    }

    .control-center .widget-mpris-player .mpris-background {
      filter: none;
    }

    .control-center .widget-mpris-player .mpris-overlay {
      min-height: 88px;
      padding: 14px 16px 12px;
      border-radius: 14px;
      background: linear-gradient(100deg, rgba(17, 17, 27, 0.90), rgba(17, 17, 27, 0.56));
    }

    .control-center .widget-mpris-title {
      color: #ffffff;
      font-size: 17px;
      font-weight: 700;
    }

    .control-center .widget-mpris-subtitle {
      color: #e4e6f3;
      font-size: 14px;
    }

    .control-center .mpris-overlay button {
      min-height: 30px;
      min-width: 30px;
      padding: 2px;
      border-radius: 50%;
      color: #ffffff;
      background: rgba(17, 17, 27, 0.50);
      box-shadow: none;
    }

    .control-center .mpris-overlay button:hover {
      background: ${palette.surface1};
    }

    /* Play/pause is the middle button in SwayNC's five-button transport. */
    .control-center .mpris-overlay > box:last-child > button:nth-child(3):not(:disabled) {
      color: ${palette.base};
      background: ${palette.sky};
    }

    .control-center .mpris-overlay > box:last-child > button:nth-child(3):not(:disabled):hover {
      background: ${palette.text};
    }

    .control-center .mpris-overlay button:disabled {
      opacity: 0.45;
    }

    .control-center .widget-title {
      margin: 10px 0 0;
    }

    .control-center .widget-title > label {
      margin: 0;
    }

    .control-center .widget-title button {
      min-width: 30px;
      min-height: 30px;
      padding: 0;
      border-radius: 50%;
      font-size: 14px;
      font-weight: 600;
      margin: 0;
    }

    .control-center .widget-title button:disabled {
      color: ${palette.overlay2};
      background: ${palette.mantle};
    }

    .control-center .control-center-list {
      margin-top: 6px;
    }

    .control-center .control-center-list,
    .control-center .control-center-list row,
    .control-center .notification-group,
    .control-center .notification-group:focus,
    .control-center .notification-row,
    .control-center .notification-row:focus {
      background: transparent;
      outline: none;
      box-shadow: none;
    }

    .control-center .notification-group .notification-group-headers,
    .control-center .notification-group .notification-group-buttons {
      margin: 0 4px;
    }

    .control-center .notification-group .notification-group-headers {
      padding: 4px 0;
    }

    .control-center .notification-group .notification-group-header {
      font-size: 15px;
      font-weight: 600;
      color: ${palette.subtext1};
    }

    .control-center .notification-group .notification-group-icon {
      -gtk-icon-size: 18px;
      margin-right: 6px;
    }

    .control-center .notification-group .notification-group-buttons button {
      min-width: 26px;
      min-height: 26px;
      padding: 0;
      margin: 0 2px;
      border: none;
      border-radius: 50%;
      background: ${palette.surface0};
      color: ${palette.text};
      box-shadow: none;
    }

    .control-center .notification-group .notification-group-buttons button:hover {
      background: ${palette.surface1};
    }

    .control-center .notification-row .notification-background {
      background: transparent;
      padding: 3px 0;
    }

    .control-center .notification-background .notification {
      background: ${palette.surface0};
      border: 1px solid ${palette.surface1};
      border-radius: 12px;
      box-shadow: none;
    }

    .control-center .notification-background .notification.critical {
      border-color: ${palette.red};
    }

    .control-center .notification-row .notification-background .notification .notification-default-action {
      padding: 7px 10px;
      border-radius: 12px;
    }

    .control-center .notification-row .notification-background .notification .summary {
      font-weight: 600;
    }

    .control-center .notification-row .notification-background .notification .time {
      margin-right: 6px;
      font-size: 12px;
      font-weight: 400;
      color: ${palette.subtext0};
    }

    .control-center .notification .time,
    .control-center .control-center-list-placeholder {
      color: ${palette.subtext0};
    }
    .control-center .control-center-list-placeholder {
      opacity: 1;
      margin: 6px 0 0;
    }

    .control-center .control-center-list-placeholder image {
      /* The GTK template reserves a 96 px icon even when there are no messages. */
      opacity: 0.6;
      transform: scale(0.44);
      margin: -28px 0;
    }
  '';
}
