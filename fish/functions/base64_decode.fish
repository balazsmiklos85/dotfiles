function base64_decode
    set encoded_string $argv[1]
    echo (echo $encoded_string | base64 --decode)
end

