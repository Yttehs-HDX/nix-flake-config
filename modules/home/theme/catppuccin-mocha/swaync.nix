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
      --notification-icon-size: 32px;
      --notification-app-icon-size: 14px;
      --notification-group-icon-size: 20px;
      --font-size-body: 14px;
      --font-size-summary: 15px;

      font-family: "SF Pro", "Noto Sans CJK SC", sans-serif;
      font-size: 14px;
      color: ${palette.text};
      background: ${palette.base};
      border: 1px solid ${palette.surface1};
      border-radius: 20px;
      padding: 18px;
    }

    .control-center .widget {
      margin: 0;
      padding: 0;
    }

    .control-center .widget-label.controls {
      margin: 2px 0 14px;
      padding-left: 10px;
      border-left: 3px solid ${palette.sky};
      border-radius: 0;
    }

    .control-center .widget-label.controls > label {
      font-size: 24px;
      font-weight: 700;
    }

    .control-center .widget-dnd,
    .control-center .widget-volume {
      background: ${palette.surface0};
      padding: 10px 14px;
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
      font-size: 14px;
      font-weight: 600;
    }

    .control-center .widget-dnd switch {
      min-width: 38px;
      min-height: 22px;
      padding: 2px;
      border: none;
      border-radius: 16px;
      background: ${palette.surface2};
    }

    .control-center .widget-dnd switch:checked {
      background: ${palette.sky};
    }

    .control-center .widget-dnd switch slider {
      min-width: 18px;
      min-height: 18px;
      background: ${palette.text};
      border: none;
      border-radius: 50%;
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
      margin: 6px 0 0;
    }

    .control-center .widget-buttons-grid flowboxchild {
      padding: 2px;
    }

    .control-center .widget-buttons-grid button {
      min-height: 28px;
      padding: 5px 14px;
      font-size: 14px;
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
      margin-top: 12px;
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
      min-height: 100px;
      padding: 14px 16px 10px;
      background: linear-gradient(100deg, rgba(17, 17, 27, 0.90), rgba(17, 17, 27, 0.56));
    }

    .control-center .widget-mpris-title {
      color: #ffffff;
      font-size: 19px;
      font-weight: 700;
    }

    .control-center .widget-mpris-subtitle {
      color: #e4e6f3;
      font-size: 13px;
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
      margin: 16px 0 7px;
    }

    .control-center .widget-title > label {
      font-size: 17px;
      font-weight: 700;
    }

    .control-center .widget-title button:disabled {
      color: ${palette.overlay2};
      background: ${palette.mantle};
    }

    .control-center .control-center-list,
    .control-center .notification-row {
      background: transparent;
    }

    .control-center .notification-row .notification-background {
      padding: 3px 1px;
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

    .control-center .notification-default-action {
      padding: 9px 11px;
    }

    .control-center .notification .time,
    .control-center .control-center-list-placeholder {
      color: ${palette.subtext0};
    }
    .control-center .control-center-list-placeholder {
      opacity: 1;
      margin: 6px 0 2px;
    }

    .control-center .control-center-list-placeholder image {
      /* The GTK template reserves a 96 px icon even when there are no messages. */
      opacity: 0.6;
      transform: scale(0.44);
      margin: -23px 0;
    }
  '';
}
