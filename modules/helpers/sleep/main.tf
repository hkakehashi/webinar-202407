resource "time_sleep" "wait" {
  create_duration = var.duration
  triggers        = var.triggers
}
