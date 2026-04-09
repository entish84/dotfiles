alias cat='batcat'

alias ls='eza -l --icons --group-directories-first'
alias ll='eza -lh --icons --git-ignore'
alias la='eza -lha --icons'
alias lt='eza --tree --icons'

# Yazi (File Manager) - Function to change directory on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Quality of Life
alias ..='cd ..'
alias ...='cd ../..'
alias cd='z'
alias grep='rg --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -vp'
alias lpath='echo -e ${PATH//:/\\n}'
alias q='exit'
alias c='clear'

# System Maintenance (Debian Specific)
alias aptupd='sudo apt update && sudo apt upgrade -y'
alias aptclean='sudo apt autoremove && sudo apt autoclean'
alias pkg-list='apt list --installed'
alias aptin='sudo apt install -y'
alias aptrm='sudo apt remove -y'
alias bashed="micro ~/.bashrc"
alias bashrl="source ~/.bashrc"

