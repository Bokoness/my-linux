#!/usr/bin/env bash
# Root-level setup for fresh Ubuntu 26.04 (resolute). Idempotent; safe to re-run.
# Run: bash setup-root-ubuntu.sh   (it asks for your sudo password once)
set -uo pipefail
LOG="$(dirname "$(readlink -f "$0")")/setup-root-ubuntu.log"
exec > >(tee -a "$LOG") 2>&1
ok(){ echo "[OK] $*"; }; fail(){ echo "[FAIL] $*"; }
run(){ local name="$1"; shift; if "$@"; then ok "$name"; else fail "$name"; fi; }
sudo -v || exit 1
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &

CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
ARCH=$(dpkg --print-architecture)
KR=/etc/apt/keyrings; sudo install -d -m 0755 $KR

# ---- Repos ----
# fish 4.x PPA
if ! ls /etc/apt/sources.list.d/ | grep -q fish-shell; then
  run "fish PPA" sudo add-apt-repository -y -n ppa:fish-shell/release-4
fi
# GitHub CLI
if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee $KR/githubcli-archive-keyring.gpg >/dev/null
  echo "deb [arch=$ARCH signed-by=$KR/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
fi
# Docker CE
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o $KR/docker.asc
  echo "deb [arch=$ARCH signed-by=$KR/docker.asc] https://download.docker.com/linux/ubuntu $CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
fi
# VS Code
if [ ! -f /etc/apt/sources.list.d/vscode.list ] && [ ! -f /etc/apt/sources.list.d/vscode.sources ]; then
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee $KR/packages.microsoft.gpg >/dev/null
  echo "deb [arch=$ARCH signed-by=$KR/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
fi
# cloudflared (Cloudflare publishes a distro-agnostic "any" suite)
if [ ! -f /etc/apt/sources.list.d/cloudflared.list ]; then
  sudo curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg -o /usr/share/keyrings/cloudflare-main.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null
fi

# ---- System update ----
run "apt update" sudo apt-get update
run "apt full-upgrade" sudo DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y
run "snap refresh" sudo snap refresh

# ---- apt packages ----
run "base packages" sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git curl wget unzip zip build-essential \
  ripgrep fd-find fzf jq tree bat tmux ranger mycli xclip wl-clipboard \
  python3-pip python3-venv pipx gnome-tweaks gnome-shell-extensions \
  gnome-shell-extension-manager dconf-cli \
  eza zoxide libfuse2t64 transmission-gtk ptyxis fish gh cloudflared code \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
run "docker service" sudo systemctl enable --now docker

# ---- Neovim release tarball -> /opt/nvim ----
NV_LATEST=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest | jq -r .tag_name)
NV_CUR=$(/opt/nvim/bin/nvim --version 2>/dev/null | head -1 | awk '{print $2}')
if [ "$NV_CUR" != "$NV_LATEST" ]; then
  T=$(mktemp -d); curl -fsSL -o "$T/nvim.tgz" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && sudo rm -rf /opt/nvim && sudo mkdir -p /opt/nvim && sudo tar -xzf "$T/nvim.tgz" -C /opt/nvim --strip-components=1 \
    && sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim && ok "neovim $NV_LATEST" || fail "neovim"
  rm -rf "$T"
else ok "neovim already $NV_CUR"; fi

# ---- .deb downloads ----
install_deb(){ # name url
  if dpkg -s "$1" >/dev/null 2>&1; then ok "$1 already installed"; return; fi
  local T; T=$(mktemp -d); chmod 755 "$T"
  curl -fsSL -o "$T/pkg.deb" "$2" && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$T/pkg.deb" && ok "$1" || fail "$1"
  rm -rf "$T"
}
install_deb google-chrome-stable https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# ---- Flameshot 14 (official GitHub build; apt only has 13.x, which lacks the multi-monitor picker) ----
FS_VER=14.0.0; FS_ZIP=flameshot-v14.0+git0.da6121bd-artifact-ubuntu-24.04-amd64.zip
if dpkg --compare-versions "$(dpkg-query -W -f='${Version}' flameshot 2>/dev/null || echo 0)" ge "$FS_VER"; then
  ok "flameshot already >= $FS_VER"
else
  T=$(mktemp -d); chmod 755 "$T"; B=https://github.com/flameshot-org/flameshot/releases/download/v$FS_VER
  curl -fsSL -o "$T/$FS_ZIP" "$B/$FS_ZIP" && curl -fsSL -o "$T/$FS_ZIP.sha256sum" "$B/$FS_ZIP.sha256sum" \
    && (cd "$T" && sha256sum -c "$FS_ZIP.sha256sum") && unzip -q "$T/$FS_ZIP" -d "$T" \
    && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$T"/flameshot-*.deb && ok "flameshot $FS_VER" || fail "flameshot"
  rm -rf "$T"
fi

# ---- Snaps ----
snapi(){ if snap list "$1" >/dev/null 2>&1; then ok "snap $1 already installed"; else run "snap $1" sudo snap install "$@"; fi; }
snapi postman
snapi webstorm --classic
snapi telegram-desktop
snapi vlc
snapi thunderbird

# ---- Default shell ----
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "/usr/bin/fish" ]; then
  run "chsh to fish" sudo chsh -s /usr/bin/fish "$USER"
else ok "fish already default shell"; fi

# ---- Wallpapers (user-level; runs as you, no sudo) ----
# Light mode: blue #4389D0, dark mode: dark grey #2E2E2E
REPO="$(dirname "$(readlink -f "$0")")"
set_wallpapers(){
  mkdir -p ~/Pictures/Wallpapers && cp "$REPO"/configs/wallpapers/*.svg ~/Pictures/Wallpapers/ &&
  gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Wallpapers/light.svg" &&
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/Wallpapers/dark.svg" &&
  gsettings set org.gnome.desktop.background picture-options zoom &&
  gsettings set org.gnome.desktop.background primary-color '#4389D0' &&
  # Show the pair as one light/dark tile in Settings → Appearance → Background
  mkdir -p ~/.local/share/gnome-background-properties &&
  cat > ~/.local/share/gnome-background-properties/bokoness-solid.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>Blue / Dark Grey</name>
    <filename>$HOME/Pictures/Wallpapers/light.svg</filename>
    <filename-dark>$HOME/Pictures/Wallpapers/dark.svg</filename-dark>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>#4389D0</pcolor>
    <scolor>#000000</scolor>
  </wallpaper>
</wallpapers>
EOF
}
run "wallpapers" set_wallpapers

echo; echo "=== Done. Summary: ==="; grep -E '^\[(OK|FAIL)\]' "$LOG" | tail -60
