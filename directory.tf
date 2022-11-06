# AWS Directory Service Directory
resource "aws_directory_service_directory" "aws-managed-ad" {
  name        = "demo.local"
  description = "Dev Enclave Directory Service"
  password    = "Retake$Frame$Trio6"
  edition     = "Standard"
  type        = "MicrosoftAD"

  vpc_settings {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
  }

  tags = {
    Name        = "Muzakkir-managed-ad"
    Environment = "Development"
  }
}

# DNS Resolver
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = aws_directory_service_directory.aws-managed-ad.dns_ip_addresses
  domain_name         = "demolocal"
  tags = {
    Name        = "demo-dev"
    Environment = "Development"
  }
}

# Associates the DNS Resolver to the VPC
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}


# Allow outbound 1812 access from Directory to RADIUS 
resource "aws_security_group_rule" "allow_radius_auth_out_to_radius_servers" {
  type                     = "egress"
  from_port                = 1812
  to_port                  = 1812
  protocol                 = "udp"
  source_security_group_id = aws_security_group.RADIUS-server.id
  security_group_id        = aws_directory_service_directory.aws-managed-ad.security_group_id
}


# Allow access to RADIUS
resource "aws_security_group_rule" "allow_radius_auth_from_directory" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${sort(aws_directory_service_directory.aws-managed-ad.dns_ip_addresses)[0]}/32"]
  security_group_id = aws_security_group.RADIUS-server.id
}

# Allow access to RADIUS
resource "aws_security_group_rule" "allow_radius_auth_from_directory2" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${sort(aws_directory_service_directory.aws-managed-ad.dns_ip_addresses)[1]}/32"]
  security_group_id = aws_security_group.RADIUS-server.id
}
