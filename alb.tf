resource "aws_lb" "this" {
  name            = "DigitalBank-ALB"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.this["pub_a"].id, aws_subnet.this["pub_b"].id]

  tags = merge(local.common_tags, { Name = "ALB" })
}

resource "aws_lb_target_group" "this" {
  name     = "ALB-TargeGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    path              = "/healthcheck"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_instanci_1" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.instanci_1.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "tg_instanci_2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.instanci_2.id
  port             = 3000
}
