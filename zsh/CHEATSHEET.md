# Zsh Reference

*Press `q` to exit this viewer.*

---

## Navigation

| Command | Action |
| :--- | :--- |
| `z <query>` | Jump to directory matching query (e.g. `z myproj`) |
| `zi` | Interactive directory selection with FZF |
| `..` / `...` / `....` | Jump up 1, 2, or 3 directory levels |
| `Alt + C` | Find directory in current tree and `cd` into it |

---

## Tab Completion & Fuzzy Finder

| Key / Shortcut | Behavior |
| :--- | :--- |
| `<Tab>` | Triggers fuzzy completion popup (`fzf-tab`) |
| `cd <Tab>` | Directory selection with `eza` preview |
| `cat <Tab>` / `vim <Tab>` | File selection with `bat` syntax preview |
| `Ctrl + N` / `Ctrl + P` (or Arrows) | Navigate candidates in tab menu |
| `Ctrl + T` | Find file in current tree (respects `.gitignore`) |
| `**<Tab>` | Trigger FZF recursive completion on paths |
| `Esc` or `Ctrl + C` | Cancel completion popup |

---

## History & Autosuggestions

| Key / Action | Behavior |
| :--- | :--- |
| `Ctrl + R` | Search history via Atuin (SQLite) |
| `Up` / `Down` Arrow | Substring search matching text already typed |
| `Right Arrow` or `End` | Accept full autosuggestion |
| `Alt + F` (or `Ctrl + Right`) | Accept autosuggestion word-by-word |

---

## Python

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `p` | `python3` | Python 3 invocation |
| `pm <module>` | `python3 -m <module>` | Run module (e.g. `pm pytest`, `pm http.server`) |
| `pip` | `python3 -m pip` | Run pip via current Python binary |
| `pipin <pkg>` | `python3 -m pip install` | Install package |
| `pipup <pkg>` | `python3 -m pip install --upgrade` | Upgrade package |
| `pipreq` | `python3 -m pip freeze > requirements.txt` | Export requirements |
| `venv` | `source .venv/bin/activate` | Activate local `.venv` or `venv` |
| `mkvenv` | `python3 -m venv .venv` | Create virtualenv in `.venv/` |
| `pyclean` | *bytecode cleanup* | Delete `__pycache__` and `*.pyc` files |
| `server` | `python3 -m http.server` | Static HTTP server on port 8000 |

---

## Git

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `g` | `git` | Root shortcut |
| `gs` | `git status -sb` | Short status with branch information |
| `ga <file>` / `gaa` | `git add` / `git add --all` | Stage file / stage everything |
| `gc` / `gcm "msg"` | `git commit -v` / `-m` | Commit with diff / commit with message |
| `gcam "msg"` | `git commit -am` | Stage tracked modifications and commit |
| `gco <branch>` | `git checkout` | Switch branch |
| `gcb <branch>` | `git checkout -b` | Create and switch to new branch |
| `gback` | `git checkout @{-1}` | Switch to previous branch |
| `gp` | `git push` | Push current branch |
| `gpf` | `git push --force-with-lease` | Push with lease verification |
| `gpl` | `git pull --rebase --autostash` | Pull with rebase and local stash |
| `gd` / `gds` | `git diff` / `--staged` | Diff via Delta / staged diff |
| `glog` | `git log --graph ...` | 15-commit visual graph |
| `gst` / `gstp` | `git stash` / `pop` | Stash / apply workspace |

---

## Docker

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `d` | `docker` | Root shortcut |
| `dc` | `docker compose` | Compose v2 |
| `dps` | *table format* | Table: Name, Status, Ports |
| `dpsa` | `docker ps -a` | List all containers |
| `dcu` / `dcd` | `docker compose up -d` / `down` | Start / stop stack in background |
| `dcl` | `docker compose logs -f --tail=100` | Follow recent logs |
| `dclean` | `docker system prune -f` | Prune unused containers and networks |

---

## Rust & Go

| Alias | Command Executed | Description |
| :--- | :--- | :--- |
| `c` | `cargo` | Cargo root |
| `cb` / `cr` / `ct` | `cargo build` / `run` / `test` | Core Cargo tasks |
| `cchk` | `cargo check` | Typecheck (avoids colliding with `/usr/bin/cc`) |
| `gtt` | `go tool task` | Go task runner |

---

## Core Utilities & System

| Alias | Target Tool | Description |
| :--- | :--- | :--- |
| `ls` / `l` | `eza` | Colorized list, directories first |
| `ll` | `eza -la --git` | Long format with permissions and Git status |
| `lt` | `eza --tree --level=2` | 2-level directory tree |
| `cat` | `bat` | Syntax highlighting and paging |
| `grep` | `rg` | Ripgrep search |
| `find` | `fd` | File and directory search |
| `ports` | `ss -tulanp` | List listening network sockets |
| `myip` | `ip -br -c addr` | Network interface addresses |
| `path` | *formatted PATH* | Prints `$PATH` one entry per line |

---

## Configuration & Reload

| Command / File | Location / Action |
| :--- | :--- |
| `reload` | Re-sources configuration (`source ~/.zshrc`) |
| `zshrc` | Edit `~/.zshrc` |
| `aliases` | Edit `~/.config/zsh/aliases.zsh` |
| `plugins` | Edit `~/.zsh_plugins.txt` |
| `starship` | Edit `~/.config/starship.toml` |
| `zsh-help` / `cheatsheet` | Open this reference in the terminal |
