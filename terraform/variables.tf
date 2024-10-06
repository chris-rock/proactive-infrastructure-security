variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project. Used in resource names"
  default     = "proactive-security-demo"
}

variable "environment" {
  description = "Environment (e.g. 'prod', 'dev', 'staging')"
  default     = "dev"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  default     = "proactive-security-demo"
}

variable "ecr_image_url" {
  description = "URL of the Docker image in ECR to deploy"
  type        = string
  default     = "084828559214.dkr.ecr.us-east-1.amazonaws.com/proactive-security-demo:latest"
}

variable "ecs_task_cpu" {
  description = "The amount of CPU to allocate for the ECS task"
  default     = "256"
}

variable "ecs_task_memory" {
  description = "The amount of memory to allocate for the ECS task"
  default     = "512"
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "task_count" {
  description = "Number of ECS tasks to run"
  default     = 1
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/"
}

variable "use_default_vpc" {
  description = "Whether to use the default VPC"
  type        = bool
  default     = true
}
