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

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    vpc_id         = "mock-vpc-id"
    vpc_cidr_block = local.vpc_cidr
  }
}

dependencies {
  paths = [
    find_in_parent_folders("vpc")
  ]
}

terraform {
  source = "git@github.com:th1enlm02/terraform-modules.git//aws/security-group?ref=main"
}

inputs = {
  name            = "${local.stack_name}-ec2-sg"
  use_name_prefix = false
  description     = "Security group for ${local.stack_name} EC2 instance"
  vpc_id          = dependency.vpc.outputs.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]

  tags = local.tags
}
