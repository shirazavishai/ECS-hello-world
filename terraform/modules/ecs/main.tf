resource "aws_ecs_cluster" "this" {
    name = var.cluster_name
    tags = {
        Name = var.cluster_name
    }
}

resource "aws_ecs_task_definition" "task" {
    family                   = "${var.cluster_name}-td"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"
    execution_role_arn       = var.ecs_task_execution_role_arn
    task_role_arn            = var.ecs_task_arn

    container_definitions = jsonencode([
        {
            name      = var.container_name,
            image     = "${var.ecr_repository_url}:latest",
            essential = true,
            portMappings = [
                {
                    containerPort = var.container_port
                    hostPort      = var.container_port
                    protocol      = "tcp"
                }
            ],
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    "awslogs-group"         = var.log_group_name
                    "awslogs-region"        = var.region
                    "awslogs-stream-prefix" = var.container_name
                }
            }
        }
    ])

    tags = {
        Name = var.cluster_name
    }
}


resource "aws_ecs_service" "this" {
    name            = var.ecs_service_name
    cluster         = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.task.arn
    desired_count   = var.desired_count
    launch_type     = "FARGATE"

    network_configuration {
        subnets = var.subnet_ids
        security_groups = var.security_group_ids
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.alb_target_group_arn
        container_name = var.container_name
        container_port = var.container_port
    }

    tags = {
        Name = var.cluster_name
    }
}
