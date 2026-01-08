param location string
param environmentName string
param principalId string

resource account 'Microsoft.DocumentDB/databaseAccounts@2024-02-15-preview' = {
  name: '${environmentName}openipamcosmos'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    disableLocalAuth: true
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
  }
}

resource db 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-02-15-preview' = {
  parent: account
  name: 'openipam'
  properties: {
    resource: {
      id: 'openipam'
    }
  }
}

resource vnetContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-02-15-preview' = {
  parent: db
  name: 'virtualNetworks'
  properties: {
    resource: {
      id: 'virtualNetworks'
      partitionKey: {
        paths: ['/subscriptionId']
        kind: 'Hash'
      }
    }
  }
}

resource pipContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-02-15-preview' = {
  parent: db
  name: 'publicIps'
  properties: {
    resource: {
      id: 'publicIps'
      partitionKey: {
        paths: ['/subscriptionId']
        kind: 'Hash'
      }
    }
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: account
  name: guid(account.id, principalId, 'cosmos-data')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00000000-0000-0000-0000-000000000002' // Cosmos DB Built-in Data Contributor
    )
    principalId: principalId
  }
}

output endpoint string = account.properties.documentEndpoint
output databaseName string = db.name
