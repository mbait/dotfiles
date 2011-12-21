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

from optparse import OptionParser


CONFIG_DIR = os.path.abspath('dotfiles')

DEFAULT_MAPPINGS = {
    'Xmodmap': '.Xmodmap',
    'Xresources': '.Xresources',
    'bashrc': '.bashrc',
    'gitconfig': '.gitconfig',
    'i3config': 'config',
    'rtorrent.rc': '.rtorrent.rc',
    'screenrc': '.screenrc',
    'vimrc': '.vimrc',
    'xinitrc': '.xinitrc',
}

DEFAULT_PATH = {
    'i3config': '~/.config/i3',
    'make.conf': '/etc',
    'package.mask': '/etc/portage',
    'package.use': '/etc/portage',
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
    parser = OptionParser()
    parser.add_option('-c', '--clean', action='store_true')
    parser.add_option('-l', '--list', action='store_true')
    parser.add_option('-i', '--install', action='store_true')
    parser.add_option('-u', '--user', action='store_true')
    parser.add_option('-s', '--system', action='store_true')
    opts, args = parser.parse_args()

    files = dict((name, get_path(name)) for name in os.listdir(CONFIG_DIR))
    max_len = max(len(name) for name in files)

    for name, path in files.iteritems():
        if opts.list:
            print '%-*s -> %s' % (max_len, name, path)

        try:
            if opts.clean:
                os.unlink(path)

            if opts.install:
                os.symlink(os.path.join(CONFIG_DIR, name), path)
        except OSError, e:
            print '%s: %s' % (e, path)


if __name__ == '__main__':
    main()
