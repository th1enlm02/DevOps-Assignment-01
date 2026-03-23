include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "ec2-sg" {
  path   = find_in_parent_folders("_env/ec2-sg.hcl")
  expose = true
}
