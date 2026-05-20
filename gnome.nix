{ pkgs, ... }:

{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.brightness-control-using-ddcutil; }
    ];
  };
}
