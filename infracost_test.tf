provider "azurerm" {
  skip_provider_registration = true
  features {}
}

variable "resource_count" {
  description = "Number of resources to provision"
  type        = number
  default     = 8
}

# Provision multiple Linux Virtual Machines
resource "azurerm_linux_virtual_machine" "my_linux_vm" {
  count               = var.resource_count
  location            = "eastus"
  name                = "test-${count.index}"
  resource_group_name = "test"
  admin_username      = "testuser"
  admin_password      = "Testpa5s"

  size = "Standard_F16s" # Change to Standard_F16s_v2 for comparison

  tags = {
    Environment = "production"
    Service     = "web-app-${count.index}"
  }

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }

  network_interface_ids = [
    "/subscriptions/123/resourceGroups/testrg/providers/Microsoft.Network/networkInterfaces/testnic-${count.index}",
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
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
