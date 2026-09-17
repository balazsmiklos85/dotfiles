#!/usr/bin/env fish

if command -v pass >/dev/null
    set -xg OPENCODE_LLM_GATEWAY_TEAM (pass show opencode_llm_gateway_team 2>/dev/null)
    set -xg SESSION_SECRET (pass show book_club/session_secret 2>/dev/null)
end
