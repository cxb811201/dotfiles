#!/usr/bin/env bash

# variables
DOTFILES=$HOME/.dotfiles
TMUX=$HOME/.tmux
ZINIT=$HOME/.zinit
ZINITBIN=$HOME/.zinit/bin
EMACSD=$HOME/.emacs.d
EMACSDOOMD=$HOME/.emacs-doom.d
DOOMD=$HOME/.doom.d

BASE_DIR="${BASH_SOURCE%/*}"
if [ ! -d "$BASE_DIR" ]; then
    BASE_DIR="$PWD";
fi

# shellcheck source=./utils.sh
. "$BASE_DIR/utils.sh"

if ! git_exists; then
    print_error_and_exit "git is not installed"
fi

if ! curl_exists; then
    print_error_and_exit "curl is not installed"
fi

if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME"/.config
fi

print_info "installing dotfiles..."
# common
ln -snf "$DOTFILES"/authinfo.gpg "$HOME"/.authinfo.gpg
ln -snf "$DOTFILES"/vimrc "$HOME"/.vimrc
ln -snf "$DOTFILES"/markdownlint.json "$HOME"/.markdownlint.json
ln -snf "$DOTFILES"/npmrc "$HOME"/.npmrc
ln -snf "$DOTFILES"/vuerc "$HOME"/.vuerc
ln -snf "$DOTFILES"/gemrc "$HOME"/.gemrc
ln -snf "$DOTFILES"/config/pip "$HOME"/.config/pip
ln -snf "$DOTFILES"/pydistutils.cfg "$HOME"/.pydistutils.cfg
if [ ! -d "$HOME/.cargo" ]; then
    mkdir -p "$HOME"/.cargo
fi
ln -snf "$DOTFILES"/cargo/config "$HOME"/.cargo/config
mkdir -p "$HOME"/.m2
cp -rf "$DOTFILES"/m2/* "$HOME"/.m2
mkdir -p "$HOME"/.sbt
cp -rf "$DOTFILES"/sbt/* "$HOME"/.sbt
ln -snf "$DOTFILES"/gitignore_global "$HOME"/.gitignore_global
ln -snf "$DOTFILES"/gitconfig_global "$HOME"/.gitconfig_global
if [ "$(get_os)" != "macos" ]; then
    ln -snf "$DOTFILES"/pam_environment "$HOME"/.pam_environment
    ln -snf "$DOTFILES"/Xresources "$HOME"/.Xresources
    ln -snf "$DOTFILES"/Xresources.d "$HOME"/.Xresources.d
    ln -snf "$DOTFILES"/config/coursier "$HOME"/.config/coursier
    ln -snf "$DOTFILES"/gitconfig_linux "$HOME"/.gitconfig
    cp -rf "$DOTFILES"/gtkrc-2.0 "$HOME"/.gtkrc-2.0
    cp -rf "$DOTFILES"/config/gtk-3.0/* "$HOME"/.config/gtk-3.0
    cp -rf "$DOTFILES"/config/mimeapps.list "$HOME"/.config/mimeapps.list
    ln -snf "$DOTFILES"/config/libfm "$HOME"/.config/libfm
    ln -nsf "$DOTFILES"/config/pcmanfm "$HOME"/.config/pcmanfm
    ln -snf "$DOTFILES"/config/fontconfig "$HOME"/.config/fontconfig
    mkdir -p "$HOME"/.config/alacritty
    ln -snf "$DOTFILES"/config/alacritty/alacritty_linux.yml "$HOME"/.config/alacritty/alacritty.yml
    ln -snf "$DOTFILES"/config/bashtop "$HOME"/.config/bashtop
    ln -snf "$DOTFILES"/config/bspwm "$HOME"/.config/bspwm
    ln -snf "$DOTFILES"/config/dunst "$HOME"/.config/dunst
    ln -snf "$DOTFILES"/config/networkmanager-dmenu "$HOME"/.config/networkmanager-dmenu
    ln -snf "$DOTFILES"/config/polybar "$HOME"/.config/polybar
    ln -snf "$DOTFILES"/config/rofi "$HOME"/.config/rofi
    ln -snf "$DOTFILES"/config/sxhkd "$HOME"/.config/sxhkd
    ln -snf "$DOTFILES"/config/compton.conf "$HOME"/.config/compton.conf
    mkdir -p "$HOME"/.mpd
    cp -rf "$DOTFILES"/mpd/* "$HOME"/.mpd
    mkdir -p "$HOME"/.mpd/playlists
    touch "$HOME"/mpd/{mpd.db,mpd.log,mpdstate}
    ln -snf "$DOTFILES"/ncmpcpp "$HOME"/.ncmpcpp
    ln -snf "$DOTFILES"/fehbg "$HOME"/.fehbg
else
    if [ ! -d "$HOME/Library/Preferences" ]; then
        mkdir -p "$HOME"/Library/Preferences
    else
        rm -rf "$HOME"/Library/Preferences/Coursier
    fi
    ln -snf "$DOTFILES"/config/coursier "$HOME"/Library/Preferences/Coursier
    ln -snf "$DOTFILES"/gitconfig_macos "$HOME"/.gitconfig
    mkdir -p "$HOME"/.config/alacritty
    ln -snf "$DOTFILES"/config/alacritty/alacritty_macos.yml "$HOME"/.config/alacritty/alacritty.yml
fi
ln -snf "$DOTFILES"/config/ranger "$HOME"/.config/ranger

print_success "dotfiles install successfully"

# fonts
print_info "installing fonts..."
if [ "$(get_os)" != "macos" ]; then
    mkdir -p "$HOME"/.local/share
    cp -rf "$DOTFILES"/local/share/fonts "$HOME"/.local/share
    fc-cache -f "$HOME"/.local/share/fonts
else
    mkdir -p "$HOME"/Library/Fonts
    cp -rf "$DOTFILES"/local/share/fonts/* "$HOME"/Library/Fonts
fi
print_success "fonts install successfully"

# fcitx5
if [ "$(get_os)" != "macos" ]; then
    print_info "configure fcitx5..."
    cp -rf "$DOTFILES"/config/fcitx5 "$HOME"/.config
    mkdir -p "$HOME"/.local/share
    cp -rf "$DOTFILES"/local/share/fcitx5 "$HOME"/.local/share
    if [ ! -d "$HOME/.local/share/fcitx5/rime" ]; then
        sync_git_repo github cxb811201/rime-wubi86-jidian "$HOME"/.local/share/fcitx5/rime
    fi
    print_success "fcitx5 configuration successfully"
fi

# tmux
print_info "installing oh_my_tmux..."
ln -snf "$DOTFILES"/tmux.conf.local "$HOME"/.tmux.conf.local
if [ ! -d "$TMUX" ]; then
    sync_git_repo github gpakosz/.tmux "$TMUX"
fi
print_success "oh_my_tmux install successfully"

# zinit and zsh
print_info "installing zinit..."
if [ ! -d "$ZINIT" ]; then
    mkdir -p "$ZINIT"
fi
if [ ! -f "$ZINIT/bin/zinit.zsh" ]; then
    rm -rf "$ZINITBIN"
    sync_git_repo github zdharma/zinit "$ZINITBIN"
fi
ln -snf "$DOTFILES"/zprofile "$HOME"/.zprofile
ln -snf "$DOTFILES"/zshenv "$HOME"/.zshenv
ln -snf "$DOTFILES"/zshrc "$HOME"/.zshrc
print_success "zinit install successfully"

if [ ! -d "$HOME/.jenv" ]; then
    print_info "installing jenv..."
    sync_git_repo github jenv/jenv "$HOME"/.jenv
    print_success "jenv install successfully"
fi

if [ ! -d "$EMACSD" ] || [ ! -d "$EMACSDOOMD" ] || [ ! -d "$DOOMD" ]; then
    print_info "installing doom-emacs..."
    if [ -d "$EMACSD" ]; then
        mv "$EMACSD" "$EMACSD".bak
    fi
    if [ -d "$EMACSDOOMD" ]; then
	mv "$EMACSDOOMD" "$EMACSDOOMD".bak
    fi
    if [ -d "$DOOMD" ]; then
        mv "$DOOMD" "$DOOMD".bak
    fi

    ln -snf "$DOTFILES"/emacs-profiles.el "$HOME"/.emacs-profiles.el

    sync_git_repo github plexus/chemacs2 "$EMACSD" develop
    sync_git_repo github hlissner/doom-emacs "$EMACSDOOMD" develop
    sync_git_repo github cxb811201/.doom.d "$DOOMD"
    "$EMACSDOOMD"/bin/doom install --no-config --no-env
    print_success "doom-emacs install successfully"
fi

# entering zsh
print_success "done. enjoy!"
if zsh_exists; then
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        chsh -s "$(command -v zsh)"
        print_info "you need to logout and login to enable zsh as the default shell."
    fi
    env zsh
else
    print_error_and_exit "zsh is not installed"
fi
