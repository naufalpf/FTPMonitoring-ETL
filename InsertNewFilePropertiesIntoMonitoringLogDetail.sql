DECLARE @monitoringLogId INT
DECLARE @monitoringConfigurationId INT
DECLARE @statusId INT

/* Input Variables From SSIS
 * Variables Name :
 * 1. monitoringLogId
 * 2. monitoringConfigurationId
 */
SET @monitoringLogId = ?
SET @monitoringConfigurationId = ?

/* Retrieve StatusId Based On Monitoring Configuration Id */
SET @statusId = (SELECT StatusId FROM MonitoringConfiguration 
                 WHERE Id = @monitoringConfigurationId)

/* Insert New File Properties From Table staging.RawFiles Into MonitoringLogDetail */
INSERT INTO dbo.MonitoringLogDetail (MonitoringLogId, FileName, FileModifiedDatetime, StatusId, ETLRunDatetime)
SELECT @monitoringLogId, FileName, FileModifiedDatetime, @statusId, GETDATE()
FROM staging.RawFiles

