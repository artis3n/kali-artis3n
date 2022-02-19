#!/usr/bin/make
SHELL=/bin/bash

.PHONY: all
all: install build

.PHONY: size-base
size-base:
	dive build --target base -t test/kali:base .

.PHONY: size-wordlists
size-wordlists:
	dive build --target wordlists -t test/kali:wordlists .

.PHONY: size
size: size-wordlists

.PHONY: build
build: base wordlists

.PHONY: base
base:
	docker build --target base -t test/kali:base .

.PHONY: wordlists
wordlists:
	docker build --target wordlists -t test/kali:wordlists .

.PHONY: test
test:
	dgoss run -t test/kali:wordlists

.PHONY: test-edit
test-edit:
	dgoss edit -t test/kali:wordlists

.PHONY: lint
lint:
	docker run --rm -i -v $$(pwd)/.hadolint.yaml:/.config/hadolint.yaml ghcr.io/hadolint/hadolint < Dockerfile
