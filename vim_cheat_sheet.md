# Neovim Plugin Shortcuts Cheat Sheet

A comprehensive reference organized from basic to advanced operations.

---

## 🎯 Essential Navigation

| Shortcut      | Description                     |
| ------------- | ------------------------------- |
| `j/k`         | Better up/down movement         |
| `<Up>/<Down>` | Better up/down movement         |
| `0`           | Go to first non-blank character |
| `L/H`         | Move view right/left            |
| `]] / [[`     | Next / Prev reference           |
| `<leader>sa`  | Visually select entire buffer   |
| `-`           | Move line down                  |
| `_`           | Move line up                    |

---

## ✍️ Basic Editing

| Shortcut        | Description                        |
| --------------- | ---------------------------------- |
| `<tab>/<s-tab>` | Indent/unindent selection          |
| `<C-e>`         | Delete word (insert mode)          |
| `<C-b>`         | Delete word backward (insert mode) |
| `;;`            | Add semicolon at end of line       |
| `,,`            | Add comma at end of line           |
| `` ` ``         | Convert to lowercase (visual)      |
| `~`             | Convert to uppercase (visual)      |
| `<C-c>`         | Change word under cursor           |
| `gV`            | Select last inserted text          |

---

## 🔄 Text Manipulation

| Shortcut      | Description                        |
| ------------- | ---------------------------------- |
| `<leader>sw`  | Interactive swap                   |
| `g< / g>`     | Swap previous/next                 |
| `gs`          | Smart word switch                  |
| `ga` (visual) | EasyAlign selection                |
| `mt`          | Surround with string interpolation |
| `<leader>gt`  | Indent block                       |
| `<leader>=`   | Create line of = signs below       |

---

## 🔍 Search & Navigation

| Shortcut       | Description                       |
| -------------- | --------------------------------- |
| `<C-p>`        | Find files (in current dir)       |
| `<leader>h`    | Find files (in all $home)         |
| `<C-b>`        | List open buffers                 |
| `<leader>/`    | Live grep                         |
| `<leader>hh`   | Help tags                         |
| `<leader>i`    | Recently opened files             |
| `<CR>`         | Clear search highlighting         |
| `*/#` (visual) | Search selected text              |
| `<C-x><C-f>`   | Fuzzy complete path (Insert mode) |
| `<leader>el`   | Search Lazy plugins dir           |
| `<leader>ee`   | Open FzfLua builtin functions     |

---

## 🪟 Window Management

| Shortcut           | Description                   |
| ------------------ | ----------------------------- |
| `<Leader><Leader>` | Switch to alternate file      |
| `<tab>`            | Cycle through windows         |
| `<c-w><c-c>`       | Close window                  |
| `<c-w>v`           | New buffer vertically split   |
| `<c-w>s`           | New buffer horizontally split |
| `<c-w>e`           | New empty buffer              |
| `<C-h>`            | Go to Left Window             |
| `<C-j>`            | Go to Lower Window            |
| `<C-k>`            | Go to Upper Window            |
| `<C-l>`            | Go to Right Window            |

---

## 📜 Buffer Navigation

| Shortcut     | Description                    |
| ------------ | ------------------------------ |
| `<leader>bp` | Pick buffer                    |
| `<leader>bc` | Pick buffer to close           |
| `[b`         | Previous buffer                |
| `]b`         | Next buffer                    |
| `<leader>bl` | Close all buffers to the left  |
| `<leader>br` | Close all buffers to the right |
| `<leader>bo` | Close all other buffers        |
| `<leader>bd` | Delete current buffer          |
| `<leader>bh` | Delete hidden buffers          |
| `<leader>bn` | Next buffer                    |

---

## 📑 Tabs

| Shortcut     | Description    |
| ------------ | -------------- |
| `]t`         | Next tab       |
| `[t`         | Previous tab   |
| `<leader>tn` | New tab        |
| `<leader>tc` | Close tab      |
| `<leader>th` | Move tab left  |
| `<leader>tl` | Move tab right |

---

## 📁 File Management

| Shortcut     | Description                      |
| ------------ | -------------------------------- |
| `<c-e>`      | Open Oil file explorer float     |
| `<c-o>`      | Toggle file tree                 |
| `<leader>v`  | Focus file in tree               |
| `<leader>cd` | Change directory to current file |
| `<leader>bd` | Delete current buffer            |
| `<leader>bh` | Delete hidden buffers            |
| `<leader>bo` | Delete all but current buffer    |

---

## 📁 Tree Operations (nvim-tree)

| Shortcut        | Description                         |
| --------------- | ----------------------------------- |
| `h` / `<Left>`  | Collapse directory or go to parent  |
| `l` / `<Right>` | Expand directory                    |
| `v`             | Open file in vertical split         |
| `i`             | Open file in horizontal split       |
| `cd`            | Change root to current node         |
| `T`             | Cycle sort method                   |
| `dd`            | Cut selected files                  |
| `yy`            | Copy selected files                 |
| `p`             | Paste copied/cut files              |
| `df`            | Trash selected files                |
| `dF`            | Permanently delete selected files   |
| `J` / `K`       | Bookmark + move down/up             |
| `mv`            | Move bookmarked files               |
| `r`             | Move current file to a new location |

---

## 🧾 Git Operations

| Shortcut     | Description                      |
| ------------ | -------------------------------- |
| `<leader>gg` | Toggle Fugitive Git status       |
| `<leader>gp` | Git push                         |
| `<leader>gl` | Git pull                         |
| `<leader>gf` | Git fetch                        |
| `<leader>gb` | Insert current branch to buffer  |
| `<leader>gB` | Copy current branch to clipboard |
| `<leader>gm` | Git menu (actions picker)        |
| `<leader>gc` | cd to Git root                   |
| `<leader>gh` | Open current line in GitHub      |
| `<leader>gd` | Diffview file history            |
| `<F4>`       | Git branch manager w/ actions    |

---

## 🪄 Gitsigns

| Shortcut         | Description          |
| ---------------- | -------------------- |
| `]c / [c`        | Next/Previous hunk   |
| `<leader>hp`     | Preview hunk         |
| `<leader>hb`     | Toggle line blame    |
| `<leader>hd`     | Toggle deleted lines |
| `ih` (visual/op) | Select hunk          |

---

## 🔄 Diff Operations

| Shortcut     | Description             |
| ------------ | ----------------------- |
| `<leader>dp` | Diffput                 |
| `<leader>dg` | Diffget                 |
| `<leader>dn` | Enable diff mode        |
| `<leader>df` | Disable diff mode       |
| `<leader>ds` | Diff with saved version |

---

## 🧠 AI & Code Intelligence

| Shortcut      | Description               |
| ------------- | ------------------------- |
| `<M-Enter>`   | Accept Copilot suggestion |
| `<leader>ccc` | Open CopilotChat          |
| `<leader>ccs` | Stop CopilotChat          |
| `<leader>ccp` | CopilotChat prompt picker |
| `<leader>lp`  | Format buffer (LSP/tool)  |
| `<leader>46`  | Base64 decode             |
| `<leader>64`  | Base64 encode             |

---

## 🐍 Debugging (DAP)

| Shortcut     | Description       |
| ------------ | ----------------- |
| `<F5>`       | Start / Continue  |
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue          |
| `<leader>do` | Step over         |
| `<leader>di` | Step into         |
| `<leader>dO` | Step out          |
| `<leader>dq` | Terminate         |
| `<leader>du` | Toggle DAP UI     |
| `<leader>dm` | DAP actions menu  |

---

## 📋 Clipboard & Yanking

| Shortcut      | Description                         |
| ------------- | ----------------------------------- |
| `cp`          | Copy to system clipboard            |
| `cP`          | Copy line to system clipboard       |
| `cv`          | Paste from system clipboard         |
| `Y`           | Copy entire file to clipboard       |
| `<leader>cfp` | Copy relative file path             |
| `<leader>cfa` | Copy full file path                 |
| `<leader>cfd` | Copy file directory path            |
| `<leader>cfn` | Copy filename                       |
| `<leader>rp`  | Replace file with clipboard content |

---

## 🌈 Yank History (Yanky)

| Shortcut        | Description                    |
| --------------- | ------------------------------ |
| `p / P`         | Paste from yanky               |
| `<C-n> / <C-m>` | Cycle forward/backward in ring |
| `<leader>y`     | Yank ring history popup        |

---

## 💻 Terminal

| Shortcut          | Description        |
| ----------------- | ------------------ |
| `<C-/>`           | Toggle terminal    |
| `<Esc>`           | Exit terminal mode |
| `<C-l><C-l>`      | Clear terminal     |
| `<C-l><C-l><C-l>` | Reset terminal     |

---

## 📑 Folding

| Shortcut     | Description      |
| ------------ | ---------------- |
| `<leader>ff` | Toggle fold      |
| `<leader>fc` | Close all folds  |
| `<leader>fo` | Open all folds   |
| `<leader>fl` | Open level folds |

---

## 📝 Macros

| Shortcut    | Description  |
| ----------- | ------------ |
| `Q`         | Run macro q  |
| `X`         | Run macro x  |
| `<leader>Q` | Edit macro q |
| `<leader>X` | Edit macro x |

---

## 📋 Quickfix and Location List

| Shortcut | Description                 |
| -------- | --------------------------- |
| `]q`     | Next quickfix item          |
| `[q`     | Previous quickfix item      |
| `]l`     | Next location list item     |
| `[l`     | Previous location list item |

---

## ✨ Treesitter

| Shortcut | Description                 |
| -------- | --------------------------- |
| `vn`     | Start incremental selection |
| `<CR>`   | Increase node selection     |
| `<BS>`   | Decrease node selection     |

---

## 🎨 UI & Appearance

| Shortcut      | Description              |
| ------------- | ------------------------ |
| `<leader>tcm` | Toggle colorscheme menu  |
| `<leader>w-`  | Reduce tree size         |
| `<leader>w=`  | Increase tree size       |
| `<leader>ww`  | Toggle wrap              |
| `<leader>z`   | Open Lazy plugin manager |

---

## 📦 Miscellaneous

| Shortcut     | Description                   |
| ------------ | ----------------------------- |
| `<leader>.`  | Toggle Scratch buffer         |
| `<leader>S`  | Select Scratch buffer         |
| `<leader>N`  | Neovim News popup             |
| `<leader>cc` | YAML Companion: Change schema |

---

This cheat sheet was generated from the actual plugin configuration.
