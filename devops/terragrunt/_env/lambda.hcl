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
}

dependency "lambda-role" {
  config_path = find_in_parent_folders("iam-role-assume")
  mock_outputs = {
    wrapper = {
      "${local.stack_name}-el-automation-process" = {
        iam_role_arn = "arn:aws:iam::${local.aws_account_id}:role/${local.stack_name}-el-automation-process"
      }
    }
  }
}

dependencies {
  paths = [
    find_in_parent_folders("iam-role-assume"),
  ]
}

terraform {
  source = "git::git@github.com:th1enlm02/terraform-modules.git//aws/lambda?ref=main"
}

inputs = {

}
