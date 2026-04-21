{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    withNodeJs = true;
  };

  home.activation.linkNeovimConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      [ -L "$HOME/.config/nvim" ] || ln -sf "$HOME/.config/home-manager/nvim" "$HOME/.config/nvim"
    '';
}
