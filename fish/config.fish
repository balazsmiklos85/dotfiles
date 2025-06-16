switch_light
detect_os

set -gx FZF_DEFAULT_COMMAND "fd . $HOME"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"

set -gx PATH $HOME/.local/bin $PATH
if [ -d $HOME/.sdkman ]
    set -gx PATH $HOME/.sdkman $PATH
end
if [ -d $HOME/.cargo/bin ]
    set -gx PATH $HOME/.cargo/bin $PATH
end
if [ (uname) = Darwin ]
    set -gx PATH /opt/homebrew/bin $PATH
    set -gx PATH $HOME/.nvm $PATH
end
if [ -d $HOME/.rvm ]
    set -gx PATH $HOME/.rvm/bin $PATH
    set -gx PATH $HOME/.rvm/gems/ruby-3.3.0/bin $PATH
end

set -gx XDG_DATA_DIRS /var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS

set -gx MAILCAPS $HOME/.config/mailcap

set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

set -gx ZED_ALLOW_EMULATED_GPU 1

set -g theme_date_format +'%Y-%m-%d %H:%M:%S %Z'

if command -v dig >/dev/null
    set -gx PUBLIC_IP $(dig +short myip.opendns.com @resolver1.opendns.com)
end

if command -v fzf >/dev/null
    fzf --fish | source
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

source ~/.config/fish/secrets.fish
