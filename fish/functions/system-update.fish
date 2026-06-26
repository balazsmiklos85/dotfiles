#!/usr/bin/fishAdd commentMore actions

function system-update
    if [ (uname) = Darwin ]
        brew upgrade
        if [ -f "$HOME/.config/Brewfile" ]
            brew bundle install --file="$HOME/.config/Brewfile"
        end
    else
        set distro (grep "^NAME" /etc/os-release | cut -d '=' -f 2)
        if test "$distro" = '"openSUSE Tumbleweed"'
            sudo zypper dist-upgrade --no-recommends
            zypper ps -s
        else if test "$distro" = '"openSUSE Leap"'
            sudo zypper update --no-recommends
            zypper ps -s
        else
            echo "Unsupported distribution: $distro"
        end
        if command -v flatpak >/dev/null 2>&1
            flatpak update
        end
    end
end
