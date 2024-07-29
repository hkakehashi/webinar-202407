data "http" "test_endpoint" {
  url             = var.endpoint
  method          = var.method
  request_headers = var.headers
}
