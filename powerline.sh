#!/bin/sh

if [[ -f $HOME/.env/powerline ]]; then
	echo "Looks like Powerline fonts have already been installed. Bye."
    exit 0
fi

echo "Installing Powerline fonts..."

if [[ ! -d $HOME/fonts ]]; then
	git clone https://github.com/powerline/fonts.git --depth=1
	# Run the installer:
	cd fonts; ./install.sh
	# Touch a file to say we are done:
	touch .env/powerline
else
	echo "Powerline fonts are already downloaded. Did you run the installer?
fi

exit 0
