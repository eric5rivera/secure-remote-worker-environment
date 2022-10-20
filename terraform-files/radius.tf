# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "radius-server"

  ami                    = "ami-08e2d37b6a0129927"
  instance_type          = "t2.micro"
  key_name               = "erivera-key-pair"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.radius-server.id]
  subnet_id              = element(module.vpc.private_subnets, 0)

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  
}

# Security group
resource "aws_security_group" "radius-server" {
  name        = "radius-server"
  description = "This is the RADIUS server"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "radius-server"
  }
}