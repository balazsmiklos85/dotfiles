function fzf_smart_preview
    if test -d "$argv[1]"
        lsd --color=always --all --icon=always "$argv[1]"
    else if test -f "$argv[1]"
        bat --color=always --line-range :25 "$argv[1]"
    else
        echo "Cannot preview '$argv[1]'"
    end
end
