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
    if name in DEFAULT_MAPPINGS:
        path = DEFAULT_MAPPINGS[name]
    else:
        path = name

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

    if opts.list:
        for v in files.values():
            print v

    if opts.install:
        for name, path in files.iteritems():
            try:
                if opts.clean:
                    os.unlink(path)

                os.symlink(os.path.join(CONFIG_DIR, name), path)
            except OSError:
                print 'error, %s' % path


if __name__ == '__main__':
    main()
