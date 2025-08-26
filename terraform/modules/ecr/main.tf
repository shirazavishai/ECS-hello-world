resource "aws_ecr_repository" "this" {
    name = var.repository_name
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
    }
    tags = {
        Name = var.repository_name
    }
    force_delete = true
}

 # image_tag_mutability - MUTABLE = allows overwriting same tag
 # ECR scanner - Amazon Inspector v2

 