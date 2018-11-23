output "ecr_repository_arn" {
  value       = "${aws_ecr_repository.default.arn}"
  description = "Full ARN of the repository."
}

output "ecr_repository_name" {
  value       = "${aws_ecr_repository.default.name}"
  description = "The name of the repository."
}

output "ecr_repository_registry_id" {
  value       = "${aws_ecr_repository.default.registry_id}"
  description = "The registry ID where the repository was created."
}

output "ecr_repository_url" {
  value       = "${aws_ecr_repository.default.repository_url}"
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName."
}
