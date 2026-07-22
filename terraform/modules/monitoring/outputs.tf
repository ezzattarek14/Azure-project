output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.law.id
  description = "Log Analytics Workspace ID"
}

output "app_insights_connection_string" {
  value       = azurerm_application_insights.appinsights.connection_string
  sensitive   = true
  description = "Application Insights Connection String"
}

output "action_group_id" {
  value       = azurerm_monitor_action_group.devops_alerts.id
  description = "Monitor Action Group ID"
}
