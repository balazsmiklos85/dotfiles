#!/usr/bin/fish

function kill_docker
	echo '> docker kill $(docker ps -q)'
	docker kill $(docker ps -q)
end

