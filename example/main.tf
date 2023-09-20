data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  name_prefix = "srwe"

  tags = {
    # team     = "devops"
    # solution = "jenkins"
  }
}

# module myip {
#   source  = "4ops/myip/http"
#   version = "1.0.0"
# }

// Call module here 
module "secure_remote_worker_environment" {
  source                          = "../modules/secure_remote_worker_environment"

  name_prefix                     = local.name_prefix
  tags                            = local.tags
  vpc_id                          = var.vpc_id
}
