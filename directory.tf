# AWS Directory Service Directory
resource "aws_directory_service_directory" "aws-managed-ad" {
  name = "demo.local"
  description = "Dev Enclave Directory Service"
  password = "Retake$Frame$Trio6"
  edition = "Standard"
  type = "MicrosoftAD"

  vpc_settings {
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
  }
  
  tags = {
    Name = "Muzakkir-managed-ad"
    Environment = "Development"
  }
}

# DNS Resolver
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = aws_directory_service_directory.aws-managed-ad.dns_ip_addresses
  domain_name = "demolocal"
  tags = {
    Name = "demo-dev"
    Environment = "Development"
  }
}

# Associates the DNS Resolver to the VPC
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}