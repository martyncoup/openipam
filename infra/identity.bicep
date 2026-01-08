param location string
param environmentName string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${environmentName}-openipam-agent-mi'
  location: location
}

output clientId string = identity.properties.clientId
output principalId string = identity.properties.principalId
