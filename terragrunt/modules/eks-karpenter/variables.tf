variable name {
  type        = string
  default     = ""
  description = "description"
}
variable cluster_version {
  type        = string
  description = "description"
}
variable region {
  type        = string
  default     = ""
  description = "description"
}
variable vpc_id {
  type        = string
  default     = ""
  description = "description"
}
variable private_subnets {
  type        = list(string)
  description = "description"
}
variable worker_node_subnets {
  type        = list(string)
  description = "description"
}
variable intra_subnets {
  type        = list(string)
  description = "description"
}
variable "tags" {
  type = map(string)
}
variable manage_aws_auth_configmap {
  type        = bool
  default     = false
  description = "description"
}
variable aws_auth_users {
  type        = any
  default     = []
  description = "description"
}
variable azs {
  type        = list(string)
  description = "description"
}
variable enable_gpu_nodes {
  type        = bool
  default     = false
  description = "description"
}