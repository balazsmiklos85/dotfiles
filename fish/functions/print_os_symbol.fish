function print_os_symbol
    if is_wsl
        echo "󰍲 "
    else if test (uname) = Darwin
        echo " "
    else if test -f /etc/os-release; and grep -q openSUSE /etc/os-release
        echo " "
    else if test (uname) = Linux
        echo " "
    else if string match -q "*MINGW*" (uname -a); or string match -q "*MSYS*" (uname -a)
        echo "󰍲 "
    else
        echo "? "
    end
end
