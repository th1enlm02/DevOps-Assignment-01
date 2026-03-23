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
  aws_account_id = local.project_vars.locals.env_acc_id_map[local.environment_vars.locals.environment]
  aws_region     = local.region_vars.locals.region
}

terraform {
  source = "git::git@github.com:th1enlm02/terraform-modules.git//aws/iam/wrappers/iam-policy?ref=main"
}

inputs = {
  items = {
    "${local.stack_name}-backend-nodejs-policy" = {
      description = "Policy for Lambda function backend Node.js application"
      name        = "${local.stack_name}-backend-nodejs-policy"
      policy = templatefile(find_in_parent_folders("_env/templates/iam-policy/backend-nodejs-policy.json.tpl"), {
        region           = local.region_vars.locals.region
        aws_account_id   = local.project_vars.locals.env_acc_id_map[local.environment_vars.locals.environment]
      })
      tags = local.tags
    }
  }
  tags = local.tags
}
