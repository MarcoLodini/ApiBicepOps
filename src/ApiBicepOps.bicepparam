using 'main.bicep'

var api = 'exampleapi' //Name of the API
var version = 'v1' //Version of the API to deploy
var revision = '2' //API revision

param apimServiceName = 'myapimservice' //Name of the APIM Service instance

param apiVersionSetConfiguration = {
  name: '${api}set'
  properties: {
    displayName: 'Example API'
    description: 'Example API set'
    versioningScheme: 'Segment'
  }
}

param apiConfiguration = {
  name: '${api}${version}'
  policy: loadTextContent('./policies/global.xml')
  properties: {
    value: loadTextContent('./apidefinition.yml')
    format: 'openapi'
    type: 'http'
    protocols: [
      'https'
    ]
    displayName: 'Example API'
    description: 'Example API description'
    serviceUrl: 'https://myapimservice/api/example'
    path: 'api/example'
    subscriptionRequired: false
    isCurrent: false
    apiVersion: version
    apiVersionDescription: version
    apiRevision: revision
    apiRevisionDescription: 'rev ${revision}'
  }
  products: [
    'Example Product'
  ]
  operations: [
    {
      operationId: 'getUsers'
      value: loadTextContent('./policies/getUsers.xml')
    }
    {
      operationId: 'createUser'
      value: loadTextContent('./policies/createUser.xml')
    }
    {
      operationId: 'getUserById'
      value: loadTextContent('./policies/getUserById.xml')
    }
    {
      operationId: 'updateUser'
      value: loadTextContent('./policies/updateUser.xml')
    }
    {
      operationId: 'deleteUser'
      value: loadTextContent('./policies/deleteUser.xml')
    }
  ]
}

param namedValuesConfiguration = [
  {
    name: 'exampleVariable'
    properties: {
      value: 'exampleValue'
    }
  }
]

param backendsConfiguration = [
  {
    name: 'example-backend'
    properties: {
      protocol: 'http'
      url: 'https://localhost/'
    }
  }
] 
