#!/usr/bin/env fish

set -xg SONARCLOUD_TOKEN (pass show token/sonarcloud 2>/dev/null)

