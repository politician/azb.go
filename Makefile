SHELL := /bin/bash

name := azb
version := $(shell cat VERSION)
project := $(name)-$(version)
tmp_dir := .build/tmp
proj_tmp_dir := $(tmp_dir)/$(project)

.PHONY: all build clean destroy

all: build

build:
	goop go build -o $(name) src/cmd/$(name)/main.go
	mkdir -p tmp/ && mv $(name) tmp/

test:
	goop go test europium.io/x/azb

clean:
	find . "-name" ".DS_Store" -exec rm {} \;
	goop go clean
	cd tmp && rm -rf *
	rmdir tmp

destroy: clean
	rm Goopfile.lock
	cd .vendor && rm -rf * && cd .. && rmdir .vendor

install:
	goop install

archive: clean build
	if [ -d $(tmp_dir) ]; then cd $(tmp_dir) && rm -rf *; fi;
	mkdir -p $(proj_tmp_dir)/bin
	cp README.md $(proj_tmp_dir)
	cp tmp/$(name) $(proj_tmp_dir)/bin
	cd $(tmp_dir) && tar -cvzf ../$(project).tar.gz $(project)

