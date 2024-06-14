source ~/.config/fish/secrets.fish

set -g theme_color_scheme zenburn

set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.local/bin/scripts $PATH
set -gx PATH $HOME/.nvm $PATH
set -gx PATH $HOME/.sdkman $PATH

if [ (uname) = "Darwin" ]
    set -gx PATH /opt/homebrew/bin $PATH
    set -gx PATH /opt/homebrew/opt/ruby/bin $PATH
    set -gx PATH $HOME/DEV/projects/hybris/core-customize/hybris/bin/platform/apache-ant/bin $PATH
    if am_i_at_work
        set -g theme_color_scheme light
    end
    set -gx GIT_EDITOR /opt/homebrew/bin/nvim
else
    set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH
end

set -gx MAILCAPS $HOME/.config/mailcap

if command -v thefuck > /dev/null
    thefuck --alias | source
end

