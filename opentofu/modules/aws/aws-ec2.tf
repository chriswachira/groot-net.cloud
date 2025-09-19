resource "aws_key_pair" "groot_net_teleport_cluster_key_pair" {
  key_name   = "kp-groot-net-teleport-cluster"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCY7v2UVHm3tgwG6m847fkD+KUOeaPA8x1otN9vaz3D4OrrGTFB33N9Opx3etKpw41cbw7xNpindmTw8urEETb171qRq7q9jkqTXfdLdOB5dulH/dM+ij2b/QK5vit9FgLoM7njF4Iue7Z+KBwFJWEvEKhrs7c7tyZ6kka+42EqGwi+kjoMuH0GzmHeagvQcMXHLDNFAdmSvETHbEJAEob61/0b63bz5vR3WynFyfYpq73TteZLrc8C3DFd0q25DijGE//YIaNAVJmTsynNl8z80bROzHJ8u7qP5lasLSPtWfuWLHF9wnYr+2Kh4coZ7LwsdKCFeTaZVuj0+6XFDO8oq+ibrY+musVfOF17Pj5EwLD1NKDjq699TH/Pqump01hV1DK5PfIdoQW94P9DBwf1iA933tc+hnGfgWPzMjryMT+NQOLWwK73yh1zwiQLo/Mz8ElMS1rYWZxpzTjU7vt1/T5bCoTib+t1zDPS4RRo/ToUM4A8xh6PlZ0Myb/+jIExnVPCl+peF2zSYmLN7YhCclun11fdnats+CvZJ9iTrnKGOIplBj+nSK0pCtGes9DkrMNpHQWFKNwCRSCy6Gt/1zynlBT/N5rqbPUjMvmXcccyHpwVcMJKkbrTjBtWXhTLXKsBJiK1WZJSHd+fcLbnHpgkKxaJefT8oJasZh3nXQ== groot@omen"
}

resource "aws_launch_template" "groot_net_teleport_cluster_ltpl" {
  name          = "ltpl-groot-net-teleport-cluster"
  instance_type = "t4g.micro"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.groot_net_teleport_cluster_instance_profile.arn
  }

  image_id = "ami-0438fcc5e04aa9413"

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  key_name = aws_key_pair.groot_net_teleport_cluster_key_pair.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    subnet_id       = aws_subnet.groot_net_vpc_public_subnet.id
    security_groups = [aws_security_group.groot_net_teleport_cluster_security_group.id]
  }

  placement {
    availability_zone = aws_subnet.groot_net_vpc_public_subnet.availability_zone
  }

  vpc_security_group_ids = [aws_security_group.groot_net_teleport_cluster_security_group.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "groot-net Teleport cluster launch template"
    }
  }
}

resource "aws_security_group" "groot_net_teleport_cluster_security_group" {
  name        = "sgp-groot-net-teleport-cluster"
  description = "Security group for groot-net.cloud Teleport cluster access"
  vpc_id      = aws_vpc.groot_net_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "teleport_cluster_all_traffic_egress_sgp_rule" {
  security_group_id = aws_security_group.groot_net_teleport_cluster_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_vpc_security_group_ingress_rule" "teleport_cluster_https_ingress_sgp_rule" {
  security_group_id = aws_security_group.groot_net_teleport_cluster_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "teleport_cluster_ssh_ingress_sgp_rule" {
  security_group_id = aws_security_group.groot_net_teleport_cluster_security_group.id
  cidr_ipv4         = "41.90.0.0/16"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_network_interface" "groot_net_teleport_cluster_instance_eni" {
  subnet_id = aws_subnet.groot_net_vpc_public_subnet.id
}

resource "aws_instance" "groot_net_teleport_cluster_instance" {
  ami                     = "ami-0438fcc5e04aa9413"
  instance_type           = "t4g.micro"
  disable_api_termination = true
  subnet_id               = aws_subnet.groot_net_vpc_public_subnet.id
  availability_zone       = aws_subnet.groot_net_vpc_public_subnet.availability_zone
  key_name                = aws_key_pair.groot_net_teleport_cluster_key_pair.key_name
  vpc_security_group_ids  = [aws_security_group.groot_net_teleport_cluster_security_group.id]
  iam_instance_profile    = aws_iam_instance_profile.groot_net_teleport_cluster_instance_profile.id

  primary_network_interface {
    network_interface_id = aws_network_interface.groot_net_teleport_cluster_instance_eni.id
  }

  ebs_block_device {
    device_name           = "/dev/sdf"
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp2"
  }

  user_data = templatefile(
    "${path.module}/aws-ec2-user-data.tpl",
    {
      region                   = "eu-west-1"
      teleport_auth_type       = "local"
      cluster_name             = "groot-net"
      email                    = var.groot_net_teleport_cluster_admin_email_address
      domain_name              = "mordor.groot-net.cloud"
      dynamo_table_name        = aws_dynamodb_table.groot_net_teleport_cluster_state_table.name
      dynamo_events_table_name = aws_dynamodb_table.groot_net_teleport_cluster_events_table.name
      locks_table_name         = aws_dynamodb_table.groot_net_teleport_cluster_locks_table.name
      license_path             = "/tmp/license.pem"
      s3_bucket                = aws_s3_bucket.groot_net_teleport_sessions_bucket.id
      enable_mongodb_listener  = false
      enable_mysql_listener    = false
      enable_postgres_listener = false
      use_acm                  = false
      use_letsencrypt          = true
      use_tls_routing          = true
    }
  )
}

resource "aws_eip" "groot_net_teleport_cluster_instance_eip" {
  instance         = aws_instance.groot_net_teleport_cluster_instance.id
  domain           = "vpc"
  public_ipv4_pool = "amazon"
}
