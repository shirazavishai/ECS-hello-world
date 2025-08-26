resource "aws_lb" "alb" {
    name               = "${var.alb_name}"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.security_group_id] # Security group ID passed as a variable
    subnets            = var.public_subnet_ids # Public subnet IDs passed as a variable
}

resource "aws_lb_target_group" "tg" {
    name     = "${var.alb_name}-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id # VPC ID passed as a variable
    target_type = "ip"
    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200-399"
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }

    depends_on = [aws_lb_target_group.tg]
}
