#!/usr/bin/env bash

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

# shellcheck source=/dev/null
. "${BASE_DIR}/utils.sh"

NVM_DIR="$HOME/.nvm"

packages=(
    npm-check
    @vue/cli
    vue-language-server
    prettier
    js-beautify
    import-js
    stylelint
    eslint
    typescript
    tslint
    markdownlint-cli
    typescript-formatter
    typescript-language-server
    vscode-css-languageserver-bin
    vscode-html-languageserver-bin
    vscode-json-languageserver
    locate-java-home
)

function check() {
    print_info "checking nvm..."
    if [[ ! -f "$NVM_DIR/nvm.sh" ]]; then
        print_warning "nvm is not installed"
        print_info "installing nvm..."
        mkdir -p "$NVM_DIR"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | METHOD="script" sh
        print_success "nvm install successfully"
        # shellcheck source=/dev/null
        source "$NVM_DIR/nvm.sh"
    else
      # shellcheck source=/dev/null
        source "$NVM_DIR/nvm.sh"
        print_success "nvm has been installed"
    fi
}

function install_nodejs() {
    print_info "checking nodejs..."
    if ! cmd_exists "node"; then
        print_info "installing nodejs..."
        nvm install node
    else
        print_success "nodejs has been installed"
    fi
}

function install_packages() {
    for p in "${packages[@]}"; do
        print_info "installing $p ..."
        npm install -g "$p"
    done
}

function main() {
    check
    install_nodejs
    install_packages
}

main
