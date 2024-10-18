#!/usr/bin/fish

function gw
    if test -x gradle
        envsource .env
        nvm use
        gradle $argv
    else if test -x "./gradlew"
        envsource .env
        nvm use
        ./gradlew $argv
    else
        echo "Gradle wrapper not found in the current directory."
    end
end
