resource "aws_lb" "loadbalancer" {
  name               = "lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_elb.id]
  subnets            = [data.terraform_remote_state.level1.outputs.public_subnet_id[1], data.terraform_remote_state.level1.outputs.public_subnet_id[0]]

  enable_deletion_protection = false

  /*access_logs {
    bucket  = aws_s3_bucket.s3_bucket.id
    prefix  = "lb"
    enabled = true
  }*/

  tags = {
    Name = "${var.environment_code}_load_balancer"
  }
}
/*
# S3 bucket for elb logs
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-tf-s3-bucket-000"

   policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-tf-s3-bucket-000/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
}
*/
# create LB target group
resource "aws_lb_target_group" "elb_target_group" {
  name     = "elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.level1.outputs.vpc_id
}

# link target group and ec2
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.elb_target_group.arn
  target_id        = aws_instance.ec2.id
  port             = 80
}

resource "aws_lb_listener" "elb_listner" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb_target_group.arn
  }
}
