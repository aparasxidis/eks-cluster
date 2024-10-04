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
  account_name = local.account_vars.locals.account_name
  project_name = local.project_vars.locals.project_name
}
# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../../../modules/eks-karpenter"
}
dependency "network" {
  config_path = "../network/vpc"
}
# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------
# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}
## These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name            = "${local.env}-${local.project_name}"
  cluster_version = "1.30"
  azs = local.azs
  tags = local.tags
#################################################################################
## DEPENDENCIES
#################################################################################
  vpc_id          = dependency.network.outputs.vpc_id
  worker_node_subnets = slice(dependency.network.outputs.private_subnets, 0, 3)
  private_subnets = dependency.network.outputs.private_subnets
  intra_subnets   = dependency.network.outputs.intra_subnets
}