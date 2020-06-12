#!/usr/bin/make
SHELL=/bin/bash

.PHONY: all
all: install build

.PHONY: install
install:
	if [ ! -f /usr/local/bin/dive ]; then scripts/install-dive.sh; else echo "Dive installed, taking no action"; fi;

.PHONY: size-base
size-base:
	dive build --target base -t test/kali:base .

.PHONY: size-wordlists
size-wordlists:
	dive build --target wordlists -t test/kali:wordlists .

.PHONY: size
size:
	dive build -t test/kali:full .

.PHONY: build
build: build-all

.PHONY: build-all
build-all: build-base build-full

.PHONY: base
base:
	docker build --target base -t test/kali:base .

.PHONY: full
full:
	docker build --target wordlists -t test/kali:full .
