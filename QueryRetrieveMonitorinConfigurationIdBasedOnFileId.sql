USE FtpMonitoringDB
GO

/* Return Monitoring Configuration Id Based On FileId Order By Sequence Order
 * Input Variable Name In SSIS
 * 1. fileId
 * Output Variable Name In SSIS
 * 1. monitoringConfigurationIds
 */
SELECT Id FROM MonitoringConfiguration
WHERE FileId = ?
ORDER BY SequenceOrder