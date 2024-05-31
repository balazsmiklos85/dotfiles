
function switch_light
    if am_i_at_work
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
        set -g theme_color_scheme light
    else
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
        set -g theme_color_scheme dark
    end
end
