{ config, pkgs, ... }:

let
  tmuxCopyCmd = pkgs.writeShellScript "tmux-copy" ''
    if command -v pbcopy >/dev/null 2>&1; then
      pbcopy
    elif [ -n "$WAYLAND_DISPLAY" ]; then
      wl-copy
    else
      xclip -selection clipboard
    fi
  '';
in
{
  home.packages = with pkgs; [
    xclip
    wl-clipboard
  ];
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    historyLimit = 20000;
    escapeTime = 10;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      copycat
      pain-control
      resurrect
      sidebar
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'off'
        '';
      }
      {
        plugin = prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_fg 'white'
          set -g @prefix_highlight_bg 'blue'
          set -g @prefix_highlight_show_copy_mode 'on'
          set -g @prefix_highlight_copy_mode_attr 'fg=black,bg=yellow,bold'
        '';
      }
    ];

    extraConfig = ''
      # Split panes with | and _
      unbind %
      bind | split-window -h
      bind _ split-window -v

      # Kill window with k (unbind default &)
      unbind &
      bind k kill-window

      # Quick window/pane switching
      bind-key C-a last-window
      bind-key j last-pane

      # Copy mode bindings
      bind Space copy-mode
      bind C-Space copy-mode

      # Clipboard integration (pbcopy on macOS, wl-copy on Wayland, xclip on X11)
      bind C-y run -b "tmux save-buffer - | ${tmuxCopyCmd}"
      bind -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${tmuxCopyCmd}"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${tmuxCopyCmd}"

      # Status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-left '#[fg=green]#H  |'
      set -g status-left-length 30
      set -g window-status-current-style bg=red
      set -g status-interval 20
      set -g status-right '#{prefix_highlight} Continuum: #{continuum_status} | #[fg=yellow]#(date -u +"%Y-%m-%d %H:%M %Z")'
      set -g status-right-length 150

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on
      setw -g automatic-rename

      # Smart pane switching with awareness of vim splits
      is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?)(diff)?$"'
      bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
    '';
  };
}
