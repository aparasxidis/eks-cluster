variable cluster_name {
  type        = string
  default     = ""
  description = "description"
}
variable cluster_endpoint {
  type        = string
  default     = ""
  description = "description"
}
variable cluster_version {
  type        = string
  description = "description"
}
variable cluster_certificate_authority_data {
  type        = string
  description = "description"
}
variable oidc_provider_arn {
  type        = string
  default     = ""
  description = "description"
}
variable region {
  type        = string
  default     = ""
  description = "description"
}
variable account_id {
  type        = string
  default     = ""
  description = "description"
}
variable vpc_id {
  type        = string
  default     = ""
  description = "description"
}
variable "tags" {
  type = map(string)
}
variable enable_external_secrets {
  type        = bool
  default     = false
  description = "description"
}
variable enable_metrics_server  {
  type        = bool
  default     = true
  description = "description"
}

variable enable_cluster_autoscaler  {
  type        = bool
  default     = false
  description = "description"
}
variable enable_argocd  {
  type        = bool
  default     = false
  description = "description"
}
variable enable_aws_load_balancer_controller  {
  type        = bool
  default     = false
  description = "description"
}
variable enable_aws_efs_csi_driver  {
  type        = bool
  default     = false
  description = "description"
}
variable enable_kube_prometheus_stack  {
  type        = bool
  default     = false
  description = "description"
}