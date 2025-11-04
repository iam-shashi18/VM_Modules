param vmName string 
param Username string 
param location string 
param vnetName string 
param subnetName string 
param nicName string 
param nsgName string 
param privateEndpointName string 
param tenantId string 
param keyVaultName string
@secure()
param sshPublicKey string

param identityName string 


module identityModule './identity.bicep' = {
  name: 'identityModule'
  params: {
    location: location
    identityName: identityName
  }
}


module vnetModule './vnet.bicep' = {
  name: 'vnetModule'
  params: {
    vnetName: vnetName
    subnetName: subnetName
    location: location
    nsgName: nsgName
  }
}


module keyVaultModule './keyvault.bicep' = {
  name: 'keyVaultPrivateModule'
  params: {
    location: location
    keyVaultName: keyVaultName
    pleSubnetId: vnetModule.outputs.pleSubnetId
    tenantId: tenantId
    privateEndpointName: privateEndpointName
  }
  dependsOn: [
    vnetModule
  ]
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
    userAssignedIdentityId: identityModule.outputs.identityId
    sshPublicKey: sshPublicKey
  }
  dependsOn: [
    networkModule
    identityModule
  ]
}
