resource "aws_iam_role" "iam_role_autoscaling" {
  name = "iam_role_autoscaling"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Action": [
        "s3:ListAllMyBuckets",
        "s3:ListBucket"
      ],
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF

  tags = {
    tag-key = "iam_role_autoscaling"
  }
}

