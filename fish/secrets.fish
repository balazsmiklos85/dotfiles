#!/usr/bin/env fish

set directory ~/.config/fish/secrets

for file in (find $directory -name "*.token")
    set filename (basename $file .token)
    set varname (echo $filename | tr '[:lower:]' '[:upper:]')_TOKEN
    set content (cat $file)
    set -xg $varname $content
end
