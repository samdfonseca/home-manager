{ config, pkgs, ... }:

{
  # Install neovim as a package rather than via `programs.neovim`, so
  # home-manager doesn't generate its own `~/.config/nvim/init.lua`
  # that would collide with the one symlinked from this repo.
  home.packages = [
    (pkgs.neovim.override {
      withPython3 = true;
      withNodeJs = true;
    })
  ];

  home.activation.linkNeovimConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      [ -L "$HOME/.config/nvim" ] || ln -sf "$HOME/.config/home-manager/nvim" "$HOME/.config/nvim"
    '';
}
