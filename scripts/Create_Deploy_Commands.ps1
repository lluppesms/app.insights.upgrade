# ----------------------------------------------------------------------------------------------------------
# Use this script to scan your subscription and generate commands to update out-dated
#   Application Insights instances
# ----------------------------------------------------------------------------------------------------------
# You can easily run this in the Azure Cloud Shell, or if you are running this locally, 
# you may need to install tye Az module:
#   Install-Module -Name Az -AllowClobber -Scope CurrentUser
#   Import-Module -Name Az
# ----------------------------------------------------------------------------------------------------------
# You may need to run this command first to connect to your subscription:
#   Connect-AzAccount
# ----------------------------------------------------------------------------------------------------------
Function ScanSubscriptionForAppInsights 
{
  Param ([string] $SubscriptionId)

  if ($SubscriptionId) 
  {
    Write-Output ""
    Write-Output "Scanning for App Insights in Subscription: $($SubscriptionId)..."
    $listOfInstances = Get-AzApplicationInsights -SubscriptionId $SubscriptionId | Select-Object -Property Name, ResourceGroupName, IngestionMode, @{label='Type';expression={
      if ([string]::IsNullOrEmpty($_.IngestionMode)) {
          'Unknown'
      } elseif ($_.IngestionMode -eq 'LogAnalytics') {
          'Workspace-based'
      } elseif ($_.IngestionMode -eq 'ApplicationInsights' -or $_.IngestionMode -eq 'ApplicationInsightsWithDiagnosticSettings') {
          'Classic'
      } else {
          'Unknown'
      }
    }}
    
    Write-Output $listOfInstances

    Write-Output ""
    Write-Output "Commands to Upgrade Instances Not Using LogAnalytics:"
    $listOfInstances | ForEach-Object {
      if ($_.IngestionMode -ne 'LogAnalytics') {
          Write-Output "az deployment group create -n update-$($_.Name) --parameters appInsightsName=$($_.Name) --resource-group $($_.ResourceGroupName) --template-file main.bicep"
      } 
    }
  }
  else {
    Write-Output "Please supply a parameter:"
    Write-Output "   Scan_Subscription -SubscriptionId {yourSubscriptionId}"
  }
}

# You may need to run this command first:
# Connect-AzAccount

# Then run this command:
# ScanSubscriptionForAppInsights -SubscriptionId yourSubscriptionId
