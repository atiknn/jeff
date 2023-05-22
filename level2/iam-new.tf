resource "aws_iam_role" "iam_role_autoscaling" {
  name = "iam_role_autoscaling"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],           
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


resource "aws_iam_policy" "s3policy" {
  name        = "s3policy"
  description = "s3policy"
  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "s3:*",           
              "Resource": "*"
          }
      ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "main" {
  role = aws_iam_role.iam_role_autoscaling.name
  policy_arn = aws_iam_policy.s3policy.arn
}


resource "aws_iam_instance_profile" "aws_iam_instance_profile" {
  name = "aws_iam_instance_profile"
  role = aws_iam_role.iam_role_autoscaling.name
}