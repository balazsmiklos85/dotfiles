
function am_i_at_work
    if [ (uname) = "Darwin" ]
        set home_ip (ifconfig | rg 'inet\s' | rg '192.168.0')
        if [ "$home_ip" = "" ]
            return 0
        else
            return 1
        end
    else
        return 2
    end
end
