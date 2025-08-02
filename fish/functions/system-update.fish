#!/usr/bin/fishAdd commentMore actions

function system-update
    ansible-playbook --ask-become-pass ~/.config/ansible/main.yaml
    set distro (grep "^NAME" /etc/os-release | cut -d '=' -f 2)
    if test "$distro" = '"openSUSE Tumbleweed"'
        sudo zypper dist-upgrade --no-recommends
    else if test "$distro" = '"openSUSE Leap"'
        sudo zypper update --no-recommends
    else
        echo "Unsupported distribution: $distro"
    end
    zypper ps -s
    if command -v flatpak >/dev/null 2>&1
        flatpak update
    end
end

