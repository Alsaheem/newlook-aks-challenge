variable "environment" {
  type        = string
  description = "Infrastructure deployment environment"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}

variable "cluster_name" {
  type        = string
  description = "AKS kubernetes cluster name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.26.3"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
  default = 1
}

variable "node_resource_group" {
  type        = string
  description = "RG name for cluster resources in Azure"
}

variable "container_registry_name" {
  type        = string
  description = "ACR Container registry name"
}
