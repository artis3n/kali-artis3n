#!/usr/bin/make
SHELL=/bin/bash

.PHONY: all
all: install build

.PHONY: install
install:
	if [ ! -f /usr/local/bin/dive ]; then scripts/install-dive.sh; else echo "Dive installed, taking no action"; fi;

.PHONY: size-base
size-base:
	dive build --no-cache --target base -t test/kali .

.PHONY: size-wordlists
size-wordlists:
	dive build --no-cache --target wordlists -t test/kali .

.PHONY: size
size:
	dive build --no-cache -t test/kali .

.PHONY: build
build: build-all

.PHONY: build-all
build-all: build-base build-full

.PHONY: build-base
build-base:
	docker build --target base -t test/kali:base .

.PHONY: build-full
build-full:
	docker build --target wordlists -t test/kali:full .
