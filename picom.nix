{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    settings = {
      use-damage = true;
    };
  };

  # Suppress startup error by ensuring graphical-session.target is fully active
  systemd.user.services.picom.Unit.Requires = [ "graphical-session.target" ];
}
