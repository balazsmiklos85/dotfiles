set theme_color_scheme zenburn

if command -v thefuck > /dev/null
    thefuck --alias | source
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if [ (uname) = "Darwin" ]
    # Commands to run only on MacOS can go here
    set -x theme_powerline_fonts no
end
