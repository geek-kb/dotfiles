# Terminal Support Configuration
# Set up terminal type and tab title management

# Set terminal type for proper color support
export TERM=xterm-256color
# Skip WezTerm's automatic CWD tracking
export WEZTERM_SHELL_SKIP_CWD=1
# Source WezTerm shell integration if available
[[ -f /Applications/WezTerm.app/Contents/Resources/wezterm.sh ]] && \
  source /Applications/WezTerm.app/Contents/Resources/wezterm.sh

# Tab title format: 15 char left-truncated current directory
ZSH_TAB_TITLE="%15<..<%~%<<" #15 char left truncated PWD
# Update tab title with current directory when showing prompt
function termsupport_cwd {
  emulate -L zsh
  print -Pn "\e]0;zsh: ${ZSH_TAB_TITLE}\a" # set tab name
}

# Update tab title with command name before execution
function termsupport_cwd_preexec {
  emulate -L zsh
  local CMD="${2%% *}"
  print -Pn "\e]0;${CMD}: ${ZSH_TAB_TITLE}\a" # set tab name
}

# Register hooks to update tab title
autoload -Uz add-zsh-hook
add-zsh-hook precmd termsupport_cwd       # Update after command completes
add-zsh-hook preexec termsupport_cwd_preexec  # Update before command runs
