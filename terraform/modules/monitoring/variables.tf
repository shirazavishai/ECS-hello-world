variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "esc_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

variable "running_threshold" {
  description = "Threshold for running tasks alarm"
  type        = number
}