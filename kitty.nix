{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono";
      size = 12;
    };

    settings = {
      # Window
      window_padding_width = 4;
      placement_strategy = "center";
      hide_window_decorations = false;
      confirm_os_window_close = 0;

      # Scrollback
      scrollback_lines = 10000;

      # Mouse
      mouse_hide_wait = "3.0";
      copy_on_select = "clipboard";
      url_style = "curly";

      # Bell
      enable_audio_bell = false;
      visual_bell_duration = 0;

      # Performance
      sync_to_monitor = true;

      # Shell integration
      shell_integration = "enabled";
    };

    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+equal" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+0" = "change_font_size all 0";
    };
  };
}
