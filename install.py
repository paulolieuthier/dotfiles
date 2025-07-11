#!/usr/bin/env python

import os
import os.path
import shutil

PWD = os.path.dirname(os.path.realpath(__file__))


def symlink_file(file_name, symlink_name):
    full_symlink_name = os.path.expanduser(symlink_name)
    full_config_name = os.path.realpath(PWD + "/" + file_name)

    if os.path.lexists(full_symlink_name):
        if os.path.islink(full_symlink_name) and not os.path.exists(os.readlink(full_symlink_name)):
            print(f"Removing broken link in {full_symlink_name}")
            os.remove(full_symlink_name)
        elif os.path.samefile(full_symlink_name, full_config_name):
            print(f"Ignoring already set link in {full_symlink_name}")
            return
        else:
            print(f"Backing up different config in {full_symlink_name}")
            shutil.move(full_symlink_name, full_symlink_name + ".old")
    else:
        dirname = os.path.dirname(full_symlink_name)
        if not os.path.exists(dirname):
            print(f"Creating dirs for {dirname}")
            os.makedirs(dirname)

    print(f"Creating link in {full_symlink_name}")
    os.symlink(full_config_name, full_symlink_name)

symlink_file("home-manager", "~/.config/home-manager")
symlink_file("background.jpg", "~/.background.jpg")
symlink_file("environment.conf", "~/.config/environment.d/basic.conf")
symlink_file("nvim.lua", "~/.config/nvim/init.lua")
symlink_file("zellij.kdl", "~/.config/zellij/config.kdl")
symlink_file("niri.kdl", "~/.config/niri/config.kdl")
symlink_file("gitconfig", "~/.gitconfig")
symlink_file("ideavimrc", "~/.ideavimrc")
symlink_file("waybar", "~/.config/waybar")
symlink_file("bin/lockscreen", "~/.local/bin/lockscreen")
