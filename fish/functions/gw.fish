#!/usr/bin/fish

function gw
	if test -x "./gradlew"
        envsource .env
		./gradlew $argv
	else
		echo "Gradle wrapper not found in the current directory."
	end
end

