locals{
    servers = flatten([
        for group in keys(var.servers) :
        [for type in var.servers[group] :
        [for i in range(type.count) : [
            {
            group                          = group
            resource_group_name            = "${group}-${lower(var.dcauto_location)}-${var.environment}-${var.azure_region}"
            instance                       = i
            zone                           = type.zones[(i % length(type.zones))]
            type                           = type.name
            create_first                   = lookup(type, "create_first", false)
            skip_domain_join               = lookup(type, "skip_domain_join", false)
            enable_dcauto_provisioning     = lookup(type, "enable_dcauto_provisioning", true)
            enable_availability_set        = lookup(type, "enable_availability_set", false)
            enable_network_watcher         = lookup(type, "enable_network_watcher", false)
            server_name                    = lower(join("", [var.dcauto_location, local.platform_system_name, type.name, local.environment_short_name[var.environment], (format("%02d", i + 1))]))
            legacy_domain_extension_in_use = try(local.format_result_check_domain_extension[lower(join("", [var.dcauto_location, local.platform_system_name, type.name, local.environment_short_name[var.environment], (format("%02d", i + 1))]))].legacy_domain_extension_in_use, false)
            sku                            = type.sku
            os_disk_storage_account_type   = type.os_disk_storage_account_type
            disk_size                      = type.disk_size
            disk_controller_type           = lookup(type, "disk_controller_type", "SCSI")
            image                          = lookup(type, "image", null)
            lb_interface_name              = lookup(type, "lb_interface_name", null)
            vm_offer                       = lookup(type, "vm_offer", null)
            vm_publisher                   = lookup(type, "vm_publisher", null)
            vm_sku                         = lookup(type, "vm_sku", null)
            vm_version                     = lookup(type, "vm_version", null)
            osType                         = type.osType
            network_interface_order        = lookup(type, "network_interface_order", null)
            network_interface_cards        = type.network_interface_cards
            data_disks                     = type.data_disks
            ansible_role                   = lookup(type, "ansible_role", null)
            identity_type                  = lookup(type, "user_assigned_identities", null) != null || var.required_identities != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
            user_assigned_identities       = lookup(type, "user_assigned_identities", null) != null || var.required_identities != null ? compact(concat(coalesce(type.user_assigned_identities, [""]), coalesce(var.required_identities, [""]))) : null
            plan                           = lookup(type, "plan", null)
            custom_data_type               = lookup(type, "custom_data_type", null)
            custom_data_file               = lookup(type, "custom_data_file", null)
            custom_data_values             = lookup(type, "custom_data_values", null)
            enable_lb                      = try(type.enable_lb[i], false)
            tags                           = merge(var.tags, lookup(type, "tags", {}))
            function                       = lookup(type, "function", null)
            dcauto_instance                = lookup(type, "dcauto_instance", null)
            dcauto_zone                    = lookup(type, "dcauto_zone", null)
            }
        ]]
        ]
    ])
}