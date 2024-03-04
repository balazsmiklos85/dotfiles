source ~/.config/fish/secrets.fish

set theme_color_scheme zenburn

set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.local/bin/scripts $PATH
set -gx PATH $HOME/.nvm $PATH
set -gx PATH $HOME/.sdkman $PATH
set -gx PATH $HOME/projects/hybris/core-customize/hybris/bin/platform/apache-ant/bin $PATH

alias gw ./gradlew

if [ (uname) = "Darwin" ]
    # Commands to run only on MacOS can go here
    set -x theme_powerline_fonts no
    set -gx PATH /opt/homebrew/bin $PATH
    set -gx PATH /opt/homebrew/opt/ruby/bin $PATH
else
    set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH
end

if command -v thefuck > /dev/null
    thefuck --alias | source
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

