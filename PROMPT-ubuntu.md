# Ubuntu setup

Read [PROMPT.md](PROMPT.md) first: shared rules, choices, and steps. This file has the Ubuntu-specific parts.
Last tested on **Ubuntu 26.04.1 LTS (resolute), GNOME 50.1**, 2026-10-19.

## 1. Root-level installs: `setup-root-ubuntu.sh`
Run `bash setup-root-ubuntu.sh` in my terminal (it asks for my sudo password once). It is idempotent and logs to `setup-root-ubuntu.log`. It does the following:
- **Repos:** `ppa:fish-shell/release-4`, cli.github.com, download.docker.com (`$VERSION_CODENAME`), packages.microsoft.com (VS Code), pkg.cloudflare.com (`any` suite; it has no per-release suite).
- **Update:** `apt full-upgrade` + `snap refresh`.
- **apt packages:** git curl wget unzip zip build-essential ripgrep fd-find fzf jq tree bat tmux ranger mycli xclip wl-clipboard python3-pip python3-venv pipx gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager flameshot dconf-cli eza zoxide libfuse2t64 transmission-gtk ptyxis fish gh cloudflared code docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
- **Docker:** enables the service. It does **not** add me to the docker group. Ask me.
- **Neovim:** latest release tarball into `/opt/nvim`, symlinked to `/usr/local/bin/nvim` (apt's 0.11 is older than the old machine's 0.12).
- **Google Chrome:** official .deb (it adds its own apt source).
- **Snaps:** postman, webstorm (`--classic`), telegram-desktop, vlc, thunderbird (preinstalled).
- **Shell:** `chsh -s /usr/bin/fish`.
- **Wallpapers:** copies `configs/wallpapers/*.svg` to `~/Pictures/Wallpapers` and sets them (blue for light mode, dark grey for dark mode). It also writes `~/.local/share/gnome-background-properties/bokoness-solid.xml`, so the pair shows as one "Blue / Dark Grey" tile in Settings → Appearance. Runs as me, no sudo.

If you add or remove a package, update the script and this file together.

## 2. Ubuntu-specific fixes
- `bat` installs as `batcat` and `fd` as `fdfind`. Symlink them: `ln -sfn /usr/bin/batcat ~/.local/bin/bat` and `ln -sfn /usr/bin/fdfind ~/.local/bin/fd`.
- apt's zoxide is 0.9.8, which breaks `cd` on fish 4. Install zoxide 0.10+ into `~/.local/bin` (see PROMPT.md). config.fish puts `~/.local/bin` first on PATH, so it wins.
- nvm: add the `NVM_DIR` lines to `~/.bashrc` so Node also works in bash.
- Flameshot: 26.04's apt has **14.0.0**, which meets the v14 requirement. If apt ever has < 14, use the official Ubuntu build from https://github.com/flameshot-org/flameshot/releases (`ubuntu-24.04-amd64` zip, verify the `.sha256sum`, then `sudo apt install ./flameshot-*.deb`).
- Ptyxis ships with 26.04. Transmission and Thunderbird are preinstalled.

## 3. GNOME on Ubuntu
- **Keep Ubuntu's own dock (`ubuntu-dock`) and desktop icons (`ding@rastersoft.com`) as they are.**
  - Don't install dash-to-dock or gtk4-ding. They duplicate the dock and desktop icons.
  - `ubuntu-dock` reads `/org/gnome/shell/extensions/dash-to-dock/`. Never load dash-to-dock settings. If the dock looks wrong, run `dconf reset -f /org/gnome/shell/extensions/dash-to-dock/`.
- **Install from extensions.gnome.org:** extension-list@tu.berry, copyous@boerdereinar.dev, hidetopbar@mathieu.bidon.ca, add-to-desktop@tommimon.github.com, trayIconsReloaded@selfmade.pl, fq@megh, vertical-workspaces@G-dH.github.com, caffeine@patapon.info, just-perfection-desktop@just-perfection, transparent-top-bar-tweaks@hectorandac.github.io.
- **Already there:** `ubuntu-appindicators@ubuntu.com` replaces `appindicatorsupport@rgcjonas.gmail.com`, so don't install the latter. apps-menu, places-menu, and launch-new-instance come from the `gnome-shell-extensions` apt package.
- **Skip:** `gtk4-ding@smedius.gitlab.com` (use Ubuntu's ding) and `background-logo@fedorahosted.org` (Fedora only).
- **Ctrl+Alt+T:** keep Ubuntu's built-in shortcut (`media-keys terminal`). Don't clear it. `media-keys.dconf` only adds the Flameshot shortcut.

## 4. Apps (Snap, not Flatpak)
- **Do NOT install Flatpak or Flathub.**
- The snaps and Chrome come from the root script. If a snap name changes, run `snap find <app>` and ask me before installing an unofficial publisher's snap.
- VS Code comes from Microsoft's apt repo (in the root script). Install its extensions as in PROMPT.md.
- ChatGPT desktop: OpenAI's preview `.deb` supports 24.04 and 26.04. I download it myself.
