provider "azurerm" {
  features {}
}

locals {
  commonTags = {
    Environment = "${var.environment}"
    Customer    = "${var.customerName}"
    Owner       = "${var.owner}"
  }
}
