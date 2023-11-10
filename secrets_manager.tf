
data "aws_caller_identity" "current" {}

################################################################################
# Secrets Manager
################################################################################
  
module "secrets_manager" {
  #checkov:skip=CKV2_AWS_57
  source = "github.com/adexltd/terraform-aws-secretsmanager-module"

  # Secret
  name_prefix             = "adex-chatbot-secrets-manager"
  description             = "Adex Chatbot Secrets Manager secret"
  recovery_window_in_days = 0

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  # Version
  create_random_password           = true
  random_password_length           = 64
  random_password_override_special = "!@#$%^&*()_+"

}