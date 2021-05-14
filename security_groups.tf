# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "Jenkins_SG" {
  name = "Jenkins_SG"
  provider = aws.region-master
  description = "Allow TCP/8080, TCP/22, TCP/80, TCP/443 "
  vpc_id = aws_vpc.vpc_Jenkins.id

  # Inbound 8080 from anywhere
  ingress {
    description = "Allow 8080 port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound ssh from anywhere
  ingress {
    description = "Allow 22 port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound http from anywhere
  ingress {
    description = "Allow 80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound https from anywhere
  ingress {
    description = "Allow 443 port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Outbound https from anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }