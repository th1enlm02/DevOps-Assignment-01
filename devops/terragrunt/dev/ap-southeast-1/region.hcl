locals {
  region = basename(get_terragrunt_dir())
  # azs    = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  azs    = ["ap-southeast-1a", "ap-southeast-1b"]
  vpc_cidr_mapping = {
    "gameloft" = "10.0.0.0/16"
  }

  region_tags = {
    "AWSRegion" = local.region
  }
}
