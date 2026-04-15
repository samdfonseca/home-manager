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
          format = "MEM %used / %available";
          threshold_degraded = "1G";
          format_degraded = "MEM < %available";
        };
      };

      "tztime local" = {
        position = 4;
        settings = {
          format = "%Y-%m-%d %H:%M:%S";
        };
      };

      # Disable default modules we don't need
      "ipv6".enable = false;
      "wireless _first_".enable = false;
      "ethernet _first_".enable = false;
      "battery all".enable = false;
      "load".enable = false;
    };
  };
}
