#!/usr/bin/fish

function tf
    if command -v terraform >/dev/null
        envsource .env
        terraform $argv
    else
        echo "No Terraform installation found."
    end
end
