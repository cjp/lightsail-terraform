terraform {
  backend "s3" {
    bucket = "example-opsbucket"
    key    = "terraform/example-app"
    region = "us-east-1"
  }
}

locals {
  appname  = "foo"
  domain   = "example.com"
  region   = "us-east-1"
  keyname  = "examplekey"
  pgpkey   = "keybase:exampleuser"
}
