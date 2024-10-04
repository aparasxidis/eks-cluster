provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}
################################################################################
# EKS Blueprints v5
################################################################################
module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "1.16.4" #ensure to update this to the latest/desired version
  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn
  eks_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      most_recent = true
      configuration_values = jsonencode({
        controller = {
          volumeModificationFeature = {
            enabled = true
          }
        }
      })
    }
  }
  enable_cluster_autoscaler  = var.enable_cluster_autoscaler
  enable_argocd     = var.enable_argocd
  enable_metrics_server  = var.enable_metrics_server
  enable_external_secrets     = var.enable_external_secrets
  enable_aws_load_balancer_controller  = var.enable_aws_load_balancer_controller
  enable_aws_efs_csi_driver     = var.enable_aws_efs_csi_driver
  enable_kube_prometheus_stack     = var.enable_kube_prometheus_stack
}
################ EBS CSI Driver IRSA #################
module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "${var.cluster_name}-ebs-csi-driver"
  attach_ebs_csi_policy = true
  oidc_providers = {
    ex = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "eks_blueprints_addon_k8sgpt" {
  source = "aws-ia/eks-blueprints-addon/aws"
  version = "1.1.1" #ensure to update this to the latest/desired version

  chart            = "k8sgpt-operator"
  chart_version    = "0.2.0"
  repository       = "https://charts.k8sgpt.ai/"
  description      = "k8sGPT Operator Helm Chart"
  namespace        = "k8sgpt-operator-system"
  create_namespace = true

  #values = [
  #  <<-EOT
  #    podDisruptionBudget:
  #      maxUnavailable: 1
  #    metrics:
  #      enabled: true
  #  EOT
  #]
#
  #set = [
  #  {
  #    name  = "replicas"
  #    value = 3
  #  }
  #]
}