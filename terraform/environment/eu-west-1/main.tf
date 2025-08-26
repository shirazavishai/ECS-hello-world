provider "aws" {
  region = var.region
}

# VPC Module
module "vpc" {
  source                = "../../modules/vpc"
  region               = var.region
  vpc_cidr              = var.vpc_cidr
  vpc_name              = var.vpc_name
  availability_zones    = var.availability_zones
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
}

# IAM Module
module "iam" {
  source = "../../modules/iam"
}


# Security Module
module "security" {
  source              = "../../modules/security"
  vpc_id              = module.vpc.vpc_id
  vpc_name            = var.vpc_name
  public_subnets      = module.vpc.public_subnets
  private_subnets     = module.vpc.private_subnets
}

# ALB Module
module "alb" {
  source              = "../../modules/alb"
  alb_name            = var.alb_name
  public_subnet_ids   = module.vpc.public_subnets
  security_group_id   = module.security.alb_security_group_id
  vpc_id              = module.vpc.vpc_id
}

# ECS Module
module "ecs" {
  source                      = "../../modules/ecs"
  depends_on                  = [module.alb, module.vpc, module.security]
  region                      = var.region
  cluster_name                = var.cluster_name
  ecs_service_name            = var.ecs_service_name
  subnet_ids                  = module.vpc.private_subnets
  security_group_ids          = [module.security.ecs_security_group_id]
  container_name              = var.container_name
  container_port              = var.container_port
  desired_count               = var.desired_count
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_arn                = module.iam.ecs_task_arn
  ecr_repository_url          = module.ecr.repository_url
  log_group_name              = module.monitoring.log_group_name
  alb_target_group_arn        = module.alb.target_group_arn
}

# AppAutoscaling Module
module "appautoscaling" {
  source        = "../../modules/appautoscaling"
  depends_on    = [module.ecs]
  cluster_name  = var.cluster_name
  service_name  = var.ecs_service_name
  min_capacity  = var.min_capacity
  max_capacity  = var.max_capacity
}

# Monitoring Module
module "monitoring" {
  source         = "../../modules/monitoring"
  cluster_name   = var.cluster_name
  app_name       = var.app_name
  esc_service_name = var.ecs_service_name
  desired_count  = var.desired_count
  running_threshold = 0
}

# ECR Module
module "ecr" {
  source           = "../../modules/ecr"
  repository_name  = var.repository_name
}