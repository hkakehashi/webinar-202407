module "vcl_service" {
  source = "../../modules/vcl_service"

  service_name    = "webinar202407-dev"
  domain          = "webinar202407-dev.global.ssl.fastly.net"
  version_comment = var.version_comment
  force_destroy   = true
}
