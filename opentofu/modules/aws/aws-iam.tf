data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "groot_net_teleport_cluster_iam_role" {
  name               = "groot-net-teleport-cluster-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "groot_net_teleport_cluster_instance_profile" {
  name = "groot-net-teleport-cluster-instance-profile"
  role = aws_iam_role.groot_net_teleport_cluster_iam_role.name
}
