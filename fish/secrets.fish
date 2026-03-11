#!/usr/bin/env fish

if command -v pass >/dev/null
    set -xg SESSION_SECRET (pass show book_club/session_secret 2>/dev/null)
end
