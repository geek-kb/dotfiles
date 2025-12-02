#!/bin/zsh
#------------------------------------------------------------------------------
# Core System Command Overrides
#------------------------------------------------------------------------------
alias rm='rm -i'      # Interactive rm - prompts before deletion
alias cp='cp -i'      # Interactive cp - prompts before overwrite
alias mv='mv -i'      # Interactive mv - prompts before overwrite
alias sed=gsed        # Use GNU sed instead of BSD sed
alias grep=ggrep      # Use GNU grep instead of BSD grep
alias sort=gsort      # Use GNU sort instead of BSD sort
alias awk=gawk        # Use GNU awk instead of BSD awk
#alias cat=bat
alias s=source        # Quick source command shortcut
alias cat="bat --style=plain --paging=never"  # Use bat for syntax highlighting
alias pbc='pbcopy'    # Quick clipboard copy

#------------------------------------------------------------------------------
# File Navigation & Management
#------------------------------------------------------------------------------
alias ll='ls -lah'              # Long listing with hidden files
alias ls='eza '                 # Use eza (modern ls replacement)
alias dc='cd '                  # Typo-friendly cd alias
alias dot='cd ~/.dotfiles'      # Quick navigation to dotfiles directory
alias src="~/src"               # Quick navigation to source directory

#------------------------------------------------------------------------------
# Editor Related
#------------------------------------------------------------------------------
alias vim="nvim"                                          # Use neovim instead of vim
alias v='nvim'                                            # Quick neovim shortcut
alias vi='nvim'                                           # Use neovim for vi command
alias vsrc='nvim ~/src'                                   # Open neovim in source directory
alias sudoedit="nvim"                                     # Use neovim for sudo editing
alias lvim='NVIM_APPNAME=LazyVim nvim'                    # Launch LazyVim configuration
alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'         # Edit zsh config file
alias diff='/usr/bin/diff --color $1 $2'                  # Use colored diff output

#------------------------------------------------------------------------------
# Development Tools
#------------------------------------------------------------------------------
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'  # Update neovim nightly build

#------------------------------------------------------------------------------
# Git
#------------------------------------------------------------------------------
alias gs='git status'                                         # Quick git status
alias git_current_branch='git branch --show-current'          # Show current git branch
alias gb='git for-each-ref --sort=-committerdate --format="%(refname:short)" | grep -n . | sed "s?origin/??g" | sort -t: -k2 -u | sort -n | cut -d: -f2 | fzf | xargs git checkout'  # Interactive branch selector with fzf
alias gaM='git diff --name-only | xargs git add'  # Add all modified files
alias gCM='git commit -m "Updates files: $(git diff --name-only --cached | xargs)"'
alias gCMP='git commit -m "Updates files: $(git diff --name-only --cached | xargs)" ; git push'

#------------------------------------------------------------------------------
# Network & System Utils
#------------------------------------------------------------------------------
alias watch='watch --color '                                  # Enable color in watch command
alias myip='curl ipv4.icanhazip.com'                          # Get public IP address
alias server='python -m http.server 3030'                     # Quick HTTP server on port 3030
alias kgevents='kubectl get event --sort-by=.metadata.creationTimestamp | grep -E -v "(Successfully (pulled|assigned)|(Started|Created) container|(Deleted|Created) pod)"'  # Get filtered Kubernetes events
alias cwd='pwd | rev | cut -d/ -f1 | rev'                     # Get current directory name only

#------------------------------------------------------------------------------
# File Type Associations
#------------------------------------------------------------------------------
alias -s {lua,yml,yaml,json,txt}=nvim  # Open these file types directly with nvim

#------------------------------------------------------------------------------
# Global Aliases (Pipe Operations)
#------------------------------------------------------------------------------
# Loop Controls
alias -g Wt='while :;do '                                        # Start infinite while loop
alias -g Wr=' | while read -r line;do echo "=== $line ==="; '    # Read line-by-line with echo
alias -g D=';done'                                               # Close loop

# Text Processing
alias -g H='| head'                            # Pipe to head (first lines)
alias -g T='| tail'                            # Pipe to tail (last lines)
alias -g G='| grep'                            # Pipe to grep (filter)
alias -g L="| less"                            # Pipe to less (paginated view)
alias -g P="| pbcopy"                          # Pipe to clipboard
alias -g V='| nvim'                            # Pipe to nvim (edit in editor)
alias -g S='| sort'                            # Pipe to sort

# Snyk cli
alias -g snyka="snyk auth $(cat ~/.snyk_pat)"  # Authenticate with Snyk using PAT

# Output Redirection
alias -g NE="2> /dev/null"      # Suppress error output
alias -g NUL="> /dev/null 2>&1"  # Suppress all output

# Kubernetes Specific
alias -g Sa='--sort-by=.metadata.creationTimestamp'                                       # Sort by creation time
alias -g Srt='--sort-by=.metadata.creationTimestamp'                                      # Sort by creation time
alias -g SECRET='-ojson | jq ".data | with_entries(.value |= @base64d)"'                  # Decode secret data from base64
alias -g IMG='-oyaml | sed -n '\''s/^\s*image:\s\(.*\)/\1/gp'\'' | sort -u'                # Extract unique images
alias -g YML='-oyaml | vim -c "set filetype=yaml | nnoremap <buffer> q :qall<cr>"'       # View YAML in vim
alias -g NM=' --no-headers -o custom-columns=":metadata.name"'                            # Get names only
alias -g RC='--sort-by=".status.containerStatuses[0].restartCount" -A | grep -v "\s0\s"'  # Show pods with restarts
alias -g BAD='| grep -v "1/1\|2/2\|3/3\|4/4\|5/5\|6/6\|Completed\|Evicted"'             # Filter out healthy pods
alias -g IP='-ojsonpath="{.spec.nodeName}"'                                               # Get node name
alias -g SRT='+short | sort'                                                              # Short output sorted

# VMWare Tanzu Cli
#alias -g tcli='~/.bin/tanzu-cli-darwin_arm64'

# Shell Processing
alias -g dollar1='$(awk "{print \$1}"<<<"${line}")'  # Extract first field from $line variable
alias -g dollar2='$(awk "{print \$2}"<<<"${line}")'  # Extract second field from $line variable

export LOADED_ALIASES=true  # Flag to indicate aliases have been loaded
