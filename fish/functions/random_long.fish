function random_long
    set num1 (math (random))
    set num2 (math (random))
    set long_num (math "$num1 * (2^32) + $num2")
    set sign (math (random) % 2)
    if test $sign -eq 0
        set long_num (math $long_num \* -1)
    end
    echo $long_num
end
