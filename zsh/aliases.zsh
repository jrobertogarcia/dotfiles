# ==============================================================================
# Shell Aliases (~/.config/zsh/aliases.zsh)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Python ('p' family)
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

# ------------------------------------------------------------------------------
# 2. Node / Package Managers (pnpm)
# ------------------------------------------------------------------------------
alias n="pnpm"
alias ni="pnpm install"
alias nr="pnpm run"
alias na="pnpm add"
alias nad="pnpm add -D"
alias nx="pnpm dlx"

# ------------------------------------------------------------------------------
# 3. Rust & Go ('cg' family)
# ------------------------------------------------------------------------------
alias cg="cargo"
alias cgb="cargo build"
alias cgr="cargo run"
alias cgt="cargo test"
alias cgchk="cargo check"   # Avoids colliding with /usr/bin/cc
alias gtt="go tool task"

# ------------------------------------------------------------------------------
# 4. Git ('g' family)
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
# 5. Docker ('d' family)
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
# 6. Navigation & Core Utilities
# ------------------------------------------------------------------------------
alias c="clear"
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
# 7. System & Shell
# ------------------------------------------------------------------------------
if [[ "$(uname -s)" == "Darwin" ]]; then
  alias ports="lsof -iTCP -sTCP:LISTEN -P -n"
  alias myip="ipconfig getifaddr en0 2>/dev/null || ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}' | head -n 1"
else
  alias ports="ss -tulanp"
  alias myip="ip -br -c addr"
fi

alias path='echo $PATH | tr ":" "\n"'
alias reload="source ~/.zshrc && echo 'Reloaded ~/.zshrc'"
alias zshrc='${EDITOR:-micro} ~/.zshrc'
alias aliases='${EDITOR:-micro} ~/.config/zsh/aliases.zsh'
alias plugins='${EDITOR:-micro} ~/.zsh_plugins.txt'
alias dots-help="bat --style=plain ~/.config/zsh/CHEATSHEET.md"
alias cheatsheet="bat --style=plain ~/.config/zsh/CHEATSHEET.md"
