function switch_light
    am_i_at_work

    if test $status -eq 0
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
        alacritty msg config "$(cat ~/.config/alacritty/catppuccin-latte.toml)"
        alias delta "delta --light"
        fish_config theme choose "Catppuccin Mocha" --color-theme=light
        set -gx BAT_THEME "Catppuccin Latte"
        set -gx LS_COLORS "di=34:ln=36:so=35:pi=33:ex=32:bd=34;43:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;42:st=37;44:er=31"
        set -gx STARSHIP_CONFIG "$HOME/.config/starship_light.toml"
        alias zellij "zellij options --theme catppuccin-latte"
    else
        if [ (uname) = Darwin ]
            osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
            alacritty msg config "$(cat ~/.config/alacritty/catppuccin-mocha.toml)"
        else if pgrep -x alacritty >/dev/null
            alacritty msg config "$(cat ~/.config/alacritty/catppuccin-mocha.toml)"
        end
        alias delta "delta --dark"
        fish_config theme choose "Catppuccin Mocha" --color-theme=dark 2>/dev/null || fish_config theme choose "Catppuccin Mocha"
        set -gx BAT_THEME "Catppuccin Mocha"
        set -ge LS_COLORS
        set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
        alias zellij "zellij options --theme catppuccin-mocha"
    end
end
