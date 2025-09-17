resource "aws_route53_zone" "groot_net_cloud_zone" {
  name = "groot-net.cloud"

  tags = {
    Environment = "Production"
  }
}
