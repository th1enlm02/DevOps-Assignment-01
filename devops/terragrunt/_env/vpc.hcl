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
  source = "git@github.com:th1enlm02/terraform-modules.git//aws/vpc?ref=main"
}

inputs = {
  name               = "${local.stack_name}-vpc"
  cidr               = local.vpc_cidr
  enable_nat_gateway = true
  single_nat_gateway = true
  azs                = local.azs
  private_subnets    = concat([for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)], [cidrsubnet(local.vpc_cidr, 4, 7)])
  public_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 4)]

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = local.stack_name
  }

  tags = local.tags
}
