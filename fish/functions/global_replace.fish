function global_replace
    rg -l -- "$argv[1]" | xargs sd -- "$argv[1]" "$argv[2]"
end
