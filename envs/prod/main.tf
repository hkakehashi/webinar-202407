module "vcl_service" {
  source = "../../modules/vcl_service"

  service_name    = "webinar202407-prod"
  domain          = "webinar202407-prod.global.ssl.fastly.net"
  version_comment = var.version_comment
  activate        = false
  force_destroy   = true
}
