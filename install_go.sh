#!/usr/bin/env bash

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

# shellcheck source=/dev/null
. "${BASE_DIR}/utils.sh"

# GO111MODULE=on
if [ -z "$GOPROXY" ]; then
  GOPROXY="https://goproxy.cn,direct"
fi

if [ -z "$GOPATH" ]; then
    GOPATH="$HOME/go"
fi

packages=(
    github.com/stamblerre/gocode
    github.com/uudashr/gopkgs/v2/cmd/gopkgs
    github.com/zmb3/gogetdoc
    github.com/davidrjenni/reftools/cmd/fillstruct
    github.com/josharian/impl
    github.com/golangci/golangci-lint/cmd/golangci-lint
    github.com/fatih/gomodifytags
    github.com/cweill/gotests/gotests
    github.com/google/gops
    github.com/haya14busa/goplay/cmd/goplay
    github.com/go-delve/delve/cmd/dlv
    github.com/motemen/gore/cmd/gore

    google.golang.org/protobuf/cmd/protoc-gen-go
    google.golang.org/grpc/cmd/protoc-gen-go-grpc

    mvdan.cc/gofumpt/gofumports

    golang.org/x/tools/cmd/guru
    golang.org/x/tools/cmd/gorename
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/godoc
    golang.org/x/tools/gopls
)

function check() {
    print_info "checking go..."
    if ! cmd_exists "go"; then
        print_error_and_exit "go is not installed, please install first"
    else
        # paths=(${GOPATH//\:/ })
        IFS=: read -ra paths <<< "$GOPATH"
        for p in "${paths[@]}"; do
            mkdir -p "${p}"{/bin,/pkg,/src,}
        done
        print_success "go has been installed"
    fi
}

function clean() {
    os=$(sys_os | tr '[:upper:]' '[:lower:]')
    for p in "${packages[@]}"; do
        print_info "cleaning ${p}..."
        go clean -i -n "${p}"
        go clean -i "${p}"
        IFS=: read -ra paths <<< "$GOPATH"
        for gp in "${paths[@]}"; do
            rm -rf "${gp}/src/${p}"
            rm -rf "${gp}/pkg/${os}_amd64/${p}"
        done
    done
    print_success "clean all old packages successfully"
}

function install() {
    for p in "${packages[@]}"; do
        print_info "installing ${p}..."
        go get "${p}"
    done
}

function main() {
    check

    promote_ny "clean all old packages?" "answer"
    # shellcheck disable=SC2154
    if [ "$answer" -eq "$YES" ]; then
        clean
    fi

    install

    print_success "done."
}

main
