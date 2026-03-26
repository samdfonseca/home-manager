{ pkgs, ... }:

{
  home.packages = [ pkgs.python3Packages.ipython ];

  home.file.".ipython/profile_default/ipython_config.py".text = ''
    c.TerminalInteractiveShell.editing_mode = "vi"
  '';
}
