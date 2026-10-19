# Installed software

Machine: **Ubuntu 26.04.1 LTS (resolute), GNOME 50.1 (Wayland), x86_64**. Last updated **2026-10-19**.
Status: ✅ installed · 👤 needs manual action · ⏭️ not installed (by choice).

## System
| Item | Version | Source | Status |
|---|---|---|---|
| Ubuntu packages | latest | `apt full-upgrade` | ✅ |
| Snaps | latest | `snap refresh` | ✅ |
| Default shell | fish | `chsh` | ✅ |

## Shell & CLI tools
| Tool | Version | Source | Used for | Status |
|---|---|---|---|---|
| fish | 4.9.3 | `ppa:fish-shell/release-4` | shell | ✅ |
| Fisher + bass, ggl.fish, theme-bira | latest | fisher | plugins, bira prompt | ✅ |
| eza | 0.23.4 | apt | `l`, `ll` | ✅ |
| bat | 0.25.0 | apt (`~/.local/bin/bat` → `batcat`) | `cat` alias | ✅ |
| fd | 10.3.0 | apt (`~/.local/bin/fd` → `fdfind`) | finder | ✅ |
| zoxide | 0.10.0 | official installer → `~/.local/bin` | `cd` | ✅ |
| zoxide (apt, unused) | 0.9.8 | apt | shadowed by the 0.10.0 binary in `~/.local/bin` | ✅ |
| atuin | 18.24.1 | official installer → `~/.atuin/bin` | history (Ctrl+R) | ✅ 👤 `atuin login` |
| lazygit | 0.66.2 | GitHub release → `~/.local/bin` | `lg` | ✅ |
| fzf | 0.67.0 | apt | `f` | ✅ |
| ripgrep | 15.1.0 | apt | search | ✅ |
| jq | 1.8.1 | apt | JSON | ✅ |
| tree | 2.3.1 | apt | | ✅ |
| tmux | 3.6a | apt | `tm` | ✅ |
| ranger | 1.9.4 | apt | `r` | ✅ |
| mycli | 1.54.1 | apt | `mysql` | ✅ |
| xclip, wl-clipboard | 0.13 / 2.2.1 | apt | `cc` | ✅ |
| git | 2.53.0 | apt | `g` + aliases in `~/.gitconfig` | ✅ |
| curl, wget, unzip, zip | 8.18 / 1.25 / 6.0 / 3.0 | apt | | ✅ |
| build-essential | 12.12 | apt | C compiler (treesitter) | ✅ |
| python3-pip, python3-venv, pipx | 25.1.1 / 3.14.3 / 1.8.0 | apt | | ✅ |
| dconf-cli | 0.49.0 | apt | GNOME settings | ✅ |
| libfuse2t64 | 2.9.9 | apt | AppImages (Beeper) | ✅ |

## Development
| Tool | Version | Source | Status |
|---|---|---|---|
| Neovim | 0.12.6 | release tarball → `/opt/nvim` (`/usr/local/bin/nvim`) | ✅ |
| LazyVim plugins | pinned in `lazy-lock.json` | `Lazy! restore` | ✅ |
| tree-sitter-cli | 0.27.1 | `npm i -g` | ✅ |
| nvm | 0.40.8 | GitHub install.sh → `~/.nvm` | ✅ |
| Node / npm | 24.22.0 / 11.19.1 | nvm (default alias 24) | ✅ |
| GitHub CLI (gh) | 2.102.0 | cli.github.com apt repo | ✅ 👤 `gh auth login`, then gh-dash + `gh co` alias |
| Docker CE | 29.9.1 | download.docker.com apt repo | ✅ (service enabled; not in the docker group) |
| containerd / buildx / compose | 2.4.2 / 0.38.0 / 5.6.0 | download.docker.com | ✅ |
| VS Code | 1.142.0 | packages.microsoft.com apt repo | ✅ |
| VS Code extensions | 38 from `lists/vscode-extensions.txt` (40 with dependencies) | `code --install-extension` | ✅ |
| cloudflared | 2026.10.1 | pkg.cloudflare.com apt repo | ✅ |
| Claude Code | 2.1.303 | claude.ai/install.sh → `~/.local/bin` | ✅ |
| Codex CLI | 0.163.0 | GitHub release (musl) → `~/.local/bin` | ✅ |

## Desktop apps
| App | Version | Source | Status |
|---|---|---|---|
| Google Chrome | 155.0.8059.84 | official .deb | ✅ |
| Postman | 11.71.7 | snap | ✅ |
| WebStorm | 2026.2.3 | snap (classic) | ✅ |
| Telegram | 7.3.1 | snap | ✅ |
| VLC | 3.0.24 | snap | ✅ |
| Thunderbird | 158.0 | snap (preinstalled) | ✅ |
| Kdenlive | 26.04.3 | snap | ✅ |
| Transmission | 4.1.1 | apt (preinstalled) | ✅ |
| Flameshot | 14.0.0 (latest upstream) | apt | ✅ |
| Ptyxis | 50.1 | apt (preinstalled) | ✅ |
| GNOME Tweaks | 49.0 | apt | ✅ |
| Extension Manager | 0.6.5 | apt | ✅ |
| ChatGPT desktop | | OpenAI preview .deb | 👤 download it yourself |
| Beeper | | AppImage in `~/Apps/` | 👤 copy it yourself |

## GNOME extensions
| Extension | Version | Source | Status |
|---|---|---|---|
| extension-list@tu.berry | 45 | extensions.gnome.org | ✅ 👤 enable after re-login |
| copyous@boerdereinar.dev | 12 | extensions.gnome.org | ✅ 👤 enable after re-login |
| hidetopbar@mathieu.bidon.ca | 127 | extensions.gnome.org | ✅ 👤 enable after re-login |
| add-to-desktop@tommimon.github.com | 17 | extensions.gnome.org | ✅ 👤 enable after re-login |
| trayIconsReloaded@selfmade.pl | 34 | extensions.gnome.org | ✅ 👤 enable after re-login |
| fq@megh | 47 | extensions.gnome.org | ✅ 👤 enable after re-login |
| vertical-workspaces@G-dH.github.com (V-Shell) | 121 | extensions.gnome.org | ✅ 👤 enable after re-login (may affect the dock) |
| caffeine@patapon.info | 61 | extensions.gnome.org | ✅ 👤 enable after re-login |
| just-perfection-desktop@just-perfection | 37 | extensions.gnome.org | ✅ 👤 enable after re-login (may affect the dock) |
| transparent-top-bar-tweaks@hectorandac.github.io | 1 | extensions.gnome.org | ✅ 👤 enable after re-login |
| apps-menu, places-menu, launch-new-instance | 50.0 | apt `gnome-shell-extensions` | ✅ |
| ubuntu-dock, ding, ubuntu-appindicators | built in | Ubuntu | ✅ kept as is |

## Configs & appearance
| Item | Where | Status |
|---|---|---|
| fish config, functions, completions | `~/.config/fish` | ✅ |
| LazyVim config | `~/.config/nvim` | ✅ |
| git config + `~/.gitignore_global` | `~/.gitconfig` | ✅ |
| atuin, flameshot, copyous configs | `~/.config/…` | ✅ |
| JetBrainsMono Nerd Font | `~/.local/share/fonts` | ✅ |
| Bibata-Modern-Classic cursor (size 24) | `~/.local/share/icons` + `~/.icons` | ✅ |
| Dark mode, monospace font | gsettings | ✅ |
| Keyboard: us + il, Caps Lock → Escape | dconf | ✅ |
| Shortcuts: Ctrl+Alt+S Flameshot, Super+M mute, workspace keys, Super+D | dconf | ✅ |
| Ctrl+Alt+T | Ubuntu default | ✅ |
| Ptyxis "Vs Code" palette + tab shortcuts | dconf | ✅ |
| `~/.ssh` | | 👤 restore it yourself |
| Google Drive (Online Accounts) | Settings | 👤 add it yourself |

## Not installed (by choice)
podman · rustup · kubectl · terraform · aws CLI / awslocal · mop · Minecraft · dash-to-dock · gtk4-ding · Flatpak/Flathub · rclone · Fedora-only items (background-logo, authselect fingerprint aliases) · docker group membership (ask if wanted)
