"""
Installation script for software configuration files.
Copyright (C) 2011  Alexander Solovets

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""
import os
import sys

from optparse import OptionParser


CONFIG_DIR = os.path.abspath('dotfiles')

DEFAULT_MAPPINGS = {
    'Xmodmap': '.Xmodmap',
    'Xresources': '.Xresources',
    'bashrc': '.bashrc',
    'i3config': 'config',
    'pentadactylrc': '.pentadactylrc',
    'rtorrent.rc': '.rtorrent.rc',
    'screenrc': '.screenrc',
    'xinitrc': '.xinitrc',
}

DEFAULT_PATH = {
    'i3config': '~/.config/i3',
    'git': '~/.config',
    'make.conf': '/etc',
    'mcabberrc': '~/.mcabber/',
    'package.mask': '/etc/portage',
    'package.use': '/etc/portage',
    'tmux': '~/.config',
    'vim': '~/.config',
    'xorg.conf': '/etc/X11',
}


def get_path(name):
    path = name

    if name in DEFAULT_MAPPINGS:
        path = DEFAULT_MAPPINGS[name]

    if name in DEFAULT_PATH:
        path = os.path.join(os.path.expanduser(DEFAULT_PATH[name]), path)
    else:
        path = os.path.join(os.path.expanduser('~'), path)

    return path


def main():
    print('''
********************************************************************
* DEPRECTED!!!                                                     *
* THIS SCRIPT HAS BEEN DEPRECTED IN FAVOR OF ANSIBLE CONFIGURATION *
********************************************************************
    '''.lstrip(), file=sys.stderr)

    parser = OptionParser()
    parser.add_option('-c', '--clean', action='store_true')
    parser.add_option('-l', '--list', action='store_true')
    parser.add_option('-i', '--install', action='store_true')
    parser.add_option('-u', '--user', action='store_true')
    parser.add_option('-s', '--system', action='store_true')
    opts, args = parser.parse_args()

    files = dict((name, get_path(name)) for name in os.listdir(CONFIG_DIR))
    max_len = max(len(name) for name in files)

    for name, path in files.items():
        if opts.list:
            print(f'{name: <{max_len}} -> {path}')

        try:
            if opts.clean:
                os.unlink(path)

            if opts.install:
                os.symlink(os.path.join(CONFIG_DIR, name), path)
        except OSError as e:
            print(e, file=sys.stderr)


if __name__ == '__main__':
    main()
