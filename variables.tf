variable "name" {
  type        = string
  description = "Name of the repository."
}

variable "tag_prefix_list" {
  type        = list(string)
  description = "List of image tag prefixes on which to take action with lifecycle policy."
}

variable "only_pull_accounts" {
  default     = []
  type        = list(string)
  description = "AWS accounts which pull only."
}

variable "push_and_pull_accounts" {
  default     = []
  type        = list(string)
  description = "AWS accounts which push and pull."
}

variable "max_untagged_image_count" {
  default     = 1
  type        = number
  description = "The maximum number of untagged images that you want to retain in repository."
}

variable "max_tagged_image_count" {
  default     = 30
  type        = number
  description = "The maximum number of tagged images that you want to retain in repository."
}

variable "scan_on_push" {
  default     = false
  type        = bool
  description = "Whether images should automatically be scanned on push or not."
}
