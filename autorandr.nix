{ config, pkgs, lib, ... }:

let
  lidWatcher = pkgs.writeShellScript "lid-watcher" ''
    set -u

    lid_file=$(${pkgs.coreutils}/bin/ls /proc/acpi/button/lid/*/state 2>/dev/null | ${pkgs.coreutils}/bin/head -n1)
    if [ -z "$lid_file" ]; then
      echo "lid-watcher: no /proc/acpi/button/lid/*/state found" >&2
      exit 1
    fi

    external_connected() {
      ${pkgs.xorg.xrandr}/bin/xrandr --query \
        | ${pkgs.gnugrep}/bin/grep -E '^(HDMI|DP)-[0-9]+ connected' >/dev/null 2>&1
    }

    prev=""
    while :; do
      curr=$(${pkgs.gawk}/bin/awk '{print $2}' "$lid_file")
      if [ -n "$prev" ] && [ "$curr" != "$prev" ]; then
        if [ "$curr" = "closed" ] && external_connected; then
          ${pkgs.autorandr}/bin/autorandr --change \
            || ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --off
        elif [ "$curr" = "open" ]; then
          ${pkgs.autorandr}/bin/autorandr --change || true
        fi
      fi
      prev="$curr"
      sleep 2
    done
  '';
in
{
  programs.autorandr = {
    enable = true;
    # Profiles are captured at runtime via `autorandr --save <name>`.
    # After activating this config:
    #   ~/.screenlayout/builtin-solo.sh  && autorandr --save builtin-solo
    #   ~/.screenlayout/dual.sh          && autorandr --save dual
    #   ~/.screenlayout/external-solo.sh && autorandr --save external-solo
    # Saved profiles land in ~/.config/autorandr/ and are matched by EDID.
  };

  # Watches X11 RandR events and triggers `autorandr --change` on monitor
  # connect/disconnect.
  systemd.user.services.autorandr-launcher = {
    Unit = {
      Description = "autorandr-launcher: trigger autorandr on RandR events";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.autorandr}/bin/autorandr-launcher";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Polls the ACPI lid state. On close with an external display connected,
  # re-runs autorandr (which will match an external-only profile by EDID); on
  # open, re-runs autorandr to pick up the new layout.
  systemd.user.services.lid-watcher = {
    Unit = {
      Description = "lid-watcher: switch monitor layout on laptop lid events";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lidWatcher}";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
