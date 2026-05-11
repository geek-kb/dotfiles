# Zsh Shortcuts & Aliases Cheat Sheet

A comprehensive reference for aliases, functions, and keybindings configured in `zsh/zsh.d/`.

---

## 🛠️ Core Command Overrides

| Alias    | Expands To                              | Description                            |
| -------- | --------------------------------------- | -------------------------------------- |
| `rm`     | `rm -i`                                 | Interactive — prompt before deletion   |
| `cp`     | `cp -i`                                 | Interactive — prompt before overwrite  |
| `mv`     | `mv -i`                                 | Interactive — prompt before overwrite  |
| `sed`    | `gsed`                                  | GNU sed instead of BSD                 |
| `grep`   | `ggrep` (with color + exclude-dir)      | GNU grep instead of BSD                |
| `sort`   | `gsort`                                 | GNU sort instead of BSD                |
| `awk`    | `gawk`                                  | GNU awk instead of BSD                 |
| `cat`    | `bat --style=plain --paging=never`      | Syntax-highlighted cat                 |
| `s`      | `source`                                | Quick source                           |
| `pbc`    | `pbcopy`                                | Quick clipboard copy                   |
| `diff`   | `/usr/bin/diff --color`                 | Colored diff output                    |
| `watch`  | `watch --color`                         | Color-enabled watch                    |

---

## 📁 File Navigation & Listing

| Alias    | Expands To                                          | Description                          |
| -------- | --------------------------------------------------- | ------------------------------------ |
| `ls`     | `eza --icons`                                       | Modern ls with icons                 |
| `ll`     | `eza -la --git --icons --group-directories-first`   | Long listing w/ git status           |
| `lt`     | `eza --tree --icons`                                | Tree view                            |
| `zl`     | `zoxide query --list`                               | List zoxide directory history        |

---

## ✍️ Editor (Neovim)

| Alias        | Expands To                          | Description                       |
| ------------ | ----------------------------------- | --------------------------------- |
| `vim`        | `nvim`                              | Use neovim instead of vim         |
| `v`          | `nvim`                              | Quick neovim shortcut             |
| `vi`         | `nvim`                              | Use neovim for vi                 |
| `vsrc`       | `nvim ~/src`                        | Open neovim in source directory   |
| `sudoedit`   | `nvim`                              | Use neovim for sudo editing       |
| `lvim`       | `NVIM_APPNAME=LazyVim nvim`         | Launch LazyVim configuration      |
| `zshrc`      | `$EDITOR ~/.zshrc`                  | Edit zsh config file              |

### File-type associations (open file directly by typing its name)

| Extension                   | Opens With |
| --------------------------- | ---------- |
| `.lua .yml .yaml .json .txt` | `nvim`     |
| `.md`                       | `glow`     |

---

## 🧾 Git Aliases

| Alias                  | Description                                                   |
| ---------------------- | ------------------------------------------------------------- |
| `gs`                   | `git status`                                                  |
| `git_current_branch`   | Show current git branch                                       |
| `gb`                   | Interactive branch selector via fzf, then checkout            |
| `gaM`                  | Add all modified files (`git diff --name-only \| xargs git add`) |
| `gCM`                  | Commit staged files with auto-generated message               |
| `gCMP`                 | Same as `gCM` then `git push`                                 |

---

## 🌐 Global Aliases (Pipe Operations)

Use these mid-pipeline — they expand anywhere on the line.

### Loop controls

| Alias  | Expands To                                  | Description                  |
| ------ | ------------------------------------------- | ---------------------------- |
| `Wt`   | `while :;do `                               | Start infinite while loop    |
| `Wr`   | ` \| while read -r line;do echo "=== $line ===";` | Read line-by-line w/ echo    |
| `D`    | `;done`                                     | Close loop                   |

### Text processing

| Alias       | Description                                |
| ----------- | ------------------------------------------ |
| `H`         | `\| head` (first lines)                    |
| `T`         | `\| tail` (last lines)                     |
| `G`         | `\| grep -i` (case-insensitive filter)     |
| `L`         | `\| less` (paginate)                       |
| `P`         | `\| pbcopy` (copy to clipboard)            |
| `V`         | `\| nvim` (edit in nvim)                   |
| `S`         | `\| sort`                                  |
| `NE`        | `2> /dev/null` (suppress errors)           |
| `NUL`       | `> /dev/null 2>&1` (suppress all output)   |
| `dollar1`   | `$(awk '{print $1}'<<<"${line}")`          |
| `dollar2`   | `$(awk '{print $2}'<<<"${line}")`          |

### Kubernetes pipe helpers

| Alias       | Description                                          |
| ----------- | ---------------------------------------------------- |
| `Sa` / `Srt` | `--sort-by=.metadata.creationTimestamp`             |
| `SECRET`    | Decode secret data from base64                       |
| `IMG`       | Extract unique images from yaml                      |
| `YML`       | View yaml output in vim (`q` to quit)                |
| `NM`        | Names-only (`--no-headers -o custom-columns=:metadata.name`) |
| `RC`        | Sort pods by restart count, hide zero-restart        |
| `BAD`       | Filter out healthy pods                              |
| `IP`        | Get node name from pod (`-ojsonpath={.spec.nodeName}`) |
| `SRT`       | `+short \| sort` (DNS-style queries)                 |

### Other

| Alias    | Description                              |
| -------- | ---------------------------------------- |
| `snyka`  | Authenticate with Snyk using PAT         |

---

## ☸️ Kubernetes (kubectl)

### Core

| Alias  | Expands To                       | Description                       |
| ------ | -------------------------------- | --------------------------------- |
| `k`    | `kubectl`                        | Main shortcut                     |
| `kca`  | `kubectl … --all-namespaces`     | Run command across all namespaces |
| `kg`   | `kubectl get `                   | Quick get                         |
| `kd`   | `kubectl describe `              | Quick describe                    |
| `ke`   | `kubectl edit `                  | Quick edit                        |
| `kdel` | `kubectl delete`                 | Quick delete                      |
| `kaf`  | `kubectl apply -f`               | Apply yaml                        |
| `krf`  | `kubectl replace -f`             | Replace yaml                      |
| `kdelf`| `kubectl delete -f`              | Delete from yaml                  |
| `keti` | `kubectl exec -t -i`             | Interactive exec into a container |
| `kpf`  | `kubectl port-forward`           | Port-forward                      |
| `kcp`  | `kubectl cp`                     | File copy                         |
| `kafd` | `kubectl apply --dry-run=true -f -` | Dry-run apply from stdin       |
| `cinfo`| `kubectl cluster-info`           | Display cluster info              |

### Contexts & namespaces

| Alias       | Description                                    |
| ----------- | ---------------------------------------------- |
| `kcuc`      | Use context                                    |
| `kcsc`      | Set context properties                         |
| `kcdc`      | Delete context                                 |
| `kccc`      | Show current context                           |
| `kcgc`      | Get contexts                                   |
| `kctx`/`ctx`| `kubectx` — fast context switch                |
| `kns`       | `kubens` — fast namespace switch               |
| `kcn`       | Set default namespace for current context      |

### Pods

| Alias       | Description                                    |
| ----------- | ---------------------------------------------- |
| `kgp`       | Get pods                                       |
| `kgpa`      | Get pods in all namespaces                     |
| `kgpw`      | Watch pods                                     |
| `kgpwide`   | Get pods (wide output)                         |
| `kgpsl`     | Get pods with labels                           |
| `kgpl`      | Get pods by label (`kgp -l ...`)               |
| `kgpn`      | Get pods in namespace (`kgp -n ...`)           |
| `kgpall`    | Get all pods (all namespaces, wide)            |
| `kep`       | Edit pods                                      |
| `kdp`       | Describe pods                                  |
| `kdelp`     | Delete pods                                    |

### Services / Ingress

| Alias    | Description                  |
| -------- | ---------------------------- |
| `kgs`    | Get services                 |
| `kgsa`   | Get services (all namespaces)|
| `kgsw`   | Watch services               |
| `kgswide`| Get services (wide)          |
| `kes`    | Edit service                 |
| `kds`    | Describe service             |
| `kdels`  | Delete service               |
| `kgi`    | Get ingress                  |
| `kgia`   | Get ingress (all namespaces) |
| `kei`    | Edit ingress                 |
| `kdi`    | Describe ingress             |
| `kdeli`  | Delete ingress               |

### Workloads (deployments, statefulsets, replicasets, daemonsets)

| Alias    | Description                          |
| -------- | ------------------------------------ |
| `kgd`    | Get deployments                      |
| `kgda`   | Get deployments (all namespaces)     |
| `kgdw`   | Watch deployments                    |
| `kgdwide`| Get deployments (wide)               |
| `ked`    | Edit deployment                      |
| `kdd`    | Describe deployment                  |
| `kdeld`  | Delete deployment                    |
| `ksd`    | Scale deployment                     |
| `krsd`   | Rollout status deployment            |
| `kgss`   | Get statefulsets                     |
| `kess`   | Edit statefulset                     |
| `kdss`   | Describe statefulset                 |
| `kdelss` | Delete statefulset                   |
| `ksss`   | Scale statefulset                    |
| `krsss`  | Rollout status statefulset           |
| `kgrs`   | Get replicasets                      |
| `kdrs`   | Describe replicaset                  |
| `kers`   | Edit replicaset                      |
| `kdelrs` | Delete replicaset                    |
| `krh`    | Rollout history                      |
| `kru`    | Rollout undo                         |
| `krs`    | Rollout restart                      |
| `kgds`   | Get daemonsets                       |
| `kgdsa`  | Get daemonsets (all namespaces)      |
| `keds`   | Edit daemonset                       |
| `kdds`   | Describe daemonset                   |
| `kdelds` | Delete daemonset                     |

### Jobs & CronJobs

| Alias    | Description       |
| -------- | ----------------- |
| `kgj`    | Get jobs          |
| `kej`    | Edit job          |
| `kdj`    | Describe job      |
| `kdelj`  | Delete job        |
| `kgcj`   | Get cronjobs      |
| `kecj`   | Edit cronjob      |
| `kdcj`   | Describe cronjob  |
| `kdelcj` | Delete cronjob    |

### ConfigMaps / Secrets

| Alias     | Description                       |
| --------- | --------------------------------- |
| `kgcm`    | Get configmaps                    |
| `kgcma`   | Get configmaps (all namespaces)   |
| `kecm`    | Edit configmap                    |
| `kdcm`    | Describe configmap                |
| `kdelcm`  | Delete configmap                  |
| `kgsec`   | Get secrets                       |
| `kgseca`  | Get secrets (all namespaces)      |
| `kesec`   | Edit secret                       |
| `kdsec`   | Describe secret                   |
| `kdelsec` | Delete secret                     |

### Storage (PVC / PV)

| Alias    | Description              |
| -------- | ------------------------ |
| `kgpvc`  | Get PVCs                 |
| `kgpvca` | Get PVCs (all namespaces)|
| `kgpvcw` | Watch PVCs               |
| `kepvc`  | Edit PVC                 |
| `kdpvc`  | Describe PVC             |
| `kdelpvc`| Delete PVC               |
| `kgpv`   | Get persistent volumes   |
| `kdpv`   | Describe PV              |
| `kepv`   | Edit PV                  |
| `kdelpv` | Delete PV                |

### Nodes / Top / Misc

| Alias        | Description                                    |
| ------------ | ---------------------------------------------- |
| `kgno`       | Get nodes                                      |
| `kgnosl`     | Get nodes with labels                          |
| `kgnol`      | Get nodes by label (`kgno -l ...`)             |
| `keno`       | Edit node                                      |
| `kdno`       | Describe node                                  |
| `kdelno`     | Delete node                                    |
| `kmem`       | Top nodes sorted by memory                     |
| `kcpu`       | Top nodes sorted by CPU                        |
| `ktn`        | Top nodes                                      |
| `ktp`        | Top pods                                       |
| `kga`        | Get all resources                              |
| `kgaa`       | Get all resources (all namespaces)             |
| `kgns`       | Get namespaces                                 |
| `kens`       | Edit namespace                                 |
| `kdns`       | Describe namespace                             |
| `kdelns`     | Delete namespace                               |
| `kdsa`       | Describe service account                       |
| `kdelsa`     | Delete service account                         |
| `kgevents`   | Filtered kubernetes events (sorted, noise-free)|
| `kgdns`      | List all external DNS hostnames                |
| `k8s`        | Open nvim with `kubectl.nvim` plugin           |

### Logs

| Alias     | Description                       |
| --------- | --------------------------------- |
| `kl`      | Logs                              |
| `kl1h`    | Logs from last hour               |
| `kl1m`    | Logs from last minute             |
| `kl1s`    | Logs from last second             |
| `klf`     | Follow logs                       |
| `klf1h`   | Follow logs (last hour onwards)   |
| `klf1m`   | Follow logs (last minute onwards) |
| `klf1s`   | Follow logs (last second onwards) |

---

## 🌍 Terraform

| Alias    | Expands To                          | Description                  |
| -------- | ----------------------------------- | ---------------------------- |
| `tf`     | `terraform`                         | Main shortcut                |
| `tfa`    | `terraform apply`                   | Apply changes                |
| `tfae`   | `terraform apply -auto-approve`     | Apply without confirmation   |
| `tfay`   | `terraform apply -auto-approve`     | Quick apply                  |
| `tfc`    | `terraform console`                 | Open terraform console       |
| `tfd`    | `terraform destroy`                 | Destroy infrastructure       |
| `tfdy`   | `terraform destroy -auto-approve`   | Quick destroy                |
| `tff`    | `terraform fmt`                     | Format files                 |
| `tfg`    | `terraform graph`                   | Generate dependency graph    |
| `tfim`   | `terraform import`                  | Import existing resources    |
| `tfin`   | `terraform init`                    | Initialize directory         |
| `tfinu`  | `terraform init -upgrade`           | Init with plugin upgrade     |
| `tfo`    | `terraform output`                  | Show outputs                 |
| `tfp`    | `terraform plan`                    | Generate execution plan      |
| `tfpde`  | `terraform plan --destroy`          | Plan for destroy             |
| `tfpr`   | `terraform providers`               | Show providers               |
| `tfr`    | `terraform refresh`                 | Refresh state                |
| `tfsh`   | `terraform show`                    | Show current state           |
| `tft`    | `terraform taint`                   | Mark resource for recreation |
| `tfut`   | `terraform untaint`                 | Remove taint from resource   |
| `tfv`    | `terraform validate`                | Validate configuration       |
| `tfffu`  | `terraform force-unlock`            | Force unlock state           |
| `tfw`    | `terraform workspace`               | Workspace management         |
| `tfwls`  | `terraform workspace list`          | List workspaces              |
| `tfwst`  | `terraform workspace select`        | Select workspace             |
| `tfwsw`  | `terraform workspace show`          | Show current workspace       |
| `tfwnw`  | `terraform workspace new`           | Create new workspace         |
| `tfwde`  | `terraform workspace delete`        | Delete workspace             |
| `tfs`    | `terraform state`                   | State management             |
| `tfsl`   | `terraform state list`              | List resources in state      |
| `tfss`   | `terraform state show`              | Show resource in state       |
| `tfsmv`  | `terraform state mv`                | Move resource in state       |
| `tfsrm`  | `terraform state rm`                | Remove resource from state   |
| `tfspl`  | `terraform state pull`              | Pull remote state            |
| `tfsph`  | `terraform state push`              | Push state to remote         |

---

## 🔍 fzf Functions

| Function                | Description                                                |
| ----------------------- | ---------------------------------------------------------- |
| `vf`                    | Fuzzy-find file w/ bat preview, then open in nvim          |
| `fdf <dir>`             | Fuzzy-find subdirectory, cd into it, open nvim             |
| `fzf-rm`                | Multi-select files via fzf, then rm                        |
| `fzf-man`               | Fuzzy-select a man page (with preview); plain `man <name>` still works |
| `fzf-eval <cmd>`        | Live-preview command output as you edit it                 |
| `fzf-aliases-functions` | Pick an alias or function via fzf, then eval it            |
| `fzf-git-status`        | Pick changed file from git status, open in `$EDITOR`       |
| `mkdp`                  | Fuzzy-find a pod, then describe it                         |
| `mklf [substr]`         | Fuzzy-find deployment/statefulset → pod → time range → tail logs |

### fzf environment

| Variable             | Description                                                |
| -------------------- | ---------------------------------------------------------- |
| `FZF_CTRL_T_COMMAND` | `rg --files --hidden --follow -g "!.git"`                  |
| `FZF_CTRL_T_OPTS`    | bat preview with line numbers + change markers             |
| `FZF_CTRL_R_OPTS`    | History search with command preview (bind `Ctrl-/` to toggle preview) |

---

## 🐳 Docker Functions

| Function                              | Description                                         |
| ------------------------------------- | --------------------------------------------------- |
| `docker_build [args...]`              | `docker build .` for `linux/amd64`                  |
| `docker_build_push [args...]`         | Same as above + `--push`                            |
| `docker_copy_between_regions -n NAME -t TAG -s SRC -d DEST` | Copy ECR image between AWS regions   |

---

## 🚀 Kubernetes Functions

| Function                | Description                                                  |
| ----------------------- | ------------------------------------------------------------ |
| `kdpw <pod>`            | Watch `kubectl describe` of a pod (auto-trimmed to terminal) |
| `kgres [pod/...]`       | Tabulated pod resource requests/limits (memory + cpu)        |
| `kgel <pod>`            | Get pod labels in `key=value` format                         |
| `kres <kind>/<name>`    | Restart a deployment/statefulset by bumping `REFRESHED_AT`   |
| `kubedebug [opts]`      | Spawn a debug pod (`mosheavni/net-debug`) — `-h` for help    |
| `get_pods_of_svc <svc>` | List pods backing a Kubernetes service                       |
| `asdf-kubectl-version`  | Auto-install + switch kubectl to match cluster version       |

### Cluster Web UIs (open + copy creds to clipboard)

| Function          | Description                                            |
| ----------------- | ------------------------------------------------------ |
| `grafana_web`     | Open Grafana ingress, copy admin password              |
| `cerebro_web`     | Open Cerebro (Elasticsearch UI)                        |
| `kibana_web`      | Open Kibana, copy elastic user password                |
| `argocd_web [-f]` | Open ArgoCD; `-f` port-forwards instead of ingress     |
| `argocd_login`    | `argocd login` using credentials pulled from cluster   |

---

## 🌿 Git Functions

| Function       | Description                                                       |
| -------------- | ----------------------------------------------------------------- |
| `clone <url>`  | cd to `~/src`, `git clone`, cd into repo, open nvim               |
| `gitcd`        | cd to the root of the current git repo                            |
| `opengit`      | Open the current repo's GitHub/GitLab page in browser             |
| `cpr`          | Open the create-PR/MR page for the current branch in browser      |
| `gurl <path>`  | Extract the repo name from a local repo's remote URL              |
| `gcM <msg...>` | `git commit -m "<msg>"` (with arg validation)                     |

---

## 🔧 General Utility Functions

| Function           | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| `take <dir>`       | `mkdir -p <dir>` and `cd` into it                            |
| `delete-zcompdump` | Wipe all zcompdump cache files (forces regeneration)         |
| `say-hebrew [text]`| macOS `say` with Hebrew voice (Carmit); dialog prompt if no arg |
| `set-tab-title`    | Set the terminal tab title (dialog prompt)                   |
| `mwatch <cmd>`     | `watch` that pre-resolves aliases recursively                |
| `ssh2 <ip-x-x-x-x>`| SSH to AWS EC2 by converting `ip-x-x-x-x` to a real IP       |
| `grl <pattern>`    | `grep -rl <pattern> .` (recursive, list filenames only)      |
| `cnf <command>`    | Open command-not-found.com for `<command>`                   |
| `lns <text>`       | Lowercase + strip spaces (slug-style)                        |
| `zip-code`         | Fetch Israeli zip code for Tel Aviv Florentin 2 → clipboard  |
| `matrix`           | Matrix-style falling-character terminal animation            |
| `man <topic>`      | Colorized man pages (custom LESS_TERMCAP_* colors)           |
| `nvim-startuptime` | Run nvim with `--startuptime startuptime.txt`                |
| `run_pre_commit`   | Loop `pre-commit run` until all checks pass                  |
| `asdf_install`     | Install every plugin + version from `~/.dotfiles/asdf/.tool-versions` |
| `sso`              | Source AWS SSO switcher script                               |

---

## 🌐 Network & System Aliases

| Alias       | Description                                |
| ----------- | ------------------------------------------ |
| `myip`      | Get public IP (curl ipv4.icanhazip.com)    |
| `server`    | Quick HTTP server on port 3030             |
| `cwd`       | Print current directory name only          |
| `update-nvim-nightly` | Reinstall asdf neovim nightly      |

---

## 🗂️ Personal Navigation Aliases

| Alias      | Goes To                                                     |
| ---------- | ----------------------------------------------------------- |
| `cl`       | `~/src/devops-candidate-core/terraform`                     |
| `go-dev`   | `~/src/devops-argo-apps-gitops-dev/aws/eu-west-1/pynr-eu-west-1`  |
| `go-qa`    | `~/src/devops-argo-apps-gitops-qa/aws/eu-west-1/pynr-eu-west-1`   |
| `go-sre`   | `~/src/devops-argo-apps-gitops-sre-playground/aws/eu-west-1/pynr-eu-west-1` |
| `go-sb`    | `~/src/devops-argo-apps-gitops-sandbox/aws/eu-west-1/pynr-eu-west-1` |
| `go-prod`  | `~/src/devops-argo-apps-gitops-prod/aws/eu-west-1/pynr-eu-west-1`   |
| `ws`       | `~/src/vscode_workspaces/`                                  |
| `k8ssec`   | `~/src/k8s_security`                                        |
| `oncall`   | `~/src/professional_work/payoneer/oncall`                   |

---

## 📜 History

| Setting / Alias      | Description                                            |
| -------------------- | ------------------------------------------------------ |
| `HISTSIZE=10000`     | Max events in memory                                   |
| `SAVEHIST=10000`     | Max events saved to disk                               |
| `APPEND_HISTORY`     | Append (don't overwrite) history file                  |
| `EXTENDED_HISTORY`   | `:start:elapsed;command` format                        |
| `HIST_IGNORE_ALL_DUPS`| Drop previous duplicate when new dup is added         |
| `HIST_IGNORE_DUPS`   | Don't record consecutive duplicates                    |
| `HIST_IGNORE_SPACE`  | Don't record commands starting with a space            |
| `HIST_EXPIRE_DUPS_FIRST` | Drop duplicates first when trimming                |
| `HIST_FIND_NO_DUPS`  | Don't show already-found events while searching        |
| `HIST_VERIFY`        | Don't execute history expansion immediately            |
| `INC_APPEND_HISTORY` | Write to file as commands run, not on exit             |
| `SHARE_HISTORY`      | Share history across all sessions                      |
| `history-stat`       | Top 50 most-used commands from history                 |

---

## ⌨️ Keybindings

| Key       | Action                                              |
| --------- | --------------------------------------------------- |
| `Ctrl-Q`  | Push current line to buffer stack (run another cmd) |
| `Ctrl-Y`  | Copy current command line to clipboard              |
| `Ctrl-R`  | fzf history search (with command preview)           |
| `Ctrl-T`  | fzf file picker (with bat preview)                  |
| `Alt-\`   | gh-copilot suggest                                  |
| `Alt-Shift-\` | gh-copilot explain                              |

---

## ⚙️ Zsh Options

| Option                 | Description                                       |
| ---------------------- | ------------------------------------------------- |
| `autocd`               | cd by typing a directory name                     |
| `menu_complete`        | Auto-select first completion match                |
| `unsetopt auto_menu`   | Don't cycle completions on repeated tab           |
| `unsetopt case_glob`   | Case-insensitive globbing                         |
| `glob_complete`        | Show completion menu for glob patterns            |
| `multios`              | Redirect to multiple streams: `echo >f1 >f2`      |
| `long_list_jobs`       | Long-form job notifications                       |
| `interactivecomments`  | Allow `#` comments in interactive shell           |
| `complete_in_word`     | Complete from both ends of a word                 |
| `WORDCHARS=""`         | `/` is a word boundary (better word nav)          |

---

## 🧠 Completions

Tab completion is wired up via `completions.zsh`:

| Tool        | Source                                |
| ----------- | ------------------------------------- |
| terraform   | native (`complete -C terraform`)      |
| terragrunt  | native                                |
| aws         | `aws_completer`                       |
| docker      | `docker completion zsh` (cached)      |
| kubectl     | `kubectl completion zsh` (cached)     |
| helm        | `helm completion zsh` (cached)        |
| asdf        | `asdf completion zsh` (cached)        |
| gh          | `gh completion --shell zsh` (cached)  |
| argocd      | `argocd completion zsh` (cached)      |
| wezterm     | `wezterm shell-completion` (cached)   |
| op          | `op completion zsh` (cached)          |
| confluent   | bundled `_confluent` function         |

Behavior:
- `menu select` — interactive menu for completions
- `_complete _prefix _match _approximate` — completion strategies
- Up to 3 errors allowed in approximate matching

---

## 🖥️ Terminal & Tab Titles

- `TERM=xterm-256color`
- WezTerm shell integration sourced if present
- Tab title auto-updates:
  - At prompt: `zsh: <15-char left-truncated cwd>`
  - During command: `<cmd>: <15-char left-truncated cwd>`

---

## 🐢 Lazy Loading

- **NVM**: `nvm`, `node`, `npm`, `npx` are placeholders that source NVM on first use (keeps shell startup fast).
- **Grep aliases**: Cached in `$ZSH_CACHE_DIR/grep-alias` (refreshed daily).

---

This cheat sheet was generated from the actual zsh configuration in `zsh/zsh.d/`.
