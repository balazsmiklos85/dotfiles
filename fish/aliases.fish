if command -v thefuck >/dev/null
    thefuck --alias | source
end

if command -v bat >/dev/null
    alias cat="bat --style plain"
end

if command -v flatpak >/dev/null
    alias zed 'flatpak run dev.zed.Zed'
end

if command -v gh >/dev/null
    alias request_review 'gh pr comment --body "/request-review"'
    alias watch_checks 'gh pr checks --json "name,state" | jq \'.[] | select(.name == "Build And Test")| .state\''
end

if command -v lsd >/dev/null
    alias ll 'lsd -Fl'
    alias lt 'lsd -Ft'
    alias tree 'lsd --tree'
else
    alias ll 'ls -ll'
end

if command -v timew >/dev/null
    alias start_work 'timew start work'
    alias stop_work 'timew stop work'
end

alias :w 'echo "Dammit Jim, I\'m a fish, not a vi!"; test 0 -eq 1'
alias :wq 'echo "Dammit Jim, I\'m a fish, not a vi!"; test 0 -eq 1'
