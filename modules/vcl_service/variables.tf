variable "service_name" {
  description = "The name of the Fastly service"
  type        = string
}

variable "domain" {
  description = "The domain of the Fastly service"
  type        = string
}

variable "activate" {
  description = "Whether to activate the Fastly service"
  type        = bool
  default     = true
}

variable "version_comment" {
  description = "The comment for the Fastly service version"
  type        = string
  default     = ""
}


variable "force_destroy" {
  description = "Whether to allow the active Fastly service to be destroyed"
  type        = bool
  default     = false
}
