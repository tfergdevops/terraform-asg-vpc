resource "aws_launch_configuration" "launch-conf" {

  name_prefix                 = "${var.cluster_name}-launch-conf-"
  image_id                    = "ami-0b7dcd6e6fd797935"
  instance_type               = "t2.micro"
  user_data                   = file("${path.module}/user_data.sh")
  associate_public_ip_address = true
  security_groups             = [aws_security_group.alb.id]
  key_name                    = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb" #var
  vpc_id = "${var.vpc_id}" #var
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  description = "HTTP"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # open to all traffic
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  description = "SSH"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.personal_ip}/32"] #var
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.cluster_name}-asg"
  launch_configuration      = aws_launch_configuration.launch-conf.name
  vpc_zone_identifier       = [var.subnet_id[0], var.subnet_id[1], var.subnet_id[2]] #var
  min_size                  = var.scope #var
  max_size                  = var.scope #var
  desired_capacity          = var.scope #var
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.target-group.arn]
  termination_policies      = ["OldestInstance"]

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lb" "load-balancer" {
  name               = "${var.cluster_name}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [var.subnet_id[0], var.subnet_id[1], var.subnet_id[2]] #var
}
resource "aws_lb_target_group" "target-group" {
  name     = "${var.cluster_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "lb-listner" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}