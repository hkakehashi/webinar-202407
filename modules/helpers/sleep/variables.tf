variable "duration" {
  description = "The duration to sleep for"
  type        = string
  default     = "1m"
}

variable "triggers" {
  description = "The triggers to use for the sleep"
  type        = map(string)
  default     = {}
}
