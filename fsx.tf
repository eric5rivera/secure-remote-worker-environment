# FSx
resource "aws_fsx_windows_file_system" "terraform-managed-fsx" {
  active_directory_id = aws_directory_service_directory.aws-managed-ad.id
  deployment_type     = "MULTI_AZ_1"
  kms_key_id          = aws_kms_key.fsx-kms.arn
  storage_capacity    = 32
  subnet_ids          = module.vpc.private_subnets
  preferred_subnet_id = element(module.vpc.private_subnets, 0)
  throughput_capacity = 32
  security_group_ids  = [aws_security_group.allow_smb.id]

}

resource "aws_security_group" "allow_smb" {
  name        = "allow_smb"
  description = "Allow SMB inbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_smb"
  }
}


# KMS Key for FSx encryption
resource "aws_kms_key" "fsx-kms" {
  description             = "fsx key"
  deletion_window_in_days = 7
}

