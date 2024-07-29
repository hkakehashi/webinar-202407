locals {
  origin_hostname = "http-me.glitch.me"
}

resource "fastly_service_vcl" "main" {
  name            = var.service_name
  activate        = var.activate
  version_comment = var.version_comment

  domain {
    name = var.domain
  }

  backend {
    name              = "http-me"
    address           = local.origin_hostname
    port              = 443
    use_ssl           = true
    ssl_cert_hostname = local.origin_hostname
    ssl_sni_hostname  = local.origin_hostname
    override_host     = local.origin_hostname
  }

  vcl {
    name    = "main"
    content = file("${path.module}/vcl/main.vcl")
    main    = true
  }

  force_destroy = var.force_destroy
}
