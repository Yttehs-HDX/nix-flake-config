{ pkgs, ... }:

{
  services.swayosd.enable = true;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "niri-level-osd";
      runtimeInputs = with pkgs; [
        brightnessctl
        gawk
        swayosd
        wireplumber
      ];
      text = ''
        export LC_ALL=C
        case "$1" in
          brightness)
            result=$(brightnessctl --class=backlight --machine-readable set "$2")
            IFS=, read -r _ _ _ percent _ <<< "$result"
            percent=''${percent%\%}
            icon=display-brightness-symbolic
            label=亮度
            ;;
          output|input)
            device=@DEFAULT_AUDIO_SINK@
            label=扬声器
            icon=sink-volume-high-symbolic
            if [[ $1 == input ]]; then
              device=@DEFAULT_AUDIO_SOURCE@
              label=麦克风
              icon=source-volume-high-symbolic
            fi

            if [[ $2 == toggle ]]; then
              wpctl set-mute "$device" toggle
            else
              wpctl set-volume "$device" "$2"
            fi
            state=$(wpctl get-volume "$device")
            read -r _ gain muted <<< "$state"
            if [[ $muted == '[MUTED]' ]]; then
              icon=''${icon/high/muted}
              label+="已静音"
            elif [[ $2 == toggle ]]; then
              label+="已取消静音"
            fi

            if [[ $2 == toggle ]]; then
              exec swayosd-client --custom-icon "$icon" --custom-message "$label"
            fi
            percent=$(awk -v gain="$gain" 'BEGIN { printf "%.0f", gain * 100 }')
            ;;
          *) exit 2 ;;
        esac

        fraction=$(awk -v p="$percent" 'BEGIN { print (p > 100 ? 1 : p / 100) }')
        exec swayosd-client --custom-icon "$icon" --custom-progress "$fraction" --custom-progress-text "$label $percent%"
      '';
    })
  ];
}
