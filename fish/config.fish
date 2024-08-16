switch_light

set -gx FZF_DEFAULT_COMMAND "fd . $HOME"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"

set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.sdkman $PATH

if [ (uname) = "Darwin" ]
	set -gx PATH /opt/homebrew/bin $PATH
	set -gx PATH $HOME/DEV/projects/hybris/core-customize/hybris/bin/platform/apache-ant/bin $PATH
	set -gx PATH $HOME/.nvm $PATH
else
    set -gx PATH $HOME/.rvm/gems/ruby-3.3.0/bin $PATH
end

set -gx MAILCAPS $HOME/.config/mailcap

if command -v fzf > /dev/null
	fzf --fish | source
end

zoxide init fish | source

if command -v thefuck > /dev/null
	thefuck --alias | source
end

alias cd='z'
alias ls='lsd -al'
alias tree='lsd --tree'

source ~/.config/fish/secrets.fish

