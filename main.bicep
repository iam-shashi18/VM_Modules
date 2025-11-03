param vmName string = 'Ansible-server'
param Username string = 'Ansibleuser'
param location string = 'Central India'
param vnetName string = 'Ansible-Vnet'
param subnetName string = 'Ansible-Subnet'
param nicName string = 'Ansible-NIC'
param nsgName string = 'Ansible-NSG'

@secure()
param sshPublicKey string
param userAssignedIdentityId string

module vnetModule './vnet.bicep' = {
  name: 'vnetModule'
  params: {
    vnetName: vnetName
    subnetName: subnetName
    location: location
    nsgName: nsgName
  }
}

module networkModule './network.bicep' = {
  name: 'networkModule'
  params: {
    nicName: nicName
    location: location
    subnetId: vnetModule.outputs.subnetId
    nsgId: vnetModule.outputs.nsgId
  }
  dependsOn: [
    vnetModule
  ]
}

module vmModule './vm.bicep' = {
  name: 'vmModule'
  params: {
    vmName: vmName
    Username: Username
    location: location
    nicId: networkModule.outputs.nicId
    userAssignedIdentityId: userAssignedIdentityId
    sshPublicKey: sshPublicKey
  }
  dependsOn: [
    networkModule
  ]
}

