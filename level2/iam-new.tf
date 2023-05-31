resource "aws_iam_role" "iam_role_autoscaling" {
  name = "iam_role_autoscaling"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]
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

resource "aws_iam_instance_profile" "aws_iam_instance_profile" {
  name = "aws_iam_instance_profile"
  role = aws_iam_role.iam_role_autoscaling.name
}