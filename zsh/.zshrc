# ==============================================================================
# ENVIRONMENT VARIABLES & PATHS
# ==============================================================================
export LANG=en_US.UTF-8
export EDITOR=micro
export VISUAL=micro

# Ensure local binaries are in path
typeset -U path
path=(
    $HOME/.local/bin
    $HOME/bin
    $path
)

# ==============================================================================
# ZINIT INSTALLATION & BOOTSTRAP
# ==============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Load core annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ==============================================================================
# OH-MY-ZSH LIBRARIES & PLUGINS (Synchronous)
# ==============================================================================
# eza config (Must be set before loading plugin)
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes

zinit snippet OMZL::git.zsh
zinit snippet OMZL::history.zsh         
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZP::git
zinit snippet OMZP::direnv
zinit snippet OMZP::eza

# ==============================================================================
# HIGH-PERFORMANCE PLUGINS (Turbo Mode)
# ==============================================================================

# 1. Additional completions (Load first, but use blockf to prevent header issues)
zinit ice wait'0' lucid blockf
zinit light zsh-users/zsh-completions

# 2. Syntax Highlighting (The engine)
# Using '0a' to ensure it starts after completions
zinit ice wait'0a' lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# 3. fzf-tab (The UI for completions)
# Load after syntax highlighting to avoid conflict
zinit ice wait'0b' lucid
zinit light Aloxaf/fzf-tab

# 4. Autosuggestions (The top layer)
# Load last ('0c') to ensure it doesn't interfere with the others
zinit ice wait'0c' lucid atload"!_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# ==============================================================================
# FZF-TAB CONFIGURATION & PREVIEWS
# ==============================================================================
# 1. Standard Zsh completion styling
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 2. fzf-tab behavioral tweaks
# Switch groups using ',' and '.'
zstyle ':fzf-tab:*' switch-group ',' '.'
# Apply the suggested height limit for a cleaner UI
zstyle ':fzf-tab:*' fzf-flags '--height=40%'

# 3. Intelligent Previews
# Specific rule for 'cd' (uses eza for directory tree/list)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Faster fallback: check -d (directory) first to avoid launching a process that will fail
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'if [ -d $realpath ]; then eza -1 --color=always $realpath; else bat --color=always --line-range :500 $realpath 2>/dev/null; fi'

# 4. Bonus: System Process Preview (for kill/ps)
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# ==============================================================================
# TOOL INITIALIZATION
# ==============================================================================
# 1. Load Atuin Environment FIRST (so the 'atuin' command is found)
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# 2. Initialize tools
eval "$(starship init zsh)"
eval "$(/home/rs/.local/bin/mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

# ==============================================================================
# HISTORY SETTINGS
# ==============================================================================
HISTFILE=$HOME/.zhistory
SAVEHIST=100000
HISTSIZE=100000
setopt EXTENDED_HISTORY          # Save timestamp and duration
setopt SHARE_HISTORY             # Share between sessions
setopt HIST_IGNORE_ALL_DUPS      # No duplicates
setopt HIST_REDUCE_BLANKS        # Clean up commands

# ==============================================================================
# FUNCTIONS & ALIASES
# ==============================================================================
# Yazi wrapper for directory tracking on exit
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias fm=yy

# Source external aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# ==============================================================================
# INTEGRATIONS & FINAL SETUP
# ==============================================================================
# VSCode shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
