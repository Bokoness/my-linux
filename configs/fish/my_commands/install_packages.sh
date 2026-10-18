#!/bin/bash

# This script installs the packages and tools found in the fish configuration.
# It assumes a Debian-based Linux distribution (like Ubuntu).
# For other distributions, you might need to change the package manager commands (e.g., use 'yum', 'dnf', 'pacman', etc., instead of 'apt-get').

# Update package lists
sudo apt-get update

# --- Git ---
# Git is a widely used version control system.
echo "Installing Git..."
if ! command -v git &> /dev/null
then
    sudo apt-get install -y git
    echo "Git installed successfully."
else
    echo "Git is already installed."
fi
echo ""

# --- Docker ---
# Docker is a platform for developing, shipping, and running applications in containers.
echo "Installing Docker..."
if ! command -v docker &> /dev/null
then
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    # Use the new method with keyrings instead of deprecated apt-key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker ${USER}
    echo "Docker installed successfully. You may need to log out and log back in for the changes to take effect."
else
    echo "Docker is already installed."
fi
echo ""

# --- NVM (Node Version Manager) ---
# nvm is a version manager for node.js.
echo "Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    # Get latest NVM version dynamically
    NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep -Po '"tag_name": "\K[^"]*')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    echo "NVM installed successfully."
    echo "Installing latest Node.js version..."
    nvm install node
    nvm use node
    echo "Node.js installed successfully."
else
    echo "NVM is already installed."
fi
echo ""

# --- Other CLI Tools ---
echo "Installing other CLI tools..."
sudo apt-get install -y mycli tmux bat ranger neovim

# For bat on Ubuntu, create symlink if batcat binary exists
if [ -f /usr/bin/batcat ] && [ ! -f /usr/local/bin/bat ]; then
    sudo ln -s /usr/bin/batcat /usr/local/bin/bat
    echo "Created symlink for bat command"
fi

# Install GitHub CLI (gh)
(type -p wget >/dev/null || (sudo apt-get update && sudo apt-get install wget -y)) && \
    sudo mkdir -p -m 755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt-get update && \
    sudo apt-get install gh -y

# Install lazygit
echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"].*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -f lazygit.tar.gz lazygit
echo "lazygit installed successfully."

# Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt-get update
sudo apt-get install -y eza

# Install zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Install atuin
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh
sh rustup-init.sh -y
source "$HOME/.cargo/env"
cargo install atuin

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl
echo "kubectl installed successfully."

# Install AWS CLI v2
echo "Installing AWS CLI v2..."
if ! command -v aws &> /dev/null
then
    # Install unzip if not present
    if ! command -v unzip &> /dev/null; then
        sudo apt-get install -y unzip
    fi
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws
    echo "AWS CLI v2 installed successfully."
else
    echo "AWS CLI v2 is already installed."
fi
echo ""

# Install pip if not already installed (required for awslocal and localstack)
if ! command -v pip3 &> /dev/null
then
    sudo apt-get install -y python3-pip python3-venv
fi

# Install awslocal (use --break-system-packages for Ubuntu 24.04+)
echo "Installing awslocal..."
pip3 install --user awslocal || pip3 install --user --break-system-packages awslocal

# Install localstack-client
echo "Installing localstack-client..."
pip3 install --user localstack-client || pip3 install --user --break-system-packages localstack-client

# Ensure .local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
fi

# Note about 'mop'
# The alias 'stocks' uses 'mop', which appears to be a local application in '~/Apps/mop/mop'.
# This script does not install 'mop'. You will need to install it manually.

echo "Other CLI tools installed."
echo ""

# --- Fish Shell and Plugins ---
echo "Installing Fish shell..."
if ! command -v fish &> /dev/null
then
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt-get update
    sudo apt-get install -y fish
    echo "Fish shell installed successfully."
    echo "To make fish your default shell, run: chsh -s \$(which fish)"
else
    echo "Fish shell is already installed."
fi
echo ""

echo "Installing Fisher and fish plugins..."
# Install Fisher (using full URL instead of git.io redirect)
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# Install plugins from fish_plugins file
fish -c "fisher install edc/bass"
fish -c "fisher install yo-goto/ggl.fish"
fish -c "fisher install oh-my-fish/theme-bira"

echo "Fisher and fish plugins installed."
echo ""

# --- Neovim Configuration ---
echo "Configuring Neovim with a default setup..."
if command -v nvim &> /dev/null
then
    # Create nvim config directory
    mkdir -p ~/.config/nvim

    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Copy the init.lua file if it exists
    if [ -f "$SCRIPT_DIR/init.lua" ]; then
        cp "$SCRIPT_DIR/init.lua" ~/.config/nvim/init.lua

        echo "Installing Neovim plugins with Packer..."
        # Install plugins
        nvim --headless +PackerInstall +qall
        nvim --headless +PackerSync +qall

        echo "Neovim configuration complete."
    else
        echo "Warning: init.lua not found in $SCRIPT_DIR. Skipping Neovim configuration."
    fi
else
    echo "Neovim is not installed. Skipping Neovim configuration."
fi
echo ""

# --- GNOME Extensions ---
echo "Installing GNOME Extensions..."

# Install GNOME Shell Extension Manager (for managing extensions)
echo "Installing GNOME Shell Extension Manager..."
sudo apt-get install -y gnome-shell-extension-manager

# Install Ubuntu-specific extensions from apt
echo "Installing Ubuntu-specific GNOME extensions..."
sudo apt-get install -y gnome-shell-extension-ubuntu-tiling-assistant
sudo apt-get install -y gnome-shell-extension-ubuntu-dock || echo "ubuntu-dock may already be installed"
sudo apt-get install -y gnome-shell-extension-appindicator || echo "appindicator may already be installed"

# Install gext (GNOME Extensions CLI tool) for installing extensions from extensions.gnome.org
echo "Installing gext tool..."
if ! command -v gext &> /dev/null
then
    pip3 install --user gnome-extensions-cli || pip3 install --user --break-system-packages gnome-extensions-cli
fi

# Function to install extension from extensions.gnome.org
install_gnome_extension() {
    local ext_id=$1
    echo "Installing extension: $ext_id"
    gext install "$ext_id" || echo "Failed to install $ext_id, you may need to install it manually"
}

# Install extensions from extensions.gnome.org
# Caffeine - Disable auto-suspend and screensaver
install_gnome_extension "caffeine@patapon.info"

# Extension List - Show list of installed extensions in top bar
install_gnome_extension "extension-list@tu.berry"

# Force Quit - Force quit applications from top bar
install_gnome_extension "fq@megh"

# V-Shell (Vertical Workspaces) - Vertical workspace switcher
install_gnome_extension "vertical-workspaces@G-dH.github.com"

# Compact Top Bar - Make the top bar more compact
install_gnome_extension "gnome-compact-top-bar@metehan-arslan.github.io"

# Pano - Clipboard Manager
install_gnome_extension "pano@elhan.io"

# Hide Top Bar - Auto-hide the top bar
install_gnome_extension "hidetopbar@mathieu.bidon.ca"

# Desktop Icons NG (DING) - Desktop icons support
install_gnome_extension "ding@rastersoft.com"

echo ""
echo "GNOME Extensions installed. You may need to log out and log back in, then enable the extensions using:"
echo "  gnome-extensions enable <extension-id>"
echo "Or use GNOME Extensions app (Extension Manager) to enable them."
echo ""

echo "All installations complete!"
