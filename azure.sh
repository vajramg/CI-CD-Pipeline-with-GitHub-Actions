#!/bin/bash

#variables
RESOURCE_GROUP_NAME="my-rg"
LOCATION="eastus"
ACR_NAME="acr$(date +%s | tail -c 6)"
SP_NAME="github_actions_webapp"

echo "setting up Azure resource"
echo "resource group: $RESOURCE_GROUP_NAME"
echo "location: $LOCATION"
echo "acr: $ACR_NAME"

#creating resource group

echo "creating resource group"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
echo "creating ACR registry"
az acr create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $ACR_NAME \
  --sku Basic \
  --admin-enabled

  #Get ACR Credentials
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query username --output tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query passwords[0].value --output tsv)

AZURE_SP=$(az ad sp create-for-rbac \
  --name $SP_NAME \
  --role contributor \
  --scopes /subscriptions/$(az account show --query id --output tsv)/resourceGroups/$RESOURCE_GROUP_NAME \
  --json-auth)

  
  echo ""
echo "=========================================="
echo "SETUP COMPLETE! 🚀"
echo "=========================================="
echo ""
echo "GitHub Secrets to create:"
echo ""
echo "AZURE_CREDENTIALS:"
echo "$AZURE_SP"
echo ""
echo "ACR_NAME: $ACR_NAME"
echo ""
echo "ACR_USERNAME: $ACR_USERNAME"
echo ""
echo "ACR_PASSWORD: $ACR_PASSWORD"
echo ""
echo "AZURE_RESOURCE_GROUP: $RESOURCE_GROUP_NAME"
echo ""
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Copy the above values to your GitHub repository secrets"
echo "2. Make sure your project-2 directory has a Dockerfile"
echo "3. Push your code to trigger the deployment"
echo ""
echo "To clean up later, run:"
echo "az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait"



##    To clean up later, run: ###
#   az group delete --name rg-webapp-deploy --yes --no-wait