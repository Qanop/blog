SHELL := /bin/bash
include .env
export

all:
	@echo Gatsby project for ${REPOSITORY} blog page.

build:
	yarn run clean && gatsby build --prefix-paths

time: current-date-tz
current-date-tz:
	date +%Y-%m-%dT%H:%M:%S.000Z

gh-pages:
	yarn run clean && gatsby build --prefix-paths && gh-pages -d public -r https://${TOKEN}@github.com${REPOSITORY}

develop:
	gatsby develop

install:
	yarn install

install-tools:
	sudo npm install -g gatsby gh-pages yarn

sync-dev:
	git add . && git stash
	git checkout dev
	git rebase master && git push
	git checkout master
	git stash pop

sync-master:
	git add . && git stash
	git checkout master
	git rebase dev && git push
	git checkout dev
	git stash pop

new-post:
	./scripts/new-post.sh