output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.tg.arn
}