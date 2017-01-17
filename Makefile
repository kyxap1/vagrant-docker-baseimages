.PHONY: all setup build generate test

all: build generate

setup:
	@gem install -g

build:
	@rake build

generate:
	@rake generate

test:
	@rake tests

