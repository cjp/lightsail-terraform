provider "aws" {
  region   = "${local.region}"
}

resource "aws_lightsail_static_ip_attachment" "app" {
  static_ip_name = "${aws_lightsail_static_ip.app.name}"
  instance_name  = "${aws_lightsail_instance.app.name}"
}

resource "aws_lightsail_static_ip" "app" {
  name = "${local.appname}"
}

resource "aws_lightsail_instance" "app" {
  name              = "${local.appname}.${local.domain}"
  availability_zone = "${local.region}b"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "micro_2_0"
  key_pair_name     = "${local.keyname}"
}

resource "aws_s3_bucket" "app" {
  bucket = "${local.appname}.${local.domain}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

data "aws_route53_zone" "zone" {
  name         = "${local.domain}."
}

resource "aws_route53_record" "app" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${local.appname}.${data.aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_lightsail_static_ip.app.ip_address}"]
}

resource "aws_iam_user" "app" {
  name = "${local.appname}"
}

resource "aws_iam_access_key" "app" {
  user    = "${aws_iam_user.app.name}"
  pgp_key = "${local.pgpkey}"
}

resource "aws_iam_user_policy" "app" {
  name = "${local.appname}"
  user = "${aws_iam_user.app.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${local.appname}.${local.domain}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::${local.appname}.${local.domain}/*"]
    }
  ]
}
EOF
}

output "s3_access_key" {
  value = "${aws_iam_access_key.app.id}"
}

output "s3_access_secret_encrypted" {
  value = "${aws_iam_access_key.app.encrypted_secret}"
}

