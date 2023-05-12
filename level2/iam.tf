data "aws_iam_policy_document" "autoscaling_s3_access_document" {
  statement {
    actions   = ["s3:*"]
    effect = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "autoscaling_permission_role_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "autoscaling_s3_role" {
  name               = "autoscaling-s3-role"
  assume_role_policy = data.aws_iam_policy_document.autoscaling_permission_role_document.json
}

resource "aws_iam_policy" "policy" {
  name        = "autoscaling_s3_role"
  description = "autoscaling_s3_role"
  policy      = data.aws_iam_policy_document.autoscaling_s3_access_document.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.autoscaling_s3_role.name
  policy_arn = aws_iam_policy.policy.arn
}
