resource "aws_s3_bucket" "groot_net_teleport_sessions_bucket" {
  bucket = "groot-net.cloud-teleport-sessions"

  tags = {
    Name        = "groot-net.cloud Teleport Session Recordings Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_acl" "groot_net_teleport_sessions_bucket_acl" {
  bucket = aws_s3_bucket.groot_net_teleport_sessions_bucket.id
  acl    = "private"
}
