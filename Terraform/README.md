# Step 1 - Just the resourceGroup
## 1)   Execute the configuration as it is
If not yet done at this point, copy the content from `main.tf_Step1` into your `main.tf`.

```bash
terraform init;
terraform plan;
terraform apply -auto-approve;
```
### The output will be this:
```bash
Terraform will perform the following actions:

  # azurerm_resource_group.Step1 will be created
  + resource "azurerm_resource_group" "Step1" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "Step1"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```
## 2)   Let's add some tags
Unhash the tags-line in the resourceGroup

```bash
terraform plan;
```
### The output will be this:
```bash
Terraform will perform the following actions:

  # azurerm_resource_group.Step1 will be updated in-place
  ~ resource "azurerm_resource_group" "Step1" {
        id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/Step1"
        name     = "Step1"
      ~ tags     = {
          + "A" = "B"
        }
        # (1 unchanged attribute hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Not really suprisingly, but this wasn't something major!

# Step 2 - Add a network module to the mix
## 1) Copy the content from `main.tf_Step2` into your `main.tf` and re-run the config

```bash
terraform init;
terraform plan;
```
### The output will be this Error:
```bash
Error: Error: Resource Group "rg" was not found

  on network_w_dataSource\main.tf line 3, in data "azurerm_resource_group" "network":
   3: data "azurerm_resource_group" "network" {
```
The issue here is that both resources will be strated to be created at the same time, though the network `depends on` the resourceGroup.
## 2) Let's unhash the `depends on` line and re-run the configuration

```bash
terraform plan;
terraform apply -auto-approve;
```
### The output will be this:
```bash
Terraform will perform the following actions:

  # azurerm_resource_group.Step1 will be destroyed
  - resource "azurerm_resource_group" "Step1" {
      - id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/Step1" -> null
      - location = "westeurope" -> null
      - name     = "Step1" -> null
      - tags     = {} -> null
    }

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "rg"
    }

  # module.network.data.azurerm_resource_group.network will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_resource_group" "network"  {
      + id       = (known after apply)
      + location = (known after apply)
      + name     = "rg"
      + tags     = (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.data.azurerm_client_config.current will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_client_config" "current"  {
      ~ client_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id              = "2021-05-28 10:43:58.1079767 +0000 UTC" -> (known after apply)
      ~ object_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ subscription_id = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ tenant_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.azurerm_virtual_network.vnet will be created
  + resource "azurerm_virtual_network" "vnet" {
      + address_space         = [
          + "10.0.0.0/16",
        ]
      + guid                  = (known after apply)
      + id                    = (known after apply)
      + location              = (known after apply)
      + name                  = "vnet"
      + resource_group_name   = "rg"
      + subnet                = (known after apply)
      + vm_protection_enabled = false
    }

Plan: 2 to add, 0 to change, 1 to destroy.
```

*Be advised the fact the resourceGroup get's destroyed and re-created is due to a deliberately renaming*

## 3) Ok, what will happen, when we unhash the tags in the resourceGroup once again
unhash the tags-line in the resourceGroup once again

```bash
terraform plan;
# DO NOT run "terraform apply -auto-approve" at this point in time !!!!
```
### The output will be this:
```bash
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg"
        name     = "rg"
      ~ tags     = {
          + "A" = "B"
        }
        # (1 unchanged attribute hidden)
    }

  # module.network.data.azurerm_resource_group.network will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_resource_group" "network"  {
      ~ id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg" -> (known after apply)
      ~ location = "westeurope" -> (known after apply)
        name     = "rg"
      ~ tags     = {} -> (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.data.azurerm_client_config.current will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_client_config" "current"  {
      ~ client_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id              = "2021-05-28 10:43:58.1079767 +0000 UTC" -> (known after apply)
      ~ object_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ subscription_id = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ tenant_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.azurerm_virtual_network.vnet must be replaced
-/+ resource "azurerm_virtual_network" "vnet" {
      - dns_servers           = [] -> null
      ~ guid                  = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet" -> (known after apply)
      ~ location              = "westeurope" -> (known after apply) # forces replacement
        name                  = "vnet"
      ~ subnet                = [] -> (known after apply)
      - tags                  = {} -> null
        # (3 unchanged attributes hidden)
    }

Plan: 1 to add, 1 to change, 1 to destroy.
```
**Ok, this is  odd!**

We just changed the tags of the resourceGroup but the location of the network forces this one to be **destroyed and re-created ??**

The key phrase's here are `(known after apply) # forces replacement` and `will be read during apply`.

### So what is happening here
* As already stated above, the module `depends_on` the resourceGroup to already exist before it can even be executed
* But the resourceGroup will only be created durring the apply phase - hence the phrases `after/ during apply`
* We as humans do know the resourceGroup is unchanged, hence the ID will be unchanged, but how is Terraform suppose to know that
* To resolve this issue Hashicorp defined all data-source blocks as `to be read during apply` - even those unrealted to the depends_on - see the `azurerm_subscription`

### But why is the VNET to be replaced?
Well as the data sources are only read during the apply phase, Terraform cannot guarantee during the plan phase that the content of the parameteres - here the location - remains unchanged, hence Terraform will go the save route and re-create the resource with whatever value will be read during the apply phase - even if it is the same one as before!


# Step 3 - Option A to resolve this issue - no data sources in the module
## 1) Copy the content from `main.tf_Step3` into your `main.tf` and re-run the config

```bash
terraform init;
terraform plan;
```
### The output will be this Error:
```bash
Error: Missing required argument

  on main.tf line 11, in module "network":
  11: module "network" {

The argument "resource_group_location" is required, but no definition was
found.
```
The issue here is ... well we do not have the data source for the location anymore within the module, so we need to provide this information during the call of the module.
## 2) Let's unhash the `resource_group_location` line and re-run the configuration

```bash
terraform plan;
# DO NOT run "terraform apply -auto-approve" at this point in time !!!!
```
### The output will be this:
```bash
No changes. Infrastructure is up-to-date.
```

## 3) We are back again: what will happen, when we unhash the tags in the resourceGroup once again

```bash
terraform plan;
# DO NOT run "terraform apply -auto-approve" at this point in time !!!!
```
### The output will be this:
```bash
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg"
        name     = "rg"
      ~ tags     = {
          + "A" = "B"
        }
        # (1 unchanged attribute hidden)
    }

  # module.network.data.azurerm_client_config.current will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_client_config" "current"  {
      ~ client_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id              = "2021-05-28 11:03:37.41191 +0000 UTC" -> (known after apply)
      ~ object_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ subscription_id = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ tenant_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Well, this would be exactly what we wanted - just the resourceGroup gets updated, but `azurerm_client_config`still gets read during apply.

## 4) As we do not have any data sources in the module we do not need `depends_on` anymore

```bash
terraform plan;
# DO NOT run "terraform apply -auto-approve" at this point in time !!!!
```
### The output will be this:
```bash
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg"
        name     = "rg"
      ~ tags     = {
          + "A" = "B"
        }
        # (1 unchanged attribute hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Finally! But this only works for rather simple modules. Bigger once most likely will require to have data sources in them!



# Step 4 - Option A to resolve this issue - no data sources in the module
## 1) Copy the content from `main.tf_Step4` into your `main.tf` and re-run the config

```bash
terraform init;
terraform plan;
```
### The output will be this:
```bash
No changes. Infrastructure is up-to-date.
```

## 2) Let's unhash the tags in the resourceGroup once again

```bash
terraform plan;
# DO NOT run "terraform apply -auto-approve" at this point in time !!!!
```
### The output will be this:
```bash
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg"
        name     = "rg"
      ~ tags     = {
          + "A" = "B"
        }
        # (1 unchanged attribute hidden)
    }

  # module.network.data.azurerm_client_config.current will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_client_config" "current"  {
      ~ client_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id              = "2021-05-28 11:11:40.5245009 +0000 UTC" -> (known after apply)
      ~ object_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ subscription_id = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ tenant_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.data.azurerm_resource_group.network will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_resource_group" "network"  {
      + id       = (known after apply)
      + location = (known after apply)
      + name     = "rg"
      + tags     = (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.azurerm_virtual_network.vnet must be replaced
-/+ resource "azurerm_virtual_network" "vnet" {
      - dns_servers           = [] -> null
      ~ guid                  = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet" -> (known after apply)
      ~ location              = "westeurope" -> (known after apply) # forces replacement
        name                  = "vnet"
      ~ subnet                = [] -> (known after apply)
      - tags                  = {} -> null
        # (3 unchanged attributes hidden)
    }

Plan: 1 to add, 1 to change, 1 to destroy.
```

Ok, to be honest, this is now exactly what we had in Step2 already, Let's have a look inside the module

## 2) Open the main.tf from inside the module
As the problem is with the location, let's simply tell terraform to ignore the location and resource_group_name.
Unhash the lifecycle-block


```bash
terraform plan;
# DO NOT run "terraform apply -auto-approve" at this point in time !!!!
```
### The output will be this:
```bash
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg]
module.network.azurerm_virtual_network.vnet: Refreshing state... [id=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place
 <= read (data resources)

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg"
        name     = "rg"
      ~ tags     = {
          + "A" = "B"
        }
        # (1 unchanged attribute hidden)
    }

  # module.network.data.azurerm_client_config.current will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_client_config" "current"  {
      ~ client_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id              = "2021-05-28 11:11:40.5245009 +0000 UTC" -> (known after apply)
      ~ object_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ subscription_id = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ tenant_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.data.azurerm_resource_group.network will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_resource_group" "network"  {
      + id       = (known after apply)
      + location = (known after apply)
      + name     = "rg"
      + tags     = (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Ok, this looks promising, but what if the resourceGroup actually changes - this way Terraform would simply ignore it.
Here comes the identifier into place.

## 2) Unhash also the `for_each` line
First we need to adjust for the fact, we switched from "just a resource" to for_each - even if we limit it to just one iteration.
Best to start out like this.

```bash
terraform state mv $'module.network.azurerm_virtual_network.vnet' $'module.network.azurerm_virtual_network.vnet["rg"]'
terraform plan;
# DO NOT run "terraform apply -auto-approve" at this point in time !!!!
```
### The output will be this:
```bash
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg]
module.network.azurerm_virtual_network.vnet["rg"]: Refreshing state... [id=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place
 <= read (data resources)

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg"
        name     = "rg"
      ~ tags     = {
          + "A" = "B"
        }
        # (1 unchanged attribute hidden)
    }

  # module.network.data.azurerm_client_config.current will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_client_config" "current"  {
      ~ client_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ id              = "2021-05-28 11:11:40.5245009 +0000 UTC" -> (known after apply)
      ~ object_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ subscription_id = "00000000-0000-0000-0000-000000000000" -> (known after apply)
      ~ tenant_id       = "00000000-0000-0000-0000-000000000000" -> (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.network.data.azurerm_resource_group.network will be read during apply
  # (config refers to values not yet known)
 <= data "azurerm_resource_group" "network"  {
      + id       = (known after apply)
      + location = (known after apply)
      + name     = "rg"
      + tags     = (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

Ok, the output is the same as before, BUT with one significant difference:
`module.network.azurerm_virtual_network.vnet["rg"]: Refreshing state... [id=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet]'`

Let's assume the name of the resource group changes - in that case the index would change as well:
`module.network.azurerm_virtual_network.vnet["rg"]` => `module.network.azurerm_virtual_network.vnet["some_new_name"]`
Which would cause the old index - and the resource behind it - to be dropped and the new one re-created!
