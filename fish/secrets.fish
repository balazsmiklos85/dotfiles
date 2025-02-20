#!/usr/bin/env fish

if command -v pass >/dev/null 
   set -xg GEMINI_API_KEY (pass show token/gemini 2>/dev/null)
   set -xg SONARCLOUD_TOKEN (pass show token/sonarcloud 2>/dev/null)
end
