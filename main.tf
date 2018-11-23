# Terraform module which creates ECR resources on AWS.
#
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html

# https://www.terraform.io/docs/providers/aws/r/ecr_repository.html
resource "aws_ecr_repository" "default" {
  name = "${var.name}"
}

# Allows specific accounts to pull images
data "aws_iam_policy_document" "only_pull" {
  statement {
    sid    = "ElasticContainerRegistryOnlyPull"
    effect = "Allow"

    principals {
      identifiers = ["${concat(list(local.current_account), local.only_pull_accounts)}"]
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

locals {
  only_pull_accounts = "${formatlist("arn:aws:iam::%s:root", var.only_pull_accounts)}"
  current_account    = "${format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)}"
}

data "aws_caller_identity" "current" {}
