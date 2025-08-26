resource "aws_security_group" "alb_sg" {
    name = "${var.vpc_name}-alb-sg"
    description = "Security group for ALB"
    vpc_id = var.vpc_id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP from anywhere"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic" 
    }
}

resource "aws_security_group" "ecs_sg" {
    name = "${var.vpc_name}-ecs-sg"
    description = "Security group for ECS"
    vpc_id = var.vpc_id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
        description = "Allow HTTP from ALB"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic" 
    }
}

# One security group of ALB - allows traffic from port 80
# One security group for ECS - allows traffic from ALB security group on port 80
# Outbound rules allow all traffic