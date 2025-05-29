# ApiBicepOps

## Overview
**ApiBicepOps** is a project designed to deploy APIs to Azure API Management using Bicep only, with the option to employ Bicep deployment scripts if necessary by extending the main bicep. The main goal is to streamline the deployment process by utilizing Bicep, eliminating the need for dedicated software solutions, Frankenstein scripts or custom undocumented YAML definitions.

If you don't know how to format a section, please refer to the awesome [Azure API Management Bicep resource definition](https://learn.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?pivots=deployment-language-bicep).

## Features
- **No scripts involved**: The entire deployment process is managed by Bicep itself through the `main.bicep` file.
- **Easily extendible**: Since it's a Bicep file definition, it can be easily extended to meet various requirements.
- **Simple CI/CD pipelines**: The project supports simple CI/CD pipelines for seamless releases: just put a Bicep deployment task and you're done.
- **Key Vault secret named values support**: Reference Key Vault values to deploy secrets and use them in your policies.
- **Simplified named value management**: Custom templating syntax eliminates the complexity of managing named values across multiple environments. Instead of calculating and hardcoding named value references in your policies, use intuitive variable placeholders that automatically resolve to environment-specific named values during deployment. This approach prevents naming conflicts, reduces configuration errors, and enables true infrastructure-as-code practices for API policies.
- **Named Values as "variables"**: By using named values as "variables" in policies, if something is missing, deployment fails. I think that's good.

## Installation
No installation is needed. Users only need a text editor to work on the project. **VS Code** is recommended due to the very useful Bicep extension.

## Usage
To use **ApiBicepOps**, follow these steps:
1. Open the `main.bicep` file in your text editor.
2. Use **Azure CLI** or **Bicep CLI** to launch the deployment of the solution.

### Custom Named Value Syntax
Unlike standard APIM policies where you must reference named values using their exact names (e.g., `{{my-specific-named-value}}`), ApiBicepOps uses a custom templating approach that simplifies multi-environment deployments.

**Standard APIM Policy Approach:**
```xml
<set-variable name="apiKey" value="{{dev-myapi-apikey-v1}}" />
```

**ApiBicepOps Templating Approach:**
```xml
<set-variable name="apiKey" value="{°{apikey}°}" />
<set-variable name="sharedValue" value="{#{globalNamedValue}#}" />
```

**Syntax Explanation:**
- `{°{variableName}°}` - Creates an API-specific named value that gets automatically prefixed with `{apiname}-{variableName}-{version}` during deployment
- `{#{existingValue}#}` - References existing named values in your APIM instance without modification

**Multi-Environment Benefits:**
When deploying to different environments, the same policy file works seamlessly:
- **Development**: `{°{apikey}°}` becomes `{{exampleapiv1-apikey-v1}}`
- **Production**: `{°{apikey}°}` becomes `{{exampleapiv1-apikey-v1}}` (with production-specific values)
- **Staging**: References remain consistent while values are environment-specific

**Automatic Naming Collision Prevention:**
In enterprise APIM instances with multiple APIs, naming collisions for named values are a common problem. If two different APIs both need a named value called "apikey" or "connectionString", standard APIM would require manual coordination to avoid conflicts (e.g., `userapi-apikey` vs `orderapi-apikey`). 

ApiBicepOps automatically prevents these collisions by prefixing each named value with the API name and version. When you use `{°{apikey}°}` in your User API and Order API policies, they automatically become distinct named values:
- User API: `{{userapi-apikey-v1}}`
- Order API: `{{orderapi-apikey-v1}}`

This eliminates the need for naming conventions, manual coordination between teams, and reduces deployment failures caused by naming conflicts.

This approach eliminates the need to maintain separate policy files per environment or complex tokenization processes. See the example policies in the `src/policies/` directory to observe this templating in action, particularly in `global.xml`.

## Prerequisites
Before using **ApiBicepOps**, ensure you have the following prerequisites:
- **Azure CLI** or **Bicep CLI** to launch the deployment.
- **Contributor** permissions on the API Management instance.
- **Key Vault access** by the Azure API Management instance to the Key Vault hosting the secret named values. 

## Contributors
This project is maintained by:
- **Marco Lodini**

Contributors are well accepted

## License
I strongly believe in open-source and free code for everyone to work on and extend. I can't recall how many times I've been saved by FOSS, "loosely" licensed software and code.

Hence, the Unlicense license is used.