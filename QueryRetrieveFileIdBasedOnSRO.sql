USE FtpMonitoringDB
GO

/* Return FileId Into SSIS
 * Variable Name In SSIS = fileIds
 */	
SELECT Name FROM MasterFile 
WHERE SroId = 1