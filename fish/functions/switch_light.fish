function switch_light
    am_i_at_work

    if test $status -eq 0
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
        set -g theme_color_scheme light
    else if [ (uname) = "Darwin" ]
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
        set -g theme_color_scheme dark
    end
end
