# Zsh Behavior Configuration
# Core zsh options and keybindings

# Remove '/' from WORDCHARS for better word navigation
export WORDCHARS=""
# Completion behavior options
setopt menu_complete       # Auto-select first completion match
unsetopt auto_menu         # Don't cycle through completions with repeated tab
unsetopt case_glob         # Case-insensitive globbing
setopt glob_complete       # Show completion menu for glob patterns
setopt multios             # enable redirect to multiple streams: echo >file1 >file2
setopt long_list_jobs      # show long list format job notifications
setopt interactivecomments # recognize comments
setopt autocd              # cd by typing directory name
setopt complete_in_word    # Complete from both ends of a word

# Push current line to buffer stack (Ctrl-Q) - useful for running another command first
bindkey '^q' push-line

# Copy current command line to clipboard (Ctrl-Y)
copy-line-to-clipboard() {
    echo -n "$BUFFER" | pbcopy
}
zle -N copy-line-to-clipboard  # Register as ZLE widget
bindkey '^Y' copy-line-to-clipboard  # Bind to Ctrl-Y

