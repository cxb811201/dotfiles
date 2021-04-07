# -*- mode: sh -*-

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"
export DOTFILES=$HOME/.dotfiles

# editor
export EDITOR="vim"

# java
if [[ ! $OSTYPE == darwin* ]]; then
  export _JAVA_AWT_WM_NONREPARENTING=1
fi
export JAVA_OPTS="-XX:+UseNUMA -XX:+UseG1GC"

# sbt
export SBT_OPTS="-Xms2048m -Xmx2048m -XX:ReservedCodeCacheSize=256m -XX:MaxMetaspaceSize=512m -Dsbt.override.build.repos=true"

# brew
if [[ $OSTYPE == darwin* ]]; then
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

# rust
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"

# node
export N_NODE_MIRROR=https://npm.taobao.org/mirrors/node
export N_PREFIX="$HOME/.n"

# golang
export GO111MODULE=on
export GOPROXY="https://goproxy.cn,direct"
export GOPRIVATE="git.iobox.me"
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
if [[ $OSTYPE == darwin* && -d "/usr/local/opt/go/libexec" ]]; then
  export GOROOT="/usr/local/opt/go/libexec"
fi

# fix git-svn for macOS
if [[ $OSTYPE == darwin* && -d "/usr/local/opt/subversion/lib/perl5/site_perl" ]]; then
  local _dirs=($(ls "/usr/local/opt/subversion/lib/perl5/site_perl"))
  for _dir in "${_dirs[@]}"; do
    local _libdir="/usr/local/opt/subversion/lib/perl5/site_perl/${_dir}/darwin-thread-multi-2level"
    if [[ -d $_libdir ]]; then
      if [[ -z $PERL5LIB ]]; then
        export PERL5LIB="${_libdir}"
      else
        export PERL5LIB="${_libdir}:$PERL5LIB"
      fi
    fi
  done
fi
