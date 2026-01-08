param location string = resourceGroup().location
param environmentName string
param agentImage string
param pollingSchedule string = '*/15 * * * *'

module identity './identity.bicep' = {
  name: 'identity'
  params: {
    location: location
    environmentName: environmentName
  }
}

module cosmos './cosmos.bicep' = {
  name: 'cosmos'
  params: {
    location: location
    environmentName: environmentName
    principalId: identity.outputs.principalId
  }
}

module agent './containerapp.bicep' = {
  name: 'agent'
  params: {
    location: location
    environmentName: environmentName
    agentImage: agentImage
    identityClientId: identity.outputs.clientId
    cosmosEndpoint: cosmos.outputs.endpoint
    databaseName: cosmos.outputs.databaseName
    pollingSchedule: pollingSchedule
  }
}
