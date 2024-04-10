function git_uncommit
    set n $argv[1]

    if test (count $argv) -ne 1; or not string match -qr '^[0-9]+$' -- $n
        echo "Usage: git_uncommit <n>"
        return 1
    end

    git reset HEAD~$n
end

