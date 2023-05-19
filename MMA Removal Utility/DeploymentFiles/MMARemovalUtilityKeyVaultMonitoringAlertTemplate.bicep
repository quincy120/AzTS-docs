param UnintendedSecretAccessAlertQuery string
param ActionGroupId string
param LAResourceId string
param Location string

var laAlertSource = {
  SourceId: LAResourceId
  Type: 'ResultCount'
}
var actionGrp = {
  ActionGroup: ActionGroupId
}
var unintendedSecretAccessAlert_var = 'AzTS MMA Removal Utility Secret access Alert'
var unintendedSecretAccessAlertDescription = 'This is to notify you that MMA Removal Utility identity credentials, stored as secret in Key Vault has been accessed by some identity other than AzTS MMA Removal Utility solution identity.`r`n**Next steps**`r`n Review the Key Vault activity logs, audit logs and access policy to identify the identity details and take appropriate action.'

resource unintendedSecretAccessAlert 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: unintendedSecretAccessAlert_var
  location: Location
  properties: {
    description: unintendedSecretAccessAlertDescription
    enabled: true
    source: {
      query: UnintendedSecretAccessAlertQuery
      dataSourceId: laAlertSource.SourceId
      queryType: laAlertSource.Type
    }
    schedule: {
      frequencyInMinutes: '60'
      timeWindowInMinutes: '60'
    }
    action: {
      'odata.type': 'Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.AlertingAction'
      severity: '1'
      aznsAction: {
        actionGroup: array(actionGrp.ActionGroup)
        emailSubject: 'AzTS MONITORING ALERT: ${unintendedSecretAccessAlert_var}'
      }
      trigger: {
        thresholdOperator: 'GreaterThan'
        threshold: '0'
      }
    }
  }
}
