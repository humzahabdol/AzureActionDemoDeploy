provider "azurerm" {
  skip_provider_registration = true
  features {}
}

variable "resource_count" {
  description = "Number of resources to provision"
  type        = number
  default     = 8
}
variable "enable_virtual_machines" {
  description = "Enable provisioning of virtual machines"
  type        = bool
  default     = true
}
locals {
  # List of virtual machine configurations
  virtual_machines = [
    for i in range(1, 11) : {
      name                = "test-vm-${i}"
      network_interface   = "testnic-${i}"
      size                = "Standard_F16s"
      resource_group_name = "test"
    }
  ]
}
# Provision multiple Linux Virtual Machines
module "linux_virtual_machine" {
  source = "./modules/linux_virtual_machine"

  for_each = var.enable_virtual_machines ? { for vm in local.virtual_machines : vm.name => vm } : {}

  location            = "eastus"
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  admin_username      = "testuser"
  admin_password      = "Testpa5s"
  size                = each.value.size

  network_interface_ids = [
    "/subscriptions/123/resourceGroups/testrg/providers/Microsoft.Network/networkInterfaces/${each.value.network_interface}",
  ]

  tags = {
    Environment = "production"
    Service     = "web-app"
  }

  source_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk = {
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }
}


# resource "azurerm_service_plan" "my_app_service" {
#   location = "eastus"
#   name = "test"
#   resource_group_name = "test_resource_group"
#   os_type = "Windows"

#   sku_name = "P1v2"
#   worker_count = 4 # <<<<<<<<<< Try changing this to 8 to compare the costs

#   tags = {
#     Environment = "Prod"
#     Service = "web-app"
#   }
# }

# resource "azurerm_linux_function_app" "my_function" {
#   location = "eastus"
#   name = "test"
#   resource_group_name = "test"
#   service_plan_id = "/subscriptions/123/resourceGroups/testrg/providers/Microsoft.Web/serverFarms/serverFarmValue"
#   storage_account_name = "test"
#   storage_account_access_key = "test"
#   site_config {}

#   tags = {
#     Environment = "Prod"
#   }
# }
