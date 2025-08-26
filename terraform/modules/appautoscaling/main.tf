resource "aws_appautoscaling_target" "svc" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

resource "aws_appautoscaling_policy" "cpu50" {
  name               = "cpu-50"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.svc.service_namespace
  resource_id        = aws_appautoscaling_target.svc.resource_id
  scalable_dimension = aws_appautoscaling_target.svc.scalable_dimension

  target_tracking_scaling_policy_configuration {
    target_value       = 50
    predefined_metric_specification { predefined_metric_type = "ECSServiceAverageCPUUtilization" }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
