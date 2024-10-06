variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "proactive-security-demo"
}

variable "environment" {
  description = "Environment (e.g. 'prod', 'dev', 'staging')"
  type        = string
  default     = "dev"
}

variable "ecr_image_url" {
  description = "URL of the Docker image in ECR to deploy"
  type        = string
  default     = "084828559214.dkr.ecr.us-east-1.amazonaws.com/proactive-security-demo:latest"
}

variable "ecs_task_cpu" {
  description = "The amount of CPU to allocate for the ECS task"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "The amount of memory to allocate for the ECS task"
  type        = number
  default     = 512
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  type        = number
  default     = 3000
}

variable "task_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "Http path for task health check"
  type        = string
  default     = "/"
}
