# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles. Source configs live under `dotfiles/`; an Ansible role symlinks them into `$HOME` and `~/.config/`. There is no build, lint, or test suite.

## Install / apply changes

```sh
cd ansible && ansible-playbook playbooks/install.yml
```

The `cd` matters: `ansible.cfg` is only auto-loaded when CWD is `ansible/`. It pins `inventory`, `roles_path`, and `transport = local`, so the playbook always runs against `localhost` with no flags.

The role refuses to touch existing files by default. To replace existing files/symlinks (e.g. when re-applying after editing the role):

```sh
ansible-playbook playbooks/install.yml -e overwrite_existing=true
```

Note: Ansible's `file` module will not turn a non-empty real directory into a symlink even with `force: true`. If a destination ever ends up as a populated directory (rather than a symlink or single file), the play will fail there — resolve by moving its contents into the repo and re-running, or switch that destination to file-level symlinks (see how `~/.config/git/` is handled).

## Layout that matters

- `dotfiles/` — source of truth for every managed config. New configs go here.
- `ansible/roles/dotfiles/tasks/main.yml` — the only place that defines what gets symlinked and where. **Adding a new dotfile requires adding an entry here**; dropping a file under `dotfiles/` alone is not enough.
- `ansible/roles/dotfiles/defaults/main.yml` — holds `overwrite_existing` and `xdg_bin_home` defaults. `xdg_bin_home` honors `$XDG_BIN_HOME` if set, else falls back to `~/.local/bin` (the systemd-path "user-binaries" location).
- `ansible/roles/dotfiles/handlers/main.yml` — notified handlers (e.g. `Reload gpg-agent` after the gpg-agent config changes).
- `dotfiles.old/` — retired configs (Xorg, i3, bash, gentoo portage, etc.). Archive only; not wired to the installer.

## Symlink shapes

Three patterns coexist in the role, chosen per destination:

- **Whole-directory symlink** (`emacs`, `tmux`, `vim`): repo `dotfiles/<tool>/` becomes `~/.config/<tool>`. Use when the whole tool dir is repo-owned.
- **File-level symlinks, enumerated** (`git`, gpg-agent): `~/.config/git/` and `~/.gnupg/` stay real directories; specific files are symlinked in. Use when other tools or user-generated files need to coexist in the same dir.
- **File-level symlinks, globbed** (`bin`): every file under `dotfiles/bin/` is symlinked into `xdg_bin_home` via `with_fileglob`. Dropping a new executable into `dotfiles/bin/` auto-installs on next play. Used here because `~/.local/bin` is shared with non-repo binaries (e.g. `claude`).

When adding a new tool, pick the shape based on whether anything else might write into that directory.
