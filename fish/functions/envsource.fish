function envsource
    # Originally from: https://github.com/ngladkikh/fish_env/blob/master/load.fish
    set -l file (string trim $argv[1]) # Trim whitespace from the first argument
    if test -z "$file" # Check if the file variable is empty
        set file .env # Default to ".env" if no argument is provided
    end

    if not test -e $file
        return
    end
    while read -la line
        if not string match -q "#*" $line
            set -l key (string trim (string split -m1 "=" $line)[1])
            set -l value (string trim (string split -m1 "=" $line)[2..])
            if test -n "$key"
                echo "Setting $key from $file..."
                set -xg $key (string join "=" $value | string trim)
            end
        end
    end <$file

end
