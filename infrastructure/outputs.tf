output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_fully_qualified_domain_name" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}
