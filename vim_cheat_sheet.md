# Neovim Plugin Shortcuts Cheat Sheet

## 🧠 General

| Shortcut           | Description                  |
|--------------------|------------------------------|
| `<leader>z`        | Open Lazy plugin manager     |
| `<c-e>`            | Open Oil file explorer float |

---

## 🔍 Fuzzy Finder (fzf-lua)

| Shortcut           | Description                          |
|--------------------|--------------------------------------|
| `<C-p>`            | Find files                           |
| `<C-b>`            | List open buffers                    |
| `<leader>/`        | Live grep                            |
| `<leader>el`       | Search Lazy plugins dir              |
| `<leader>ee`       | Open FzfLua builtin functions        |
| `<leader>hh`       | Help tags                            |
| `<leader>i`        | Recently opened files                |
| `<C-x><C-f>`       | Fuzzy complete path (Insert mode)    |
| `<F4>`             | Git branch manager w/ actions        |
| `<leader>ccp`      | CopilotChat prompt actions picker    |

---

## 🧠 Copilot + CopilotChat

| Shortcut           | Description                  |
|--------------------|------------------------------|
| `<M-Enter>`        | Accept Copilot suggestion     |
| `<leader>ccc`      | Open CopilotChat              |
| `<leader>ccs`      | Stop CopilotChat              |

---

## 🧾 Git / GitHub

| Shortcut           | Description                            |
|--------------------|----------------------------------------|
| `<leader>gg`       | Toggle Fugitive Git status             |
| `<leader>gp`       | Git push                               |
| `<leader>gl`       | Git pull                               |
| `<leader>gf`       | Git fetch                              |
| `<leader>gb`       | Insert current branch to buffer        |
| `<leader>gB`       | Copy current branch to clipboard       |
| `<leader>gm`       | Git menu (actions picker)              |
| `<leader>gc`       | cd to Git root                         |
| `<leader>gh`       | Open current line in GitHub            |
| `<leader>gd`       | Diffview file history                  |

---

## 🪄 Gitsigns

| Shortcut           | Description                        |
|--------------------|------------------------------------|
| `]c / [c`          | Next/Previous hunk                 |
| `<leader>hp`       | Preview hunk                       |
| `<leader>hb`       | Toggle line blame                  |
| `<leader>hd`       | Toggle deleted lines               |
| `ih` (visual/op)   | Select hunk                        |

---

## 📁 Tree (nvim-tree)

| Shortcut           | Description                          |
|--------------------|--------------------------------------|
| `<c-o>`            | Toggle file tree                     |
| `<leader>v`        | Focus file in tree                   |
| `h` / `<Left>`     | Collapse directory or go to parent   |
| `l` / `<Right>`    | Expand directory                     |
| `v`                | Open file in vertical split          |
| `i`                | Open file in horizontal split        |
| `cd`               | Change root to current node          |
| `T`                | Cycle sort method                    |
| `dd`               | Cut selected files                   |
| `yy`               | Copy selected files                  |
| `p`                | Paste copied/cut files               |
| `df`               | Trash selected files                 |
| `dF`               | Permanently delete selected files    |
| `J` / `K`          | Bookmark + move down/up              |
| `mv`               | Move bookmarked files                |
| `r`                | Move current file to a new location  |

---

## 🐍 DAP (Debugging)

| Shortcut           | Description                    |
|--------------------|--------------------------------|
| `<F5>`             | Start / Continue               |
| `<leader>db`       | Toggle breakpoint              |
| `<leader>dc`       | Continue                       |
| `<leader>do`       | Step over                      |
| `<leader>di`       | Step into                      |
| `<leader>dO`       | Step out                       |
| `<leader>dq`       | Terminate                      |
| `<leader>du`       | Toggle DAP UI                  |
| `<leader>dm`       | DAP actions menu               |

---

## 🌈 Yanky (Yank history)

| Shortcut           | Description                        |
|--------------------|------------------------------------|
| `p / P`            | Paste from yanky                   |
| `<C-n> / <C-m>`    | Cycle forward/backward in ring     |
| `<leader>y`        | Yank ring history popup            |

---

## 💻 Terminal (snacks.nvim)

| Shortcut           | Description                        |
|--------------------|------------------------------------|
| `<C-/>`            | Toggle terminal                    |

---

## 🧼 Formatting (conform.nvim)

| Shortcut           | Description                  |
|--------------------|------------------------------|
| `<leader>lp`       | Format buffer (LSP or tool)  |

---

## 🔄 Swap / Switch / Align

| Shortcut           | Description                        |
|--------------------|------------------------------------|
| `<leader>sw`       | Interactive swap                   |
| `g< / g>`          | Swap previous/next                 |
| `gs`               | Smart word switch                  |
| `ga` (visual)      | EasyAlign selection                |

---

## ✨ Treesitter

| Shortcut           | Description                     |
|--------------------|---------------------------------|
| `vn`               | Start incremental selection     |
| `<CR>`             | Increase node selection         |
| `<BS>`             | Decrease node selection         |

---

## 📦 Miscellaneous

| Shortcut           | Description                      |
|--------------------|----------------------------------|
| `<leader>.`        | Toggle Scratch buffer            |
| `<leader>S`        | Select Scratch buffer            |
| `<leader>bd`       | Delete current buffer            |
| `<leader>bh`       | Delete hidden buffers            |
| `<leader>bo`       | Delete all but current buffer    |
| `]] / [[`          | Next / Prev reference (snacks)   |
| `<leader>N`        | Neovim News popup                |
| `<leader>cc`       | YAML Companion: Change schema    |

---

## 🖼️ Colorschemes

Use this menu to toggle:

```vim
:lua require('user.menu').open('Colorscheme')
```

---

_This cheat sheet was generated from your actual plugin configuration._
