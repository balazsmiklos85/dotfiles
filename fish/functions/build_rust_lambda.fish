#!/usr/bin/fish
function build_rust_lambda
    echo 'Cleaning up target...'
    rm -rf target/
    echo 'Cleanup done.'
    echo 'Compilation...'
    podman run --rm -v $(pwd):/lambda:Z rust:1.84-alpine sh -c "apk add --no-cache musl gcc libc-dev pkgconfig openssl-dev openssl-libs-static && cd /lambda && cargo build --release --target x86_64-unknown-linux-musl"
    echo 'Compilation done.'
    echo 'Renaming executable...'
    mv target/x86_64-unknown-linux-musl/release/$(basename $PWD) target/x86_64-unknown-linux-musl/release/bootstrap
    echo 'File renamed.'
    echo 'Creating zip file...'
    zip -j target/bootstrap.zip target/x86_64-unknown-linux-musl/release/bootstrap
    echo 'Done.'
end
