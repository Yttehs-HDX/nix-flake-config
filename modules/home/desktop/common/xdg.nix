{ ... }:

{
  xdg.userDirs.enable = true;

  # Home Manager owns ~/.config/mimeapps.list because dux-files enables
  # xdg.mimeApps. Preserve the defaults that apps had registered there at
  # runtime before the switch to dux.
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/clash" = "clash-verge.desktop";
      "x-scheme-handler/clash-verge" = "clash-verge.desktop";
      "text/csv" = "onlyoffice-desktopeditors.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/clash" = "clash-verge.desktop";
      "x-scheme-handler/clash-verge" = "clash-verge.desktop";
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/codex" = "chatgpt.desktop";
      "x-scheme-handler/openbot" = "openbot.desktop";
      "text/csv" = "onlyoffice-desktopeditors.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };
}
