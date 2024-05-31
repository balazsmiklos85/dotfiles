
function switch_light
    set network_name (networksetup -getairportnetwork en0 | cut -d ":" -f 2 | string trim)
    set light_network "FN-BYOD"

    echo "The Wi-Fi network name is '$network_name'..."

    if [ "$network_name" = "$light_network" ]
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
    else
        osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
    end
end
