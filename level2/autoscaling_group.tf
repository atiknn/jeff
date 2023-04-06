resource "aws_launch_configuration" "asg_launch_configuration" {
  name_prefix     = "asg-launch-configuration"
  image_id        = data.aws_ami.ec2_amazon.id
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.aws_security_group_instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "aws_autoscaling_group" {  
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.asg_launch_configuration.name
  vpc_zone_identifier  = [data.terraform_remote_state.level1.outputs.private_subnet_id[1]]
}
