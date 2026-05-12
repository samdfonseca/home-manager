{ config, pkgs, ... }:

{
  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      interval = 5;
    };

    modules = {
      "volume master" = {
        position = 1;
        settings = {
          format = "♪ %volume";
          format_muted = "♪ muted (%volume)";
          device = "pulse";
        };
      };

      "disk /" = {
        position = 2;
        settings = {
          format = "/ %avail";
        };
      };

      "memory" = {
        position = 3;
        settings = {
          format = "MEM %used";
          threshold_degraded = "1G";
          format_degraded = "MEM < %available";
        };
      };
      
      "battery all" = {
        position = 4;
        settings = {
          status_chr = "⚡ CHR";
          status_bat = "🔋 BAT";
          status_full = "FULL";
        };
      };

      "tztime local" = {
        position = 5;
        settings = {
          format = "%Y-%m-%d %H:%M:%S";
        };
      };

      # Disable default modules we don't need
      "ipv6".enable = false;
      "wireless _first_".enable = true;
      "ethernet _first_".enable = true;
      "load".enable = false;
    };
  };
}
