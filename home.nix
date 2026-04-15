{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./tmux.nix
    ./starship.nix
    ./i3.nix
    ./i3status.nix
    ./picom.nix
    ./neovim.nix
    ./ipython.nix
    ./gpg.nix
    ./pass.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "safonse";
  home.homeDirectory = "/home/ANT.AMAZON.COM/safonse";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.jq
    pkgs.page
    pkgs.luajit
    pkgs.bat
    pkgs.curl
    pkgs.htop
    pkgs.deno
    pkgs.regclient
    pkgs.manifest-tool
    pkgs.solaar
    pkgs.clang_22
    pkgs.bear
    pkgs.nodejs
    pkgs.lazygit

    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.zed-mono
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.fira-mono
    pkgs.nerd-fonts.sauce-code-pro

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/samfonseca/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Non-NixOS GPU support: makes host GPU drivers visible to Nix programs
  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.nvidia = {
    version = "580.126.09";
    sha256 = "09pchs4lk2h8zpm8q2fqky6296h54knqi1vwsihzdpwaizj57b2c";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.keychain = {
    enable = true;
    enableZshIntegration = false;
    keys = [ "id_ecdsa" ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ ];
    daemon.enable = true;
    settings = {
      keymap_mode = "vim-normal";
      enter_accept = true;
      filter_mode = "host";
      search_mode = "fuzzy";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
