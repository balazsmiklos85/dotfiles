#!/usr/bin/fish

function gw
    if command -v gradle >/dev/null
        envsource .env
        if command -v nvm >/dev/null
            nvm use
        end
        echo "Using the installed Gradle."
        gradle $argv
    else if test -x "./gradlew"
        envsource .env
        if command -v nvm >/dev/null
            nvm use
        end
        echo "Using the Gradle wrapper."
        ./gradlew $argv
    else
        echo "No Gradle installation or wrapper not found."
    end
end
