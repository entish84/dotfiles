# ~/.config/blesh/init.sh

# --- SYNTAX HIGHLIGHTING ---
# Use a modern color palette compatible with Kitty
#ble-face -s syntax_command                fg=cyan,bold
#ble-face -s syntax_quoted                 fg=yellow
#ble-face -s syntax_error                  fg=white,bg=red
#ble-face -s auto_complete                 fg=242 # Dim grey suggestions

# --- AUTO-COMPLETION (Fish-style) ---
bleopt complete_auto_complete=1
bleopt complete_auto_history=1
bleopt complete_delay=150 # 150ms delay for snappiness

# --- INTEGRATIONS ---
# FZF Integration: Ensures fzf menus don't break the ble.sh UI
ble-import -d integration/fzf-completion
ble-import -d integration/fzf-key-bindings

# Bash-Completion: Improve standard tab completion
ble-import -d core-complete

# --- TERMINAL FEATURES ---
# Enable mouse support for scrolling through completion menus
bleopt input_encoding=utf8
