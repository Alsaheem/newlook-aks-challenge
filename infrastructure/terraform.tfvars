environment = "development"
resource_group_name = "aks_terraform_rg"
location            = "West Europe"
cluster_name        = "terraform-aks"
container_registry_name = "newlookchallengecontainerregistry"
kubernetes_version  = "1.26.3"
system_node_count   = 1
node_resource_group = "aks_terraform_resources_rg"