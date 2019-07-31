#!/usr/bin/env bash

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

. "${BASE_DIR}/utils.sh"

# packages
packages=(
    neofetch
    tmux
    emacs
    ripgrep
    the_silver_searcher
    xsel
    urlview

    # font
    nerd-fonts-hack
    powerline-fonts-git
    wqy-zenhei
)

function check() {
    if ! yay_exists; then
        print_error_and_exit "yay is not installed"
    fi
}

function install() {
    for p in ${packages[@]}; do
        print_info "installing ${p}..."
        yay -S --noconfirm ${p}
    done
}

function main() {
    check
    install
}

main
