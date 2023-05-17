resource "aws_iam_role" "iam_role_autoscaling" {
  name = "iam_role_autoscaling"

  assume_role_policy = <<EOF
    {
  "Id": "Policy1684334551610",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1684334545250",
      "Action": "s3:*",
      "Effect": "Allow",     
      "Principal": {
        "Service": [
          "autoscaling.amazonaws.com"
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

