function detect_os
    if not set -q OS_SYMBOL
        if is_wsl
            set -gx OS_SYMBOL "󰍲"
        else if set -q container
            set -gx OS_SYMBOL ""
        else if test (uname) = Darwin
            set -gx OS_SYMBOL ""
        else if test -f /etc/os-release; and rg -q openSUSE /etc/os-release
            set -gx OS_SYMBOL ""
        else if test (uname) = Linux
            set -gx OS_SYMBOL ""
        else if string match -q "*MINGW*" (uname -a); or string match -q "*MSYS*" (uname -a)
            set -gx OS_SYMBOL "󰍲"
        else
            set -gx OS_SYMBOL "?"
        end
    end

end
