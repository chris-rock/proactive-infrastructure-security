data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Output the ALB DNS name
output "app_url" {
  value       = "http://${aws_lb.main.dns_name}"
  description = "The URL of the application"
}
