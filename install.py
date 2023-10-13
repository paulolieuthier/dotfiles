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
symlink_file("environment.conf", "~/.config/environment.d/basic.conf")
symlink_file("zshrc", "~/.zshrc")
symlink_file("zsh_prompt", "~/.zsh_prompt.zsh")
symlink_file("inputrc", "~/.inputrc")
symlink_file("profile", "~/.profile")
symlink_file("xprofile", "~/.xprofile")
symlink_file("tigrc", "~/.tigrc")
symlink_file("gitconfig", "~/.gitconfig")
symlink_file("emacs.el", "~/.emacs.d/init.el")
symlink_file("vimrc", "~/.config/nvim/init.vim")
symlink_file("ideavimrc", "~/.ideavimrc")
symlink_file("Xmodmap", "~/.Xmodmap")
symlink_file("tmux", "~/.tmux.conf")
symlink_file("sway", "~/.config/sway/config")
symlink_file("arrowsinhomerow.xkb", "~/.xkb/symbols/arrowsinhomerow")
symlink_file("waybar", "~/.config/waybar")
symlink_file("kanshi", "~/.config/kanshi/config")
symlink_file("i3config", "~/.config/i3/config")
symlink_file("i3status", "~/.config/i3status/config")
symlink_file("mako", "~/.config/mako/config")
symlink_file("dunstrc", "~/.config/dunst/dunstrc")
symlink_file("gtk.ini", "~/.config/gtk-3.0/settings.ini")
symlink_file("qt5ct", "~/.config/qt5ct/qt5ct.conf")
symlink_file("bin/wallpaper", "~/.local/bin/wallpaper")
symlink_file("bin/copy", "~/.local/bin/copy")
symlink_file("bin/lockscreen", "~/.local/bin/lockscreen")
symlink_file("systemd/user-applications.target", "~/.config/systemd/user/user-applications.target")
symlink_file("systemd/greenclip.service", "~/.config/systemd/user/greenclip.service")
symlink_file("systemd/ssh-agent.service", "~/.config/systemd/user/ssh-agent.service")

print("Take a look at PACKAGES for a list of packages you may want to install")
print("Run 'systemctl enable --user --now' for nm-applet, greenclip and ssh-agent")
