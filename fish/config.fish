switch_light
detect_os

set -gx PATH $HOME/.local/bin $PATH
if [ -d $HOME/.sdkman ]
    set -gx PATH $HOME/.sdkman $PATH
end
if [ -d $HOME/.cargo/bin ]
    set -gx PATH $HOME/.cargo/bin $PATH
end
if [ (uname) = Darwin ]
    set -gx PATH /opt/homebrew/bin $PATH
end
if [ -d $HOME/.nvm ]
    set -gx PATH $HOME/.nvm $PATH
end
if [ -d $HOME/.rvm ]
    set -gx PATH $HOME/.rvm/bin $PATH
    set -gx PATH $HOME/.rvm/rubies/default/bin $PATH
    set -gx PATH $HOME/.rvm/gems/default/bin $PATH
    set -gx GEM_HOME $HOME/.rvm/gems/default
    set -gx GEM_PATH $HOME/.rvm/gems/default
end

set -gx XDG_DATA_DIRS /var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS

set -gx MAILCAPS $HOME/.config/mailcap

set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

set -gx ZED_ALLOW_EMULATED_GPU 1

set -g theme_date_format +'%Y-%m-%d %H:%M:%S %Z'

if command -v dig >/dev/null
    set -gx PUBLIC_IP $(dig +short myip.opendns.com @resolver1.opendns.com)
end

if command -v zoxide >/dev/null
    zoxide init fish | source
end

if command -v starship >/dev/null
    starship init fish | source
end

if command -v thefuck >/dev/null
    thefuck --alias | source
end

if command -v bat >/dev/null
    alias cat="bat --style plain"
end

alias :w 'echo "Dammit Jim, I\'m a fish, not a vi!"; test 0 -eq 1'
alias :wq 'echo "Dammit Jim, I\'m a fish, not a vi!"; test 0 -eq 1'

source ~/.config/fish/fzf.fish
source ~/.config/fish/secrets.fish

if is_wsl; and not test -S "$SSH_AUTH_SOCK"
    eval (ssh-agent -c)
    set -gx SSH_AUTH_SOCK $SSH_AUTH_SOCK
    ssh-add (fd --type f --exclude '*.pub' --exclude 'config' --exclude 'authorized_keys' --exclude 'known_hosts*' . ~/.ssh)
end

fish_add_path $HOME/.opencode/bin
