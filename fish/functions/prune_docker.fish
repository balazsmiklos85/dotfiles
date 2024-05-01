#!/usr/bin/fish

function prune_docker
	echo '> docker system prune --all --force --volumes'
	docker system prune --all --force --volumes
end

