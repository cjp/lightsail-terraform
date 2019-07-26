# lightsail-terraform

This is an example [terraform](https://terraform.io) configuration for a small
app deployed to [AWS Lightsail](https://aws.amazon.com/lightsail/). I threw this
together when noodling around with [Nextcloud](https://nextcloud.com).

It builds:

- 1 `micro_2_0` `ubuntu_18_04` instance,
- a static IP glued to said instance, 
- an S3 bucket, with associated IAM user, and
- a route53 `A` record.

I believe the interpolation may require terraform >= 0.12.

`local.tf` includes all of the configuration one would most certainly need to
update. `main.tf` is the bulk of the config; it was simple enough to put in a
single file, but of course could be split as needed.

