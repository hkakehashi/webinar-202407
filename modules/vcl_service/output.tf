output "service_id" {
  value = fastly_service_vcl.main.id
}

output "active_version" {
  value = fastly_service_vcl.main.active_version
}
