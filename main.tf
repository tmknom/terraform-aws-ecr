# Terraform module which creates ECR resources on AWS.
#
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html

# https://www.terraform.io/docs/providers/aws/r/ecr_repository.html
resource "aws_ecr_repository" "this" {
  name = var.name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

# https://www.terraform.io/docs/providers/aws/r/ecr_repository_policy.html
resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.push_and_pull.json
}

# Allows specific accounts to pull images
data "aws_iam_policy_document" "only_pull" {
  statement {
    sid    = "ElasticContainerRegistryOnlyPull"
    effect = "Allow"

    principals {
      identifiers = concat([local.current_account], local.only_pull_accounts)
      type        = "AWS"
    }

    # https://docs.aws.amazon.com/AmazonECR/latest/userguide/RepositoryPolicyExamples.html#IAM_allow_other_accounts
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
}

# Allows specific accounts to push and pull images
data "aws_iam_policy_document" "push_and_pull" {
  # An IAM policy document to import as a base for the current policy document
  source_json = data.aws_iam_policy_document.only_pull.json

  statement {
    sid    = "ElasticContainerRegistryPushAndPull"
    effect = "Allow"

    principals {
      identifiers = concat([local.current_account], local.push_and_pull_accounts)
      type        = "AWS"
    }

    # https://docs.aws.amazon.com/AmazonECR/latest/userguide/RepositoryPolicyExamples.html#IAM_within_account
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}

# https://www.terraform.io/docs/providers/aws/r/ecr_lifecycle_policy.html
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_untagged_image_count} untagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.max_untagged_image_count
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last ${var.max_tagged_image_count} tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = var.tag_prefix_list
          countType     = "imageCountMoreThan"
          countNumber   = var.max_tagged_image_count
        }
        action = {
          type = "expire"
        }
      },
    ]
  })
}

locals {
  only_pull_accounts     = formatlist("arn:aws:iam::%s:root", var.only_pull_accounts)
  push_and_pull_accounts = formatlist("arn:aws:iam::%s:root", var.push_and_pull_accounts)
  current_account        = format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
}

data "aws_caller_identity" "current" {}
