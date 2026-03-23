# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level non-hidden directory is a Stow "package" that mirrors the structure of `$HOME`.

## Applying / removing dotfiles

```bash
# Symlink all packages into $HOME
./start.sh apply

# Preview without making changes
./start.sh dry-run

# Remove all symlinks
./start.sh delete

# Unstow then restow everything
./start.sh restow
```

Files listed in `.stowrc` (Brewfile, BACKUP.md, etc.) are excluded from stowing globally.

## Key packages and what they configure

| Directory | Target | Purpose |
|-----------|--------|---------|
| `zsh/` | `~/.zshrc`, `~/zsh.d/` | Zsh shell with antidote plugin manager |
| `git/` | `~/.gitconfig`, `~/.gitignore_global` | Git with delta as the pager/diff tool |
| `nvim/` | `~/.config/nvim/` | Neovim (0.10+) with lazy.nvim |
| `ghostty/` | `~/.config/ghostty/` | Ghostty terminal config |
| `wezterm/` | `~/.config/wezterm/` | WezTerm terminal config |
| `asdf/` | `~/.tool-versions` | asdf version manager tool pins |
| `starship.toml` | `~/.config/starship.toml` | Starship prompt |

## Zsh config structure

`~/.zshrc` sources every `*.zsh` file in `~/zsh.d/` and `~/zsh.d/personal/` at startup. To add new shell config, drop a `.zsh` file in `zsh/zsh.d/`.

Key files in `zsh/zsh.d/`:
- `aliases.zsh` — shell aliases
- `functions.zsh` — shell functions
- `kubectl.zsh` — Kubernetes helpers
- `terraform.zsh` — Terraform helpers
- `fzf.zsh` — fzf keybindings and functions
- `confluent.zsh` — Confluent/Kafka helpers

NVM is lazy-loaded on first use of `nvm`, `node`, `npm`, or `npx` to speed up shell startup.

## Neovim config structure

Entry point: `nvim/.config/nvim/init.lua`

- `lua/core/` — leader key, lazy.nvim bootstrap
- `lua/user/` — options, keymaps, autocommands, lazy config
- `lua/plugins/` — one file per plugin or plugin group (loaded by lazy.nvim)
- `colorscheme.txt` — persisted colorscheme preference; changed via `<leader>tcm`

Plugin files in `lua/plugins/` worth knowing:
- `lsp.lua` — LSP configuration
- `cmpconf.lua` — completion (nvim-cmp)
- `telescope.lua` — fuzzy finder
- `git.lua` / `gitsigns.lua` — git integration
- `dap.lua` — debug adapter protocol
- `databases.lua` — database UI
- `kubectl.lua` — Kubernetes inside Neovim

### Running Neovim tests

```bash
cd nvim/.config/nvim
make prepare   # clone plenary.nvim (one-time)
make test      # run tests via PlenaryBusted
```

## Bootstrap a new Mac

See README.md for the full step-by-step sequence:
1. `xcode-select --install`
2. Install Homebrew, then `brew install git stow nvm`
3. Clone repo to `~/.dotfiles`
4. Install antidote: `git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote`
5. `./start.sh apply && source ~/.zshrc`
6. `brew bundle install --file=~/.dotfiles/Brewfile`
7. Install asdf plugins and run `asdf install`
8. Set up Python venv with `pip install -r requirements.txt`

## Git configuration notes

- Default pager and diff viewer: **delta** with the `arctic-fox` theme (Nord color scheme, side-by-side diffs)
- `pull.rebase = false` — merges, not rebases, on pull
- `push.default = current` — pushes to same-name remote branch
- `init.defaultBranch = master`
