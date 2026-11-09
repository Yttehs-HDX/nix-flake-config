let
  palette = import ./palette.nix;
in
{
  xdg.configFile."swayosd/style.css".text = ''
    window#osd {
      background: ${palette.base};
      color: ${palette.text};
      border: 1px solid ${palette.surface1};
      border-radius: 18px;
    }
    window#osd #container { margin: 12px 16px; }
    window#osd image, window#osd label { color: ${palette.text}; }
    window#osd trough { background: ${palette.surface1}; }
    window#osd progress { background: ${palette.sky}; }
  '';
}
