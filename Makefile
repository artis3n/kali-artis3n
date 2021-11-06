#!/usr/bin/make
SHELL=/bin/bash

.PHONY: all
all: install build

.PHONY: install
install:
	if [ ! -f /opt/homebrew/bin/dive ]; then brew install dive; fi;

.PHONY: size-base
size-base:
	dive build --target base -t test/kali:base .

.PHONY: size-wordlists
size-wordlists:
	dive build --target wordlists -t test/kali:wordlists .

.PHONY: size
size:
	dive build -t test/kali:latest .

.PHONY: build
build: base wordlists

.PHONY: old-build
old-build: old-base old-wordlists

.PHONY: base
base:
	packer build -only="kali-base.docker.kali-base" -var 'final_image_name=test/kali' docker.pkr.hcl

.PHONY: wordlists
wordlists:
	packer build -only="kali-final.docker.kali-final" -var 'final_image_name=test/kali' docker.pkr.hcl

.PHONY: old-base
old-base:
	docker build --target base -t test/kali:old-base .

.PHONY: old-wordlists
old-wordlists:
	docker build --target wordlists -t test/kali:old-wordlists .
