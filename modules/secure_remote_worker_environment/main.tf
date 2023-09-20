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

# Let RADIUS server access the Dirctory
resource "aws_security_group_rule" "allow_all_from_RADIUS" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${module.ec2_instance["radius-server"].private_ip}/32"]
  security_group_id = aws_directory_service_directory.aws-managed-ad.security_group_id
}

locals {
  instances = {
    "radius-server" = {
      subnet         = module.vpc.private_subnets[0]
      security_group = [aws_security_group.RADIUS-server.id]
    }
    "bastion-server" = {
      subnet         = module.vpc.public_subnets[0]
      security_group = []
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
  # # This is where we configure the instance with ansible-playbook
  # provisioner "local-exec" {
  #   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./deployer.pem -i '${aws_instance.jenkins_master.public_ip},' master.yml"
  # }
  # # This is where we configure the instance with ansible-playbook
  # provisioner "local-exec" {
  #   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./deployer.pem -i '${aws_instance.jenkins_master.public_ip},' master.yml"
  # }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
