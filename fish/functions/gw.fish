#!/usr/bin/fish

function gw
    if command -v gradle >/dev/null
        envsource .env
        if command -v nvm >/dev/null
            nvm use
        end
        gradle $argv
    else if test -x "./gradlew"
        envsource .env
        if command -v nvm >/dev/null
            nvm use
        end
        ./gradlew $argv
    else
        echo "Gradle wrapper not found in the current directory."
    end
end
