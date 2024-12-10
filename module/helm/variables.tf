variable "eks_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "eks_certificate_authority" {
  description = "Base64 encoded certificate authority data for the EKS cluster"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "release_name" {
  description = "Helm release name"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy the Helm release"
  type        = string
  default     = "default"
}

variable "create_namespace" {
  description = "Whether to create the namespace if it does not exist"
  type        = bool
  default     = true
}

variable "repository" {
  description = "Helm repository URL"
  type        = string
}

variable "chart" {
  description = "Helm chart name"
  type        = string
}

variable "chart_version" {
  description = "Version of the Helm chart to deploy"
  type        = string
  default     = "latest"
}

variable "values" {
  description = "Custom values to override in the Helm chart"
  type        = list(any)
  default     = []
}
