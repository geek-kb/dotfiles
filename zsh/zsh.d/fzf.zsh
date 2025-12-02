# Initialize fzf shell integration for zsh
source <(fzf --zsh)
# Configure fzf to search all files (including hidden) except .git
export FZF_CTRL_T_COMMAND='rg --color=never --files --hidden --follow -g "!.git"'
# Show file preview with syntax highlighting using bat
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=numbers,changes {}"'
# Configure history search with command preview
export FZF_CTRL_R_OPTS="--ansi --color=hl:underline,hl+:underline --height 80% --preview 'echo {2..} | bat --color=always -pl bash' --preview-window 'down:4:wrap' --bind 'ctrl-/:toggle-preview'"

# Interactive file deletion using fzf for selection
function fzf-rm() {
  if [[ "$#" -eq 0 ]]; then
    local files
    files=$(find . -maxdepth 1 -type f | fzf --multi)
    echo $files | xargs -I '{}' rm {} #we use xargs to capture filenames with spaces in them properly
  else
    command rm "$@"
  fi
}

# Man without options will use fzf to select a page
# Interactive man page viewer with fzf search and preview
function fzf-man() {
  MAN="/usr/bin/man"
  if [ -n "$1" ]; then
    $MAN "$@"
    return $?
  else
    $MAN -k . | fzf --reverse --preview="echo {1,2} | sed 's/ (/./' | sed -E 's/\)\s*$//' | xargs $MAN" | awk '{print $1 "." $2}' | tr -d '()' | xargs -r $MAN
    return $?
  fi
}

# Live command evaluation with preview - type command and see output in real-time
function fzf-eval() {
  echo | fzf -q "$*" --preview-window=up:99% --preview="eval {q}"
}

# Fuzzy search and execute aliases or functions interactively
function fzf-aliases-functions() {
  CMD=$(
    (
      (alias)
      (functions | grep "()" | cut -d ' ' -f1 | grep -v "^_")
    ) | fzf | cut -d '=' -f1
  )

  eval $CMD
}

# Interactive git status - select and edit changed files with fzf
function fzf-git-status() {
  git rev-parse --git-dir >/dev/null 2>&1 || {
    echo "You are not in a git repository" && return
  }
  local selected
  selected=$(git -c color.status=always status --short |
    fzf --height 50% "$@" --border -m --ansi --nth 2..,.. \
      --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //')
  if [[ $selected ]]; then
    for prog in $(echo $selected); do
      $EDITOR $prog
    done
  fi
}
