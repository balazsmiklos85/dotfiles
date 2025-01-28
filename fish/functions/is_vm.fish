function is_vm
    set vm (lsmod | grep vbox)
    if test -n "$vm"
        return 0
    end
    return 1
end
