__GREP_CACHE_FILE="$ZSH_CACHE_DIR"/grep-alias

# See if there's a cache file modified in the last day
__GREP_ALIAS_CACHES=("$__GREP_CACHE_FILE"(Nm-1))
if [[ -n "$__GREP_ALIAS_CACHES" ]]; then
  source "$__GREP_CACHE_FILE"
else
  grep-flags-available() {
      command ggrep "$@" "" &>/dev/null <<< ""
  }

  # Ignore these folders (if the necessary grep flags are available)
  EXC_FOLDERS="{.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}"

  # Check for --exclude-dir, otherwise check for --exclude. If --exclude
  # isn't available, --color won't be either (they were released at the same
  # time (v2.5): https://git.savannah.gnu.org/cgit/grep.git/tree/NEWS?id=1236f007
  if grep-flags-available --color=auto --exclude-dir=.cvs; then
    GREP_OPTIONS="--color=auto --exclude-dir=$EXC_FOLDERS"
  elif grep-flags-available --color=auto --exclude=.cvs; then
    GREP_OPTIONS="--color=auto --exclude=$EXC_FOLDERS"
  fi

  if [[ -n "$GREP_OPTIONS" ]]; then
    # export grep, egrep and fgrep settings
    alias grep="ggrep $GREP_OPTIONS"
    alias egrep="grep -E"
    alias fgrep="grep -F"

    # write to cache file if cache directory is writable
    if [[ -w "$ZSH_CACHE_DIR" ]]; then
      alias -L grep egrep fgrep >| "$__GREP_CACHE_FILE"
    fi
  fi

  # Clean up
  unset GREP_OPTIONS EXC_FOLDERS
  unfunction grep-flags-available
fi

unset __GREP_CACHE_FILE __GREP_ALIAS_CACHES
