variable "iam_role_name" {
  type        = string
  default     = "svcacct.s3-replication"
  description = "IAM Role name for replication"
}

variable "iam_role_policy_name" {
  type        = string
  default     = "svcacct.s3-replication-policy"
  description = "IAM policy for replication"
}

variable "default_region" {
  type        = string
  default     = "ap-south-1"
  description = "Default region"
}

variable "source_bucket_name" {
  type        = string
  description = "Source bucket name"
}

variable "destination_bucket_name" {
  type        = string
  description = "Destination bucket name"
}

variable "access" {
  type        = string
  description = "defines access to bucket"
  default     = "private"
}

variable "force_destroy" {
  description = "Delete all objects in bucket on destroy"
  default     = false
}


variable "versioning" {
  type        = bool
  default     = true
  description = "Is versioning enabled on bucket?"
}
