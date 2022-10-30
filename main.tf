terraform {
  cloud {
    organization = "ericmrivera"

    workspaces {
      name = "secure-remote-worker-environment"
    }
  }
}

# Security group for bastion server
resource "aws_security_group" "bastion-server" {
  name        = "bastion-server"
  description = "This is the bastion server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-server"
  }
}


# Let bastion server ping and ssh to the RADIUS
resource "aws_security_group_rule" "allow_ssh_from_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${module.ec2_instance["bastion-server"].private_ip}/32"]
  security_group_id = aws_security_group.RADIUS-server.id
}
## SG for RADIUS
resource "aws_security_group" "RADIUS-server" {
  name        = "RADIUS-server"
  description = "This is the RADIUS server"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RADIUS-server"
  }
}

locals {
  instances = {
    "radius-server" = {
      subnet         = module.vpc.private_subnets[0]
      security_group = [aws_security_group.RADIUS-server.id]
    }
    "bastion-server" = {
      subnet         = module.vpc.public_subnets[0]
      security_group = [aws_security_group.bastion-server.id]
    }
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  ami           = "ami-08e2d37b6a0129927"
  instance_type = "t2.micro"
  key_name      = "erivera-key-pair"
  monitoring    = true

  for_each               = local.instances
  name                   = each.key
  vpc_security_group_ids = each.value.security_group
  subnet_id              = each.value.subnet

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}