provider "azurerm" {
  features {}
}

variable "desired_capacity" {
  default = 2
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = var.desired_capacity
  }

  upgrade_policy {
    mode = "Manual"
  }

  network_profile {
    name    = "example-networkprofile"
    primary = true

    ip_configuration {
      name      = "internal"
      subnet_id = azurerm_subnet.example.id
      primary   = true
    }
  }

  os_profile {
    computer_name_prefix = "testvm"
    admin_username       = "adminuser"
    admin_password       = "Password1234!"
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }
}

data "azurerm_virtual_machine_scale_set" "example" {
  name                = azurerm_virtual_machine_scale_set.example.name
  resource_group_name = azurerm_virtual_machine_scale_set.example.resource_group_name
}

locals {
  vmss_exists       = length(try(data.azurerm_virtual_machine_scale_set.example.id, [])) > 0
  current_capacity  = local.vmss_exists ? azurerm_virtual_machine_scale_set.example.sku[0].capacity : 0
  should_scale_down = var.desired_capacity < local.current_capacity
}

resource "null_resource" "fetch_instance_ids" {
  count = local.vmss_exists ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      az vmss list-instances --resource-group ${azurerm_resource_group.example.name} --name ${azurerm_virtual_machine_scale_set.example.name} --query "[].{instanceId:instanceId}" -o tsv > instance_ids.txt
    EOT
  }

  depends_on = [
    azurerm_virtual_machine_scale_set.example
  ]
}

resource "null_resource" "remove_instance" {
  count = local.should_scale_down && local.vmss_exists ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      instance_id=$(head -n 1 instance_ids.txt)
      python3 remove_vm_instance.py ${azurerm_resource_group.example.name} ${azurerm_virtual_machine_scale_set.example.name} $instance_id
    EOT

    environment = {
      AZURE_SUBSCRIPTION_ID = "your-subscription-id"
      AZURE_TENANT_ID       = "your-tenant-id"
      AZURE_CLIENT_ID       = "your-client-id"
      AZURE_CLIENT_SECRET   = "your-client-secret"
    }
  }

  depends_on = [
    azurerm_virtual_machine_scale_set.example,
    null_resource.fetch_instance_ids
  ]
}
