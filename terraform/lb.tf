####################################################
# ALB
####################################################
resource "aws_lb" "alb" {
  name               = "example-alb"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
  ]

  security_groups = [aws_security_group.allow_http.id]

  # access_logs {
  #   bucket  = aws_s3_bucket.alb_log.id
  #   enabled = true
  # }

  tags = {
    Name = "example-alb"
  }
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "example-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  deregistration_delay = 300

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }

  depends_on = [aws_lb.alb]

  tags = {
    Name = "example-alb-tg"
  }
}
