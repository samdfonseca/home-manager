{ config, pkgs, ... }:

let
  zinitHome = "${config.xdg.dataHome}/zinit/zinit.git";
in
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ ];
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

  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    defaultKeymap = "viins";

    initContent = ''
      # Reduce mode switch delay (default is 0.4s)
      export KEYTIMEOUT=1

      # Bootstrap zinit
      ZINIT_HOME="${zinitHome}"
      if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
        print -P "%F{33}▓▒░ %F{220}Installing zinit…%f"
        command mkdir -p "$(dirname "$ZINIT_HOME")"
        command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
          print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
          print -P "%F{160}▓▒░ Clone failed.%f%b"
      fi
      source "''${ZINIT_HOME}/zinit.zsh"

      # Plugins
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light zsh-users/zsh-completions

      # Snippets (OMZ libraries/plugins loaded as snippets)
      zinit snippet OMZP::git
      zinit snippet OMZP::command-not-found
      zinit snippet OMZP::eza
      zinit snippet OMZP::aws
      zinit snippet OMZP::uv

      # Completions
      autoload -Uz compinit && compinit
      zinit cdreplay -q

      # vicmd: up/down → atuin interactive history search
      bindkey -M vicmd '^[[A' _atuin_search_widget
      bindkey -M vicmd '^[[B' _atuin_search_widget

      # vicmd: j/k → basic sequential history navigation
      bindkey -M vicmd 'k' up-line-or-history
      bindkey -M vicmd 'j' down-line-or-history

      # Mise (dev tool version manager)
      eval "$(mise activate zsh)"
      eval "$(mise completion zsh)"
    '';
  };
}
