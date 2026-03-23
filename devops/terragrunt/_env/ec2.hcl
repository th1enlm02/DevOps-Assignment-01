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

  user_data = <<-USERDATA
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-$(uname -m) -o /usr/local/bin/docker-compose \
    && sudo chmod +x /usr/local/bin/docker-compose
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx
    yum install -y certbot python3-certbot-nginx
    mkdir -p /home/ec2-user/app
    chown ec2-user:ec2-user /home/ec2-user/app
    yum install -y git
  USERDATA
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

dependency "security_group" {
  config_path = find_in_parent_folders("security_group/ec2-sg")
  mock_outputs = {
    security_group_id = "mock-security-group-id"
  }
}

dependency "ami" {
  config_path = find_in_parent_folders("data/ami")
  mock_outputs = {
    ami_id = "mock-ami-id"
  }
}

dependencies {
  paths = [
    find_in_parent_folders("vpc"),
    find_in_parent_folders("security_group/ec2-sg"),
    find_in_parent_folders("data/ami")
  ]
}

terraform {
  source = "git::git@github.com:th1enlm02/terraform-modules.git//aws/ec2?ref=main"
}

inputs = {
  name = local.stack_name

  ami                         = "ami-01dc51e87421923b6"
  instance_type               = "t3.small"
  availability_zone           = element(local.azs, 0)
  subnet_id                   = element(dependency.vpc.outputs.public_subnets, 0)
  create_eip                  = true
  eip_tags                    = local.tags
  create_iam_instance_profile = false
  vpc_security_group_ids      = [dependency.security_group.outputs.security_group_id]
  user_data_base64            = base64encode(local.user_data)
  enable_volume_tags          = true
  key_name                    = "${local.stack_name}-keypair"
  root_block_device = [
    {
      encrypted   = false
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    },
  ]
  tags = local.tags
}
