// --------------------------------------------------------------------------------
// Main Bicep file that deploys or upgrades an App Insights Instance
// --------------------------------------------------------------------------------
// To deploy this Bicep manually:
// 	 az login
//   az account set --subscription <subscriptionId>
//   az deployment group create -n manual-deploy --resource-group rg_sandbox --template-file 'main-classic.bicep' --parameters appInsightsName=myClassicAppInsights
// --------------------------------------------------------------------------------
param appInsightsName string = ''
param logAnalyticsWorkspaceName string = ''
param location string = resourceGroup().location
param runDateTime string = utcNow()

// --------------------------------------------------------------------------------
var deploymentSuffix = '-${runDateTime}'
var commonTags = {         
  LastDeployed: runDateTime
}

// --------------------------------------------------------------------------------
module appInsightsModule 'appinsights-classic.bicep' = {
  name: 'appinsights${deploymentSuffix}'
  params: {
    appInsightsName: appInsightsName
    location: location
    commonTags: commonTags
    workSpaceName: logAnalyticsWorkspaceName
  }
}
