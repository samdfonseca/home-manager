# Home Manager Configuration

Nix flake-based [home-manager](https://nix-community.github.io/home-manager/) configuration for user `samfonseca` on a non-NixOS x86_64-linux system with an NVIDIA GPU.

## Structure

```
flake.nix   — Flake entrypoint: pins nixpkgs (unstable) and home-manager, defines the single homeConfiguration
flake.lock  — Pinned dependency versions (do not edit by hand)
home.nix    — Root module: imports all others, sets user identity, stateVersion, packages, session vars, genericLinux/GPU config
kitty.nix   — Kitty terminal emulator settings (font, keybindings, window behavior)
tmux.nix    — Tmux config (prefix C-a, plugins via tmuxPlugins, cross-platform clipboard, vim-aware pane switching)
zsh.nix     — Zsh shell config (vi mode, zinit plugin manager, atuin history, zoxide, completions)
```

`home.nix` is the root module — all other `*.nix` files are imported from its `imports` list. To add a new program module, create a new `.nix` file and add it to that list.

## Applying Changes

```sh
home-manager switch --flake .
```

This builds the configuration and activates it (symlinks dotfiles, updates PATH, etc.). Run this after every change.

## Updating Dependencies

```sh
nix flake update          # update all inputs (nixpkgs + home-manager)
home-manager switch --flake .
```

## Key Details

- **Not NixOS** — this is a standalone home-manager setup on a regular Linux distro. `targets.genericLinux.enable = true` bridges the gap (GPU drivers, XDG dirs, etc.).
- **NVIDIA GPU** — driver version and hash are pinned in `home.nix` under `targets.genericLinux.gpu.nvidia`. Update these when the host driver changes.
- **stateVersion = "25.11"** — do not change this unless intentionally migrating (see home-manager release notes first).
- **Nix language** — all config files are Nix expressions. Use `pkgs` for packages, `config` for self-referencing option values. Strings with interpolation use double-single-quotes (`''...''`), and `$` must be escaped as `''$` inside them.

## Conventions

- One `.nix` file per program/concern, imported from `home.nix`.
- Packages that only one module needs (e.g., `xclip` for tmux clipboard) go in that module's `home.packages`, not in `home.nix`.
- Use `programs.<name>.enable = true` with home-manager module options wherever available rather than installing packages and writing dotfiles manually.
- Prefer home-manager's structured options (e.g., `programs.kitty.settings`) over raw config strings (`extraConfig`) when the option exists.

## Useful References

- Home-manager options search: https://home-manager-options.extranix.com/
- Nixpkgs package search: https://search.nixos.org/packages
- Nix language reference: https://nix.dev/manual/nix/latest/language/
