function base64_encode
    set plain_string $argv[1]
    echo (echo -n $plain_string | base64)
end

