// ----------------------------------------------------------------------------------------------------
// This BICEP file will create a CLASSIC (!) Application Insights Resource without Log Analytics
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

@description('If you want to use an existing Log Analytics Resource, provide the Id here. Otherwise, leave it empty to create a new one.')
param workSpaceName string = ''

param commonTags object = {}

// --------------------------------------------------------------------------------
// gotta use the workspace id somewhere that's irrelevant to the resource or bicep will throw an error, so put it in a tag
var templateTag = { TemplateFile: '~appInsights.bicep', WorkSpaceName: workSpaceName }
var tags = union(commonTags, templateTag)


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
  }
}

output id string = appInsightsResource.id
output name string = appInsightsResource.name
