param location string
param environmentName string
param agentImage string
param identityClientId string
param cosmosEndpoint string
param databaseName string
param pollingSchedule string

resource env 'Microsoft.Web/containerAppsEnvironments@2023-05-01' = {
  name: '${environmentName}-env'
  location: location
}

resource job 'Microsoft.Web/containerApps/jobs@2023-05-01' = {
  name: '${environmentName}-openipam-agent'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityClientId}': {}
    }
  }
  properties: {
    environmentId: env.id
    configuration: {
      triggerType: 'Schedule'
      scheduleTriggerConfig: {
        cronExpression: pollingSchedule
      }
    }
    template: {
      containers: [
        {
          name: 'agent'
          image: agentImage
          env: [
            { name: 'OPENIPAM_AUTH_MODE', value: 'ManagedIdentity' }
            { name: 'OPENIPAM_MANAGED_IDENTITY_CLIENT_ID', value: identityClientId }
            { name: 'OPENIPAM_COSMOS_ACCOUNT_ENDPOINT', value: cosmosEndpoint }
            { name: 'OPENIPAM_COSMOS_DATABASE_NAME', value: databaseName }
            { name: 'OPENIPAM_COSMOS_VNET_CONTAINER', value: 'virtualNetworks' }
            { name: 'OPENIPAM_COSMOS_PUBLICIP_CONTAINER', value: 'publicIps' }
          ]
        }
      ]
    }
  }
}
