# ApiBicepOps

## Overview
**ApiBicepOps** is a project designed to deploy APIs to Azure API Management using Bicep only, with the option to employ Bicep deployment scripts if necessary by extending the main bicep. The main goal is to streamline the deployment process by utilizing Bicep, eliminating the need for dedicated software solutions, Frankenstein scripts or custom undocumented YAML definitions.

If you don't know how to format a section, please refer to the awesome [Azure API Management Bicep resource definition](https://learn.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service?pivots=deployment-language-bicep).

## Features
- **No scripts involved**: The entire deployment process is managed by Bicep itself through the `main.bicep` file.
- **Easily extendible**: Since it's a Bicep file definition, it can be easily extended to meet various requirements.
- **Simple CI/CD pipelines**: The project supports simple CI/CD pipelines for seamless releases: just put a Bicep deployment task and you're done.
- **Key Vault secret named values support**: Reference Key Vault values to deploy secrets and use them in your policies.

## Installation
No installation is needed. Users only need a text editor to work on the project. **VS Code** is recommended due to the very useful Bicep extension.

## Usage
To use **ApiBicepOps**, follow these steps:
1. Open the `main.bicep` file in your text editor.
2. Use **Azure CLI** or **Bicep CLI** to launch the deployment of the solution.

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
