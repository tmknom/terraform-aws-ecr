variable "name" {
  type        = "string"
  description = "Name of the repository."
}

variable "only_pull_accounts" {
  default     = []
  type        = "list"
  description = "AWS accounts which pull only."
}
