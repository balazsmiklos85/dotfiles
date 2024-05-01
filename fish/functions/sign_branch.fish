#!/usr/bin/fish

function sign_branch
	git stash
	git rebase --exec 'git commit --amend --no-edit -n -S' -i master
	git stash pop
end

