provider "azurerm" {
  features {}
}

# module "windows_virtual_machine" {
#   source = "./modules/linux_virtual_machine"

#   for_each = { for server in local.servers : server.server_name => server if lower(server.osType) == "windows" && server.create_first == false }

#   #image or plan
#   source_image_id = each.value["image"] != null ? module.compute_gallery_image_version[each.key].latest.id : null
#   vm_offer        = each.value["vm_offer"]
#   vm_publisher    = each.value["vm_publisher"]
#   vm_sku          = each.value["vm_sku"]
#   vm_version      = each.value["vm_version"]
#   plan            = each.value["plan"]

#   custom_data_type   = each.value["custom_data_type"]
#   custom_data_file   = each.value["custom_data_file"]
#   custom_data_values = each.value["custom_data_values"]

#   os_disk_storage_account_type = each.value["os_disk_storage_account_type"]
#   os_disk_size_gb              = max(128, each.value["disk_size"])

# }

# module "humzah-test" {
#   source = "./modules/linux_virtual_machine"

#   vm_sku          = "Standard_F2"

# }

module "app_plan_2" {
  source = "./modules/app_plan"
  #  for_each = { for server in local.servers : server.server_name => server if lower(server.osType) == "windows" && server.create_first == false }

  for_each = { for app_plan in local.app_plans : app_plan.name => app_plan if lower(app_plan.osType) == "windows"}
  sku_name = "S3"

}

# module "app_plan" {
#   source = "./modules/app_plan"
#   sku_name = "S3"

# }