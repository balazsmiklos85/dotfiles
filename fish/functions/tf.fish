#!/usr/bin/fish

function tf
    if command -v terraform >/dev/null
        env2sh | source
        terraform $argv
    else
        echo "No Terraform installation found."
    end
end
