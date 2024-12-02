# Common
azure_region       = "westus3"
dcauto_location    = "W3"
dcauto_environment = "DEMO"

# Linux templating
dns_search_order = "humzah"

# Virtual Network

app_plans = {
    security= [
        {
            osType                       = "Windows"
            sku                          = "S3"
        }
    ]
}

servers = {
  backend = []
  security = [
    {
      name                         = "SQLTOOL"
      osType                       = "Windows"
      count                        = 1
      sku                          = "Standard_D4s_v4"
      os_disk_storage_account_type = "Premium_LRS"
      disk_size                    = 200
      data_disks                   = {}
      image                        = "asodhsaohd"
      user_assigned_identities     = ["/subscriptions/obdsg;adjvbsdfljsb/resourceGroups/jlansdsljsnd/providers/Microsoft.ManagedIdentity/userAssignedIdentities/MsfSqlfabricUserAssignedIdentityDemoUs"]
      network_interface_cards = {
        "primary_nic" = {
          subnet_name                = "Admin"
          application_security_group = "sql-tools"
        }
      }
    }
  ]

  frontend = []
}
