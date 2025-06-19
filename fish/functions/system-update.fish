#!/usr/bin/fish

function system-update
    ansible-playbook --ask-become-pass ~/.config/ansible/main.yaml

    if is_wsl
        echo "Running in WSL..."
    else if is_vm
        if ! command -v xhost >/dev/null
            set packages_to_install $packages_to_install xhost
        end
    else
    end

    if test (count $packages_to_install) -gt 0
        sudo zypper install --no-recommends $packages_to_install
    else
        echo "Nothing to install."
    end
    if test (count $packages_to_remove) -gt 0
        sudo zypper remove -u $packages_to_remove
    else
        echo "Nothing to remove."
    end

    set distro (grep "^NAME" /etc/os-release | cut -d '=' -f 2)
    if test "$distro" = '"openSUSE Tumbleweed"'
        sudo zypper dist-upgrade --no-recommends
    else if test "$distro" = '"openSUSE Leap"'
        sudo zypper update --no-recommends
    else
        echo "Unsupported distribution: $distro"
    end

    zypper ps -s
end
