param apimServiceName string
param apiConfiguration object
param apiVersionSetConfiguration object
param namedValuesConfiguration array
param backendsConfiguration array

resource apim 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apimServiceName
}

resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2023-05-01-preview' = {
  name: apiVersionSetConfiguration.name
  parent: apim
  properties: apiVersionSetConfiguration.properties
}

resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apiConfiguration.name};rev=${apiConfiguration.properties.apiRevision}'
  parent: apim
  properties: union(apiConfiguration.properties,
    {
      apiVersionSetId: apiVersionSet.id
    })

  resource globalPolicy 'policies' = {
    name: 'policy'
    properties: {
      //This MAY look ugly, but it really simplifies life for the user: easier named values!
      //That way, users do not have to calculate named values when putting them in their .xml, but use the same variable name
      //Also, allows global values if their named values already exist in APIM by using {#{value-name}#}
      value: replace(replace(replace(replace(apiConfiguration.policy, '{°{', '{{${apiConfiguration.name}-'), '}°}', '-${apiConfiguration.properties.apiVersion}}}'), '{#{', '{{'), '}#}', '}}')
      format: 'rawxml'
    }
  }
}

resource operationPolicies 'Microsoft.ApiManagement/service/apis/operations/policies@2023-05-01-preview' = [for policy in apiConfiguration.operations: {
// Disabling next line due to conflicting parent property type
#disable-next-line use-parent-property
  name: '${apim.name}/${apiConfiguration.name};rev=${apiConfiguration.properties.apiRevision}/${policy.operationId}/policy'
  dependsOn: [
    namedValues
  ]
  properties: {
    //Same thing as the global policy here
    value: replace(replace(replace(replace(policy.value, '{°{', '{{${apiConfiguration.name}-'), '}°}', '-${apiConfiguration.properties.apiVersion}}}'), '{#{', '{{'), '}#}', '}}')
    format: 'rawxml'
  }
}]

resource namedValues 'Microsoft.ApiManagement/service/namedValues@2023-05-01-preview' = [for namedVal in namedValuesConfiguration: {
  name: '${apiConfiguration.name}-${namedVal.name}-${apiConfiguration.properties.apiVersion}'
  parent: apim
  properties: union(namedVal.properties, {
    displayName: '${apiConfiguration.name}-${namedVal.name}-${apiConfiguration.properties.apiVersion}'
  })
}]

resource productBinding 'Microsoft.ApiManagement/service/products/apis@2023-05-01-preview' = [for product in apiConfiguration.products: {
// Disabling next line due to conflicting parent property type
#disable-next-line use-parent-property
  name: '${apim.name}/${replace(product, ' ', '')}/${apiConfiguration.name}' //product name doesn't like whitespaces
  dependsOn: [
    api
    products
  ]
}]

resource products 'Microsoft.ApiManagement/service/products@2023-05-01-preview' = [for product in apiConfiguration.products: {
  // Disabling next line due to conflicting parent property type
  #disable-next-line use-parent-property
    name: replace(product, ' ', '') //product name doesn't like whitespaces
    parent: apim
    properties: {
      displayName: product
      subscriptionRequired: false
      description: '${product} product'
      state: 'published'
    }
}]

resource backends 'Microsoft.ApiManagement/service/backends@2024-05-01' = [for backend in backendsConfiguration: {
  name: '${apiConfiguration.name}-${backend.name}'
  properties: backend.properties
}]
