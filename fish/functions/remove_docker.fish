#!/usr/bin/fish

function remove_docker
	docker rmi $(docker images -q)
end

