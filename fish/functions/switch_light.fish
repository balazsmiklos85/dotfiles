function switch_light
	am_i_at_work

	if test $status -eq 0
		osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
		set -g theme_color_scheme "Catppuccin Latte"
		set -gx BAT_THEME "Catppuccin Latte"
	else
		if [ (uname) = "Darwin" ]
			osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
		end
		set -g theme_color_scheme "Catppuccin Mocha"
		set -gx BAT_THEME "Catppuccin Mocha"
	end
end
