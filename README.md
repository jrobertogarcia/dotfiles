# ⚡ Personal Dotfiles & Modern Zsh Environment

A fast, modular, polyglot development terminal environment powered by **Antidote**, **Starship**, **fzf-tab**, **Atuin**, and modern Rust/Go CLI utilities.

---

## 🚀 Quickstart (Install on Any Machine)

On any new machine (Fedora, Ubuntu/Debian, Arch, macOS, or WSL):

```bash
git clone https://github.com/jrobertogarcia/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Then start a fresh session:
```bash
exec zsh
```

### What `install.sh` Does Automatically
1. **Installs core prerequisites**: `zsh`, `git`, `curl`.
2. **Installs modern CLI tools** (with automatic zero-root fallback into `~/.local/bin` if sudo is unavailable):
   - **Prompt**: `starship`
   - **Smart Navigation**: `zoxide`
   - **History Engine**: `atuin`
   - **Fuzzy Finder**: `fzf`
   - **CLI Upgrades**: `bat` (cat), `eza` (ls), `delta` (git diff), `fd` (find).
3. **Sets up Antidote v2.0** for static Zsh plugin bundling.
4. **Safely backs up** any pre-existing config files on the target machine.
5. **Establishes symlinks** from `~/dotfiles/` to `$HOME`.
6. **Compiles static plugin caches** and sets `zsh` as default shell.

---

## 📂 Repository Structure

```text
~/dotfiles/
├── install.sh                  # One-command idempotent installer
├── README.md                   # This documentation
├── zsh/
│   ├── zshrc                   # Symlinked to ~/.zshrc
│   ├── zsh_plugins.txt         # Symlinked to ~/.zsh_plugins.txt
│   ├── aliases.zsh             # Symlinked to ~/.config/zsh/aliases.zsh
│   └── CHEATSHEET.md           # Symlinked to ~/.config/zsh/CHEATSHEET.md
└── config/
    └── starship.toml           # Symlinked to ~/.config/starship.toml
```

---

## 🔄 Daily Workflow: Syncing Changes Across Machines

Because all files in `$HOME` are **symbolic links** pointing into `~/dotfiles`, any changes you make are immediately reflected in your Git repository.

### Pushing changes from this machine:
```bash
cd ~/dotfiles
git status
git add .
git commit -m "feat: add new alias"
git push
```

### Pulling updates on another machine:
```bash
cd ~/dotfiles
git pull
reload   # Instantly reloads the shell and re-sources all aliases
```

---

## 📖 Quick Reference Cheat Sheet

You can view the full interactive cheat sheet directly from your terminal at any time:

```bash
zsh-help
# or
cheatsheet
```

### Highlights
- **Python**: `p` (runs `python3`), `pm <module>`, `pip`, `venv` (activates `.venv`), `mkvenv`.
- **Git**: `g`, `gs` (concise status), `gpl` (rebase pull), `gback` (toggle previous branch), `gd` (Delta diffs).
- **Navigation**: `z <folder>` (smart jump), `..` / `...` (tree climbing), `<Tab>` (fzf-tab with live `eza` & `bat` previews).
- **History**: `Ctrl+R` (Atuin full TUI database search), `Up`/`Down` (prefix history search).
- **Docker**: `d`, `dc`, `dps` (clean table), `dcu`, `dcd`, `dclean`.
- **Rust/Go**: `c` (`cargo`), `cb`, `cr`, `ct`, `cchk`, `gtt`.
- **Shell**: `reload` (re-source config without restarting terminal).
