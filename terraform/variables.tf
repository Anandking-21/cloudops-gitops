variable "cluster_name" {
  description = "The name of the local Kind cluster"
  type        = string
  default     = "cloudops-platform"
}

variable "kubernetes_version" {
  description = "Kubernetes node image version"
  type        = string
  default     = "v1.31.0"
}
