# 🔧 Vim Cheat Sheet

## 📋 Modes

| Mode | Key | Description |
|------|-----|-------------|
| Normal | `Esc` | Default mode for navigation and commands. |
| Insert | `i` | Edit mode - insert text before cursor. |
| Insert | `I` | Insert text at the beginning of the line. |
| Insert | `a` | Insert text after cursor. |
| Insert | `A` | Insert text at the end of the line. |
| Insert | `o` | Create a new line below and insert. |
| Insert | `O` | Create a new line above and insert. |
| Visual | `v` | Select text character by character. |
| Visual | `V` | Select entire lines. |
| Visual | `Ctrl + v` | Select text in block/column mode. |
| Command | `:` | Execute commands (search, save, quit). |

## ⌨️ Navigation (Normal Mode)

### Basic Movement:
- `h` – Move left.
- `j` – Move down.
- `k` – Move up.
- `l` – Move right.
- `w` – Jump to the next word.
- `b` – Jump to the previous word.
- `e` – Jump to the end of the word.
- `0` – Jump to the beginning of the line.
- `$` – Jump to the end of the line.
- `gg` – Jump to the beginning of the file.
- `G` – Jump to the end of the file.
- `:{line_number}` – Jump to a specific line number.
- `Ctrl + f` – Page down.
- `Ctrl + b` – Page up.

## ✏️ Editing (Normal Mode)

### Insertion:
- `i` – Insert before cursor.
- `a` – Insert after cursor.
- `o` – New line below and insert.
- `O` – New line above and insert.

### Deletion:
- `x` – Delete character under cursor.
- `X` – Delete character before cursor.
- `dw` – Delete word.
- `dd` – Delete entire line.
- `d$` – Delete from cursor to end of line.
- `d0` – Delete from cursor to beginning of line.
- `D` – Delete from cursor to end of line (same as d$).

### Copying & Pasting:
- `yy` – Yank (copy) entire line.
- `yw` – Yank word.
- `y$` – Yank from cursor to end of line.
- `p` – Paste after cursor.
- `P` – Paste before cursor.

### Undo & Redo:
- `u` – Undo last action.
- `Ctrl + r` – Redo last action.

## 🔍 Search & Replace

- `/pattern` – Search forward for pattern.
- `?pattern` – Search backward for pattern.
- `n` – Jump to next search result.
- `N` – Jump to previous search result.
- `:%s/old/new/g` – Replace all occurrences of old with new.
- `:%s/old/new/gc` – Replace with confirmation prompt.
- `:s/old/new/g` – Replace in current line only.

## 📝 Text Manipulation

- `~` – Toggle case of character.
- `>>` – Indent line to the right.
- `<<` – Indent line to the left.
- `J` – Join current line with next line.
- `.` – Repeat last command.
- `r{char}` – Replace single character.
- `cw` – Change (delete and insert) word.
- `cc` – Change entire line.
- `C` – Change from cursor to end of line.

## 💾 File Operations (Command Mode)

- `:w` – Save file.
- `:w filename` – Save as new filename.
- `:q` – Quit vim.
- `:q!` – Quit without saving.
- `:wq` – Save and quit.
- `:x` – Save and quit (shorthand).
- `:e filename` – Open file.
- `:split filename` – Open file in horizontal split.
- `:vsplit filename` – Open file in vertical split.

## 🎯 Selection & Operators (Visual Mode)

- `v` – Start character-wise selection.
- `V` – Start line-wise selection.
- `Ctrl + v` – Start block-wise selection.
- `d` – Delete selected text.
- `y` – Yank selected text.
- `>` – Indent selected text.
- `<` – UnIndent selected text.
- `~` – Toggle case of selected text.

## 🔧 Useful Tips & Tricks

- `:set number` – Show line numbers.
- `:set nonumber` – Hide line numbers.
- `:syntax on` – Enable syntax highlighting.
- `:!command` – Execute shell command without leaving vim.
- `:%!sort` – Sort all lines in file.
- `:read filename` – Insert content of another file.
- `Ctrl + ]` – Jump to tag definition (requires tags).
- `Ctrl + o` – Jump to previous location.
- `Ctrl + i` – Jump to next location.

## 🚀 Advanced Commands

- `:global/pattern/command` – Execute command on lines matching pattern.
- `:vimgrep pattern files` – Search for pattern in multiple files.
- `:make` – Run build command.
- `:shell` – Open a shell without leaving vim.
- `gf` – Open file under cursor.
- `*` – Search for word under cursor forward.
- `#` – Search for word under cursor backward.
