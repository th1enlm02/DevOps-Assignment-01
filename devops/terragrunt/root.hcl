locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  aws_account_id = local.project_vars.locals.env_acc_id_map[local.environment_vars.locals.environment]

  root_tags = {
    ManagedBy  = "Terragrunt"
    AWSAccount = local.aws_account_id
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">=1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
}

provider "aws" {
  assume_role {
    # role_arn     = "arn:aws:iam::${local.aws_account_id}:role/AdminAccess_AssumeRole"
    session_name = "gameloft"
  }
  region = "${local.region_vars.locals.region}"
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  # terragrunt plan --backend-bootstrap
  config = {
    bucket  = "vns-tf-state-${local.project_vars.locals.project_dir}-${local.environment_vars.locals.environment}-${local.region_vars.locals.region}"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = local.region_vars.locals.region
    encrypt = true
    use_lockfile           = true # S3 native locking
    skip_region_validation = true
    # assume_role = {
    #   role_arn = "arn:aws:iam::${local.aws_account_id}:role/AdminAccess_AssumeRole"
    # }
  }
}

