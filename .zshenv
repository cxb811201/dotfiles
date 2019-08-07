export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export JAVA_OPTS="-XX:+UseNUMA -XX:+UseG1GC"
export SBT_OPTS="-Xms2048m -Xmx2048m -XX:ReservedCodeCacheSize=256m -XX:MaxMetaspaceSize=512m -Dsbt.override.build.repos=true"

if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# brew
if [[ $OSTYPE == darwin* ]]; then
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
    export HOMEBREW_GITHUB_API_TOKEN="257876059321209bf5add4b877dd695ebf9d1d48"
fi

# rust
export RUSTUP_DIST_SERVER="https://mirrors.sjtug.sjtu.edu.cn/rust-static"
export RUSTUP_UPDATE_ROOT="https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup"

# nvm
export NVM_DIR="$HOME/.nvm"

# editor
if command -v "emacsclient" &> /dev/null; then
    export EDITOR='emacsclient -a "" -c'
else
    export EDITOR="vim"
fi

# metals
export METALS_ENABLED="true"

# golang
export GO111MODULE=on
export GOPROXY="https://goproxy.io"
export GOPATH="$HOME/Projects/go"
if [[ $OSTYPE == darwin* ]]; then
    export GOROOT="/usr/local/opt/go/libexec"
fi
export PATH="${GOPATH//://bin:}/bin:$PATH"

# gem for ruby
if [[ -d "$HOME/.gem/ruby/2.6.0/bin" ]]; then
    export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
elif [[ -d "/usr/local/lib/ruby/gems/2.6.0/bin" ]]; then
     export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
fi
