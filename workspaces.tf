# This is a Windows Standard Bundle
data "aws_workspaces_bundle" "value_windows_10_server_2019_based" {
 bundle_id = "wsb-fb2xfp6r8"
}


data "aws_iam_policy_document" "workspaces" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "workspaces-default" {
  name = "workspaces_DefaultRole"
  assume_role_policy = data.aws_iam_policy_document.workspaces.json
}

resource "aws_iam_role_policy_attachment" "workspaces-default-service-access" {
  role = aws_iam_role.workspaces-default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}

resource "aws_iam_role_policy_attachment" "workspaces-default-self-service-access" {
  role = aws_iam_role.workspaces-default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}

resource "aws_workspaces_directory" "workspaces-directory" {
 directory_id = aws_directory_service_directory.aws-managed-ad.id
  subnet_ids   = module.vpc.private_subnets
  depends_on = [aws_iam_role.workspaces-default]
}

resource "aws_kms_key" "workspaces-kms" {
  description = "Muzakkir  KMS"
  deletion_window_in_days = 7
}


resource "aws_workspaces_workspace" "workspaces" {
  directory_id = aws_workspaces_directory.workspaces-directory.id
  bundle_id = data.aws_workspaces_bundle.value_windows_10_server_2019_based.id
  # Admin is the Administrator of the AWS Directory Service
  user_name = "Admin"
  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key = aws_kms_key.workspaces-kms.arn
  workspace_properties {
    compute_type_name = "STANDARD"
    user_volume_size_gib = 50
    root_volume_size_gib = 80
    running_mode = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }
  tags = {
    Name = "demo-workspaces"
    Environment = "dev"
  }
  depends_on = [
    aws_iam_role.workspaces-default,
    aws_workspaces_directory.workspaces-directory
  ]
}



# Allow access to FSx
resource "aws_security_group_rule" "allow_smb_from_workspace" {
  type              = "ingress"
  from_port         = 445
  to_port           = 445
  protocol          = "tcp"
  cidr_blocks       = module.vpc.private_subnets_cidr_blocks
  security_group_id = aws_security_group.allow_smb.id
}