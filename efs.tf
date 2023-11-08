################################################################################
# EFS Module
################################################################################
module "efs" {
  source = "./modules/efs"

  # File system
  name           = local.efs.name
  creation_token = local.efs.name
  encrypted      = true

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  # provisioned_throughput_in_mibps = 20

  lifecycle_policy = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  # File system policy
  attach_policy                      = true
  bypass_policy_lockout_safety_check = false
  policy_statements = [
    {
      sid = "Example"
      actions = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess"
      ]
      principals = [
        {
          type = "AWS"
          identifiers = [
            "*"
        ] }
      ]
    }
    # {
    #   "Sid" : "NonSecureTransport",
    #   "Effect" : "Allow",
    #   "Principal" : {
    #     "AWS" : "*"
    #   },
    #   "Action" : "*",
    #   "Resource" : "arn:aws:elasticfilesystem:us-east-1:426857564226:file-system/fs-0f849e278cb69c6c6",
    #   "Condition" : {
    #     "Bool" : {
    #       "aws:SecureTransport" : "true"
    #     }
    #   }
    # }
  ]

  # Mount targets / security group
  mount_targets = { for k, v in zipmap(local.azs, module.vpc.private_subnets) : k => { subnet_id = v } }

  security_group_description = "EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }
  # Access point(s)
  access_points = {
    root_example = {

      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002]
      }
      root_directory = {
        path = "/efs"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }
  # Backup policy
  enable_backup_policy = true
}
