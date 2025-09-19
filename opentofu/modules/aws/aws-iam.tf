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

// Policy to permit cluster to talk to S3 (Session recordings)
resource "aws_iam_role_policy" "cluster_s3" {
  name = "groot-net-teleport-cluster-s3"
  role = aws_iam_role.groot_net_teleport_cluster_iam_role.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": [
         "s3:ListBucket",
         "s3:ListBucketVersions",
         "s3:ListBucketMultipartUploads",
         "s3:AbortMultipartUpload"
      ],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.groot_net_teleport_sessions_bucket.bucket}"]
     },
     {
       "Effect": "Allow",
       "Action": [
         "s3:PutObject",
         "s3:GetObject",
         "s3:GetObjectVersion"
       ],
       "Resource": ["arn:aws:s3:::${aws_s3_bucket.groot_net_teleport_sessions_bucket.bucket}/*"]
     }
   ]
 }

EOF

}

// Policy to permit cluster to access DynamoDB tables (Cluster state, events, and SSL)
resource "aws_iam_role_policy" "cluster_dynamo" {
  name = "groot-net-teleport-cluster-dynamodb"
  role = aws_iam_role.groot_net_teleport_cluster_iam_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllActionsOnTeleportDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:eu-west-1:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.groot_net_teleport_cluster_state_table.name}"
        },
        {
            "Sid": "AllActionsOnTeleportEventsDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:eu-west-1:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.groot_net_teleport_cluster_events_table.name}"
        },
        {
            "Sid": "AllActionsOnTeleportEventsIndexDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:eu-west-1:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.groot_net_teleport_cluster_events_table.name}/index/*"
        },
        {
            "Sid": "AllActionsOnTeleportStreamsDB",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:eu-west-1:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.groot_net_teleport_cluster_state_table.name}/stream/*"
        },
        {
            "Sid": "AllActionsOnLocks",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:eu-west-1:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.groot_net_teleport_cluster_locks_table.name}"
        }
    ]
}
EOF

}

// Policy to permit cluster to access Route53 (SSL)
resource "aws_iam_role_policy" "cluster_route53" {
  name = "groot-net-teleport-cluster-route53"
  role = aws_iam_role.groot_net_teleport_cluster_iam_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "certbot-dns-route53 policy",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
                "arn:aws:route53:::hostedzone/${aws_route53_zone.groot_net_cloud_zone.zone_id}"
            ]
        }
    ]
}
EOF

}
