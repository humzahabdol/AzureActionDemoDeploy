# locals {
#   servers = flatten([
#     for group in keys(var.servers) :
#     [for type in var.servers[group] :
#       [for i in range(type.count) : [
#         {
#           group                        = group
#           resource_group_name          = "${group}-${lower(var.dcauto_location)}-${var.environment}-${var.azure_region}"
#           instance                     = i
#           zone                         = type.zones[(i % length(type.zones))]
#           type                         = type.name
#           server_name                  = lower(join("", [var.dcauto_location, local.platform_system_name, type.name, local.environment_short_name[var.environment], (format("%02d", i + 1))]))
#           sku                          = type.sku
#           os_disk_storage_account_type = type.os_disk_storage_account_type
#           disk_size                    = type.disk_size
#           plan                         = lookup(type, "plan", null)
#         }
#       ]]
#     ]
#   ])
# }
locals {
  servers = flatten([
    for group in keys(var.app_plans) :
    [for type in var.app_plans[group] :
      [for i in range(type.count) : [
        {
          osType                         = type.osType
          sku                            = type.sku
        }
      ]]
    ]
  ])
}
