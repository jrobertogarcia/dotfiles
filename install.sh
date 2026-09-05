#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Bootstrap Installer
# Supports: Linux (Fedora, Debian/Ubuntu, Arch) and macOS
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR" "$HOME/.config/zsh"

# Ensure ~/.local/bin is in PATH for this session
export PATH="$BIN_DIR:$PATH"

# Color helpers
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${BLUE}${BOLD}==>${NC} $*"; }
success() { echo -e "${GREEN}${BOLD}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}${BOLD}!${NC} $*"; }
error()   { echo -e "${RED}${BOLD}✗${NC} $*"; exit 1; }

info "Starting installation from: $DOTFILES_DIR"

# ------------------------------------------------------------------------------
# 1. System & Architecture Detection
# ------------------------------------------------------------------------------
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64)  ARCH_ALT="amd64" ;;
  aarch64|arm64) ARCH_ALT="arm64" ;;
  *) error "Unsupported architecture: $ARCH" ;;
esac

info "Detected environment: $OS ($ARCH)"

# Helper to check for command
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Helper to run sudo if available
has_sudo() {
  if has_cmd sudo; then
    sudo -n true 2>/dev/null || sudo -v 2>/dev/null
  else
    return 1
  fi
}

# ------------------------------------------------------------------------------
# 2. Package Management & Core Prerequisites
# ------------------------------------------------------------------------------
info "Checking core prerequisites (zsh, git, curl)..."

install_system_packages() {
  if has_cmd dnf; then
    has_sudo && sudo dnf install -y zsh git curl fzf ripgrep || warn "No sudo access; skipping dnf install"
  elif has_cmd apt-get; then
    has_sudo && (sudo apt-get update && sudo apt-get install -y zsh git curl fzf ripgrep) || warn "No sudo access; skipping apt install"
  elif has_cmd pacman; then
    has_sudo && sudo pacman -Sy --noconfirm zsh git curl fzf ripgrep || warn "No sudo access; skipping pacman install"
  elif has_cmd brew; then
    brew install zsh git curl fzf ripgrep bat eza zoxide starship atuin git-delta fd
  fi
}

install_system_packages

has_cmd zsh  || error "zsh is required. Please install zsh on this system."
has_cmd git  || error "git is required. Please install git on this system."
has_cmd curl || error "curl is required. Please install curl on this system."

# ------------------------------------------------------------------------------
# 3. CLI Tools Installation
# ------------------------------------------------------------------------------
info "Checking CLI tools in $BIN_DIR..."

# 3.1 Starship Prompt
if ! has_cmd starship; then
  info "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir "$BIN_DIR"
fi
success "Starship ready: $(starship --version | head -n 1)"

# 3.2 Zoxide
if ! has_cmd zoxide; then
  info "Installing Zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi
success "Zoxide ready: $(zoxide --version 2>/dev/null || echo 'installed')"

# 3.3 Atuin
if ! has_cmd atuin; then
  info "Installing Atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi
success "Atuin ready: $(atuin --version 2>/dev/null || echo 'installed')"

# 3.4 FZF
if ! has_cmd fzf; then
  info "Installing FZF..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --bin
  cp -f "$HOME/.fzf/bin/fzf" "$BIN_DIR/"
fi
success "FZF ready: $(fzf --version 2>/dev/null || echo 'installed')"

# 3.5 Bat, Eza, Delta, Fd (Binary fallback for Linux x86_64)
TMP_INSTALL="$(mktemp -d)"
cleanup() { rm -rf "$TMP_INSTALL"; }
trap cleanup EXIT

if [[ "$OS" == "Linux" && "$ARCH" == "x86_64" ]]; then
  # Delta
  if ! has_cmd delta; then
    info "Downloading Delta binary..."
    curl -sL https://github.com/dandavison/delta/releases/download/0.19.2/delta-0.19.2-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C "$TMP_INSTALL"
    mv -f "$TMP_INSTALL"/delta-*/delta "$BIN_DIR/"
    chmod +x "$BIN_DIR/delta"
  fi

  # Fd
  if ! has_cmd fd; then
    info "Downloading Fd binary..."
    curl -sL https://github.com/sharkdp/fd/releases/download/v10.5.0/fd-v10.5.0-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C "$TMP_INSTALL"
    mv -f "$TMP_INSTALL"/fd-*/fd "$BIN_DIR/"
    chmod +x "$BIN_DIR/fd"
  fi

  # Bat
  if ! has_cmd bat; then
    info "Downloading Bat binary..."
    curl -sL https://github.com/sharkdp/bat/releases/download/v0.26.1/bat-v0.26.1-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C "$TMP_INSTALL"
    mv -f "$TMP_INSTALL"/bat-*/bat "$BIN_DIR/"
    chmod +x "$BIN_DIR/bat"
  fi

  # Eza
  if ! has_cmd eza; then
    info "Downloading Eza binary..."
    curl -sL https://github.com/eza-community/eza/releases/download/v0.23.5/eza_x86_64-unknown-linux-gnu.tar.gz | tar -xz -C "$TMP_INSTALL"
    mv -f "$TMP_INSTALL"/eza "$BIN_DIR/"
    chmod +x "$BIN_DIR/eza"
  fi
fi

# ------------------------------------------------------------------------------
# 4. Antidote Plugin Manager Setup
# ------------------------------------------------------------------------------
info "Setting up Antidote..."
if [[ ! -d "$HOME/.antidote" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
  success "Cloned Antidote to ~/.antidote"
else
  success "Antidote present at ~/.antidote"
fi

# ------------------------------------------------------------------------------
# 5. Backup & Symlink Dotfiles
# ------------------------------------------------------------------------------
info "Setting up symlinks..."

backup_and_link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="${dst}.pre-dotfiles.bak"
    warn "Backing up $dst to $backup"
    mv "$dst" "$backup"
  fi

  ln -sfn "$src" "$dst"
  success "Linked $dst -> $src"
}

backup_and_link "$DOTFILES_DIR/zsh/zshrc"          "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/zsh/zsh_plugins.txt"  "$HOME/.zsh_plugins.txt"
backup_and_link "$DOTFILES_DIR/zsh/aliases.zsh"      "$HOME/.config/zsh/aliases.zsh"
backup_and_link "$DOTFILES_DIR/zsh/CHEATSHEET.md"    "$HOME/.config/zsh/CHEATSHEET.md"
backup_and_link "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"

# ------------------------------------------------------------------------------
# 6. Antidote Compilation & Git Delta Configuration
# ------------------------------------------------------------------------------
info "Compiling Antidote plugins..."
zsh -c "source \$HOME/.antidote/antidote.zsh && antidote bundle < \$HOME/.zsh_plugins.txt > \$HOME/.zsh_plugins.zsh"
success "Compiled ~/.zsh_plugins.zsh"

if has_cmd delta; then
  info "Configuring Git Delta..."
  git config --global core.pager "delta"
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true
  git config --global delta.light false
  git config --global delta.side-by-side true
  git config --global delta.line-numbers true
  success "Git Delta configured"
fi

# ------------------------------------------------------------------------------
# 7. Verification & Default Shell
# ------------------------------------------------------------------------------
info "Validating Zsh syntax..."
zsh -n "$HOME/.zshrc" && success "Syntax check passed"

CURRENT_SHELL="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || echo "$SHELL")"
if [[ "$CURRENT_SHELL" != *"zsh"* ]]; then
  ZSH_PATH="$(command -v zsh)"
  info "Default shell: $CURRENT_SHELL"
  if has_cmd chsh; then
    info "Changing default shell to $ZSH_PATH..."
    chsh -s "$ZSH_PATH" || warn "Could not set shell automatically. Run: chsh -s $ZSH_PATH"
  fi
fi

echo ""
echo -e "${GREEN}${BOLD}Setup completed.${NC}"
echo -e "Start a new session: ${BOLD}exec zsh${NC}"
echo -e "Open reference: ${BOLD}zsh-help${NC}"
echo ""
