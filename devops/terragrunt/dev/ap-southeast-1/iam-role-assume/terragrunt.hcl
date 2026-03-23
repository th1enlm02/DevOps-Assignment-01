include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "iam-role" {
  path   = find_in_parent_folders("_env/iam-role-assume.hcl")
  expose = true
}
