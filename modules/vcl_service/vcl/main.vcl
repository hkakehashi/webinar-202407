sub vcl_recv {
#FASTLY recv

  set req.url = querystring.sort(req.url);
  # Normally, you should consider requests other than GET and HEAD to be uncacheable
  # (to this we add the special FASTLYPURGE method)
  if (req.method != "HEAD" && req.method != "GET" && req.method != "FASTLYPURGE") {
    return(pass);
  }

  # If you are using image optimization, insert the code to enable it here
  # See https://www.fastly.com/documentation/reference/io/ for more information.

  return(lookup);
}

sub vcl_hash {
  set req.hash += req.url;
  set req.hash += req.http.host;
#FASTLY hash
  return(hash);
}

sub vcl_hit {
#FASTLY hit
  return(deliver);
}

sub vcl_miss {
#FASTLY miss
  return(fetch);
}

sub vcl_pass {
#FASTLY pass
  return(pass);
}

sub vcl_fetch {
#FASTLY fetch

  # Unset headers that reduce cacheability for images processed using the Fastly image optimizer
  if (req.http.X-Fastly-Imageopto-Api) {
    unset beresp.http.Set-Cookie;
    unset beresp.http.Vary;
  }

  # Log the number of restarts for debugging purposes
  if (req.restarts > 0) {
    set beresp.http.Fastly-Restarts = req.restarts;
  }

  # If the response is setting a cookie, make sure it is not cached
  if (beresp.http.Set-Cookie) {
    return(pass);
  }

  # By default we set a TTL based on the `Cache-Control` header but we don't parse additional directives
  # like `private` and `no-store`. Private in particular should be respected at the edge:
  if (beresp.http.Cache-Control ~ "(?:private|no-store)") {
    return(pass);
  }

  # If no TTL has been provided in the response headers, set a default
  if (http_status_matches(beresp.status, "200,206,301,302")) {
    if (!beresp.http.Cache-Control) {
      set beresp.ttl = 86400s;
      set beresp.http.Cache-Control = "max-age=86400";

      # Apply a longer default TTL for images processed using Image Optimizer
      if (req.http.X-Fastly-Imageopto-Api) {
        set beresp.ttl = 2592000s; # 30 days
        set beresp.http.Cache-Control = "max-age=2592000, public";
      }
    }
  }

  return(deliver);
}

sub vcl_error {
#FASTLY error
  return(deliver);
}

sub vcl_deliver {
#FASTLY deliver

  if (req.http.Fastly-Debug) {
    set resp.http.Fastly-Debug-VCL-Version = req.vcl.version;
  }

  return(deliver);
}

sub vcl_log {
#FASTLY log
}
