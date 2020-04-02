#!/usr/bin/env bash

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

# shellcheck disable=SC1090
. "${BASE_DIR}/utils.sh"

# packages
packages=(
    neofetch
    tmux
    emacs
    ripgrep
    xsel
    urlview
    openbsd-netcat

    # monitor
    lm_sensors
    i2c-tools
    smartmontools
    hddtemp

    # input method
    fcitx5-git
    fcitx5-gtk-git
    fcitx5-qt5-git
    fcitx5-chinese-addons-git
    librime
    brise

    # font
    nerd-fonts-hack
    noto-fonts
    noto-fonts-cjk
    ttf-sarasa-gothic
    wqy-microhei

    # proxy
    privoxy
    v2ray
)

function check() {
    if ! yay_exists; then
        print_error_and_exit "yay is not installed"
    fi
}

function install() {
    for p in "${packages[@]}"; do
        print_info "installing ${p}..."
        yay -S --noconfirm "${p}"
    done
}

function main() {
    check
    install
}

main
