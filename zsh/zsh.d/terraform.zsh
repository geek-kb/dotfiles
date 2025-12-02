# Terraform Aliases
# Comprehensive shortcuts for Terraform commands

alias tf='terraform'         # Main terraform shortcut
alias tfa='terraform apply'  # Apply changes
alias tfae='terraform apply -auto-approve'  # Apply without confirmation
alias tfc='terraform console'               # Open terraform console
alias tfd='terraform destroy'               # Destroy infrastructure
alias tff='terraform fmt'                   # Format terraform files
alias tfg='terraform graph'                 # Generate dependency graph
alias tfim='terraform import'               # Import existing resources
alias tfin='terraform init'                 # Initialize terraform directory
alias tfo='terraform output'                # Show outputs
alias tfp='terraform plan'                  # Generate execution plan
alias tfpr='terraform providers'            # Show providers
alias tfr='terraform refresh'               # Refresh state
alias tfsh='terraform show'                 # Show current state
alias tft='terraform taint'                 # Mark resource for recreation
alias tfut='terraform untaint'              # Remove taint from resource
alias tfv='terraform validate'              # Validate configuration
alias tfw='terraform workspace'             # Workspace management
alias tfs='terraform state'                 # State management
alias tffu='terraform force-unlock'         # Force unlock state
alias tfwst='terraform workspace select'    # Select workspace
alias tfwsw='terraform workspace show'      # Show current workspace
alias tfss='terraform state show'           # Show resource in state
alias tfwde='terraform workspace delete'    # Delete workspace
alias tfwls='terraform workspace list'      # List workspaces
alias tfsl='terraform state list'           # List resources in state
alias tfwnw='terraform workspace new'       # Create new workspace
alias tfsmv='terraform state mv'            # Move resource in state
alias tfspl='terraform state pull'          # Pull remote state
alias tfsph='terraform state push'          # Push state to remote
alias tfsrm='terraform state rm'            # Remove resource from state
alias tfay='terraform apply -auto-approve'   # Quick apply
alias tfdy='terraform destroy -auto-approve' # Quick destroy
alias tfinu='terraform init -upgrade'        # Init with plugin upgrade
alias tfpde='terraform plan --destroy'       # Plan for destroy
