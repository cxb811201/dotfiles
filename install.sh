#!/usr/bin/env bash

# variables
DOTFILES=$HOME/.dotfiles
ANTIGEN=$HOME/.antigen
TMUX=$HOME/.tmux
EMACSD=$HOME/.emacs.d
DOOMD=$HOME/.doom.d

BASE_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$BASE_DIR" ]]; then BASE_DIR="$PWD"; fi

# shellcheck source=/dev/null
. "${BASE_DIR}/utils.sh"

if ! git_exist; then
    print_error_and_exit "git is not installed"
fi

if ! curl_exist; then
    print_error_and_exit "curl is not installed"
fi

if [ "$(get_os)" == "macos" ]; then
    print_info "checking brew..."
    if brew_exist; then
        print_success "brew has been installed"
    else
        print_info "installing brew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        print_success "brew install successfully"
    fi

    print_info "checking homebrew-cask..."
    if [[ -d "$(brew --repo)/Library/Taps/homebrew/homebrew-cask" ]]; then
        print_success "homebrew-cask has been added"
    else
        print_info "adding homebrew-cask..."
        brew tap homebrew/cask
        print_success "homebrew-cask add successfully"
    fi

    print_info "checking homebrew-cask-fonts..."
    if [[ -d "$(brew --repo)/Library/Taps/homebrew/homebrew-cask-fonts" ]]; then
        print_success "homebrew-cask-fonts has been added"
    else
        print_info "adding homebrew-cask-fonts..."
        brew tap homebrew/cask-fonts
        print_success "homebrew-cask-fonts add successfully"
    fi

    print_info "checking homebrew-cask-versions..."
    if [[ -d "$(brew --repo)/Library/Taps/homebrew/homebrew-cask-versions" ]]; then
        print_success "homebrew-cask-versions has been added"
    else
        print_info "adding homebrew-cask-versions..."
        brew tap homebrew/cask-versions
        print_success "homebrew-cask-versions add successfully"
    fi

    print_info "checking homebrew-cask-upgrade..."
    if [[ -d "$(brew --repo)/Library/Taps/buo/homebrew-cask-upgrade" ]]; then
        print_success "homebrew-cask-upgrade has been added"
    else
        print_info "adding homebrew-cask-upgrade..."
        brew tap buo/cask-upgrade
        print_success "homebrew-cask-upgrade add successfully"
    fi

    print_info "checking homebrew-emacs-plus..."
    if [[ -d "$(brew --repo)/Library/Taps/d12frosted/homebrew-emacs-plus" ]]; then
        print_success "homebrew-emacs-plus has been added"
    else
        print_info "adding homebrew-emacs-plus..."
        brew tap d12frosted/emacs-plus
        print_success "homebrew-emacs-plus add successfully"
    fi

    print_info "check homebrew-bloop..."
    if [[ -d "$(brew --repo)/Library/Taps/scalacenter/homebrew-bloop" ]]; then
        print_success "homebrew-bloop has been added"
    else
        print_info "adding homebrew-bloop..."
        brew tap scalacenter/homebrew-bloop
        print_success "homebrew-bloop add successfully"
    fi
fi

print_info "checking antigne..."
antigen_files=("${ANTIGEN}/antigen.zsh" "/usr/local/share/antigen/antigen.zsh" "/usr/share/zsh/share/antigen.zsh")
found_antigen=0
for file in "${antigen_files[@]}"; do
    if [[ -f $file ]]; then
        found_antigen=1
        break;
    fi
done

if [[ found_antigen -eq 1 ]]; then
    print_success "antigen has been installed"
else
    print_info "installing antigen..."
    case $(get_os) in
        macos)
            brew install antigen
            ;;
        arch)
            if ! yay_exists; then
                print_error_and_exit "yay is not installed, please install yay first"
            fi
            yay -S --noconfirm antigen-git
            ;;
        *)
            # shellcheck disable=SC2086
            mkdir -p $ANTIGEN
            # shellcheck disable=SC2086
            curl -fsSL https://raw.githubusercontent.com/zsh-users/antigen/develop/bin/antigen.zsh > $ANTIGEN/antigen.zsh.tmp && mv $ANTIGEN/antigen.zsh.tmp $ANTIGEN/antigen.zsh
    esac
    print_success "antigen install successfully"
fi

print_info "installing dotfiles..."
# shellcheck disable=SC2086
sync_git_repo github cxb811201/dotfiles $DOTFILES

# common
if [ "$(get_os)" != "macos" ]; then
    if [ "$(get_os)" == "gentoo" ]; then
        # shellcheck disable=SC2086
        ln -sf $DOTFILES/.xprofile $HOME/.xprofile
    else
        # shellcheck disable=SC2086
        ln -sf $DOTFILES/.pam_environment $HOME/.pam_environment
    fi
fi
# shellcheck disable=SC2086
ln -sf $DOTFILES/.editorconfig $HOME/.editorconfig

# zsh
if [ "$(get_os)" == "macos" ]; then
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.zshenv $HOME/.zprofile
else
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.zshenv $HOME/.zshenv
fi
# shellcheck disable=SC2086
ln -sf $DOTFILES/.zshrc.local $HOME/.zshrc.local
# shellcheck disable=SC2086
ln -sf $DOTFILES/.zshrc $HOME/.zshrc

# tmux
if [ "$(get_os)" == "macos" ]; then
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.tmux.conf.local_macos $HOME/.tmux.conf.local
else
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.tmux.conf.local $HOME/.tmux.conf.local
fi

# urxvt
if [ "$(get_os)" != "macos" ]; then
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.Xresources $HOME/.Xresources
    # shellcheck disable=SC2086
    mkdir -p $HOME/.config/fontconfig
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/fonts.conf $HOME/.config/fontconfig/fonts.conf
    # shellcheck disable=SC2086
    xrdb -merge $HOME/.Xresources
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.urxvt $HOME/.urxvt
fi

# fcitx5
if [ "$(get_os)" != "macos" ]; then
    # shellcheck disable=SC2086
    mkdir -p $HOME/.config/fcitx5/conf
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/fcitx5/profile $HOME/.config/fcitx5/profile
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/fcitx5/conf/classicui.conf $HOME/.config/fcitx5/conf/classicui.conf
    # shellcheck disable=SC2086
    mkdir -p $HOME/.config/autostart
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/autostart/fcitx5.desktop $HOME/.config/autostart/fcitx5.desktop
    # shellcheck disable=SC2086
    mkdir -p $HOME/.local/share/fcitx5/themes
    # shellcheck disable=SC2086
    sync_git_repo github hosxy/fcitx5-dark-transparent $HOME/.local/share/fcitx5/themes/dark-transparent
fi

# markdownlint
# shellcheck disable=SC2086
ln -sf $DOTFILES/.markdownlint.json $HOME/.markdownlint.json

# npm
# shellcheck disable=SC2086
ln -sf $DOTFILES/.npmrc $HOME/.npmrc

# vue
# shellcheck disable=SC2086
ln -sf $DOTFILES/.vuerc $HOME/.vuerc

# gem
# shellcheck disable=SC2086
ln -sf $DOTFILES/.gemrc $HOME/.gemrc

# python
# shellcheck disable=SC2086
mkdir -p $HOME/.config/pip
# shellcheck disable=SC2086
ln -sf $DOTFILES/pip.conf $HOME/.config/pip/pip.conf
# shellcheck disable=SC2086
ln -sf $DOTFILES/.pydistutils.cfg $HOME/.pydistutils.cfg

# cargo for rust
# shellcheck disable=SC2086
mkdir -p $HOME/.cargo
# shellcheck disable=SC2086
ln -sf $DOTFILES/.cargo/config $HOME/.cargo/config

# sbt
# shellcheck disable=SC2086
cp -rf $DOTFILES/.sbt $HOME

# git
# shellcheck disable=SC2086
ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global
# shellcheck disable=SC2086
ln -sf $DOTFILES/.gitconfig_global $HOME/.gitconfig_global
if [ "$(get_os)" == "macos" ]; then
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.gitconfig_macos $HOME/.gitconfig
else
    # shellcheck disable=SC2086
    ln -sf $DOTFILES/.gitconfig_linux $HOME/.gitconfig
fi
print_success "dotfiles install successfully"

print_info "installing oh_my_tmux..."
# shellcheck disable=SC2086
sync_git_repo github gpakosz/.tmux $TMUX
# shellcheck disable=SC2086
ln -sf $TMUX/.tmux.conf $HOME/.tmux.conf
print_success "oh_my_tmux install successfully"

if [ "$(get_os)" != "macos" ]; then
    print_info "installing fonts..."
    # shellcheck disable=SC2086
    mkdir -p $HOME/.local/share
    # shellcheck disable=SC2086
    cp -rf $DOTFILES/fonts $HOME/.local/share
    fc-cache -f -v > /dev/null
    print_success "fonts install successfully"
fi

print_info "installing doom-emacs..."
# shellcheck disable=SC2086
sync_git_repo github hlissner/doom-emacs $EMACSD develop
# shellcheck disable=SC2086
sync_git_repo github cxb811201/.doom.d $DOOMD
# shellcheck disable=SC2086
$EMACSD/bin/doom install --no-config --no-env
print_success "doom-emacs install successfully"

# Entering zsh
print_success "done. Enjoy!"
if zsh_exists; then
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        chsh -s "$(command -v zsh)"
        print_info "you need to logout and login to enable zsh as the default shell."
    fi
    env zsh
else
    print_error_and_exit "zsh is not installed"
fi
