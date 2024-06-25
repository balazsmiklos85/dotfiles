#!/usr/bin/fish

function init_opensuse
	sudo zypper install --no-recommends \
		bat \
		docker \
		docker-compose \
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
		w3m \
		youtube-dl \
		zoxide
	if not [ -z "$DISPLAY" ]
		sudo zypper install --no-recommends \
			evince-plugin-djvudocument \
			hyprland \
			hyprpaper \
			hyprshot \
			kitty \
			kitty-terminfo \
			MozillaFirefox \
			MozillaThunderbird \
			waybar
	end
end

