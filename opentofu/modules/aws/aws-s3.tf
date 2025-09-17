resource "aws_s3_bucket" "groot_net_teleport_sessions_bucket" {
  bucket = "groot-net.cloud-teleport-sessions"

  tags = {
    Name        = "groot-net.cloud Teleport Session Recordings Bucket"
    Environment = "Production"
  }
}
