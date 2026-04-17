function is_wsl
    if test -d /mnt/c
        return 0
    end
    return 1
end
