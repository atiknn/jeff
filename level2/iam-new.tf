resource "aws_iam_role" "iam_role_autoscaling" {
  name = "iam_role_autoscaling"

  tags = {
    tag-key = "iam_role_autoscaling"
  }
}
