function is_wsl
    set microsoft_kernel (uname -r | grep -i microsoft)
    if test -n "$microsoft_kernel"
        return 0
    end
    return 1
end
