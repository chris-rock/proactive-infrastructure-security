.PHONY: install start dev build docker-build docker-run

install:
	npm install

start:
	npm start

dev:
	npm run dev

build:
	docker build -t npm-aws-demo .

docker-run:
	docker run -p 3000:3000 npm-aws-demo

test/lint:
	semgrep scan .

all: install build
