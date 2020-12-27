# -*- mode: sh -*-

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"
export DOTFILES=$HOME/.dotfiles

# editor
if command -v "emacsclient" &> /dev/null; then
    export EDITOR='emacsclient -a "emacs"'
else
    export EDITOR="vim"
fi

# java
export JAVA_OPTS="-XX:+UseNUMA -XX:+UseG1GC"

# sbt
export SBT_OPTS="-Xms2048m -Xmx2048m -XX:ReservedCodeCacheSize=256m -XX:MaxMetaspaceSize=512m -Dsbt.override.build.repos=true"

# brew
if [[ $OSTYPE == darwin* ]]; then
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
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
if [[ $OSTYPE == darwin* ]]; then
    if [[ -d "/usr/local/opt/go/libexec" ]]; then
        export GOROOT="/usr/local/opt/go/libexec"
    fi
fi
