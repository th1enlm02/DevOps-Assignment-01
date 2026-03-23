include "root" {
  path = find_in_parent_folders("root.hcl")
}

generate "data_aws_ami" {
  path      = "aws_ec2_ami_generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_ami" "amazon_linux_23" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

output "ami_id" {
  value = data.aws_ami.amazon_linux_23.id
  sensitive = true
}
EOF
}

terraform {
  source = "./"
}