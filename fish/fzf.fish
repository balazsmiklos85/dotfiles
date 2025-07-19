if command -v fzf >/dev/null
    set -gx FZF_DEFAULT_COMMAND "fd . $HOME"
    set -gx FZF_DEFAULT_OPTS "--preview 'fzf_smart_preview {}'"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"

    fzf --fish 2>/dev/null | source
    alias fuzzy_add="git status -s | fzf -m --preview 'fzf_smart_preview {2}' | awk '{print \$2}' | xargs git add"
    alias fuzzy_cat="fd --type f . | fzf --preview 'fzf_smart_preview {}' | xargs -ro bat --style plain --color always"
    alias fuzzy_checkout="git checkout (git branch | fzf)"
    alias fuzzy_cherry_pick="git log --oneline | fzf --preview 'git show {1}' | awk 'print \$1}' | xargs git cherry-pick"
    alias fuzzy_config="nvim (fd --hidden --no-ignore --type f . ~/.config | fzf)"
    alias fuzzy_install="zypper search | rg -v -i '^i' | rg -v 'srcpackage' | sed -n '/^---/,\$p' |  awk '{print \$2}' | fzf -m --preview 'zypper info {1} | sed -n \'/^---/,\$p\'' | xargs sudo zypper install --no-recommends"
    alias fuzzy_kill="ps -ef | fzf -m | awk '{print \$2}' | xargs kill -9"
    alias fuzzy_restart="systemctl list-units --type=service | fzf |  awk '{print \$1}' | xargs -r sudo systemctl restart"
    alias fuzzy_show_commit="git log --oneline | fzf --preview 'git show {1}' | awk '{print \$1}' | xargs git show"
    alias fuzzy_ssh="rg 'Hostname ' ~/.ssh/config | awk '{print \$2}' | fzf | xargs ssh"
    alias fuzzy_stop_docker="docker ps --format '{{.ID}}\\t{{.Names}}\\t{{.Image}}' | fzf -m --preview 'docker logs {1}' | awk '{print \$1}' | xargs -r docker stop"
    alias fuzzy_stop_podman="podman ps --format '{{.ID}}\\t{{.Names}}\\t{{.Image}}' | fzf -m --preview 'podman logs {1}' | awk '{print \$1}' | xargs -r podman stop"
    alias fuzzy_uninstall="zypper search | rg -i '^i' | sed -n '/^---/,\$p' |  awk '{print \$2}' | fzf -m --preview 'zypper info {1} | sed -n \'/^---/,\$p\'' | xargs sudo zypper remove -u"
end
