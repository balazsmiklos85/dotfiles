function delete_old_branches
    set old_enough_limit (math $argv[1] 2>/dev/null)
    or set old_enough_limit 2
    set local_branches (git branch -l --sort=-committerdate --format='%(refname:short)')
    set to_delete ()
    set old_enough 0
    set branches_to_keep 'release\|integration\|master\|main'
    for branch in $local_branches
        if echo $branch | grep -q -E $branches_to_keep
            set old_enough (math $old_enough+1)
        end
        if test $old_enough -ge $old_enough_limit
            set to_delete $to_delete $branch
        end
    end
    for branch in $to_delete
        if not echo $branch | grep -q -E $branches_to_keep
            echo "removing local branch: $branch"
            git branch -D $branch
        end
    end
    set local_branches (git branch -l --sort=-committerdate --format='%(refname:short)')
    echo "remaining branches:\n$local_branches"
end

