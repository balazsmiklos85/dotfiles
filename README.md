# dotfiles

My very own configuration files. Organized to set up a Linux (openSUSE) environment to my taste fast.

## Usage

1. Install a new system.
2. Install `ansible`, `fish`, `git`, `hostname`, `rsync`. For example as `sudo zypper install --no-recommends ansible fish git hostname rsync`
3. Change the default shell to `fish` with `chsh -s $(which fish) $USER`
4. Create SSH keys: `ssh-keygen -t ed25519 -C "bmiklos@$(hostname)"`
5. Add the keys to https://github.com/settings/keys
6. Clone the repository with `git clone git@github.com:balazsmiklos85/dotfiles.git`
7. Move everything from `./dotfiles/` to `~/.config`, including the `.git` directory with `rsync -av ./dotfiles/ ~/.config/`
8. Log out and log in
9. Run `system-update`
