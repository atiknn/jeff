resource "aws_iam_role" "iam_role_autoscaling" {
  name = "iam_role_autoscaling"

  tags = {
    tag-key = "iam_role_autoscaling"
  }
}

data "aws_iam_policy" "aws_iam_policy" {
  arn = "arn:aws:s3:::*"
}

resource "aws_iam_role_policy_attachment" "aws_iam_role_policy_attachment_s3" {
  role       = aws_iam_role.iam_role_autoscaling.name
  policy_arn = data.aws_iam_policy.aws_iam_policy.arn
}
