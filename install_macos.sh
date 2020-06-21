#!/usr/bin/env bash

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

# shellcheck disable=SC1090
. "${BASE_DIR}/utils.sh"

# packages
packages=(
    coreutils
    findutils
    gnu-tar
    gnu-sed
    gnu-indent
    gawk
    gnupg

    htop
    pwgen

    neofetch
    antigen
    git
    tmux
    aria2
    reattach-to-user-namespace
    ripgrep
    urlview
    editorconfig
    telnet
    tree
    tig
    fd
    fzf
    jq

    ranger
    highlight

    sbt
    coursier
    bloop

    go
    ruby
    protobuf

    shellcheck
)

function check() {
    if ! brew_exists; then
        print_error_and_exit "brew is not installed"
    fi
}

function install() {
    for p in "${packages[@]}"; do
        print_info "installing ${p}..."
        brew install "${p}"
    done
}

function main() {
    check
    install
}

main
