.PHONY: install start dev build test docker/build docker/run ecr/login ecr/push-release ecr/build-multi-arch ecr/push-multi-archtf/init tf/plan tf/apply tf/destroy

# AWS ECR variables
AWS_ACCOUNT_ID ?= your-aws-account-id
AWS_REGION ?= us-east-1
ECR_REPOSITORY ?= your-ecr-repository-name

# Terraform variables
TF_DIR = ./terraform
TF_VARS ?=

install:
	npm install

start:
	npm start

dev:
	npm run dev

docker/build:
	docker build -t npm-aws-demo .

docker/run:
	docker run -p 3000:3000 npm-aws-demo

test/lint:
	npx eslint src
	tflint --chdir ./terraform

test/sast:
	semgrep scan .

# only for testing, github actions are used for production
ecr/login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

# only for testing, github actions are used for production
ecr/push: docker/build ecr/login
	docker tag npm-aws-demo:latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPOSITORY):latest
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPOSITORY):latest

ecr/build-multi-arch:
	docker buildx create --use
	docker buildx build --platform linux/amd64,linux/arm64 -t $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPOSITORY):latest .

ecr/push-multi-arch: ecr/build-multi-arch
	docker buildx build --platform linux/amd64,linux/arm64 -t $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPOSITORY):latest --push .

tf/init:
	cd $(TF_DIR) && terraform init

tf/plan:
	cd $(TF_DIR) && terraform plan $(TF_VARS)

tf/apply:
	cd $(TF_DIR) && terraform apply $(TF_VARS)

tf/destroy:
	cd $(TF_DIR) && terraform destroy $(TF_VARS)

all: install build
