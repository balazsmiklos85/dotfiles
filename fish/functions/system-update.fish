#!/usr/bin/fish

function system-update
    sudo zypper refresh
    set packages_to_install
    set packages_to_remove

    if ! command -v bat >/dev/null
        set packages_to_install $packages_to_install bat
    end
    if ! command -v dust >/dev/null
        set packages_to_install $packages_to_install dust
    end
    if ! command -v fd >/dev/null
        set packages_to_install $packages_to_install fd
    end
    if ! command -v fish >/dev/null
        set packages_to_install $packages_to_install fish
    end
    if ! command -v fzf >/dev/null
        set packages_to_install $packages_to_install fzf
    end
    if ! command -v git >/dev/null
        set packages_to_install $packages_to_install git
    end
    if ! command -v delta >/dev/null
        set packages_to_install $packages_to_install git-delta
    end
    if ! command -v htop >/dev/null
        set packages_to_install $packages_to_install htop
    end
    if ! command -v jq >/dev/null
        set packages_to_install $packages_to_install jq
    end
    if ! command -v lsd >/dev/null
        set packages_to_install $packages_to_install lsd
    end
    if ! command -v mc >/dev/null
        set packages_to_install $packages_to_install mc
    end
    if ! command -v nvim >/dev/null
        set packages_to_install $packages_to_install neovim
    end
    if ! command -v pass >/dev/null
        set packages_to_install $packages_to_install password-store
    end
    if ! command -v rg >/dev/null
        set packages_to_install $packages_to_install ripgrep
    end
    if ! command -v thefuck >/dev/null
        set packages_to_install $packages_to_install thefuck
    end
    if ! test -f /usr/sbin/traceroute >/dev/null
        set packages_to_install $packages_to_install traceroute
    end
    if ! command -v zellij >/dev/null
        set packages_to_install $packages_to_install zellij
    end
    if ! command -v zoxide >/dev/null
        set packages_to_install $packages_to_install zoxide
    end

    if is_wsl
        echo "Running in WSL..."
    else if is_vm
        echo "Running in a VM..."
    else
        if ! command -v encfs >/dev/null
            set packages_to_install $packages_to_install encfs
        end
        if ! command -v cargo >/dev/null
            set packages_to_install $packages_to_install cargo rust
        end
        if ! command -v go >/dev/null
            set packages_to_install $packages_to_install go
        end
        if ! command -v dot >/dev/null
            set packages_to_install $packages_to_install graphviz
        end

        if ! command -v lynx >/dev/null and ! is_wsl
            set packages_to_install $packages_to_install lynx
        end

        if ! command -v neomutt >/dev/null
            set packages_to_install $packages_to_install neomutt
        end

        if ! command -v podman >/dev/null
            set packages_to_install $packages_to_install podman
        end

        if ! fc-list | grep Powerline >/dev/null
            set packages_to_install $packages_to_install powerline-fonts symbols-only-nerd-fonts
        end
        if ! test -f /usr/sbin/powertop >/dev/null
            set packages_to_install $packages_to_install powertop
        end
        if ! command -v syncthing >/dev/null
            set packages_to_install $packages_to_install syncthing
        end
        if ! command -v youtube-dl >/dev/null
            set packages_to_install $packages_to_install youtube-dl
        end
        if ! command -v w3m >/dev/null
            set packages_to_install $packages_to_install w3m
        end
        if test -n "$DISPLAY"
            if ! command -v hyprctl >/dev/null
                set packages_to_install $packages_to_install hyprland waybar hyprshot alacritty
            end
            if ! command -v firefox >/dev/null
                set packages_to_install $packages_to_install MozillaFirefox
            end
            if ! zypper search --installed-only evince-plugin-djvudocument >/dev/null
                set packages_to_install $packages_to_install evince-plugin-djvudocument
            end
            if ! command -v thunderbird >/dev/null
                set packages_to_install $packages_to_install MozillaThunderbird
            end
        end
    end

    if command -v icewm >/dev/null
        set packages_to_remove $packages_to_remove icewm
    end
    if command -v parole >/dev/null
        set packages_to_remove $packages_to_remove parole
    end
    if command -v pragha >/dev/null
        set packages_to_remove $packages_to_remove pragha
    end
    if command -v remmina >/dev/null
        set packages_to_remove $packages_to_remove remmina
    end
    if command -v samba >/dev/null
        set packages_to_remove $packages_to_remove \
            gvfs-backend-samba \
            samba \
            samba-ad-dc-libs \
            samba-client \
            samba-client-libs \
            samba-libs \
            samba-libs-python3
    end
    if command -v vim >/dev/null
        set packages_to_remove $packages_to_remove \
            vim \
            vim-data \
            vim-data-common
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
