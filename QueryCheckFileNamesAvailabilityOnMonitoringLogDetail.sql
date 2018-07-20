DECLARE @monitoringLogId INT
DECLARE @monitoringConfigurationId Int
DECLARE @statusId INT

SET @monitoringLogId = ?
SET @monitoringConfigurationId = ?
SET @statusId = (SELECT StatusId FROM MonitoringConfiguration
                 WHERE Id = @monitoringConfigurationId)

SELECT COUNT(FileName) from dbo.MonitoringLogDetail 
where MonitoringLogId = @monitoringLogId and StatusId = @statusId