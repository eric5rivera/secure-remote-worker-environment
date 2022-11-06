# VPC
module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "secure-remote-worker-vpc"
  cidr                   = "10.10.0.0/16"
  azs                    = ["us-west-2a", "us-west-2b"]
  private_subnets        = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_suffix  = "private"
  public_subnets         = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
  public_subnet_suffix   = "public"
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
  tags = {
    Name        = "demo-dev"
    Environment = "Development"
  }
}