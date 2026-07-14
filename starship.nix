{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Only show these modules — everything else is implicitly hidden
      format = "$hostname$directory$git_branch$git_status$character";

      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        format = "[$branch]($style) ";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
      };

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](purple)";
      };

      hostname = {
        ssh_only = true;
      };
    };
  };
}
