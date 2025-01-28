switch_light

set -gx FZF_DEFAULT_COMMAND "fd . $HOME"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"

set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.sdkman $PATH
set -gx PATH $HOME/.cargo/bin $PATH

if [ (uname) = Darwin ]
    set -gx PATH /opt/homebrew/bin $PATH
    set -gx PATH $HOME/DEV/projects/hybris/core-customize/hybris/bin/platform/apache-ant/bin $PATH
    set -gx PATH $HOME/.nvm $PATH
else
    set -gx PATH $HOME/.rvm/gems/ruby-3.3.0/bin $PATH
end

set -gx MAILCAPS $HOME/.config/mailcap

set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

set -g theme_date_format +'%Y-%m-%d %H:%M:%S %Z'

if command -v fzf >/dev/null
    fzf --fish | source
end

if command -v zoxide >/dev/null
    zoxide init fish | source
    alias cd='z'
else
    alias z='cd'
end

if command -v thefuck >/dev/null
    thefuck --alias | source
end

alias ls='lsd -al'
alias tree='lsd --tree'
alias cat='bat --style plain'

source ~/.config/fish/secrets.fish

