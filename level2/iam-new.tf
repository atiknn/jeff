resource "aws_iam_role" "iam_role_autoscaling" {
  name = "iam_role_autoscaling"

  assume_role_policy = <<EOF
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF

  tags = {
    tag-key = "iam_role_autoscaling"
  }
}

