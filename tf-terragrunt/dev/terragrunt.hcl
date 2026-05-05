locals {
  env_vars = yamldecode(
    file(find_in_parent_folders("common-environment.yaml"))
  )
}

inputs = {
  instance_type = local.env_vars.locals.dev.instance_type
}