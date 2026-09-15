function to_merge
    set AUTHOR balazsmiklos85

    set pr_lines (gh api "search/issues?q=is%3Apr+is%3Aopen+author%3A$AUTHOR" --jq '.items[] |
      "\(.html_url) \(.title)"')

    if test -z "$pr_lines"
        echo 'No open PRs found.'
        return
    end

    set approved_list ""

    for line in $pr_lines
        set url (echo "$line" | awk '{print $1}')
        set title (echo "$line" | cut -d' ' -f2-)

        set repo (echo "$url" | sed -n 's|https://github.com/\([^/]*\/[^/]*\)/pull/.*|\1|p')
        set num (echo "$url" | sed -n 's|.*\/pull/\([0-9]*\)|\1|p')

        if test -z "$repo" -o -z "$num"
            continue
        end

        set count (gh api "repos/$repo/pulls/$num/reviews" --jq '[.[] | select(.state == "APPROVED")] |
          length')

        if test (math "$count") -gt 0
            set -a approved_list "$url"
        end
    end

    if test -z "$approved_list"
        echo 'No approved PRs ready to merge. Open PRs:'
        for line in $pr_lines
            set url (echo "$line" | awk '{print $1}')
            set title (echo "$line" | cut -d' ' -f2-)
            echo "- $title - $url"
        end
    else
        echo "(count $approved_list) approved PR(s) ready to merge:"
        for url in $approved_list
            echo "- $url"
        end
    end
end
