variables {
  service_name  = "webinar202407-test"
  domain        = "webinar202407-test.global.ssl.fastly.net"
  force_destroy = true
}

run "create_fastly_service" {}

run "sleep_1m" {
  module {
    source = "../helpers/sleep"
  }

  variables {
    duration = "1m"
  }
}

run "root_path_returns_200_with_cache_control" {
  module {
    source = "../helpers/http"
  }
  variables {
    endpoint = "https://${var.domain}/"
  }

  assert {
    condition     = output.http_response.status_code == 200
    error_message = "Path '/' returned unexpected status code: ${output.http_response.status_code}. Expected: 200"
  }

  assert {
    condition     = output.http_response.response_headers["Cache-Control"] == "max-age=86400"
    error_message = "Path '/' returned unexpected Cache-Control header: ${output.http_response.response_headers["Cache-Control"]}. Expected: max-age=86400"
  }
}

run "unknown_path_returns_404_without_cache_control" {
  module {
    source = "../helpers/http"
  }
  variables {
    endpoint = "https://${var.domain}/status=404"
  }

  assert {
    condition     = output.http_response.status_code == 404
    error_message = "Path '/' returned unexpected status code: ${output.http_response.status_code}. Expected: 404"
  }

  assert {
    condition     = !contains(keys(output.http_response.response_headers), "Cache-Control")
    error_message = "Path '/status=404' unexpectedly contained a Cache-Control header. Expected: no Cache-Control header"
  }
}
