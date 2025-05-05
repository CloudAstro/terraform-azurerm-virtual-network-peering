## 🌐 Additional Information

This module provides a flexible way to manage Azure Virtual Network peerings, enabling secure connectivity between VNets across subscriptions or regions. It supports advanced configuration options such as traffic forwarding, gateway transit, and IPv6 peering, making it suitable for both simple and complex network topologies.

## 📚 Resources

- [Terraform AzureRM Virtual Network Peering Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering)  
- [Azure Virtual Network Peering Overview](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)  
- [Azure Virtual Network Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/)  
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## ⚠️ Notes

- Ensure both VNets are in the **same or compatible regions** if required.
- Peering links are **non-transitive** — peered VNets cannot automatically reach other peered VNets.
- Gateway transit and use of remote gateways must be planned carefully to avoid conflicts.
- Review Azure subscription limits for the number of allowed peerings per VNet.

## 🧾 License

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
