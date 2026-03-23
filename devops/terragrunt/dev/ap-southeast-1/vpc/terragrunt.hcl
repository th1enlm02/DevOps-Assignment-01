include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "vpc" {
  path   = find_in_parent_folders("_env/vpc.hcl")
  expose = true
}
