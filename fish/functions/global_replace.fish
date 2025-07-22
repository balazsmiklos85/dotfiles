function global_replace
    rg -lF -- "$argv[1]" | xargs sed -i "s#$argv[1]#$argv[2]#g"
end
