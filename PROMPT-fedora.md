# Fedora setup

Read [PROMPT.md](PROMPT.md) first: shared rules, choices, and steps. This file has the Fedora-specific parts.
This matches the original machine: **Fedora 44, GNOME 50**. Commands use dnf5 (Fedora 41+).

## 1. Root-level installs
`sudo` needs my password, so write these steps into a root script (like `setup-root-ubuntu.sh`) and run it in my terminal.
- **Update:** `sudo dnf upgrade --refresh -y` and `flatpak update -y`.
- **dnf packages:** git curl wget unzip zip gcc gcc-c++ make ripgrep fd-find fzf jq tree bat tmux ranger mycli xclip wl-clipboard python3-pip pipx gnome-tweaks gnome-extensions-app flameshot dconf fish neovim zoxide gh fuse-libs gnome-shell-extension-apps-menu gnome-shell-extension-places-menu gnome-shell-extension-launch-new-instance gnome-shell-extension-appindicator
  - On Fedora, `bat` and `fd` already have their normal names. No symlinks needed.
  - Fedora's fish is 4.x and Neovim is current. Check `nvim --version` ≥ 0.11. If it's older, use the release tarball into `/opt/nvim`.
  - eza: `sudo dnf install eza` if it exists. Otherwise use the GitHub release binary into `~/.local/bin`.
  - Flameshot must be v14+. If dnf's is older, use the official `fedora-*` build from https://github.com/flameshot-org/flameshot/releases (verify the `.sha256sum`).
- **Docker CE:** `sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo`, then install docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin. Run `sudo systemctl enable --now docker`. Ask me about the docker group.
- **VS Code:** import `https://packages.microsoft.com/keys/microsoft.asc` and add the `packages.microsoft.com/yumrepos/vscode` repo, then `sudo dnf install code`.
- **cloudflared:** `sudo dnf config-manager addrepo --from-repofile=https://pkg.cloudflare.com/cloudflared.repo`, then `sudo dnf install cloudflared`.
- **Shell:** `chsh -s /usr/bin/fish`.

## 2. Apps (Flathub)
Fedora uses Flatpak natively, as on the old machine.
- Enable Flathub if needed: `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`.
- Install: `com.getpostman.Postman`, `com.google.Chrome`, `com.jetbrains.WebStorm`, `com.mattjakeman.ExtensionManager`, `com.transmissionbt.Transmission`, `org.mozilla.thunderbird_esr`, `org.telegram.desktop`, `org.videolan.VLC`, `org.kde.kdenlive`.
- ChatGPT desktop: OpenAI's preview `.rpm` supports Fedora 43 and 44. I download it myself.

## 3. GNOME on Fedora
- **Desktop icons:** Fedora has no dock and no desktop icons, which matches my setup. Install `gtk4-ding@smedius.gitlab.com` for desktop icons.
- **Install from extensions.gnome.org:** extension-list@tu.berry, copyous@boerdereinar.dev, hidetopbar@mathieu.bidon.ca, add-to-desktop@tommimon.github.com, gtk4-ding@smedius.gitlab.com, trayIconsReloaded@selfmade.pl, fq@megh, vertical-workspaces@G-dH.github.com, caffeine@patapon.info, just-perfection-desktop@just-perfection, transparent-top-bar-tweaks@hectorandac.github.io.
- **From dnf:** `appindicatorsupport@rgcjonas.gmail.com` (gnome-shell-extension-appindicator), apps-menu, places-menu, launch-new-instance.
- `background-logo@fedorahosted.org` ships with Fedora. Leave it as is. Keep `window-list@…` disabled.
- `extensions.dconf` can be loaded whole on Fedora.
- **Ctrl+Alt+T:** Fedora has no default terminal shortcut. If Ctrl+Alt+T should open Ptyxis, ask me, then add a custom shortcut (`ptyxis --new-window`).
