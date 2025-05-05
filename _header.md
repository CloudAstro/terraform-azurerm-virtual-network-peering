# Azure Virtual Network Peering Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)
[![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE)
[![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)
[![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/CloudAstro/vnet-peering/azurerm/)

This module is designed to manage **Azure Virtual Network (VNet) peerings** between two VNets. It allows fine-grained control over peering settings such as traffic forwarding, gateway transit, and network access, providing secure and scalable network connectivity across VNets.

# Features

- **VNet Peering Management:** Creates and manages peering connections between Azure virtual networks.
- **Access Control:** Supports configuration of virtual network access, forwarded traffic, and gateway transit.
- **IPv6 Peering:** Optionally enables IPv6 peering for dual-stack scenarios.
- **Complete Network Peering:** Allows peering of all subnets and networks across the virtual networks.

# Example Usage

This example demonstrates how to configure a peering between two virtual networks:
