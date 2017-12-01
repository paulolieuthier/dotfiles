#!/usr/bin/env python

import os
import os.path
import shutil

pwd = os.path.dirname(os.path.realpath(__file__))

def install_config_file(file_name, symlink_name):
    full_symlink_name = os.path.expanduser(symlink_name)
    full_config_name = os.path.realpath(pwd + "/" + file_name)

    if os.path.exists(full_symlink_name):
        if os.path.samefile(full_symlink_name, full_config_name):
            return
        else:
            shutil.move(full_symlink_name, full_symlink_name + ".old")
    else:
        dirname = os.path.dirname(full_symlink_name)
        if not os.path.exists(dirname):
            os.makedirs(dirname)

    os.symlink(full_config_name, full_symlink_name)

install_config_file("zshrc", "~/.zshrc")
install_config_file("emacs.el", "~/.emacs.d/init.el")
install_config_file("vimrc", "~/.config/nvim/init.vim")
install_config_file("Xmodmap", "~/.Xmodmap")
install_config_file("tmux", "~/.tmux.conf")
install_config_file("sway", "~/.config/sway")
install_config_file("i3config", "~/.config/i3status/config")
install_config_file("bin/lockscreen", "~/.local/bin/lockscreen")
install_config_file("systemd/lockscreen.service", "~/.config/systemd/user/lockscreen.service")
