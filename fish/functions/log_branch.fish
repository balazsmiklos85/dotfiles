#!/usr/bin/fish

function log_branch
	git log master.. --pretty=oneline
end

