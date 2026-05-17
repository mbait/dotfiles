# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles. Source configs live under `dotfiles/`; an Ansible role symlinks them into `$HOME` and `~/.config/`. There is no build, lint, or test suite.

## Install / apply changes

The Ansible role is the supported installer (the older `install.py` is deprecated and prints a deprecation banner).

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
- `ansible/roles/dotfiles/tasks/main.yml` — the only place that defines what gets symlinked and where. **Adding a new dotfile requires adding an entry here**; dropping a file under `dotfiles/` alone is not enough (unlike the old `install.py`, which auto-discovered everything).
- `ansible/roles/dotfiles/defaults/main.yml` — holds `overwrite_existing` default.
- `dotfiles.old/` — retired configs (Xorg, i3, bash, gentoo portage, etc.). Archive only; not wired to the installer.
- `bin/swap_ws.py` — standalone utility, unrelated to the installer.
- `install.py` — deprecated; kept only so old muscle-memory invocations print the banner. Do not extend it.

## Symlink shapes

Two patterns coexist in the role, chosen per destination:

- **Whole-directory symlink** (`emacs`, `tmux`, `vim`): repo `dotfiles/<tool>/` becomes `~/.config/<tool>`. Use when the whole tool dir is repo-owned.
- **File-level symlinks** (`git`): `~/.config/git/` stays a real directory; individual files (`config`, `ignore`) are symlinked in. Use when other tools or user-generated files need to coexist in the same dir.

When adding a new tool, pick the shape based on whether anything else might write into that directory.
