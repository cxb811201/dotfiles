export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"

# editor
if command -v "emacsclient" &> /dev/null; then
    export EDITOR='emacsclient -a "emacs"'
else
    export EDITOR="vim"
fi

if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/.emacs.d/bin" ]]; then
    export PATH="$HOME/.emacs.d/bin:$PATH"
fi

# java
if [[ -d "$HOME/.jenv/bin" ]]; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init - zsh)"
fi
export JAVA_OPTS="-XX:+UseNUMA -XX:+UseG1GC"
export SBT_OPTS="-Xms2048m -Xmx2048m -XX:ReservedCodeCacheSize=256m -XX:MaxMetaspaceSize=512m -Dsbt.override.build.repos=true"

# coursier
export COURSIER_REPOSITORIES="ivy2Local|https://mirrors.cloud.tencent.com/nexus/repository/maven-public|central|sonatype:releases"

# brew
if [[ $OSTYPE == darwin* ]]; then
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
fi

# rust
export RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"
if [[ -d "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# nvm
export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/mirrors/node"
export NVM_DIR="$HOME/.nvm"
if [[ -f "$NVM_DIR/nvm.sh" ]]; then
    . "$NVM_DIR/nvm.sh"
fi

# golang
export GO111MODULE=on
export GOPROXY="https://goproxy.cn,direct"
export GOPRIVATE="git.iobox.me"
export GOPATH="$HOME/.go"
if [[ $OSTYPE == darwin* ]]; then
    if [[ -d "/usr/local/opt/go/libexec" ]]; then
        export GOROOT="/usr/local/opt/go/libexec"
    fi
fi
export PATH="${GOPATH//://bin:}/bin:$PATH"

# gem for ruby
if [[ -d "$HOME/.gem/ruby/2.6.0/bin" ]]; then
    export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
elif [[ -d "/usr/local/lib/ruby/gems/2.6.0/bin" ]]; then
     export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
fi

# other's path for macos
if [[ $OSTYPE == darwin* ]]; then
    if [[ -d "/usr/local/opt/openssl/bin" ]]; then
        export PATH="/usr/local/opt/openssl/bin:$PATH"
    fi

    if [[ -d "/usr/local/opt/gnu-tar/libexec/gnubin" ]]; then
        export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
    fi

    if [[ -d "/usr/local/opt/coreutils/libexec/gnubin" ]]; then
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    fi
fi
