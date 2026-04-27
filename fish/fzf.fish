if command -v fzf >/dev/null
    set -gx FZF_DEFAULT_COMMAND "fd . $HOME"
    set -gx FZF_DEFAULT_OPTS "--preview 'fzf_smart_preview {}'"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd -t d . $HOME"

    fzf --fish 2>/dev/null | source
    alias fzf_add="git status -s | fzf -m --preview 'fzf_smart_preview {2}' | awk '{print \$2}' | xargs git add"
    alias fzf_cat="fd --type f . | fzf --preview 'fzf_smart_preview {}' | xargs -ro bat --style plain --color always"
    alias fzf_checkout_branch="git checkout (git branch | rg -v '\\*' | sd '^\\s|\\s+\$' '' | fzf | sd '^\\s|\\s+\$' '')"
    alias fzf_checkout_file="fd --type f . | fzf --preview 'fzf_smart_preview {}' | xargs -I {}  git checkout main -- {}"
    alias fzf_cherry_pick="git log --oneline | fzf --preview 'git show {1}' | awk 'print \$1}' | xargs git cherry-pick"
    alias fzf_config="nvim (fd --hidden --no-ignore --type f . ~/.config | fzf)"
    alias fzf_edit="fd --type f . | fzf --preview 'fzf_smart_preview {}' | xargs nvim"
    if command -v zypper >/dev/null
        alias fzf_install="zypper search | rg -v -i '^i' | rg -v 'srcpackage' | sed -n '/^---/,\$p' |  awk '{print \$2}' | fzf -m --preview 'zypper info {1} | sed -n \'/^---/,\$p\'' | xargs sudo zypper install --no-recommends"
        alias fzf_uninstall="zypper search | rg -i '^i' | sed -n '/^---/,\$p' |  awk '{print \$2}' | fzf -m --preview 'zypper info {1} | sed -n \'/^---/,\$p\'' | xargs sudo zypper remove -u"
    else
        alias fzf_install="brew search '/./' | rg -v '(deprecated|disabled)' | fzf | xargs brew install"
        alias fzf_uninstall="brew list | fzf | xargs brew uninstall"
    end
    alias fzf_kill="ps -ef | fzf -m | awk '{print \$2}' | xargs kill -9"
    alias fzf_mail="neomutt -F (fd '.*rc' ~/.config/neomutt/ | fzf)"
    alias fzf_restart="systemctl list-units --type=service | fzf |  awk '{print \$1}' | xargs -r sudo systemctl restart"
    alias fzf_show_commit="git log --oneline | fzf --preview 'git show {1}' | awk '{print \$1}' | xargs git show"
    alias fzf_ssh="rg . ~/.ssh/known_hosts | awk '{print \$1}' | uniq | fzf | xargs ssh"
    alias fzf_stop_docker="docker ps --format '{{.ID}}\\t{{.Names}}\\t{{.Image}}' | fzf -m --preview 'docker logs {1}' | awk '{print \$1}' | xargs -r docker stop"
    alias fzf_stop_podman="podman ps --format '{{.ID}}\\t{{.Names}}\\t{{.Image}}' | fzf -m --preview 'podman logs {1}' | awk '{print \$1}' | xargs -r podman stop"
    alias fzf_test="rg '^\\s*(public){0,1} void \\w+' | rg '(Test|IT)\\.java' | sd '.*/([^/]+)\\.java:\\s+(public)?\\s+void\\s+([\\w]+).*' '\$1.\$3' | fzf | xargs gw :service:test --tests"
    alias fzf_test_class="rg '^\\s*(public){0,1} void \\w+' | rg '(Test|IT)\\.java' | sd '.*/([^/]+)\\.java:\\s+(public)?\\s+void\\s+([\\w]+).*' '\$1' | uniq | fzf | xargs gw :service:test --tests"
end
