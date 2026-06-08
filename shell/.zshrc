# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sxntty/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ls='exa --icons --color=always'
alias tree='exa --icons --color=always -T'

eval "$(starship init zsh)"

export PATH=$PATH:/home/sxntty/.spicetify
export PATH=$PATH:$HOME/.spicetify

# Ejecutar fastfetch con logo aleatorio
~/.config/fastfetch/fastfetch_random.sh
