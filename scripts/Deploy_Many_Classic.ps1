# ------------------------------------------------------------------------------------------------------------------------
# Update many App Insights classic instances
# ------------------------------------------------------------------------------------------------------------------------
# You may need to run these commands first to connect to your subscription:
#   az login
#   az account set --subscription <subscriptionId>
# ------------------------------------------------------------------------------------------------------------------------

$templateFileName = 'main-classic.bicep'

$resourceGroupName = "rg_sandbox_demo"
az deployment group create -n manual-aiup-01Z --parameters appInsightsName=lll-ai-demo-01 --resource-group $resourceGroupName --template-file $templateFileName
az deployment group create -n manual-aiup-02Z --parameters appInsightsName=lll-ai-demo-02 --resource-group $resourceGroupName --template-file $templateFileName
az deployment group create -n manual-aiup-03Z --parameters appInsightsName=lll-ai-demo-03 --resource-group $resourceGroupName --template-file $templateFileName

$resourceGroupName = "rg_sandbox_dev"
az deployment group create -n manual-aiup-04Z --parameters appInsightsName=lll-ai-dev-04 --resource-group $resourceGroupName --template-file $templateFileName
az deployment group create -n manual-aiup-05Z --parameters appInsightsName=lll-ai-dev-05 --resource-group $resourceGroupName --template-file $templateFileName
az deployment group create -n manual-aiup-06Z --parameters appInsightsName=lll-ai-dev-06 --resource-group $resourceGroupName --template-file $templateFileName

# $resourceGroupName = "rg_sandbox_qa"
# az deployment group create -n manual-aiup-07Z --parameters appInsightsName=lll-ai-qa-07 --resource-group $resourceGroupName --template-file $templateFileName
# az deployment group create -n manual-aiup-08Z --parameters appInsightsName=lll-ai-qa-08 --resource-group $resourceGroupName --template-file $templateFileName
# az deployment group create -n manual-aiup-09Z --parameters appInsightsName=lll-ai-qa-09 --resource-group $resourceGroupName --template-file $templateFileName

# $resourceGroupName = "rg_sandbox_prod"
# az deployment group create -n manual-aiup-10Z --parameters appInsightsName=lll-ai-prod-10 --resource-group $resourceGroupName --template-file $templateFileName
# az deployment group create -n manual-aiup-11Z --parameters appInsightsName=lll-ai-prod-11 --resource-group $resourceGroupName --template-file $templateFileName
# az deployment group create -n manual-aiup-12Z --parameters appInsightsName=lll-ai-prod-12 --resource-group $resourceGroupName --template-file $templateFileName
