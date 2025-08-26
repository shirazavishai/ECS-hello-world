# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

# ECR Variables
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

# ECS Variables
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "container_name" {
  description = "Name of the ECS container"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "container_port" {
  description = "Port number for the ECS container"
  type        = number
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

# AppAutoscaling Variables
variable "min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
}
  
variable "max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
}