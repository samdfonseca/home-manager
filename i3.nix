{ config, pkgs, ... }:

let
  mod = "Mod1";
  refresh_i3status = "killall -SIGUSR1 i3status";

  i3-workspace = pkgs.writeShellScript "i3-workspace" ''
    set -euo pipefail
    ACTION="$1"
    WS_NUM="$2"

    eval "$(${pkgs.xdotool}/bin/xdotool getmouselocation --shell)"

    primary_x=999999
    cursor_monitor_x=0

    while IFS= read -r line; do
      if [[ "$line" =~ ([0-9]+)x[0-9]+\+([0-9]+)\+[0-9]+ ]]; then
        w="''${BASH_REMATCH[1]}"
        ox="''${BASH_REMATCH[2]}"
        if (( ox < primary_x )); then
          primary_x=$ox
        fi
        if (( X >= ox && X < ox + w )); then
          cursor_monitor_x=$ox
        fi
      fi
    done < <(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep -oP ' connected (primary )?\d+x\d+\+\d+\+\d+' | ${pkgs.gnugrep}/bin/grep -oP '\d+x\d+\+\d+\+\d+')

    offset=0
    if (( cursor_monitor_x != primary_x )); then
      offset=10
    fi

    target=$(( WS_NUM + offset ))

    case "$ACTION" in
      switch) ${pkgs.i3}/bin/i3-msg "workspace number $target" ;;
      move)   ${pkgs.i3}/bin/i3-msg "move container to workspace number $target" ;;
    esac
  '';

  # Move focused container to the visible workspace on the other monitor.
  i3-move-to-other-monitor = pkgs.writeShellScript "i3-move-to-other-monitor" ''
    set -euo pipefail
    focused=$(${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .output')
    target=$(${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r --arg f "$focused" '.[] | select(.visible and .output != $f) | .name' | head -n1)
    if [ -n "$target" ]; then
      ${pkgs.i3}/bin/i3-msg "move container to workspace $target"
    fi
  '';
in
{
  home.packages = [
    pkgs.brightnessctl
    pkgs.pulseaudio  # provides pactl for volume keybindings
  ];

  home.file.".config/X11/xorg.conf.d/40-libinput.conf".text = ''
    Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
        Option "NaturalScrolling" "false"
        Option "ClickMethod" "clickfinger"
    EndSection
  '';

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = mod;

      # font pango:monospace 10
      # font pango:SauceCodePro Nerd Font Mono Regular 10
      fonts = {
        names = [ "SauceCodePro Nerd Font Mono Regular" ];
        size = 12.0;
      };

      floating.modifier = mod;

      workspaceAutoBackAndForth = false;

      startup = [
        # { command = "/usr/bin/gnome-session"; notification = false; }
        { command = "/usr/local/amazon/sbin/acmed-session.sh"; notification = false; }
        { command = "/usr/bin/user-hooks"; notification = false; }
        # Start XDG autostart .desktop files using dex
        { command = "dex --autostart --environment i3"; notification = false; }
        # xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
        # screen before suspend. Use loginctl lock-session to lock your screen.
        { command = "xss-lock --transfer-sleep-lock -- i3lock --nofork"; notification = false; }
        # NetworkManager system tray GUI
        { command = "nm-applet"; notification = false; }
        # Make DISPLAY/XAUTHORITY visible to systemd user services (autorandr-launcher, lid-watcher, etc.)
        { command = "systemctl --user import-environment DISPLAY XAUTHORITY"; notification = false; }
        # Activate graphical-session.target so systemd user services (picom, etc.) start
        { command = "systemctl --user start graphical-session.target"; notification = false; }
        # { command = "dfzf-daemon"; notification = false; } # reboot to make the daemon running
        # { command = "copyq"; notification = false; }
      ];

      keybindings = {
        "${mod}+Shift+p" = "exec --no-startup-id ~/.local/bin/pw-picker.sh";
        # Volume controls (PulseAudio)
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && ${refresh_i3status}";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && ${refresh_i3status}";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && ${refresh_i3status}";
        "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${refresh_i3status}";

        # Brightness controls
        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";

        # Media controls
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPause" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";

        # Start a terminal
        "${mod}+Return" = "exec kitty";

        # Kill focused window
        "${mod}+Shift+q" = "kill";

        # Program launcher
        "${mod}+d" = "exec --no-startup-id i3-dmenu-desktop";

        # Change focus
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus right";
        # "${mod}+l" = "focus up";
        # "${mod}+semicolon" = "focus right";
        # "${mod}+Left" = "focus left";
        # "${mod}+Down" = "focus down";
        # "${mod}+Up" = "focus up";
        # "${mod}+Right" = "focus right";

        # Move focused window
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        # Split orientation
        "${mod}+h" = "split h";
        "${mod}+v" = "split v";

        # Fullscreen
        "${mod}+f" = "fullscreen toggle";

        # Container layout (stacked, tabbed, toggle split)
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # Toggle tiling / floating
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        # Focus parent container
        "${mod}+a" = "focus parent";
        # Focus child container
        # "${mod}+d" = "focus child";

        # Move focused container to the visible workspace on the other monitor
        "${mod}+Shift+m" = "exec --no-startup-id ${i3-move-to-other-monitor}";

        # Screenshot (selection to clipboard)
        "Print" = "exec maim -s -u | xclip -selection clipboard -t image/png -i";

        # Switch to workspace (cursor-aware: primary monitor = 1-9, secondary = 11-19)
        "${mod}+1" = "exec --no-startup-id ${i3-workspace} switch 1";
        "${mod}+2" = "exec --no-startup-id ${i3-workspace} switch 2";
        "${mod}+3" = "exec --no-startup-id ${i3-workspace} switch 3";
        "${mod}+4" = "exec --no-startup-id ${i3-workspace} switch 4";
        "${mod}+5" = "exec --no-startup-id ${i3-workspace} switch 5";
        "${mod}+6" = "exec --no-startup-id ${i3-workspace} switch 6";
        "${mod}+7" = "exec --no-startup-id ${i3-workspace} switch 7";
        "${mod}+8" = "exec --no-startup-id ${i3-workspace} switch 8";
        "${mod}+9" = "exec --no-startup-id ${i3-workspace} switch 9";
        "${mod}+0" = "exec --no-startup-id ${i3-workspace} switch 10";

        # Move focused container to workspace (cursor-aware)
        "${mod}+Shift+1" = "exec --no-startup-id ${i3-workspace} move 1";
        "${mod}+Shift+2" = "exec --no-startup-id ${i3-workspace} move 2";
        "${mod}+Shift+3" = "exec --no-startup-id ${i3-workspace} move 3";
        "${mod}+Shift+4" = "exec --no-startup-id ${i3-workspace} move 4";
        "${mod}+Shift+5" = "exec --no-startup-id ${i3-workspace} move 5";
        "${mod}+Shift+6" = "exec --no-startup-id ${i3-workspace} move 6";
        "${mod}+Shift+7" = "exec --no-startup-id ${i3-workspace} move 7";
        "${mod}+Shift+8" = "exec --no-startup-id ${i3-workspace} move 8";
        "${mod}+Shift+9" = "exec --no-startup-id ${i3-workspace} move 9";
        "${mod}+Shift+0" = "exec --no-startup-id ${i3-workspace} move 10";

        # Reload / restart / exit
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'\"";

        # Enter resize mode
        "${mod}+r" = "mode resize";
      };

      modes = {
        resize = {
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "semicolon" = "resize grow width 10 px or 10 ppt";
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          "Return" = "mode default";
          "Escape" = "mode default";
          "${mod}+r" = "mode default";
        };
      };

      bars = [
        {
          fonts = {
            names = [ "SauceCodePro Nerd Font Mono Regular" ];
            size = 12.0;
          };
          statusCommand = "i3status";
        }
      ];
    };

    extraConfig = ''
      set $PATH $PATH:${config.home.homeDirectory}/.local/share/mise/shims

      tiling_drag modifier titlebar

      # Set ultrawide to 100Hz
      exec_always --no-startup-id xrandr --output DP-2 --mode 3440x1440 --rate 100

      bindcode ctrl+d exec rofi -show combi -combi-modes drun,run -modes combi

      # for_window [app_id="^launcher$"] floating enable, sticky enable, resize set 30 ppt 60 ppt, border pixel 10
      # for_window [app_id="^launcher$"] floating enable, sticky enable
      # set $menu exec xterm -a launcher -e ${config.home.homeDirectory}/dev/git/sway-launcher-desktop/sway-launcher-desktop.sh
      # bindsym $mod+d exec $menu
      # A more modern dmenu replacement is rofi:
      # bindcode $mod+40 exec "rofi -modi drun,run -show drun"
      # There also is i3-dmenu-desktop which only displays applications shipping a
      # .desktop file. It is a wrapper around dmenu, so you need that installed.
      # bindcode $mod+40 exec --no-startup-id i3-dmenu-desktop

      # set $term kitty -1
      # exec --no-startup-id kitty -1 --start-as hidden
      # exec --no-startup-id kitty -1 --instance-group dfzf --start-as hidden  -o 'map escape close_window' -o 'listen_on=unix:/tmp/kitty-dfzf'
      # bindsym $mod+Tab    exec --no-startup-id kitty -1 --class=dfzf-popup -e dfzf-windows
      # bindsym $mod+l      exec --no-startup-id kitty -1 --instance-group dfzf --class=dfzf-popup -e dfzf-hub
      # bindsym $mod+n exec dfzf-term scratchpad $term
      # bindsym ctrl+slash exec dfzf-term toggle $term
      # bindsym shift+ctrl+slash exec dfzf-term kill $term
      # bindsym $mod+g exec dfzf-git

      # for_window [class="^dfzf-popup$"] floating enable, sticky enable, border pixel 6, exec dfzf-resize 65
    '';
  };
}
