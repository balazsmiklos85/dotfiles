
function am_i_at_work
    if [ (uname) = "Darwin" ]
        set ip_third_octet (ifconfig | rg 'inet\s' | rg '192.168' | awk '{print $2}' | awk -F. '{print $3}')
        if [ "$ip_third_octet" != "0" ]
            return 0
        else
            return 1
        end
    else
        return 2
    end
end
