resource "aws_cloudwatch_log_group" "ecs_log_group" {
    name = "/ecs/${var.cluster_name}"
    retention_in_days = 14
}

resource "aws_cloudwatch_metric_alarm" "running_below_desired" {
    alarm_name         = "${var.app_name}-running-below-desired"
    namespace          = "AWS/ECS"
    metric_name        = "RunningTaskCount"
    statistic          = "Minimum"
    period             = 60
    evaluation_periods = 2
    threshold          = var.running_threshold
    comparison_operator = "LessThanOrEqualToThreshold"
    dimensions = {
        ClusterName = var.cluster_name
        ServiceName = var.esc_service_name
    }
}

resource "aws_cloudwatch_log_metric_filter" "errors" {
  name           = "${var.app_name}-errors"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
  pattern        = "\"ERROR\""
  metric_transformation {
    name      = "${var.app_name}ErrorCount"
    namespace = "${var.app_name}App"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "${var.app_name}-Errors"
  namespace           = "${var.app_name}App"
  metric_name         = "${var.app_name}ErrorCount"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
}