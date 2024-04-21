function random_int
    set number (math (random))
    set sign (math (random) % 2)
    if test $sign -eq 0
        set number (math $number \* -1)
    end
    echo $number
end

