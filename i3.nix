{ config, pkgs, ... }:

let
  mod = "Mod1";
  refresh_i3status = "killall -SIGUSR1 i3status";
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
        { command = "/usr/bin/gnome-keyring-daemon --start --components=secrets"; notification = false; }
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
        { command = ''i3-msg rename workspace 1 to "1: Dev"''; }
        { command = ''i3-msg rename workspace 2 to "2: Chrome"''; }
        { command = ''i3-msg rename workspace 3 to "3: Slack"''; }
        { command = ''i3-msg rename workspace 4 to "4: Terminal"''; }
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
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

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

        # Screenshot (selection to clipboard)
        "Print" = "exec maim -s -u | xclip -selection clipboard -t image/png -i";

        # Switch to workspace
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        # Move focused container to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

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
