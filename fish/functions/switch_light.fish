function switch_light
    am_i_at_work

    if test $status -eq 0
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
        alacritty msg config "$(cat ~/.config/alacritty/catppuccin-latte.toml)"
        fish_config theme choose "Catppuccin Latte"
        set -gx BAT_THEME "Catppuccin Latte"
        set -gx STARSHIP_CONFIG "$HOME/.config/starship_light.toml"
        alias zellij "zellij options --theme catppuccin-latte"
    else
        if [ (uname) = Darwin ]
            osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
        end
        alacritty msg config "$(cat ~/.config/alacritty/catppuccin-mocha.toml)"
        fish_config theme choose "Catppuccin Mocha"
        set -gx BAT_THEME "Catppuccin Mocha"
        set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
        alias zellij "zellij options --theme catppuccin-mocha"
    end
end
