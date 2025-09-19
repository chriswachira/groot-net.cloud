resource "aws_autoscaling_group" "groot_net_teleport_cluster_asg" {
  name               = "asg-groot-net-teleport-cluster"
  max_size           = 1
  min_size           = 1
  desired_capacity   = 1
  availability_zones = [aws_subnet.groot_net_vpc_public_subnet.availability_zone]

  launch_template {
    id      = aws_launch_template.groot_net_teleport_cluster_ltpl.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
    }
  }
}
