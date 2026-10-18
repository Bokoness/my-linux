# Prompt: restore my dev environment on this fresh Ubuntu install

You are setting up my new Ubuntu machine so it matches my old Fedora 44 (GNOME 50) machine.
A backup folder from the old machine is at `~/ubuntu-migration/` (it sits next to this file). Use the files in it as the source of truth.

## Ground rules
- Run `cat /etc/os-release` and `gnome-shell --version` first, then adapt every command to this Ubuntu release.
- Prefer apt. Use the official upstream repo or a release binary only when apt's version is too old or missing (noted below).
- Make every step idempotent: check whether a tool is already installed before installing it.
- Ask before running anything destructive, and before running `chsh`. Ask before anything that needs my credentials (gh auth, atuin login, Docker group).
- At the end, give me a summary table: installed / skipped / failed / needs manual action.

## Backup folder layout (`~/ubuntu-migration/`)
- `configs/fish/`: full `~/.config/fish` (config.fish, functions, completions, conf.d, fish_plugins, my_commands/)
- `configs/nvim/`: LazyVim config (`~/.config/nvim`)
- `configs/gitconfig`: `~/.gitconfig`
- `configs/atuin/`, `configs/flameshot/`, `configs/copyous@boerdereinar.dev/`: app configs for `~/.config/`
- `configs/fonts/`: JetBrainsMono Nerd Font (goes to `~/.local/share/fonts`)
- `configs/Bibata-Modern-Classic/`: cursor theme (goes to `~/.local/share/icons`)
- `configs/gnome-extensions/`: copies of the installed extension folders (fallback only)
- `dconf/*.dconf`: GNOME settings dumps (extensions, keybindings, Ptyxis, input sources, interface)
- `dconf/FULL-dump-reference-only.dconf`: full dump. **Do NOT load it wholesale.** Read it only for reference.
- `lists/`: enabled/disabled GNOME extensions, VS Code extensions, the old Flatpak app list (reference only)

## 1. Base packages
```
sudo apt update && sudo apt install -y git curl wget unzip zip build-essential \
  ripgrep fd-find fzf jq tree bat tmux ranger mycli xclip wl-clipboard \
  python3-pip python3-venv pipx gnome-tweaks gnome-shell-extensions \
  gnome-shell-extension-manager flameshot dconf-cli
```
Ubuntu-specific fixes:
- `bat` installs as `batcat` and `fd` as `fdfind`. Symlink both into `~/.local/bin` as `bat` and `fd`. My fish config calls `bat`.
- Make sure `~/.local/bin` is on PATH. config.fish already handles this for fish.

## 2. Fish shell + plugins
- Install the latest fish 4.x from `ppa:fish-shell/release-4` (the old machine had 4.6.0).
- Copy `configs/fish/` to `~/.config/fish/`. Also `git clone git@github.com:Bokoness/shell.git` once SSH keys are restored. The repo is the same config, so prefer the repo if it is newer, and diff the two.
- Install Fisher, then the plugins from `fish_plugins`:
  `jorgebucaran/fisher`, `edc/bass`, `yo-goto/ggl.fish`, `oh-my-fish/theme-bira` (the bira theme provides `fish_prompt.fish`).
  Run: `fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"`
- Tools that config.fish depends on (install each one):
  | Tool | Used by | How on Ubuntu |
  |---|---|---|
  | eza | `l`, `ll` aliases | apt (`eza`), or the deb.gierens.de repo if apt lacks it |
  | bat | `cat` alias, `f` function | apt + symlink (see above) |
  | zoxide | replaces `cd` | apt or official install script |
  | atuin | shell history (`enter_accept = true`, sync enabled) | official installer `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh \| sh`; copy `configs/atuin/` |
  | lazygit | `lg` | latest GitHub release binary into `~/.local/bin` |
  | gh + gh-dash | `gd` alias | see section 4 |
  | mycli | `mysql` alias | apt |
  | ranger, tmux | `r`, `tm` | apt |
  | fzf | `f` function | apt |
  | xclip | `cc` function | apt |
  | docker | `d`, `startDocker` | see section 6 |
  | nvm (via bass) | `nvm` function | see section 5 |
- Fedora-only aliases: `fpoff` and `fpon` use `authselect`, which Ubuntu doesn't have. Rewrite them to use `sudo pam-auth-update` (enable/disable fingerprint), or ask me.
- `conf.d/rustup.fish` sources `~/.cargo/env.fish` only if it exists. Leave it there. Ask me whether to install rustup.
- Aliases exist for `kubectl`, `terraform`, `aws`/`awslocal`, and `~/Apps/mop/mop` (stocks), but none of these were installed on the old machine. **Ask me** before installing them.
- `my_commands/install_packages.sh` is an older Ubuntu install script I wrote. Don't run it. Its nvim (Packer) and extension sections are outdated.
- `init.lua` inside the fish folder is an old Packer config. Ignore it.
- Ask before setting fish as my default shell with `chsh -s $(which fish)`.

## 3. Neovim (LazyVim)
- LazyVim needs Neovim ≥ 0.11 (the old machine had 0.12.5). Ubuntu's apt version is usually too old. Install the official release tarball (`nvim-linux-x86_64.tar.gz`) into `/opt/nvim` and symlink `/opt/nvim/bin/nvim` to `/usr/local/bin/nvim`. Or use `ppa:neovim-ppa/unstable` if that is current.
- LazyVim deps: git, build-essential (C compiler for treesitter), ripgrep, fd, fzf, lazygit, curl, unzip, Node (for some Mason LSPs), and a Nerd Font (section 8). Optionally `tree-sitter-cli` via npm.
- Copy `configs/nvim/` to `~/.config/nvim/`. Then run `nvim --headless "+Lazy! restore" +qa`. This installs the exact plugin versions pinned in `lazy-lock.json`.
- Set `EDITOR=nvim`. config.fish already sets it.

## 4. Git + GitHub CLI
- Copy `configs/gitconfig` to `~/.gitconfig`. It has my name, email, and aliases (`l1`, `l2`, `l`, `a`, `c`, `ca`, `cm`, `cam`, `s`).
  It points `core.excludesfile` at `~/.gitignore_global`, which didn't exist on the old machine. Create it with sensible defaults (`.env`, `node_modules/`, `.DS_Store`, `*.log`, `.idea/`, `.vscode/`).
- Install `gh` from the official cli.github.com apt repo.
- Ask me to run `gh auth login` (interactive). Then run:
  - `gh extension install dlvhdr/gh-dash`
  - `gh alias set co 'pr checkout'`
- SSH: I'll restore `~/.ssh` myself (keys + `config`). Afterwards run `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa ~/.ssh/config`, and test with `ssh -T git@github.com`.

## 5. Node / npm
- Install nvm from its latest GitHub release (install.sh).
- `nvm install 24 && nvm alias default 24`. The old machine had Node v24.21.0 / npm 11.x.
- The fish `nvm` function wraps nvm through `bass`. Check that `nvm use default` works inside fish, because config.fish calls it on startup.
- No extra global npm packages were installed. Enable corepack only if needed.

## 6. Docker & containers
- Install Docker CE from the official docker.com apt repo (docker-ce, cli, containerd, buildx, compose plugin).
- `sudo usermod -aG docker $USER` and enable the service. Tell me to log out and back in afterwards.
- Also install `podman` (it was installed on the old machine).

## 7. GNOME extensions + settings
Extensions that were **enabled** (install from extensions.gnome.org using `gext`, from `pipx install gnome-extensions-cli`, or Extension Manager):
- `extension-list@tu.berry`
- `copyous@boerdereinar.dev` (clipboard manager; copy `configs/copyous@boerdereinar.dev/` into `~/.config/`)
- `hidetopbar@mathieu.bidon.ca`
- `add-to-desktop@tommimon.github.com`
- `gtk4-ding@smedius.gitlab.com` (desktop icons)
- `appindicatorsupport@rgcjonas.gmail.com` (Ubuntu already ships this as `ubuntu-appindicators`, so use that one instead)
- `trayIconsReloaded@selfmade.pl`
- `fq@megh` (force quit)
- `vertical-workspaces@G-dH.github.com` (V-Shell)
- `caffeine@patapon.info`
- `just-perfection-desktop@just-perfection`
- `transparent-top-bar-tweaks@hectorandac.github.io`
- `apps-menu@gnome-shell-extensions.gcampax.github.com`, `places-menu@…`, `launch-new-instance@…` (from the `gnome-shell-extensions` apt package)

These were installed but **disabled**: `dash-to-dock@micxgx.gmail.com`, `window-list@…`.
`background-logo@fedorahosted.org` is Fedora-only, so skip it.

Ubuntu notes:
- Ubuntu ships its own `ubuntu-dock` and `ding@rastersoft.com`. I used gtk4-ding and had no dock, so ask me whether to disable `ubuntu-dock` and `ding`. Disabling them avoids duplicate desktop icons and docks.
- If an extension on extensions.gnome.org doesn't support this GNOME version, try the copy in `configs/gnome-extensions/`. If it still fails, report it.
- Extensions only load after a logout/login on Wayland. Install everything first, ask me to re-login, then enable them with `gnome-extensions enable <uuid>`.

Restore settings **after** the extensions are installed:
```
dconf load /org/gnome/shell/extensions/ < dconf/extensions.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < dconf/media-keys.dconf
dconf load /org/gnome/desktop/wm/keybindings/ < dconf/wm-keybindings.dconf
dconf load /org/gnome/desktop/input-sources/ < dconf/input-sources.dconf
dconf load /org/gnome/Ptyxis/ < dconf/ptyxis.dconf
```
For `interface.dconf`, don't load the whole file. Apply only these keys:
- `color-scheme 'prefer-dark'`
- `monospace-font-name 'JetBrainsMono Nerd Font Mono 12'`
- `cursor-theme 'Bibata-Modern-Classic'`, `cursor-size 24`

What these restore:
- Custom shortcuts: Ctrl+Alt+T opens `ptyxis --new-window`; Ctrl+Alt+S opens `QT_QPA_PLATFORM=wayland flameshot gui`; Super+M is mute.
- Workspace shortcuts: Ctrl+Alt+arrows switch workspace, Ctrl+Shift+Alt+arrows move a window, Super+D shows the desktop.
- Keyboard: layouts us + il (Hebrew), Caps Lock acts as Escape (`caps:escape_shifted_capslock`).
- Terminal: Ptyxis with the "Vs Code" palette and tab shortcuts Ctrl+Shift+H/L/K. Install `ptyxis` if Ubuntu doesn't ship it.
- Copy `configs/flameshot/` to `~/.config/flameshot/`.

## 8. Fonts + cursor
- Copy `configs/fonts/*` to `~/.local/share/fonts/`, then run `fc-cache -f`.
- Copy `configs/Bibata-Modern-Classic/` to `~/.local/share/icons/Bibata-Modern-Classic/`. Also symlink it into `~/.icons/` for X11 and snap apps. Then run `gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'`.

## 9. Apps
- VS Code: install from Microsoft's apt repo. Then run `cat lists/vscode-extensions.txt | xargs -L1 code --install-extension`.
- Google Chrome: install the official .deb.
- **Do NOT install Flatpak or Flathub.** Use the built-in Snap store instead (apt only where noted). These apps were Flatpaks on the old machine (`lists/flatpaks.txt` is for reference only):
  - Postman: `sudo snap install postman`
  - WebStorm: `sudo snap install webstorm --classic`
  - Telegram: `sudo snap install telegram-desktop`
  - VLC: `sudo snap install vlc`
  - Thunderbird: `sudo snap install thunderbird` (Ubuntu may already ship it as a snap)
  - Transmission: `sudo apt install transmission-gtk`
  - Extension Manager: already installed via apt in section 1
  - Google Chrome: already covered by the .deb above
  - Minecraft: use Mojang's official `.deb` launcher from minecraft.net. Ask me first.
  - If a snap name has changed, look it up with `snap find <app>` and confirm with me before installing an unofficial publisher's snap.
- Claude Code (`curl -fsSL https://claude.ai/install.sh | bash`) and OpenAI Codex CLI. Both lived in `~/.local/bin`.
- ChatGPT desktop app and cloudflared were installed on Fedora from their own repos. Install the Ubuntu equivalents if they exist.
- Kdenlive: `sudo snap install kdenlive` (or apt).
- Beeper: an AppImage in `~/Apps/`. I'll copy it myself. Install `libfuse2t64` so AppImages run.

## 10. Google Drive
Don't set up rclone. Ask me to add my Google account in Settings → Online Accounts (GNOME's built-in Drive integration) once everything else is done.

## 11. Verify
- In a new fish session these should all work with no errors at startup: `l`, `ll`, `cat`, `cd` (zoxide), `lg`, `gd`, `g l`, `nvm`, `node -v`, `nvim` (opens LazyVim with no errors; run `:checkhealth`), `docker ps`, `atuin` (ctrl+r), and the bira prompt.
- Run `gnome-extensions list --enabled` and compare it with `lists/gnome-extensions-enabled.txt`.
- Print the final summary table.
