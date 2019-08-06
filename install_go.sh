#!/usr/bin/env bash

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

. "${BASE_DIR}/utils.sh"

GO111MODULE=on
GOPROXY="https://goproxy.io"
GOPATH="$HOME/Projects/go"

packages=(
    github.com/stamblerre/gocode # for go mod
    github.com/rogpeppe/godef
    github.com/haya14busa/gopkgs/cmd/gopkgs
    github.com/zmb3/gogetdoc
    github.com/davidrjenni/reftools/cmd/fillstruct
    github.com/josharian/impl
    github.com/golangci/golangci-lint/cmd/golangci-lint
    github.com/fatih/gomodifytags
    github.com/godoctor/godoctor
    github.com/cweill/gotests/gotests
    github.com/google/gops
    github.com/haya14busa/goplay/cmd/goplay
    github.com/derekparker/delve/cmd/dlv
    github.com/aarzilli/gdlv

    golang.org/x/lint/golint
    golang.org/x/tools/cmd/guru
    golang.org/x/tools/cmd/gorename
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/cmd/gopls
)

function check() {
    print_info "checking go..."
    if ! cmd_exists "go"; then
        print_error_and_exit "go is not installed, please install first"
    else
        mkdir -p $GOPATH{/bin,/pkg,/src,}
        print_success "go has been installed"
    fi
}

function clean() {
    for p in ${packages[@]}; do
        print_info "cleaning ${p}..."
        go clean -i -i "${p}"
        go clean -i "${p}"
    done
    print_success "clean all old packages successfully"
}

function install() {
    for p in ${packages[@]}; do
        print_info "installing ${p}..."
        go get -u "${p}"
    done
}

function main() {
    check

    promote_ny "clean all old packages?" "continue"
    if [ $continue -eq $YES ]; then
        clean
    fi

    install

    print_success "done."
}

main
