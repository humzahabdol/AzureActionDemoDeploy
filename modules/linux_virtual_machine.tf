# Provision multiple Linux Virtual Machines
resource "azurerm_linux_virtual_machine" "my_linux_vm" {
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