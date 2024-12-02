# # Provision multiple Linux Virtual Machines
# resource "azurerm_linux_virtual_machine" "my_linux_vm" {
#   location            = "eastus"
#   name                = "test-${count.index}"
#   resource_group_name = "test"
#   admin_username      = "testuser"
#   admin_password      = "Testpa5s"

#   size = "Standard_F16s" # Change to Standard_F16s_v2 for comparison

#   tags = {
#     Environment = "production"
#     Service     = "web-app-${count.index}"
#   }

#   os_disk {
#     caching               = "ReadWrite"
#     storage_account_type  = "Standard_LRS"
#   }

#   network_interface_ids = [
#     "/subscriptions/123/resourceGroups/testrg/providers/Microsoft.Network/networkInterfaces/testnic-${count.index}",
#   ]

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
# }

resource "azurerm_windows_virtual_machine" "windows_virtual_machine" {
  name                       = lower(var.server_name)
  resource_group_name        = var.resource_group_name
  location                   = var.azure_region
  size                       = var.sku
  timezone                   = var.timezone
  encryption_at_host_enabled = var.encryption_at_host_enabled

  availability_set_id = var.availability_set_id != null ? var.availability_set_id : null
  zone                = var.availability_set_id != null ? null : var.availability_zone

  admin_username = var.local_admin_username
  admin_password = data.azurerm_key_vault_secret.secret[0].value

  network_interface_ids = [
    "/subscriptions/123/resourceGroups/testrg/providers/Microsoft.Network/networkInterfaces/testnic-${count.index}",
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  dynamic "plan" {
    for_each = var.plan == null ? [] : [1]
    content {
      name      = var.plan.name
      publisher = var.plan.publisher
      product   = var.plan.product
    }
  }

  custom_data = var.custom_data_type != null ? module.custom_data[0].completed_custom_data_file : var.custom_data

  disk_controller_type = var.disk_controller_type == "none" ? null : var.disk_controller_type

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }
  license_type             = "Windows_Server"

  winrm_listener {
    protocol = "Http"
  }

}