# dotfiles

My very own configuration files. Organized to set up a Linux (openSUSE) environment to my taste fast.

## Usage

1. Install a new system.
2. Install `fish` and `git`. For example as `sudo zypper install --no-recommends git fish`
3. Change the default shell to `fish` with `chsh -s $(which fish) $USER`
4. Create SSH keys.
5. Add the keys to https://github.com/settings/keys
6. Clone the repository with `git clone git@github.com:balazsmiklos85/dotfiles.git`
7. Move everything from `./dotfiles/` to `~/.config`, including the `.git` directory with `rsync -av ./dotfiles/ ~/.config/`
8. Log out and log in
9. Install `oh-my-fish` with `curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish`
10. Run `system-update`
