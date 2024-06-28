#!/usr/bin/fish

function epoch
	set date $argv

	if test -z "$date"
		echo "Usage: epoch <YYYY-MM-DD HH:MM:SS>"
		return
	end

	if [ (uname) = "Darwin" ]
		echo (date -j -f "%F %T" "$date" +%s)
	else
		echo (date --date="$date" +"%s")
	end
end

