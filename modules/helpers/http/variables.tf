variable "endpoint" {
  description = "The endpoint to test"
  type        = string
}

variable "method" {
  description = "The HTTP method to use"
  type        = string
  default     = "GET"
}

variable "headers" {
  description = "The request headers to send"
  type        = map(string)
  default     = {}
}
