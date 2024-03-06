Function ScanSubscriptionForAppInsights 
{
  Param ([string] $SubscriptionId)

  if ($SubscriptionId) 
  {
    Write-Output "Scanning for App Insights in Subscription: $($SubscriptionId)..."
    Get-AzApplicationInsights -SubscriptionId $SubscriptionId | Format-Table -Property Name, IngestionMode, Id, ResourceGroupName, @{label='Type';expression={
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
  }
  else {
    Write-Output "Please supply a parameter:"
    Write-Output "   Scan_Subscription -SubscriptionId {yourSubscriptionId}"
  }
}

# You may need to run this command first:
# Connect-AzAccount
ScanSubscriptionForAppInsights -SubscriptionId yourSubId
