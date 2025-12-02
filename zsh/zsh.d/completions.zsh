# Load command completion and cache it for faster subsequent loads
# Usage: load_completion_from_cmd <command> <completion_args>
load_completion_from_cmd() {
  local cmd=$1
  local args=("${@:2}")
  local completion_file="${ZSH_CACHE_DIR}/completions/_${cmd}"

  [[ -n $commands[$cmd] ]] || return  # Exit if command doesn't exist

  if [[ ! -f $completion_file ]]; then
    typeset -g -A _comps
    autoload -Uz _$cmd
    _comps[$cmd]=_$cmd
  fi

  eval "$cmd ${args[*]}" >| $completion_file &|  # Generate and cache completion
}

# Constants at the top
GENCOMPL_FPATH="${HOME}/.zsh/complete"  # Directory for generated completions

# zstyles - Configure completion behavior
zstyle ':completion:*:*:*:*:*' menu select  # Enable interactive menu for completions
zstyle ':completion:*' completer _complete _prefix _match _approximate  # Set completion strategies
# zstyle ':completion:*' matcher-list 'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'  # Case-insensitive matching (disabled)
zstyle ':completion:*:approximate:*' max-errors 3 numeric  # Allow up to 3 errors in approximate matching
zstyle :plugin:zsh-completion-generator programs ggrep kubedebug docker_copy_between_regions ab  # Programs for auto-completion generation

# Initialize completion system
autoload -U +X bashcompinit && bashcompinit  # Enable bash-style completion compatibility

# Group related paths together - Add completion lookup directories
fpath+=(
  "${ZSH_CACHE_DIR}/completions"                # Cached completions
  "/opt/homebrew/share/zsh/site-functions"      # Homebrew installed completions
  "${GENCOMPL_FPATH}"                            # Generated completions
)

# Group related completions together
# Infrastructure tools
complete -o nospace -C terraform terraform      # Terraform completion
complete -o nospace -C terragrunt terragrunt    # Terragrunt completion
complete -o nospace -C 'aws_completer' aws      # AWS CLI completion

# Development tools
load_completion_from_cmd docker completion zsh    # Docker completion
load_completion_from_cmd kubectl completion zsh   # Kubernetes kubectl completion
load_completion_from_cmd helm completion zsh      # Helm chart manager completion
load_completion_from_cmd asdf completion zsh      # ASDF version manager completion

# CLI tools
load_completion_from_cmd gh completion --shell zsh               # GitHub CLI completion
load_completion_from_cmd argocd completion zsh                   # ArgoCD completion
load_completion_from_cmd wezterm shell-completion --shell zsh    # WezTerm terminal completion
load_completion_from_cmd op completion zsh                       # 1Password CLI completion
