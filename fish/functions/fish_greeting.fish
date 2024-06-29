function fish_greeting -d "What's up, fish?"
    set_color $fish_color_autosuggestion
    uname -nmsr

    if command -v uptime >/dev/null
        uptime
    end

    if command -v zypper >/dev/null
        echo "$(zypper lu | rg '^v \|' | wc -l) packages to update."
    end

    set_color normal
end
