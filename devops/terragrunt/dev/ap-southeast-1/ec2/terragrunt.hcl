include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "ec2" {
  path   = find_in_parent_folders("_env/ec2.hcl")
  expose = true
}
