#!/usr/bin/fish

function kill_docker
    echo '> docker ps -q | xargs -n 1 -r docker kill'
    docker ps -q | xargs -n 1 -r docker kill
end
