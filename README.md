# Dotfiles

Zsh configuration and CLI environment for Linux and macOS. Uses Antidote for plugin management, Starship for prompts, fzf-tab for completion, and Atuin for history.

---

## Installation

Run on any target machine:

```bash
git clone https://github.com/jrobertogarcia/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```

### What `install.sh` Does
1. Checks for prerequisites (`zsh`, `git`, `curl`).
2. Installs CLI utilities (`starship`, `zoxide`, `atuin`, `eza`, `bat`, `delta`, `fd`, `fzf`). If `sudo` is not available, downloads precompiled binaries to `~/.local/bin`.
3. Clones Antidote to `~/.antidote`.
4. Backs up existing configuration files to `*.pre-dotfiles.bak`.
5. Symlinks configuration files from `~/dotfiles/` to `$HOME`.
6. Compiles Antidote plugins and configures Git to use Delta for diffs.

---

## Structure

```text
~/dotfiles/
├── install.sh                  # Bootstrap installer
├── README.md                   # Documentation
├── zsh/
│   ├── zshrc                   # Symlinked to ~/.zshrc
│   ├── zsh_plugins.txt         # Symlinked to ~/.zsh_plugins.txt
│   ├── aliases.zsh             # Symlinked to ~/.config/zsh/aliases.zsh
│   └── CHEATSHEET.md           # Symlinked to ~/.config/zsh/CHEATSHEET.md
└── config/
    └── starship.toml           # Symlinked to ~/.config/starship.toml
```

---

## Workflow

All configuration files in `$HOME` are symlinks pointing to `~/dotfiles`.

### Pushing changes:
```bash
cd ~/dotfiles
git add .
git commit -m "feat: add alias"
git push
```

### Pulling changes on another machine:
```bash
cd ~/dotfiles
git pull
reload
```

---

## Quick Reference

View the reference guide in the terminal:

```bash
dots-help
# or
cheatsheet
```

### Summary
- **Node**: `n` (`pnpm`), `ni`, `nr`, `na`, `nad`, `nx`.
- **Python**: `p` (`python3`), `pm <module>`, `pip`, `venv` (activates `.venv`), `mkvenv`.
- **Git**: `g`, `gs` (status), `gpl` (rebase pull), `gback` (previous branch), `gd` (Delta diffs).
- **Navigation**: `z <folder>` (frecency jump), `..` / `...`, `<Tab>` (fzf-tab with file and directory previews).
- **History**: `Ctrl+R` (Atuin SQLite search), `Up`/`Down` (prefix search).
- **Docker**: `d`, `dc`, `dps` (table format), `dcu`, `dcd`, `dclean`.
- **Rust/Go**: `cg` (`cargo`), `cgb`, `cgr`, `cgt`, `cgchk`, `gtt`.
- **Shell**: `c` (`clear`), `reload` (re-sources `~/.zshrc`).
