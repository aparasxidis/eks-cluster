# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  project_name = "k8sgpt"
  cidr = "10.0.0.0/23"
  secondary_cidr_blocks = "100.64.0.0/16"
  tags = {
            "Environment": "demo",
            "karpenter.sh/discovery": "demo-k8sgpt",
  }
}