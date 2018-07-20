USE FtpMonitoringDB
GO

/* Return Monitoring Log Id Based On FileId
 * Input Variable Name In SSIS :
 * 1. fileId
 */  
SELECT Id FROM MonitoringLog 
WHERE FileId = ?