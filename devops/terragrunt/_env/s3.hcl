locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  environment = local.environment_vars.locals.environment
  azs         = local.region_vars.locals.azs
  project_dir = local.project_vars.locals.project_dir
  stack_name  = "${local.project_dir}-${local.environment}"

  tags = merge(
    local.environment_vars.locals.env_tags,
    local.region_vars.locals.region_tags,
    local.project_vars.locals.project_tags
  )
}

terraform {
  source = "git::git@github.com:th1enlm02/terraform-modules.git//aws/s3/wrappers?ref=main"
}

inputs = {
  items = {
    "${local.stack_name}-lambda-source-code" = {
      bucket         = "${local.stack_name}-lambda-source-code"
      force_destroy  = false
      lifecycle_rule = []
      tags           = local.tags
    }
  }
}
