# ECS-hello-world

This project automates the provisioning and deployment of a containerized application on AWS ECS using Terraform. The infrastructure includes an Application Load Balancer (ALB), ECS cluster, and CloudWatch monitoring.

### AWS Well-Architected Framework Pillars

* Operational Excellence: Automate deployments with Terraform and enable CloudWatch monitoring to track ECS task health and container metrics for timely alerting and troubleshooting.

* Security - Implement IAM roles with least privilege for ECS tasks, and use security groups to restrict network access to only required ports.

* Reliability - Deploy ECS tasks across 3 Availability Zones for high availability, and configure ECS Service Auto Scaling policies to ensure service continuity under varying load.

* Performance Efficiency - Use Application Load Balancer to distribute traffic efficiently and configure Auto Scaling policies for ECS to adjust capacity dynamically.

* Cost Optimization - Utilize AWS Fargate to run containers serverlessly, paying only for the resources used, combined with Auto Scaling to match load and minimize waste.

### Deployment Instructions

* Terrafor
    1. Authenticate with AWS account
    1. Adjust variables in ECS-hello-world\terraform\environment\eu-west-1\terraform.tfvars if needed
    1. RUN: `terraform init` to initialize providers
    1. RUN: `terraform plan`  to review changes
    1. RUN: `terraform apply` to provision resources

* GitActions
    Trigger deployment by pushing code or manually running workflow.

* Access the deployed application via:
    1.  http://helloworld-alb-[lb-id].eu-west-1.elb.amazonaws.com/
    * For example: http://helloworld-alb-952388767.eu-west-1.elb.amazonaws.com/

### Future Enhancements
CI/CD enhancements
Alerting
Cost management strategies
