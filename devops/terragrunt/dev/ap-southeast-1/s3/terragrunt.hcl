include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "s3" {
  path   = find_in_parent_folders("_env/s3.hcl")
  expose = true
}
