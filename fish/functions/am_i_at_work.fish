
function am_i_at_work
    if [ "$OSTYPE" = "darwin" ]
        set wifi_ssid (networksetup -getairportnetwork en0 | cut -d ":" -f 2 | string trim)
        if [ "$wifi_ssid" = "FN-BYOD" ]
            return 1
        else
            return 0
        end
    else
        return 0
    end
end
