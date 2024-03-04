// ----------------------------------------------------------------------------------------------------
// This BICEP file will create an Application Insights Resource
// ----------------------------------------------------------------------------------------------------
@description('The name of the Application Insights resource.')
param appInsightsName string = ''
@description('The location for the Application Insights resource. Default is the resource group location.')
param location string = resourceGroup().location
@description('The public network access for ingestion. Default is Enabled.')
param publicNetworkAccessForIngestion string = 'Enabled'
@description('The public network access for query. Default is Enabled.')
param publicNetworkAccessForQuery string = 'Enabled'
@description('Application type for the Application Insights resource. Default is web.')
@allowed([ 'web' ]) // extend this list if there are other types you want to support...
param applicationType string = 'web'
@description('The source of the request. Default is rest.')
@allowed([ 'rest' ]) // extend this list if there are other types you want to support...
param requestSource string = 'rest'

@description('If you want to use an existing Log Analytics Resource, provide the name here. Otherwise, leave it empty to create a new one.')
param workSpaceName string = ''
@description('The SKU for the Log Analytics Workspace if a new one is to be created.')
param workSpaceSku string = 'PerGB2018'
@description('The retention period for the Log Analytics Workspace if a new one is to be created.')
param workSpaceRetention int = 90
// @description('The daily cap for the Log Analytics Workspace if a new one is to be created.')
// param workspaceDailyCapGb int = 1

param commonTags object = {}

// --------------------------------------------------------------------------------
var templateTag = { TemplateFile: '~appInsights.bicep' }
var tags = union(commonTags, templateTag)

// if a workspaceId is not provided, create a new workspace
var newWorkSpaceName = '${appInsightsName}-law'
resource newWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2020-08-01' = if (workSpaceName == '') {
  name: newWorkSpaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: workSpaceSku
    }
    retentionInDays: workSpaceRetention
    //you can limit the maximum daily ingestion on the Workspace by providing a value for dailyQuotaGb. 
    // workspaceCapping: {
    //   dailyQuotaGb: workspaceDailyCapGb
    // }
  }
}
resource existingWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = if (workSpaceName == '') {
  name: workSpaceName
} 

resource appInsightsResource 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: applicationType
  tags: tags
  properties: {
    Application_Type: applicationType
    Request_Source: requestSource
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    WorkspaceResourceId: (workSpaceName == '') ? newWorkspaceResource.id : existingWorkspaceResource.id
  }
}

output id string = appInsightsResource.id
output name string = appInsightsResource.name
output logAnalyticsWorkspaceId string = (workSpaceName == '') ? newWorkspaceResource.id : existingWorkspaceResource.id
