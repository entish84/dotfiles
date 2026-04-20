# ==============================================================================
# ENVIRONMENT VARIABLES & PATHS
# ==============================================================================
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim

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
    mkdir -p "$(dirname $ZINIT_HOME)"
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
zinit snippet OMZL::git.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# eza config (Must be set before loading plugin)
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes

zinit snippet OMZP::git
zinit snippet OMZP::direnv
zinit snippet OMZP::eza

# ==============================================================================
# HIGH-PERFORMANCE PLUGINS (Turbo Mode)
# ==============================================================================

# fzf-tab: Modern tab completion
zinit ice wait'0' lucid
zinit light Aloxaf/fzf-tab

# fast-syntax-highlighting: Use the correct internal Zinit function names
zinit ice wait'0b' lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# autosuggestions: Load after syntax highlighting
zinit ice wait'0c' lucid atload"!_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Additional completions for development tools
zinit ice wait'0' lucid blockf
zinit light zsh-users/zsh-completions

# ==============================================================================
# FZF-TAB CONFIGURATION & PREVIEWS
# ==============================================================================
# Disable default group descriptions to keep it clean
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group ',' '.'

# Previews using eza (directories) and bat (files)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --line-range :500 $realpath'

# ==============================================================================
# TOOL INITIALIZATION
# ==============================================================================
# 1. Load Atuin Environment FIRST (so the 'atuin' command is found)
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# 2. Initialize tools
eval "$(starship init zsh)"
eval "$(/home/rs/.local/bin/mise activate zsh)"
eval "$(zoxide init zsh)"

# 3. Initialize Atuin (now that it's in the PATH)
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

# ==============================================================================
# HISTORY SETTINGS
# ==============================================================================
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

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
alias vim=nvim
alias lg=lazygit

# Source external aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# ==============================================================================
# INTEGRATIONS & FINAL SETUP
# ==============================================================================
# VSCode shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Atuin environment
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# Clean up path duplicates
typeset -U PATH
