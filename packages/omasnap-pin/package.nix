{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "omasnap-pin";
  # This version provides draggable, wheel-resizable native layer-shell pins.
  version = "1.12.0";
  src = pkgs.fetchFromGitHub {
    owner = "omacom";
    repo = "omasnap";
    rev = "a5009a4089f90b29e4b5d84fc1c6727551812df2";
    hash = "sha256-5xmgIOFzvStMRpzgMy8fBdm34UVrCATYT+s+ZAR/odc=";
  };
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    pkg-config
    wayland-scanner
    qt6.wrapQtAppsHook
  ];
  buildInputs = with pkgs; [
    wayland
    qt6.qtbase
    qt6.qtwayland
    kdePackages.layer-shell-qt
  ];
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail /usr/share/wayland-protocols ${pkgs.wayland-protocols}/share/wayland-protocols
  '';
  qtWrapperArgs = [
    "--prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.wl-clipboard ]}"
    "--prefix QT_PLUGIN_PATH : ${pkgs.kdePackages.layer-shell-qt}/${pkgs.qt6.qtbase.qtPluginPrefix}"
  ];
}
