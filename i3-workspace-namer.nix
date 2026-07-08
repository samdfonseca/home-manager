{ config, pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.i3ipc ]);

  i3-workspace-namer = pkgs.writeScript "i3-workspace-namer" ''
    #!${python}/bin/python3
    import i3ipc

    CLASS_NAMES = {
        "google-chrome": "Chrome",
        "firefox": "Firefox",
        "slack": "Slack",
        "kitty": "Terminal",
        "alacritty": "Terminal",
        "code": "VSCode",
        "obsidian": "Obsidian",
        "spotify": "Spotify",
        "discord": "Discord",
        "gimp": "GIMP",
        "thunderbird": "Thunderbird",
        "org.remmina.remmina": "Remmina",
        "org.gnome.evolution": "Evolution",
    }

    def friendly_name(con):
        wm_class = con.window_class
        if wm_class and wm_class.lower() in CLASS_NAMES:
            return CLASS_NAMES[wm_class.lower()]
        if wm_class:
            return wm_class
        return None

    def first_window(workspace):
        """Find the first leaf (window) in the workspace container tree."""
        leaves = workspace.leaves()
        return leaves[0] if leaves else None

    def rename_workspace(i3, workspace):
        num = workspace.num
        first = first_window(workspace)
        if first:
            name = friendly_name(first)
            if name:
                new_name = f"{num}: {name}"
            else:
                new_name = str(num)
        else:
            new_name = str(num)

        if workspace.name != new_name:
            i3.command(f'rename workspace "{workspace.name}" to "{new_name}"')

    def rename_all(i3):
        tree = i3.get_tree()
        for ws in tree.workspaces():
            rename_workspace(i3, ws)

    def on_window(i3, event):
        rename_all(i3)

    def on_move(i3, event):
        rename_all(i3)

    i3 = i3ipc.Connection()
    i3.on(i3ipc.Event.WINDOW_NEW, on_window)
    i3.on(i3ipc.Event.WINDOW_CLOSE, on_window)
    i3.on(i3ipc.Event.WINDOW_MOVE, on_move)
    rename_all(i3)
    i3.main()
  '';
in
{
  systemd.user.services.i3-workspace-namer = {
    Unit = {
      Description = "Auto-rename i3 workspaces based on first window";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${i3-workspace-namer}";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
