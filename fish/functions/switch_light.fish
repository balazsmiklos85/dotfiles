function switch_light
	am_i_at_work
	
	if test $status -eq 0
		osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
		set -g theme_color_scheme switch_light
		set -gx BAT_THEME "Catppuccin Latte"
		if command -v kitty > /dev/null
			kitty +kitten themes --reload-in=all Catppuccin-Latte
		end
	else
		if [ (uname) = "Darwin" ]
			osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
		end
		set -g theme_color_scheme zenburn
		set -gx BAT_THEME "Catppuccin Mocha"
		if command -v kitty > /dev/null
			kitty +kitten themes --reload-in=all Catppuccin-Mocha
		end
	end
end
