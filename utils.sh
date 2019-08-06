#!/usr/bin/env bash

# Use colors, but only if connected to a terminal, and that terminal supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1 2> /dev/null)"
    GREEN="$(tput setaf 2 2> /dev/null)"
    YELLOW="$(tput setaf 3 2> /dev/null)"
    BLUE="$(tput setaf 4 2> /dev/null)"
    PURPLE="$(tput setaf 5 2> /dev/null)"
    BOLD="$(tput bold 2> /dev/null)"
    NORMAL="$(tput sgr0 2> /dev/null)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    PURPLE=""
    BOLD=""
    NORMAL=""
fi

function print_in_color() {
    printf "%b" \
        "$2" \
        "$1" \
        "${NORMAL}"
}

function print_in_red() {
    print_in_color "$1" $RED
}

function print_in_green() {
    print_in_color "$1" $GREEN
}

function print_in_yellow() {
    print_in_color "$1" $YELLOW
}

function print_in_blue() {
    print_in_color "$1" $BLUE
}

function print_result() {
    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"
}

function print_error() {
    print_in_red "[✖] $1 $2\n"
}

function print_error_and_exit() {
    print_in_red "[✖] $1 $2\n"
    exit 1
}

function print_success() {
    print_in_green "[✔] $1\n"
}

function print_warning() {
    print_in_yellow "[!] $1\n"
}

function print_info() {
    print_in_blue "[i] $1\n"
}

function print_question() {
    print_in_yellow "[?] $1"
}

function cmd_exists() {
    command -v "$1" &> /dev/null
}

function git_exists() {
    cmd_exists "git"
}

function curl_exists() {
    cmd_exists "curl"
}

function brew_exists() {
    cmd_exists "brew"
}

function yay_exists() {
    cmd_exists "yay"
}

function zsh_exists() {
    cmd_exists "zsh"
}

function get_os() {
    local os=""
    local kernelName=""

    kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" == "Linux" ]; then
        if [ -f "/etc/lsb-release" ]; then
            os="ubuntu"
        elif [ -f "/etc/debian_version" ]; then
            os="debian"
        elif [ -f "/etc/redhat-release" ]; then
            os="redhat"
        elif [ -f "/etc/arch-release" ]; then
            os="arch"
        elif [ -f "/etc/gentoo-release"]; then
            os="gentoo"
        fi
    else
        os="$kernelName"
    fi

    printf "%s" "$os"
}

function check_os() {
    case $(get_os) in
        macos|arch|gentoo)
            ;;
        *)
            print_error_and_exit "Unsupported OS type $(get_os)"
            ;;
    esac
}

YES=0
NO=1
function promote_yn() {
    if [ "$#" -ne 2 ]; then
        print_error_and_exit "ERROR with promote_yn. Usage: promote_yn <Message> <Variable Name>"
    fi

    eval ${2}=$NO
    print_question "$1 [Yn]"
    read yn
    case $yn in
        [Yy]*|'' ) eval ${2}=$YES;;
        [Nn]* )    eval ${2}=$NO;;
        *)         eval ${2}=$NO;;
    esac
}

function promote_ny() {
    if [ "$#" -ne 2 ]; then
        print_error_and_exit "ERROR with promote_ny. Usage: promote_ny <Message> <Variable Name>"
    fi

    eval ${2}=$NO
    print_question "$1 [yN]"
    read yn
    case $yn in
        [Nn]*|'' ) eval ${2}=$NO;;
        [Yy]* )    eval ${2}=$YES;;
        *)         eval ${2}=$NO;;
    esac
}

function sync_git_repo() {
    local repo_type="$1"
    local repo_uri="$2"
    local repo_path="$3"
    local repo_branch="$4"

    if [ -z "$repo_branch" ]; then
        repo_branch="master"
    fi

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --recursive --depth 1 --branch $repo_branch "https://$repo_type.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull origin $repo_branch && git submodule update --init --recursive; cd - >/dev/null
    fi
}

check_os
