set fish_greeting "" 

#Sway autostart (TTY1)
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = "1"
        exec sway
    end
end

# Aliases
#alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Package management (paru)
alias clean='yay -Qtdq | yay -Rns -'     # orphan packages clean

# Fastfetch
fastfetch

# Starship
starship init fish | source

# Nvim
set -gx EDITOR nvim
set -gx VISUAL nvim
