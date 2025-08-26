output "scaling_policy_name" {
  description = "Name of the scaling policy"
  value       = aws_appautoscaling_policy.cpu50.name
}