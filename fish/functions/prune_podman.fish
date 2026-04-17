#!/usr/bin/fish

function prune_podman
	echo '> podman system prune --all --force --volumes'
	podman system prune --all --force --volumes
end

