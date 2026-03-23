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

dependency "lambda" {
  config_path = find_in_parent_folders("lambda/backend-nodejs")
  mock_outputs = {
    lambda_function_arn = "mock-lambda-arn"
  }
}

dependencies {
  paths = [
    find_in_parent_folders("lambda"),
  ]
}

terraform {
  source = "git::git@github.com:th1enlm02/terraform-modules.git//aws/apigateway/wrappers?ref=main"
}

inputs = {
  items = {
    "${local.stack_name}-backend-nodejs-api" = {
        name = "${local.stack_name}-api-gateway"
        protocol_type = "HTTP"
        routes = {
            "ANY /{proxy+}" = {
                integration = {
                    uri = dependency.lambda.outputs.lambda_function_arn
                }
            }
        }
        stage_name = "$default"
        create_domain_name    = false
        create_domain_records = false
        tags = local.tags
    }
  }
}
