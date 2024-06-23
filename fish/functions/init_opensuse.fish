#!/usr/bin/fish

function init_opensuse
	sudo zypper install --no-recommends \
		bat \
		docker \
		docker-compose \
		encfs \
		fd \
		fish \
		git \
		git-delta \
		graphviz \
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
		telnet \
		thefuck \
		w3m \
		youtube-dl
	if not [ -z "$DISPLAY" ]
		sudo zypper install --no-recommends \
			evince-plugin-djvudocument \
			firefox \
			thunderbird
	end
end

