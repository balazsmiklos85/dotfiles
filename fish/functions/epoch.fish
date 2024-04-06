#!/usr/bin/fish

function epoch
	set date $argv

	if test -z "$date"
		echo "Usage: epoch <YYYY-MM-DD HH:MM:SS>"
		return
	end

	echo (date --date="$date" +"%s")
end

