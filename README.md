# Application Insights Instances that need to be updated

"Classic" Application Insights is being deprecated and will be retired in February 2024. Classic Application Insights instances are those not associated with a Log Analytics Workspace.  

Usually there is a warning and a manual migration link, but not always. The status can be verified by looking at the App Insights Properties page and scrolling to the bottom to the Workspace property.

For more info on the migration process, see [Migrate to workspace-based Application Insights resources](https://learn.microsoft.com/en-us/azure/azure-monitor/app/convert-classic-resource).

Excerpts from that article:

> When you migrate to a workspace-based resource, no data is transferred from your classic resource's storage to the new workspace-based storage. Choosing to migrate changes the location where new data is written to a Log Analytics workspace while preserving access to your classic resource data.

> Your classic resource data persists and is subject to the retention settings on your classic Application Insights resource. All new data ingested post migration is subject to the retention settings of the associated Log Analytics workspace, which also supports different retention settings by data type.

## What happens after March 1?
See [Application Insights Classic Retired on 29 February 2024](https://learn.microsoft.com/en-us/answers/questions/1501279/application-insights-classic-retired-on-29-februar) post for more info on this topic.

A short summary:

- March 2024
  - Continuous Export will no longer work or be accessible
  - Classic components will still remain and be able to receive and ingestion telemetry.
  - You cannot create a Classic Application Insights Component

- April 2024
  - Classic resources will be treated exactly like traditional software that is out of support; there will no fixes, no new compute resources, etc., in other words if there is an issue on the Component side the first step will be to see if that issue exists under a workspace-based component or migrate to the workspace-based component.

- May 2024
  - Microsoft will begin an automatic phased approach to migrating classic resources to workspace-based resources beginning in May 2024 and this migration will span the course of several months. We can't provide approximate dates that specific resources, subscriptions, or regions will be migrated.

---

## Powershell Script to find Classic Application Insights Instances

To find instances of Application Insights using classic mode, use this PowerShell Script and specify a subscription to search:


``` bash
Connect-AzAccount
Get-AzApplicationInsights -SubscriptionId 'yourSubId' | Format-Table -Property Name, IngestionMode, Id, @{label='Type';expression={
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
```

## Recommended Long-Term Fix

Update your appInsights.bicep modules such that when they create new Application Insights instances it will create and associate them with a new Log Analytics Workspace automatically, and the old app insights instances will also be updated automatically when the bicep is run.

If it is desired to use an existing Log Analytics Workspace, the module should have an optional parameter that can be used to point to that existing workspace.

## Automated Short-Term Patch Pipeline

A *short-term one-time-use-only* YML pipeline has been created to update the classic Application Insights instances to the new Application Insights instances, located in [/.azdo/pipelines/upgrade-app-insights.yml](/.azdo/pipelines/upgrade-app-insights.yml). The pipeline will update the classic Application Insights instances one environment at a time to the new Application Insights version by creating a new Log Analytics Workspace and associating them with that. Update that pipeline with your service connection names and the resource group names and the Application Insights names and run it to update the classic Application Insights instances.

## Bicep Testing Commands

Download and edit the following scripts to deploy classic instances to test with and to update them to the new format.

- Use the script [scripts/Deploy_Many_Classic.ps1](scripts/Deploy_Many_Classic.ps1) to deploy some test instances using the classic format.
- Use the script [scripts/Update_Many_Instances.ps1](scripts/Update_Many_Instances.ps1) to deploy some test instances using the classic format.
