if status is-interactive
    # Commands to run in interactive sessions can go here
end

# set -x GOPATH /usr/local/go # GoPath

# Path
#set PATH $PATH $GOPATH/bin #GoLang
#set PATH $PATH $HOME/.local/bin
#set PATH $PATH $HOME/.cargo/bin

# Mysql config
set -x MYSQL_USER bokoness
set -x MYSQL_PASSWORD 312123
set -x MYSQL_HOST localhost

# Aliases
# alias mysql="docker exec -it mysql mysql -p" #mysql
# alias mysql="mysql -u bokoness -p"
alias python="python3"
alias mysql="mycli"
alias g="git" #git
alias gd="gh dash" #Github Dash
alias gdba="git branch | grep -v "master" | grep -v "main" | xargs git branch -D" # delete all git local branches
alias lg="lazygit" #Lazygit
alias l="eza" #Use Eza plugin https://github.com/eza-community/eza
alias ll="eza -l"
alias tm="tmux" #Use tmux
alias cat="bat" # Fedora packages bat as `bat`
alias r="ranger" # ranger
alias fpoff="sudo authselect disable-feature with-fingerprint" # disable fingerprint for bash
alias startDocker="sudo systemctl restart docker" # restarts docker
alias fpon="sudo authselect enable-feature with-fingerprint" # enable fingerprint for bash
alias connect_hg_db="ssh -L 3307:bo-mysql-1-2021-02-02.crmg6rxqqxbh.eu-central-1.rds.amazonaws.com:3306 ness@3.122.222.124 -N"
alias stocks="~/Apps/mop/mop"
alias logout="gnome-session-quit --logout"
# Docker
alias d="docker"
# K8S
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgd="kubectl get deployments"
alias kgs="kubectl get services"
# shortcuts for HG repos
alias bo="cd ~/dev/hg/back-office/"
alias boa="cd ~/dev/hg/back-office-api/"
alias suspend="sudo systemctl suspend -f" # suspend the system
alias fish-ls="cat ~/.config/fish/config.fish | grep alias" # list all fish aliases
alias gls="cat ~/.gitconfig"
alias c="clear"
alias mman="cat ~/.config/fish/my_commands/my_man.md"
alias viman="cat ~/.config/fish/my_commands/vim_man.md"
alias awsman="cat ~/.config/fish/my_commands/aws_man.md"
alias git-sync="git config --global core.excludesfile ~/.gitignore_global"
#aws
alias awslocal="aws --profile local --endpoint-url=http://localhost:4566"
#Terraform
alias t="terraform"
# Commands to run on startup
type -q nvm; and nvm use default >/dev/null

type -q zoxide; and zoxide init fish --cmd cd | source # init zoxide and override the `cd` command with zoxide

type -q atuin; and atuin init fish | source # use atuin

set -x OPENSSL_LIB_DIR /usr/bin/openssl
set -gx EDITOR nvim
export PATH="$HOME/.local/bin:$PATH"
