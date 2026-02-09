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
    alias watch_checks 'gh pr checks --watch'
end

alias gw_compile 'gw compileJava compileTestJava --console=plain 2>&1 | rg -A 4 -B 1 \'java:\d+: error\''
alias gw_test 'gw clean test --console=plain 2>&1 | rg -v \'> Task|BUILD FAILED\' | rg \'FAILED|See the report at\''
alias gw_it 'gw test --console=plain 2>&1 | rg -v \'( at |failure threshold)\' | rg -v \'^$\' | rg -A 5 \'ApplicationContext\''

if command -v timew >/dev/null
    alias start_work 'timew start work'
    alias stop_work 'timew stop work'
    alias balance 'timew balance :year'
end

alias :w 'echo "Dammit Jim, I\'m a fish, not a vi!"; test 0 -eq 1'
alias :wq 'echo "Dammit Jim, I\'m a fish, not a vi!"; test 0 -eq 1'
