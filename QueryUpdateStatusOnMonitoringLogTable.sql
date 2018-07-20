USE FtpMonitoringDB
GO

/* Update Status On MonitoringLogTable Where MonitoringLogId Equal Input
 * Input Variable Name In SSIS :
 * 1. monitoringLogId
 */
UPDATE MonitoringLog SET Status = 1
WHERE Id = ?