# Prompt: restore my dev environment on a fresh Linux install

This repo is a backup of my dev environment (originally Fedora 44, GNOME 50). Use it to set up a fresh **Ubuntu** or **Fedora** machine so it matches.
The backup is the folder that contains this file. Use the files in it as the source of truth.

## Step 0: pick the right prompt
1. Run `cat /etc/os-release` and `gnome-shell --version`.
2. Read the rest of this file (shared rules and choices). Then follow the prompt for this distro:
   - `ID=ubuntu` → **[PROMPT-ubuntu.md](PROMPT-ubuntu.md)**
   - `ID=fedora` → **[PROMPT-fedora.md](PROMPT-fedora.md)**
   - Anything else → stop and ask me.
3. Adapt every command to the exact release you found. Each distro prompt notes what was learned on a real install.

## Ground rules (both distros)
- Use the native package manager (apt / dnf). Use the official upstream repo or a release binary only when the packaged version is too old or missing (each distro prompt says where).
- Make every step idempotent: check whether a tool is already installed before installing it.
- `sudo` needs my password, and you can't type it. Put root steps in a script and run it in my terminal so I can enter the password (Ubuntu has `setup-root-ubuntu.sh` for this). Do user-level steps yourself.
- Never edit a script while it is running. Wait for it to finish.
- Ask before anything destructive, before `chsh`, and before anything that needs my credentials (gh auth, atuin login, Docker group).
- Don't install anything that is specific to the *other* distro.
- At the end, give me a summary table (installed / skipped / failed / needs manual action), and update [INSTALLED.md](INSTALLED.md).

## My choices (both distros, don't ask again)
- **Don't install:** podman, rustup, kubectl, terraform, aws CLI / awslocal, mop (stocks), Minecraft, dash-to-dock. config.fish still has aliases for some of these. Leave them alone.
- **Don't** set up rclone or Flatpak on Ubuntu (Snap there). Fedora uses Flathub, as before.
- Fingerprint aliases (`fpoff`/`fpon`) were removed from config.fish. Don't add them back.
- Do set fish as my default shell (`chsh -s $(which fish)`).
- Ask me about the Docker group. Explain it first: it lets me run `docker` without sudo, but it is root-equivalent.

## Backup folder layout
- `configs/fish/`: full `~/.config/fish` (config.fish, functions, completions, conf.d, fish_plugins, my_commands/)
- `configs/nvim/`: LazyVim config (`~/.config/nvim`)
- `configs/gitconfig`: `~/.gitconfig`
- `configs/atuin/`, `configs/flameshot/`, `configs/copyous@boerdereinar.dev/`: app configs for `~/.config/`
- `configs/fonts/`: JetBrainsMono Nerd Font (goes to `~/.local/share/fonts`)
- `configs/Bibata-Modern-Classic/`: cursor theme (goes to `~/.local/share/icons`)
- `configs/gnome-extensions/`: copies of the installed extension folders (fallback only)
- `dconf/*.dconf`: GNOME settings dumps (extensions, keybindings, Ptyxis, input sources, interface)
- `dconf/FULL-dump-reference-only.dconf`: full dump. **Do NOT load it wholesale.** Read it only for reference.
- `lists/`: GNOME extensions, VS Code extensions, the old Flatpak app list (reference only)
- `setup-root-ubuntu.sh`: Ubuntu root-level installer (repos, apt, Docker, Neovim, Chrome, snaps, chsh)
- `INSTALLED.md`: table of everything installed on the current machine

## Shared steps (same on both distros)
- **Configs:** copy `configs/fish`, `configs/nvim`, `configs/atuin`, `configs/flameshot`, and `configs/copyous@boerdereinar.dev` into `~/.config/`, and `configs/gitconfig` to `~/.gitconfig`. Create `~/.gitignore_global` (`.env`, `node_modules/`, `.DS_Store`, `*.log`, `.idea/`, `.vscode/`).
  - `git clone git@github.com:Bokoness/shell.git` once SSH keys are restored. It is the same fish config. Diff the two and prefer the newer one.
  - `my_commands/install_packages.sh` is an old script, and `configs/fish/init.lua` is an old Packer config. Ignore both.
- **Fisher:** `fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"` installs `edc/bass`, `yo-goto/ggl.fish`, `oh-my-fish/theme-bira`.
- **PATH:** config.fish puts `~/.local/bin` first on PATH on its first line. It must come before the zoxide/atuin init, so the newer binaries in `~/.local/bin` win.
- **zoxide:** use the official installer (`curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh`, which installs to `~/.local/bin`). Older zoxide (< 0.10) breaks `cd` on fish 4 because it reads `$__fish_data_dir/functions/cd.fish`, which fish 4 no longer ships.
- **atuin:** `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive`. Ask me to run `atuin login` for sync.
- **lazygit:** latest GitHub release binary into `~/.local/bin`.
- **nvm + Node:** nvm from its latest GitHub release, then `nvm install 24 && nvm alias default 24`. The fish `nvm` function wraps it through `bass`. Check that `nvm use default` works in fish.
- **Neovim deps:** `npm i -g tree-sitter-cli` (Mason can't install it headless). Copy `configs/nvim`, then run `nvim --headless "+Lazy! restore" +qa` to install the plugin versions pinned in `lazy-lock.json`.
- **gh:** ask me to run `gh auth login`, then `gh extension install dlvhdr/gh-dash` and `gh alias set co 'pr checkout'`.
- **SSH:** I restore `~/.ssh` myself. Then run `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_rsa ~/.ssh/config` and `ssh -T git@github.com`.
- **Fonts + cursor:** copy `configs/fonts/*` to `~/.local/share/fonts/` and run `fc-cache -f`. Copy `configs/Bibata-Modern-Classic/` to `~/.local/share/icons/` and symlink it into `~/.icons/`.
- **CLIs in `~/.local/bin`:** Claude Code (`curl -fsSL https://claude.ai/install.sh | bash`) and Codex (GitHub release `codex-x86_64-unknown-linux-musl.tar.gz`).
- **VS Code extensions:** `cat lists/vscode-extensions.txt | xargs -L1 code --install-extension`.
- **GNOME extensions:** download each from extensions.gnome.org for the running GNOME version (`https://extensions.gnome.org/extension-info/?uuid=<uuid>&shell_version=<major>` gives `download_url`), then `gnome-extensions install --force <zip>`. If there's no build for this GNOME, fall back to `configs/gnome-extensions/`. On Wayland they load only after logout/login. Then enable them, and ask me before enabling V-Shell and Just Perfection, because they change the dash and top bar.
- **GNOME settings:** after the extensions are installed, load `dconf/media-keys.dconf`, `wm-keybindings.dconf`, `input-sources.dconf`, and `ptyxis.dconf` with `dconf load`, plus `extensions.dconf` (see your distro prompt for caveats). From `interface.dconf` set only: `color-scheme 'prefer-dark'`, `monospace-font-name 'JetBrainsMono Nerd Font Mono 12'`, `cursor-theme 'Bibata-Modern-Classic'`, `cursor-size 24`.
  - What these restore: Ctrl+Alt+S runs `flameshot gui`, Super+M mutes, Ctrl+Alt+arrows switch workspace, Ctrl+Shift+Alt+arrows move a window, Super+D shows the desktop, layouts us + il, Caps Lock acts as Escape, Ptyxis "Vs Code" palette, tab shortcuts Ctrl+Shift+H/L/K. Ctrl+Alt+T stays the distro default.
- **Flameshot:** must be **v14+** (it adds a monitor picker for multi-monitor capture). Check the packaged version first.
- **Beeper:** I copy the AppImage to `~/Apps/` myself. Install the FUSE 2 library so AppImages run.
- **ChatGPT desktop:** OpenAI's official Linux preview (.deb / .rpm). I download it myself from OpenAI.
- **Google Drive:** at the end, ask me to add my Google account in Settings → Online Accounts.

## Verify (both distros)
- In a new fish session these should work with no startup warnings: `l`, `ll`, `cat`, `cd` (zoxide), `lg`, `gd`, `g l`, `nvm`, `node -v`, `nvim` (LazyVim, `:checkhealth`), `docker ps` (with sudo if not in the docker group), `atuin` (Ctrl+R), and the bira prompt.
- `gnome-extensions list --enabled`: compare with `lists/gnome-extensions-enabled.txt`, allowing for the distro differences in your prompt.
- Print the summary table and update `INSTALLED.md`.
