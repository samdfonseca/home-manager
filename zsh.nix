{ config, pkgs, ... }:

let
  zinitHome = "${config.xdg.dataHome}/zinit/zinit.git";
in
{
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
      # When connected via SSH with agent forwarding, add keys to the
      # forwarded agent rather than letting keychain start its own.
      if [[ -n "''${SSH_CONNECTION}" && -n "''${SSH_AUTH_SOCK}" ]]; then
        ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_ed25519 2>/dev/null
      fi

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

      # Prevent syntax-highlighting from stat-checking paths on slow NFS mount
      ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/nas_mnt)

      # Snippets (OMZ libraries/plugins loaded as snippets)
      zinit snippet OMZP::git
      zinit snippet OMZP::command-not-found
      zinit snippet OMZP::eza
      zinit snippet OMZP::aws
      zinit snippet OMZP::uv
      zinit snippet OMZP::rust

      # Completions
      autoload -Uz compinit && compinit
      autoload -Uz bashcompinit && bashcompinit
      zinit cdreplay -q

      # Exclude slow NFS mount from completion
      zstyle ':completion:*' ignored-patterns '/mnt/nas_mnt|/mnt/nas_mnt/*'

      # vicmd: up/down → atuin interactive history search
      bindkey -M vicmd '^[[A' _atuin_search_widget
      bindkey -M vicmd '^[[B' _atuin_search_widget

      # vicmd: j/k → basic sequential history navigation
      bindkey -M vicmd 'k' up-line-or-history
      bindkey -M vicmd 'j' down-line-or-history

      export PATH=$HOME/.toolbox/bin:$PATH

      # Mise (dev tool version manager)
      eval "$(mise activate zsh)"
      eval "$(mise completion zsh)"

      # gcloud completions (installed via mise)
      source "$(mise where gcloud)/completion.zsh.inc"

      # Module proxy configuration (BrazilMakeGo 3.0 handles this automatically)
      export GOPROXY=direct  # Only needed for older BrazilMakeGo versions

      # Private module configuration
      export GOPRIVATE=golang.a2z.com

      # Disable checksum database for internal modules
      export GOSUMDB=off
    '';
  };
}
