source ~/.config/fish/secrets.fish

set -g theme_color_scheme zenburn
set -gx BAT_THEME "Catppuccin Mocha"
kitty +kitten themes --reload-in=all Catppuccin-Mocha 

set -gx FZF_DEFAULT_COMMAND "fd . $HOME"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"

set -gx PATH $HOME/.sdkman $PATH

if [ (uname) = "Darwin" ]
	set -gx PATH /opt/homebrew/bin $PATH
	set -gx PATH $HOME/DEV/projects/hybris/core-customize/hybris/bin/platform/apache-ant/bin $PATH
	set -gx PATH $HOME/.nvm $PATH
	if am_i_at_work
		set -g theme_color_scheme light
		set -gx BAT_THEME "Catppuccin Latte"
		kitty +kitten themes --reload-in=all Catppuccin-Latte
	end
	set -gx GIT_EDITOR /opt/homebrew/bin/nvim
end

set -gx MAILCAPS $HOME/.config/mailcap

zoxide init fish | source

if command -v thefuck > /dev/null
	thefuck --alias | source
end

alias cd='z'
alias ls='lsd -al'
alias tree='lsd --tree'

