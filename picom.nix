{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    settings = {
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
      use-damage = true;
    };
  };
}
