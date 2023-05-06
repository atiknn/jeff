data "aws_iam_policy_document" "s3bucketfullaccess" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "*",
    ]
  }
}

  resource "aws_iam_policy" "policys3" {
  name        = "s3-policy"
  description = "A policy"
  policy      = data.aws_iam_policy_document.s3bucketfullaccess.json
}

data "aws_iam_policy_document" "autoscalegrp_access_s3" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "s3fullaccessrole" {
  name               = "s3fullaccessrole"
  assume_role_policy = data.aws_iam_policy_document.autoscalegrp_access_s3.json
}

resource "aws_iam_role_policy_attachment" "policys3-attach" {
  role       = aws_iam_role.s3fullaccessrole.name
  policy_arn = aws_iam_policy.policys3.arn
}

resource "aws_iam_instance_profile" "iam_s3_profile" {
  name = "iam_s3_profile"
  role = aws_iam_role.s3fullaccessrole.name
}