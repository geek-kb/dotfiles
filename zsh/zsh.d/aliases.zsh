#!/bin/zsh
#------------------------------------------------------------------------------
# Core System Command Overrides
#------------------------------------------------------------------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sed=gsed
alias grep=ggrep
alias sort=gsort
alias awk=gawk
#alias cat=bat
alias s=source
alias cat="bat --style=plain --paging=never"
alias pbc='pbcopy'

#------------------------------------------------------------------------------
# File Navigation & Management
#------------------------------------------------------------------------------
alias ll='ls -lah'
alias ls='eza '
alias dc='cd '
alias dot='cd ~/.dotfiles'
alias src="~/src"

#------------------------------------------------------------------------------
# Editor Related
#------------------------------------------------------------------------------
alias vim="nvim"
alias v='nvim'
alias vi='nvim'
alias vsrc='nvim ~/src'
alias sudoedit="nvim"
alias lvim='NVIM_APPNAME=LazyVim nvim'
alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'
alias diff='/usr/bin/diff --color $1 $2'

#------------------------------------------------------------------------------
# Development Tools
#------------------------------------------------------------------------------
alias tf='terraform'
alias tg='terragrunt'
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'

#------------------------------------------------------------------------------
# Git
#------------------------------------------------------------------------------
alias gs='git status'
alias git_current_branch='git branch --show-current'
alias gb='git for-each-ref --sort=-committerdate --format="%(refname:short)" | grep -n . | sed "s?origin/??g" | sort -t: -k2 -u | sort -n | cut -d: -f2 | fzf | xargs git checkout'

#------------------------------------------------------------------------------
# Network & System Utils
#------------------------------------------------------------------------------
alias watch='watch --color '
alias myip='curl ipv4.icanhazip.com'
alias server='python -m http.server 3030'
alias kgevents='kubectl get event --sort-by=.metadata.creationTimestamp | grep -E -v "(Successfully (pulled|assigned)|(Started|Created) container|(Deleted|Created) pod)"'

#------------------------------------------------------------------------------
# File Type Associations
#------------------------------------------------------------------------------
alias -s {lua,yml,yaml,json,txt}=nvim

#------------------------------------------------------------------------------
# Global Aliases (Pipe Operations)
#------------------------------------------------------------------------------
# Loop Controls
alias -g Wt='while :;do '
alias -g Wr=' | while read -r line;do echo "=== $line ==="; '
alias -g D=';done'

# Text Processing
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g P="| pbcopy"
alias -g V='| nvim'
alias -g S='| sort'

# Output Redirection
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

# Kubernetes Specific
alias -g Sa='--sort-by=.metadata.creationTimestamp'
alias -g Srt='--sort-by=.metadata.creationTimestamp'
alias -g SECRET='-ojson | jq ".data | with_entries(.value |= @base64d)"'
alias -g IMG='-oyaml | sed -n '\''s/^\s*image:\s\(.*\)/\1/gp'\'' | sort -u'
alias -g YML='-oyaml | vim -c "set filetype=yaml | nnoremap <buffer> q :qall<cr>"'
alias -g NM=' --no-headers -o custom-columns=":metadata.name"'
alias -g RC='--sort-by=".status.containerStatuses[0].restartCount" -A | grep -v "\s0\s"'
alias -g BAD='| grep -v "1/1\|2/2\|3/3\|4/4\|5/5\|6/6\|Completed\|Evicted"'
alias -g IP='-ojsonpath="{.spec.nodeName}"'
alias -g SRT='+short | sort'

# VMWare Tanzu Cli
#alias -g tcli='~/.bin/tanzu-cli-darwin_arm64'

# Shell Processing
alias -g dollar1='$(awk "{print \$1}"<<<"${line}")'
alias -g dollar2='$(awk "{print \$2}"<<<"${line}")'

export LOADED_ALIASES=true
