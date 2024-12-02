resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = "westus2"
  resource_group_name = "testing"
  os_type             = "Linux"
  sku_name            = "S1" # Standard pricing tier
  worker_count        = 3

  tags = {
    Environment = "Staging"
    Owner       = "DevOpsTeam"
  }
}