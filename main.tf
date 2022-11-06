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
    description = "Allow inbound SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound SSH to RADIUS server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.radius-server.id]
  }

  tags = {
    Name = "bastion-server"
  }
}


# Let bastion server ping and ssh to the RADIUS
resource "aws_security_group_rule" "allow_ssh_from_bastion" {
  description = "All ingress SSH from bastion server"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id   = aws_security_group.bastion-server.id
  security_group_id = aws_security_group.radius-server.id
}

## SG for RADIUS
resource "aws_security_group" "radius-server" {
  name        = "RADIUS-server"
  description = "This is the RADIUS server"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all out to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RADIUS-server"
  }
}

# Let RADIUS server access the Dirctory
resource "aws_security_group_rule" "allow_all_from_radius" {
  description = "Allow all inbound from RADIUS server"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id   = aws_security_group.radius-server.id
  security_group_id = aws_directory_service_directory.aws-managed-ad.security_group_id
}

# locals {
#   instances = {
#     "radius-server" = {
#       subnet         = module.vpc.private_subnets[0]
#       security_group = [aws_security_group.RADIUS-server.id]
#     }
#     "bastion-server" = {
#       subnet         = module.vpc.public_subnets[0]
#       security_group = [aws_security_group.bastion-server.id]
#     }
#   }
# }

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   ami           = "ami-08e2d37b6a0129927"
#   instance_type = "t2.micro"
#   key_name      = "erivera-key-pair"
#   monitoring    = true

#   for_each               = local.instances
#   name                   = each.key
#   vpc_security_group_ids = each.value.security_group
#   subnet_id              = each.value.subnet
#   # # This is where we configure the instance with ansible-playbook
#   # provisioner "local-exec" {
#   #   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./deployer.pem -i '${aws_instance.jenkins_master.public_ip},' master.yml"
#   # }
#   # # This is where we configure the instance with ansible-playbook
#   # provisioner "local-exec" {
#   #   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./deployer.pem -i '${aws_instance.jenkins_master.public_ip},' master.yml"
#   # }

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# Create EC2 Instance
resource "aws_instance" "bastion-server" {
  ami                         = "ami-08e2d37b6a0129927"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion-server.id]
  associate_public_ip_address = true
  key_name                    = "erivera-key-pair"

  # root disk
  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "bastion-server"
    Environment = "dev"
  }
}

# Create EC2 Instance
resource "aws_instance" "radius-server" {
  ami                         = "ami-08e2d37b6a0129927"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.radius-server.id]
  associate_public_ip_address = true
  key_name                    = "erivera-key-pair"

  # root disk
  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "radius-server"
    Environment = "dev"
  }
}
