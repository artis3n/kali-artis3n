#!/usr/bin/make

.PHONY: install
install:
	if [ ! -f /usr/local/bin/dive ]; then wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb && sudo apt install ./dive_0.9.2_linux_amd64.deb && rm dive*.deb; else echo "Dive installed, taking no action"; fi;

.PHONY: size
size:
	dive build --no-cache -t test/kali .
