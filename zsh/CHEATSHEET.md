# 🚀 ZSH Setup Quick Reference Cheat Sheet

*Press `q` to exit this viewer at any time.*

---

## ⚡ Navigation & Directory Jumping

| Command | Action |
| :--- | :--- |
| `z <query>` | Jump to most frecent directory matching query (e.g. `z myproj`) |
| `zi` | Interactive directory selection using FZF |
| `..` / `...` / `....` | Jump up 1, 2, or 3 directory levels |
| `Alt + C` | Fuzzy find directory within current tree and `cd` into it |

---

## 🔍 Interactive Tab Menus (`fzf-tab`) & Fuzzy Find

| Key / Shortcut | Behavior |
| :--- | :--- |
| `<Tab>` | Triggers interactive fuzzy completion popup |
| `cd <Tab>` | Interactive folder picker with **live `eza` directory preview** |
| `cat <Tab>` / `vim <Tab>` | Interactive file picker with **live `bat` code preview** |
| `Ctrl + N` / `Ctrl + P` (or Arrows) | Navigate candidates in tab menu |
| `Ctrl + T` | Fuzzy find any file in current tree (respects `.gitignore`) |
| `**<Tab>` | Trigger FZF recursive completion for any command argument |
| `Esc` or `Ctrl + C` | Cancel completion popup |

---

## 📜 Shell History & Predictive Typing (`atuin`)

| Key / Action | Behavior |
| :--- | :--- |
| `Ctrl + R` | Open **Atuin full-screen TUI** (SQLite history with stats, filters) |
| `Up` / `Down` Arrow | Substring search history matching what you already typed |
| `Right Arrow` or `End` | Accept full ghost-text autosuggestion |
| `Alt + F` (or `Ctrl + Right`) | Accept autosuggestion word-by-word |

---

## 🐍 Python Productivity Suite (`p` family)

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `p` | `python3` | Primary Python 3 invocation (single keystroke) |
| `pm <module>` | `python3 -m <module>` | Run module (e.g. `pm pytest`, `pm http.server`) |
| `pip` | `python3 -m pip` | Invokes pip through current Python binary |
| `pipin <pkg>` | `python3 -m pip install` | Install package |
| `pipup <pkg>` | `python3 -m pip install --upgrade` | Upgrade package |
| `pipreq` | `python3 -m pip freeze > requirements.txt` | Export requirements |
| `venv` | `source .venv/bin/activate` | Auto-detect and activate local `.venv` or `venv` |
| `mkvenv` | `python3 -m venv .venv` | Create standard virtualenv in `.venv/` |
| `pyclean` | *bytecode cleanup* | Delete `__pycache__` and `*.pyc` files |
| `server` | `python3 -m http.server` | Start instant static HTTP server on port 8000 |

---

## 🐙 Git Ergonomics (`g` family)

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `g` | `git` | Root shortcut |
| `gs` | `git status -sb` | Compact branch status with ahead/behind counts |
| `ga <file>` / `gaa` | `git add` / `git add --all` | Stage file / stage everything |
| `gc` / `gcm "msg"` | `git commit -v` / `-m` | Commit with diff editor / commit with message |
| `gcam "msg"` | `git commit -am` | Stage tracked modifications & commit |
| `gco <branch>` | `git checkout` | Switch branch |
| `gcb <branch>` | `git checkout -b` | Create & switch to new branch |
| `gback` | `git checkout @{-1}` | **Toggle back to previous branch** |
| `gp` | `git push` | Push current branch |
| `gpf` | `git push --force-with-lease` | Safe force push |
| `gpl` | `git pull --rebase --autostash` | Pull without merge commits & auto-stash |
| `gd` / `gds` | `git diff` / `--staged` | **Delta** side-by-side colorized diffs |
| `glog` | `git log --graph ...` | 15-commit compact visual graph |
| `gst` / `gstp` | `git stash` / `pop` | Stash / restore workspace |

---

## 🐳 Docker Operations (`d` family)

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `d` | `docker` | Root shortcut |
| `dc` | `docker compose` | Compose v2 |
| `dps` | *table format* | Clean table: Name, Status, Ports |
| `dpsa` | `docker ps -a` | List all containers including stopped |
| `dcu` / `dcd` | `docker compose up -d` / `down` | Start / Stop stack in background |
| `dcl` | `docker compose logs -f --tail=100` | Follow recent stack logs |
| `dclean` | `docker system prune -f` | Reclaim disk space from unused containers |

---

## 🦀 Rust & Go (`c` family)

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `c` | `cargo` | Cargo root |
| `cb` / `cr` / `ct` | `cargo build` / `run` / `test` | Core Cargo tasks |
| `cchk` | `cargo check` | Fast typecheck (avoids colliding with `/usr/bin/cc`) |
| `gtt` | `go tool task` | Go task runner |

---

## 🛠️ Modern CLI & System Tools

| Alias | Replaced Tool | Key Feature |
| :--- | :--- | :--- |
| `ls` / `l` | `eza` | Icons, colors, directory-first sorting |
| `ll` | `eza -la --git` | Long format with permissions & Git status columns |
| `lt` | `eza --tree --level=2` | 2-level directory tree structure |
| `cat` | `bat` | Automatic syntax highlighting and line numbers |
| `grep` | `rg` | Blazing-fast ripgrep search |
| `find` | `fd` | Fast, colorized file/folder search |
| `ports` | `ss -tulanp` | Check active listening network ports |
| `myip` | `ip -br -c addr` | Summary of local IPs |
| `path` | *formatted PATH* | Prints `$PATH` one entry per line |

---

## ⚙️ Maintenance & Configuration

| Command / File | Location / Action |
| :--- | :--- |
| `reload` | Re-source shell instantly (`source ~/.zshrc`) |
| `zshrc` | Edit main configuration (`~/.zshrc`) |
| `aliases` | Edit aliases file (`~/.config/zsh/aliases.zsh`) |
| `plugins` | Edit plugin manifest (`~/.zsh_plugins.txt`) |
| `starship` | Edit prompt configuration (`~/.config/starship.toml`) |
| `zsh-help` / `cheatsheet` | Open this cheat sheet in the terminal |
