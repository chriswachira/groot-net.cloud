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

  image_id = "teleport-oss-18.2.1-arm64-20250912-234316UTC"

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
    associate_public_ip_address = true
  }

  placement {
    availability_zone = aws_subnet.groot_net_vpc_public_subnet.availability_zone
  }

  vpc_security_group_ids = ["sg-12345678"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "groot-net Teleport cluster launch template"
    }
  }
}
