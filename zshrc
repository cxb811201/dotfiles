# -*- mode: sh -*-

source $DOTFILES/utils.sh

if [[ -z $INSIDE_EMACS && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && is_gui ; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zinit/bin/zinit.zsh

zinit light-mode for \
  is-snippet OMZ::lib/history.zsh \
  is-snippet OMZ::lib/key-bindings.zsh \
  MichaelAquilina/zsh-you-should-use

if [[ -z $INSIDE_EMACS ]] ; then
  zinit ice wait lucid atinit"
    zstyle :history-search-multi-word page-size 5
    zstyle :history-search-multi-word highlight-color fg=red,bold
    zstyle :plugin:history-search-multi-word reset-prompt-protect 1"
  zinit light zdharma/history-search-multi-word
fi

zinit wait lucid for \
 atinit"ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'; ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions \
 as"completion" is-snippet \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
    https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose

zinit ice wait lucid from"gh" depth=1
zinit light-mode lucid for \
  hlissner/zsh-autopair \
  ajeetdsouza/zoxide \
  load"command -v fzf &> /dev/null" \
  Aloxaf/fzf-tab \
  mdumitru/git-aliases

# snippet
zinit ice atinit"ZSH_TMUX_FIXTERM=false"
zinit snippet OMZ::plugins/tmux/tmux.plugin.zsh
if brew_exists ; then
   zinit snippet OMZ::plugins/brew/brew.plugin.zsh
fi
zinit snippet OMZ::plugins/web-search/web-search.plugin.zsh

if [[ -z $INSIDE_EMACS ]] && is_gui ; then
  zinit ice from"gh" depth=1
  zinit light romkatv/powerlevel10k
else
  if ! is_gui ; then
    PURE_PROMPT_SYMBOL=">"
  fi
  zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
  zinit light sindresorhus/pure
fi

zinit ice wait lucid as"program" from"gh-r" \
  mv"exa* -> exa" pick"exa/exa" lucid \
  atload"
    alias ls='exa --group-directories-first'
    alias l='exa --group-directories-first -laH'
    alias ll='exa --group-directories-first -lH'"
zinit light ogham/exa

# complete for ssh_host
function _all_ssh_host() {
  local _known_hosts=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })
  local _conf_hosts=()
  if [[ -f "$HOME/.ssh/config" ]]; then
    _conf_hosts=($(egrep '^Host.*' $HOME/.ssh/config | awk '{print $2}' | grep -v '^*' | sed -e 's/\.*\*$//'))
  fi

  local _hosts=("$_known_hosts[@]" "$_conf_hosts[@]")

  echo ${(u)_hosts}
}

zstyle -e ':completion:*:hosts' hosts 'reply=($(_all_ssh_host))'

if [[ -n $INSIDE_EMACS || -n $TMUX ]] && cmd_exists "jenv" ; then
  export PATH=${PATH//$HOME\/.jenv\/shims:}
  eval "$(jenv init - zsh)"
fi

alias tailf="tail -f"
alias t="tail -f"

alias goto_dotfiles='cd $DOTFILES'
alias upgrade_dotfiles='cd $DOTFILES && git pull; cd - >/dev/null'
alias upgrade_oh_my_tmux='cd $HOME/.tmux && git pull; cd - >/dev/null'

if cmd_exists "emacsclient"; then
  [[ -z $EDITOR ]] && export EDITOR='emacsclient -a "emacs"'
  alias e="$EDITOR -n"
  alias ec="$EDITOR -n -c"
  alias ef="$EDITOR -c"
  alias te="$EDITOR -a '' -nw"
fi

if cmd_exists "node"; then
  alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'
  alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'
fi

if cmd_exists "md5-cli"; then
  alias md5="md5-cli"
fi

function encode64() {
    if [[ $# -eq 0 ]]; then
        cat | base64
    else
        printf '%s' $1 | base64
    fi
}

function decode64() {
    if [[ $# -eq 0 ]]; then
        cat | base64 --decode
    else
        printf '%s' $1 | base64 --decode
    fi
}
alias e64=encode64
alias d64=decode64

# show system info
if cmd_exists "neofetch" && is_gui ; then
    neofetch
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [[ -z $INSIDE_EMACS ]] && is_gui ; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
