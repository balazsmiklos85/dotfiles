#!/usr/bin/fish

function system-update
    sudo zypper refresh
    sudo zypper install --no-recommends \
        bat \
        dust \
        encfs \
        fd \
        fish \
        fzf \
        git \
        git-delta \
        go \
        graphviz \
        jq \
        lsd \
        lynx \
        mc \
        neomutt \
        neovim \
        password-store \
        podman \
        powerline-fonts \
        powertop \
        ripgrep \
        symbols-only-nerd-fonts \
        syncthing \
        thefuck \
        traceroute \
        w3m \
        youtube-dl \
        zellij \
        zoxide
    if not [ -z "$DISPLAY" ]
        sudo zypper install --no-recommends \
            evince-plugin-djvudocument \
            MozillaFirefox \
            MozillaThunderbird
    end
    sudo zypper remove -u \
        icewm \
        gvfs-backend-samba \
        samba \
        samba-ad-dc-libs \
        samba-client \
        samba-libs \
        samba-libs-python3 \
        vim \
        vim-data \
        vim-data-common 2>/dev/null

    set distro (grep "^NAME" /etc/os-release | cut -d '=' -f 2)
    if test "$distro" = '"openSUSE Tumbleweed"'
        sudo zypper dist-upgrade --no-recommends
    else if test "$distro" = '"openSUSE Leap"'
        sudo zypper update --no-recommends
    else
        echo "Unsupported distribution: $distro"
    end
end
