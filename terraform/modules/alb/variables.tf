variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}