SHELL := /bin/bash
include .env
export

all:
	@echo Gatsby project for ${REPOSITORY} blog page.

build:
	gatsby build --prefix-paths

current-date-tz:
	date +%Y-%m-%dT%H:%M:%S.000Z

deploy-gh-pages:
	gatsby build --prefix-paths && gh-pages -d public -r https://${TOKEN}@github.com${REPOSITORY}

develop:
	gatsby develop

install-global:
	sudo npm install -g gatsby gh-pages