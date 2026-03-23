locals {
  environment = basename(get_terragrunt_dir())

  # Common tags
  env_tags = {
    ManagedBy   = "DevOps"
    Environment = local.environment
  }
}
