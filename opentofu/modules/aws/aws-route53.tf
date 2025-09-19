resource "aws_route53_zone" "groot_net_cloud_zone" {
  name = "groot-net.cloud"

  tags = {
    Environment = "Production"
  }
}

resource "aws_route53_record" "groot_net_teleport_cluster_a_record" {
  zone_id = aws_route53_zone.groot_net_cloud_zone.zone_id
  name    = "mordor.groot-net.cloud"
  type    = "A"
  ttl     = 300
  records = [aws_eip.groot_net_teleport_cluster_instance_eip.public_ip]
}

resource "aws_route53_record" "groot_net_teleport_cluster_wildcard_a_record" {
  zone_id = aws_route53_zone.groot_net_cloud_zone.zone_id
  name    = "*.mordor.groot-net.cloud"
  type    = "A"
  ttl     = 300
  records = [aws_eip.groot_net_teleport_cluster_instance_eip.public_ip]
}
