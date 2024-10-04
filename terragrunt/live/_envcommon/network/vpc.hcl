# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for vpc. The common variables for each environment to
# deploy vpc are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------
# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = local.base_source_url
}
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
  account_name = local.account_vars.locals.account_name
  project_name = local.project_vars.locals.project_name
  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "tfr:///terraform-aws-modules/vpc/aws?version=5.13.0"
}
# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  name   = "${local.env}-${local.project_name}"
  region = local.region
  cidr                = local.cidr
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.cidr, 3, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.cidr, 5, k + 12)]
  intra_subnets       = [for k, v in local.azs : cidrsubnet(local.cidr, 5, k + 16)]
  vpc_tags = {
    Name = "${local.env}-${local.project_name}-vpc"
  }
  igw_tags = {
    Name = "${local.env}-${local.project_name}-igw"
  }
  nat_gateway_tags = {
    Name = "${local.env}-${local.project_name}-natgw"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery" = "${local.env}-${local.project_name}"
  }
  enable_nat_gateway           = true
  single_nat_gateway           = true
  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 90
  tags = local.tags
}