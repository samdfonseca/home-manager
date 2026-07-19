{ config, pkgs, lib, ... }:

# keyd remaps keys at the evdev level, so it works across X11/Wayland/console.
# Its daemon runs as root and only reads /etc/keyd/, which home-manager can't
# manage on a non-NixOS system. Split of responsibilities:
#   - home-manager owns the config (~/.config/keyd/default.conf) and package
#   - `keyd-setup` (run once, needs sudo) symlinks /etc/keyd/default.conf to
#     the home-manager copy and installs the systemd system service, so later
#     config changes only need `home-manager switch` (which reloads keyd)
let
  # ExecStart uses the stable profile path (not a /nix/store path) so the unit
  # survives package updates without rerunning keyd-setup.
  serviceUnit = pkgs.writeText "keyd.service" ''
    [Unit]
    Description=keyd key remapping daemon
    Requires=local-fs.target
    After=local-fs.target

    [Service]
    Type=simple
    ExecStart=${config.home.profileDirectory}/bin/keyd
    Restart=always

    [Install]
    WantedBy=sysinit.target
  '';

  keyd-setup = pkgs.writeShellScriptBin "keyd-setup" ''
    set -euo pipefail

    sudo mkdir -p /etc/keyd
    sudo ln -sfn ${config.xdg.configHome}/keyd/default.conf /etc/keyd/default.conf
    sudo install -m 644 ${serviceUnit} /etc/systemd/system/keyd.service
    # membership in the keyd group allows `keyd reload` without sudo
    sudo groupadd -f keyd
    sudo usermod -aG keyd "''$USER"
    sudo systemctl daemon-reload
    sudo systemctl enable keyd.service
    sudo systemctl restart keyd.service
    echo "keyd is installed and running."
    echo "Log out and back in for keyd group membership to take effect."
  '';
in
{
  home.packages = [
    pkgs.keyd
    keyd-setup
  ];

  xdg.configFile."keyd/default.conf".text = ''
    [ids]

    *

    [main]

    capslock = leftcontrol
  '';

  # Best-effort reload so config edits apply on switch; skipped until the
  # daemon has been installed via keyd-setup. Falls back to sudo hint because
  # keyd group membership only applies to sessions started after keyd-setup.
  home.activation.reloadKeyd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v systemctl >/dev/null 2>&1 && systemctl is-active --quiet keyd.service; then
      run ${pkgs.keyd}/bin/keyd reload || verboseEcho "keyd reload failed; run 'sudo keyd reload' to apply the new config"
    fi
  '';
}
