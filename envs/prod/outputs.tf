output "service_id" {
  value = module.vcl_service.service_id
}

output "active_version" {
  value = module.vcl_service.active_version
}

output "service_url" {
  value = "https://cfg.fastly.com/${module.vcl_service.service_id}"
}
