function balance --description 'Show yearly TimeWarrior balance vs expected hours'
    set -l expected_daily_hours 7.5
    set -l excluded_days 19700101 20260817

    set -l uniq_dates (timew export :year | jq -r '.[].start[0:8]' | sort -u) # TODO `timew export` ran twice, call only once: `set -l year_export (timew export :year)`

    set -l work_days 0
    for d in $uniq_dates
        if contains -- $d $excluded_days
            continue
        end
        set -l wday (date -j -f '%Y%m%d' $d +%w) # TODO N+1 date forks (up to ~365) for weekday. Fold into jq, e.g. compute wday via strptime("%Y%m%d") | mktime | strflocaltime("%w") and filter weekends/excluded in one pass.
        if test $wday -eq 0 -o $wday -eq 6
            continue
        end
        set work_days (math $work_days + 1)
    end

    set -l now_epoch (date +%s)
    set -l total_seconds (TZ=UTC timew export :year | TZ=UTC jq -r --argjson now $now_epoch '[.[] | ((.end | if . then
    strptime("%Y%m%dT%H%M%SZ") | mktime else $now end) - (.start | strptime("%Y%m%dT%H%M%SZ") | mktime))] | add // 0') # TODO First `TZ=UTC` on timew is a no-op.

    set -l balance_raw (math "$total_seconds / 3600 - $work_days * $expected_daily_hours")

    set -l work_until (date -r (math -s0 "$now_epoch - $balance_raw * 3600") '+%Y-%m-%d %H:%M')

    echo "Balance: (printf '%.2f' $balance_raw) hours" # TODO use `printf "Balance: %.2f hours\n" $balance_raw` maybe?
    echo "Work until: $work_until"
end
