include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}
include "dynamodb-table" {
  path   = find_in_parent_folders("_env/dynamodb-table.hcl")
  expose = true
}