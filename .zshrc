# zsh configuration

function cmd_exists() {
    command -v "$1" &> /dev/null
}

ANTIGEN=$HOME/.antigen
DOTFILES=$HOME/.dotfiles

# configure antigen
declare -a ANTIGEN_CHECK_FILES
ANTIGEN_CHECK_FILES=($HOME/.zshrc $HOME/.zshrc.local)

# load antigen
declare ANTIGEN_FILE
if [[ $OSTYPE == darwin* ]]; then
    ANTIGEN_FILE=/usr/local/share/antigen/antigen.zsh
else
    if [[ -f "/etc/arch-release" ]]; then
        ANTIGEN_FILE=/usr/share/zsh/share/antigen.zsh
    else
        ANTIGEN_FILE=$ANTIGEN/antigen.zsh
    fi
fi

source $ANTIGEN_FILE

# load the oh-my-zsh's library
antigen use oh-my-zsh

# bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle git
antigen bundle gitfast
antigen bundle git-remote-branch
antigen bundle colored-man-pages
antigen bundle history
antigen bundle z
antigen bundle extract
antigen bundle encode64
antigen bundle web-search
antigen bundle urltools

if cmd_exists "tmux"; then
    antigen bundle tmux
    if [[ -n "$TERM" ]]; then
        ZSH_TMUX_FIXTERM_WITH_256COLOR="$TERM"
    fi
fi

if cmd_exists "docker"; then
    antigen bundle docker
fi

if cmd_exists "docker-compose"; then
    antigen bundle docker-compose
fi

if cmd_exists "docker-machine"; then
    antigen bundle docker-machine
fi

if [[ $OSTYPE == darwin* ]]; then
    if cmd_exists "brew"; then
        antigen bundle brew
    fi

    antigen bundle osx
else
    if cmd_exists "pacman"; then
        antigen bundle archlinux
    fi
fi

if cmd_exists "cargo"; then
    antigen bundle cargo
fi

if cmd_exists "python"; then
  antigen bundle djui/alias-tips
fi

# syntax highlighting
# antigen bundle zsh-users/zsh-syntax-highlighting
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp)
# ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
# ZSH_HIGHLIGHT_REGEXP+=('^#.*' 'fg=white')
antigen bundle zdharma/fast-syntax-highlighting

# auto suggestions
antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# auto pair
antigen bundle hlissner/zsh-autopair

# load theme
antigen theme romkatv/powerlevel10k

POWERLEVEL9K_MODE="nerdfont-complete"

POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\uF7C6 "

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir dir_writable vcs status)

# local customizations, e.g. theme, plugins, aliases, etc.
if [[ -f $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi

# tell antigen that you're done
antigen apply

# complete for nvm
if [[ -f "$NVM_DIR/bash_completion" ]]; then
    . "$NVM_DIR/bash_completion"
fi

# alias
if [[ $OSTYPE == darwin* ]]; then
    if cmd_exists "gls"; then
        alias ls='gls --color=tty --group-directories-first'
    fi
    if cmd_exists "brew"; then
        alias upgrade_antigen='brew update antigen'
    fi
    alias upgrade_oh_my_tmux='cd $HOME/.tmux && git pull; cd - >/dev/null'
else
    alias ls='ls --color=tty --group-directories-first'
    if cmd_exists "yay"; then
        alias upgrade_antigen='yay -S --noconfirm antigen-git'
    else
        alias upgrade_antigen='curl -fsSL https://raw.githubusercontent.com/zsh-users/antigen/develop/bin/antigen.zsh > $ANTIGEN/antigen.zsh.tmp && mv $ANTIGEN/antigen.zsh.tmp $ANTIGEN/antigen.zsh'
    fi
fi

alias goto_dotfiles='cd $DOTFILES'
alias upgrade_dotfiles='cd $DOTFILES && git pull; cd - >/dev/null'
alias upgrade_powerlevel10k='cd $ANTIGEN/bundles/romkatv/powerlevel10k && git pull; cd - >/dev/null'

if cmd_exists "emacsclient"; then
    alias e='emacsclient -a "" -n'
    alias ec='emacsclient -a "" -n -c'
    alias ef='emacsclient -a "" -c'
    alias te='emacsclient -a “” -nw'
fi
