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

  vpc_cidr = local.region_vars.locals.vpc_cidr_mapping[local.project_dir]
}

terraform {
  source = "git@github.com:th1enlm02/terraform-modules.git//aws/dynamodb-table/wrappers?ref=main"
}

inputs = {
  defaults = {
    table_class  = "STANDARD"
    billing_mode = "PAY_PER_REQUEST"
    tags         = local.tags
  }

  items = {
    "${local.stack_name}-users" = {
      name     = "users"
      hash_key = "userId"
      attributes = [
        {
          name = "userId"
          type = "S"
        }
      ]
    }
  }
}
