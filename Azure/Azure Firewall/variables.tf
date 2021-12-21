variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default = "westeurope"
}

variable "customerName"{
  description = "The name of the customer. This name is added to the ressource group name"
  default = "wbb"
}

variable "environment"{
  description = "The environment. Normaly prod or stage or dev."
  default = "Prod"
}

variable "owner"{
  description = "Who is responsible for this?."
  default = "Bernd Spieth"
}

variable "windowsAdmin"{
  description = "The admin user for the Windows vm"
  default = "bspieth"
}

variable "windowsAdminPassword"{
  description = "The password for the Windows vm"
  default = "ThisIsASsecret1!"
  type        = string
  sensitive   = true
}