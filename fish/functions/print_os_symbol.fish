function print_os_symbol
    if not set -q OS_SYMBOL
        if is_wsl
            set -U OS_SYMBOL "󰍲"
        else if test (uname) = Darwin
            set -U OS_SYMBOL ""
        else if test -f /etc/os-release; and rg -q openSUSE /etc/os-release
            set -U OS_SYMBOL ""
        else if test (uname) = Linux
            set -U OS_SYMBOL ""
        else if string match -q "*MINGW*" (uname -a); or string match -q "*MSYS*" (uname -a)
            set -U OS_SYMBOL "󰍲"
        else
            set -U OS_SYMBOL "?"
        end
    end
    echo $OS_SYMBOL
end
