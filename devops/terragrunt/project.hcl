locals {
  project_dir = "gameloft"
  project_tags = {
    "ProjectName"  = upper(local.project_dir)
    "Component"    = upper(local.project_dir)
    "ProjectOwner" = "Thien Luu"
    "ContactEmail" = "minhthienluu2406@gmail.com"
  }
  env_acc_id_map = {
    dev     = "659211415972"
    staging = ""
    prod    = ""
  }
}