#!/usr/bin/env python

import os
import os.path
import shutil

pwd = os.path.dirname(os.path.realpath(__file__))

def install_config_file(config_file_name, symlink_name):
    full_symlink_name = os.path.expanduser(symlink_name)

    if os.path.exists(full_symlink_name):
        shutil.move(full_symlink_name, full_symlink_name + ".old")
    else:
        dirname = os.path.dirname(full_symlink_name)
        if not os.path.exists(dirname):
            os.makedirs(dirname)

    os.symlink(pwd + "/" + config_file_name, full_symlink_name)

install_config_file("zshrc", "~/.zshrc")
install_config_file("emacs.el", "~/.emacs.d/init.el")
install_config_file("vimrc", "~/.vimrc")
