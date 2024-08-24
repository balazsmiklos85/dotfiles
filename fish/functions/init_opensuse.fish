#!/usr/bin/fish

function init_opensuse
	sudo zypper install --no-recommends \
		bat \
		docker \
		docker-compose \
		dust \
		encfs \
		fd \
		fish \
		fzf \
		git \
		git-delta \
		graphviz \
		jq \
		lsd \
		lynx \
		mc \
		neomutt \
		neovim \
		password-store \
		powerline-fonts \
		powertop \
		ripgrep \
		symbols-only-nerd-fonts \
		syncthing \
		thefuck \
		traceroute \
		w3m \
		youtube-dl \
		zoxide
	if not [ -z "$DISPLAY" ]
		sudo zypper install --no-recommends \
			evince-plugin-djvudocument \
			MozillaFirefox \
			MozillaThunderbird
	end
	sudo zypper remove -u \
        samba \
        samba-client \
        vim \
        vim-data \
        vim-data-common \
        2>/dev/null
end

