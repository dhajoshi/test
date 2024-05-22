variable "project_id" {
  description = "The ID of the project in which to create the service account."
  type        = string
}

variable "account_id" {
  description = "The account ID of the service account. This must be unique within the project."
  type        = string
}

variable "display_name" {
  description = "The display name of the service account."
  type        = string
  default     = "Service Account"
}

variable "roles" {
  description = "The list of roles to assign to the service account."
  type        = list(string)
  default     = []
}
