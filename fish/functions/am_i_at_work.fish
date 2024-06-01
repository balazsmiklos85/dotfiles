
function am_i_at_work
    if [ (uname) = "Darwin" ]
        set wifi_ssid (networksetup -getairportnetwork en0 | cut -d ":" -f 2 | string trim)
        if [ "$wifi_ssid" = "FN-BYOD" ]
            return 0
        else
            return 1
        end
    else
        return 2
    end
end
