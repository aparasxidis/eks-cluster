# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  # Extract out common variables for reuse
  env          = local.environment_vars.locals.environment
  tags         = local.project_vars.locals.tags
  region       = local.region_vars.locals.aws_region
  azs          = local.region_vars.locals.azs
  cidr         = local.project_vars.locals.cidr
  secondary_cidr_blocks         = local.project_vars.locals.secondary_cidr_blocks
  account_name = local.account_vars.locals.account_name
  project_name = local.project_vars.locals.project_name
}
# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = include.envcommon.locals.base_source_url
}
# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------
# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}
# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network/vpc.hcl"
  expose = true
}
## These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  secondary_cidr_blocks = [local.secondary_cidr_blocks]
  private_subnets = concat(
    [for k, v in local.azs : cidrsubnet(local.cidr, 3, k)],
    [for k, v in local.azs : cidrsubnet(local.secondary_cidr_blocks, 2, k)],
  )
}