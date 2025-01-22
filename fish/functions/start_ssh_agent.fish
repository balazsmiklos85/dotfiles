#!/usr/bin/fish

function start_ssh_agent
    if is_wsl
        eval (ssh-agent -c) >/dev/null
        rg -l "PRIVATE KEY" ~/.ssh | xargs -0 ssh-add >/dev/null 2>/dev/null
    end
end
