#!/usr/bin/env python

import os
import os.path
import shutil

pwd = os.path.dirname(os.path.realpath(__file__))


def symlink_file(file_name, symlink_name):
    full_symlink_name = os.path.expanduser(symlink_name)
    full_config_name = os.path.realpath(pwd + "/" + file_name)

    if os.path.exists(full_symlink_name):
        if not os.path.exists(os.readlink(full_symlink_name)):
            os.remove(full_symlink_name)
        elif os.path.samefile(full_symlink_name, full_config_name):
            return
        else:
            shutil.move(full_symlink_name, full_symlink_name + ".old")
    else:
        dirname = os.path.dirname(full_symlink_name)
        if not os.path.exists(dirname):
            os.makedirs(dirname)

    os.symlink(full_config_name, full_symlink_name)

symlink_file("background.jpg", "~/.background.jpg")
symlink_file("profile", "~/.profile")
symlink_file("zshrc", "~/.zshrc")
symlink_file("tigrc", "~/.tigrc")
symlink_file("gitconfig", "~/.gitconfig")
symlink_file("emacs.el", "~/.emacs.d/init.el")
symlink_file("vimrc", "~/.config/nvim/init.vim")
symlink_file("ideavimrc", "~/.ideavimrc")
symlink_file("Xmodmap", "~/.Xmodmap")
symlink_file("tmux", "~/.tmux.conf")
symlink_file("alacritty.yml", "~/.config/alacritty/alacritty.yml")
symlink_file("sway", "~/.config/sway")
symlink_file("i3config", "~/.config/i3/config")
symlink_file("i3status", "~/.config/i3status/config")
symlink_file("systemd/ssh-agent.service", "~/.config/systemd/user/ssh-agent.service")
symlink_file("systemd/greenclip.service", "~/.config/systemd/user/greenclip.service")
