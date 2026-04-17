#!/usr/bin/fish

function disable_ipv6
	sudo sh -c 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6'
end

