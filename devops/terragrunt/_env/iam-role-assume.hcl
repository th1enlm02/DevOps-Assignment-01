locals {
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  environment = local.env_vars.locals.environment
  azs         = local.region_vars.locals.azs
  project_dir = local.project_vars.locals.project_dir
  stack_name  = "${local.project_dir}-${local.environment}"

  tags = merge(
    local.env_vars.locals.env_tags,
    local.region_vars.locals.region_tags,
    local.project_vars.locals.project_tags
  )
}

dependency "iam-policy" {
  config_path = find_in_parent_folders("iam-policy")
}

dependencies {
  paths = [
    find_in_parent_folders("iam-policy")
  ]
}

terraform {
  source = "git::git@github.com:th1enlm02/terraform-modules.git//aws/iam/wrappers/iam-assumable-role?ref=main"
}

inputs = {
  items = {
    backend-nodejs-role = {
      create_role       = true
      role_name         = "${local.stack_name}-backend-nodejs-role"
      role_requires_mfa = false
      trusted_role_services = [
        "lambda.amazonaws.com"
      ]
      custom_role_policy_arns = [
        dependency.iam-policy.outputs.wrapper["${local.stack_name}-backend-nodejs-policy"].arn,
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
        "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
      ]
      trusted_role_actions = [
        "sts:AssumeRole"
      ]
    }
  }
}
