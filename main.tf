resource "null_resource" "create_kubernetes_toolchain" {
  provisioner "local-exec" {
    command = "${path.cwd}/scripts/create-toolchain.sh"

    environment={
      REGION     =  var.region
      TOOLCHAIN_TEMPLATE_REPO  = var.toolchain_template_repo
      APPLICATION_REPO = var.application_repo
      RESOURCE_GROUP = var.resource_group
      API_KEY = var.ibmcloud_api_key
      CLUSTER_NAME = var.cluster_name
      CLUSTER_NAMESPACE = var.cluster_namespace
      CONTAINER_REGISTRY_NAMESPACE = var.container_registry_namespace
      TOOLCHAIN_NAME = var.toolchain_name
    }
  } 
}