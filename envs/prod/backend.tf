terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "webinar202407/prod"
  }
}
