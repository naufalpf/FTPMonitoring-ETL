USE FtpMonitoringDB
GO

/* Return StateId Based On Monitoring Configuration Id
 * Input Variable Name In SSIS :
 * 1. monitoringConfigurationId
 * Output Variable Name In SSIS :
 * 1. stateId
 */
SELECT StateId FROM MonitoringConfiguration
WHERE Id = ? 