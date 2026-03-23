include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "iam-policy" {
  path   = find_in_parent_folders("_env/iam-policy.hcl")
  expose = true
}