include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "apigateway" {
  path   = find_in_parent_folders("_env/apigateway.hcl")
  expose = true
}