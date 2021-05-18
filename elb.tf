resource "aws_lb" "application-lb" {
  provider           = aws.region-master
  name               = "jenkins-ELB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Jenkins_SG.id]
  subnets            = [aws_subnet.subnet_1.id]
  tags = {
    Name = "Jenkins-ELB"
  }
}



#Change port to variable in jenkins-sg group ingress rule which allows traffic from LB SG.

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-master
  name        = "app-lb-tg"
  port        = "80"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_Jenkins.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = "80"
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "jenkins-target-group"
  }
}

resource "aws_lb_listener" "jenkins-listener-http" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.id
  }
}


resource "aws_lb_target_group_attachment" "jenkins-master-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.jenkins-master.id
  port             = var.webserver-port
}