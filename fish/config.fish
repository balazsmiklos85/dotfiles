source ~/.config/fish/secrets.fish

set -g theme_color_scheme zenburn
set -gx BAT_THEME "Catppuccin Mocha"

set -gx PATH $HOME/.sdkman $PATH

if [ (uname) = "Darwin" ]
	set -gx PATH /opt/homebrew/bin $PATH
	set -gx PATH $HOME/DEV/projects/hybris/core-customize/hybris/bin/platform/apache-ant/bin $PATH
	set -gx PATH $HOME/.nvm $PATH
	if am_i_at_work
		set -g theme_color_scheme light
		set -gx BAT_THEME "Catppuccin Latte"
	end
	set -gx GIT_EDITOR /opt/homebrew/bin/nvim
end

set -gx MAILCAPS $HOME/.config/mailcap

if command -v thefuck > /dev/null
	thefuck --alias | source
end

