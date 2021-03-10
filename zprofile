# -*- mode: sh -*-

if [[ -d "$HOME/.bin" ]]; then
  export PATH="$HOME/.bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ $OSTYPE == linux* && -d "$DOTFILES/local/bin" ]]; then
  export PATH="$DOTFILES/local/bin:$PATH"
fi

if [[ -d "$HOME/.doom-emacs.d/bin" ]]; then
  export PATH="$HOME/.doom-emacs.d/bin:$PATH"
fi

# java
if [[ -d "$HOME/.jenv/bin" ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init - zsh)"
fi

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# node
export PATH="$N_PREFIX/bin:$PATH"

# golang
export PATH="${GOPATH//://bin:}/bin:$PATH"

# gem for ruby
if [[ -d "$HOME/.gem/ruby/2.6.0/bin" ]]; then
  export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
elif [[ -d "$HOME/.gem/ruby/2.7.0/bin" ]]; then
  export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
elif [[ -d "/usr/local/lib/ruby/gems/2.6.0/bin" ]]; then
  export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
elif [[ -d "/usr/local/lib/ruby/gems/2.7.0/bin" ]]; then
  export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
fi

# other's path for macos
if [[ $OSTYPE == darwin* ]]; then
  if [[ -d "/usr/local/opt/openssl/bin" ]]; then
    export PATH="/usr/local/opt/openssl/bin:$PATH"
  fi

  if [[ -d "/usr/local/opt/ruby/bin" ]]; then
    export PATH="/usr/local/opt/ruby/bin:$PATH"
  fi

  if [[ -d "/usr/local/opt/gnu-indent/libexec/gnubin" ]]; then
    export PATH="/usr/local/opt/gnu-indent/libexec/gnubin:$PATH"
  fi

  if [[ -d "/usr/local/opt/gnu-tar/libexec/gnubin" ]]; then
    export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
  fi

  if [[ -d "/usr/local/opt/gnu-sed/libexec/gnubin" ]]; then
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  fi

  if [[ -d "/usr/local/opt/findutils/libexec/gnubin" ]]; then
    export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
  fi

  if [[ -d "/usr/local/opt/gawk/libexec/gnubin" ]]; then
    export PATH="/usr/local/opt/gawk/libexec/gnubin:$PATH"
  fi

  if [[ -d "/usr/local/opt/coreutils/libexec/gnubin" ]]; then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  fi
fi
