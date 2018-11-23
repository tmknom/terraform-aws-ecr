# Terraform module which creates ECR resources on AWS.
#
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html

# https://www.terraform.io/docs/providers/aws/r/ecr_repository.html
resource "aws_ecr_repository" "default" {
  name = "${var.name}"
}
