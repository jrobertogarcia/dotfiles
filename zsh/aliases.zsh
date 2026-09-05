# ==============================================================================
# MODULAR DEVELOPER ALIASES (~/.config/zsh/aliases.zsh)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PYTHON PRODUCTIVITY SUITE ('p' family)
# ------------------------------------------------------------------------------
alias p="python3"
alias py="python3"
alias pm="python3 -m"
alias pip="python3 -m pip"
alias pipin="python3 -m pip install"
alias pipup="python3 -m pip install --upgrade"
alias pipreq="python3 -m pip freeze > requirements.txt"
alias venv='[ -d .venv ] && source .venv/bin/activate || ([ -d venv ] && source venv/bin/activate || echo "No .venv or venv found")'
alias mkvenv="python3 -m venv .venv"
alias pyclean='find . -type f -name "*.py[co]" -delete -o -type d -name "__pycache__" -delete'
alias server="python3 -m http.server"

# ------------------------------------------------------------------------------
# 2. JAVASCRIPT / PACKAGE MANAGERS (Minimal Fallbacks)
# ------------------------------------------------------------------------------
alias pn="pnpm"
alias nr="npm run"
alias ni="npm install"

# ------------------------------------------------------------------------------
# 3. RUST & GO ('c' family)
# ------------------------------------------------------------------------------
alias c="cargo"
alias cb="cargo build"
alias cr="cargo run"
alias ct="cargo test"
alias cchk="cargo check"   # Avoids colliding with /usr/bin/cc
alias gtt="go tool task"

# ------------------------------------------------------------------------------
# 4. GIT ERGONOMICS ('g' family)
# ------------------------------------------------------------------------------
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -v"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gback="git checkout @{-1}"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpl="git pull --rebase --autostash"
alias gd="git diff"
alias gds="git diff --staged"
alias glog="git log --graph --oneline --decorate -n 15"
alias gst="git stash"
alias gstp="git stash pop"

# ------------------------------------------------------------------------------
# 5. DOCKER & CONTAINERS ('d' family)
# ------------------------------------------------------------------------------
alias d="docker"
alias dc="docker compose"
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa="docker ps -a"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f --tail=100"
alias dclean="docker system prune -f"

# ------------------------------------------------------------------------------
# 6. NAVIGATION & MODERN CLI REPLACEMENTS
# ------------------------------------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --group-directories-first --git"
  alias lt="eza --tree --level=2 --icons"
  alias l="eza -lah --icons --group-directories-first"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat --style=plain"
fi

if command -v rg >/dev/null 2>&1; then
  alias grep="rg"
fi

if command -v fd >/dev/null 2>&1; then
  alias find="fd"
fi

alias mkdir="mkdir -pv"
alias cp="cp -iv"
alias mv="mv -iv"

# ------------------------------------------------------------------------------
# 7. SYSTEM INSPECTION & SHELL MANAGEMENT
# ------------------------------------------------------------------------------
alias ports="ss -tulanp"
alias myip="ip -br -c addr"
alias path='echo $PATH | tr ":" "\n"'
alias reload="source ~/.zshrc && echo 'ZSH configuration reloaded!'"
alias zshrc='${EDITOR:-nano} ~/.zshrc'
alias aliases='${EDITOR:-nano} ~/.config/zsh/aliases.zsh'
alias zsh-help="bat --style=plain ~/.config/zsh/CHEATSHEET.md"
alias cheatsheet="bat --style=plain ~/.config/zsh/CHEATSHEET.md"
