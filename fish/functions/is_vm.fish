function is_vm
    set vm (lsmod | grep vboxguest)
    if test -n "$vm"
        return 0
    end
    return 1
end
