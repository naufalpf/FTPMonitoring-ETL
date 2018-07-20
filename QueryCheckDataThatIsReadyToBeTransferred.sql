/* Declare Local Variables */
DECLARE @fileTemplateId INT
DECLARE @monitoringConfigurationId INT
DECLARE @fileTemplateName NVARCHAR(64)
DECLARE @filePath NVARCHAR(255)
DECLARE @filePatternExtension NVARCHAR(128)
DECLARE @batchFilePath NVARCHAR(128) 
DECLARE @extLength INT
DECLARE @countRow INT
DECLARE @command NVARCHAR(255)
DECLARE @rawFiles TABLE (ID int IDENTITY, FileProp NVARCHAR(500))

/* Passing Variables SSIS Into Query 
 * Input Variables In SSIS : 
 * 1. fileId
 * 2. monitoringConfigurationId
 */
SET @fileTemplateId = ?
SET @monitoringConfigurationId = ?

/* Retrieve Batch File Path Name In Table MasterBatchFile 
   INNER JOIN Monitoring Configuration Based On @monitoringConfigurationId */
SET @batchFilePath = (SELECT mbf.PathName From MasterBatchFile as mbf
					  INNER JOIN MonitoringConfiguration as mc ON mbf.Id = mc.BatchFileId
					  WHERE mc.Id = @monitoringConfigurationId)

/* Retrieve File Path Name In Table MasterPath 
   INNER JOIN Monitoring Configuration Based On @monitoringConfigurationId */
SET @filePath = (SELECT mp.Name From MasterPath as mp
				 INNER JOIN MonitoringConfiguration as mc ON mp.Id = mc.PathId
				 WHERE mc.Id = @monitoringConfigurationId)

/* Retrieve File Pattern Extension In Table MasterPath INNER JOIN MasterStatus 
   INNER JOIN Monitoring Configuration Based On @monitoringConfigurationId */
SET @filePatternExtension = (SELECT mpe.Name FROM MasterPatternExtension AS mpe
							 INNER JOIN MasterStatus AS ms ON ms.PatternExtensionId = mpe.Id
							 INNER JOIN MonitoringConfiguration as mc ON mc.StatusId = ms.Id
							 WHERE mc.Id = @monitoringConfigurationId)

/* Retrieve File Template Name Based On @fileTemplateId */
SET @fileTemplateName = (SELECT Name From MasterFile where Id = @fileTemplateId)

/* SET The Command For The CMD Shell */
SET @command = 'cd.. && "' + @batchFilePath + '" ' + @filePath + ' ' + @fileTemplateName + ' ' + @filePatternExtension 

--SELECT @batchFilePath as BatchFilePath, @filePath as FilePath, @filePatternExtension as FileExtension, @fileTemplateName as FileName, @command as CMDShellCommand

/* INSERT The Result From CMD Shell Into Table @rawFiles */
INSERT INTO @rawFiles EXECUTE xp_cmdshell @command
DELETE FROM @rawFiles WHERE FileProp LIKE 'dir%' OR FileProp LIKE 'No file%'
--SELECT FileProp FROM @rawFiles 
--WHERE FileProp LIKE (SELECT '%' + @fileTemplateName + @filePatternExtension)

/* Count the Number of Retrieved Files */
SET @countRow = (SELECT COUNT(FileProp) FROM @rawFiles 
                 WHERE FileProp LIKE (SELECT '%' + @fileTemplateName + @filePatternExtension))

IF @countRow > 0
	TRUNCATE TABLE staging.RawFiles
	INSERT INTO [FtpMonitoring].[staging].[RawFiles] (FileName, FileModifiedDatetime)
	SELECT left(SUBSTRING(FileProp, 65, 250), CHARINDEX('.', SUBSTRING(FileProp, 65, 250)) - 1)  as FileName
		  ,CAST(SUBSTRING(FileProp, 44, 20) as datetime) as FileModifiedDatetime
	FROM @rawFiles WHERE FileProp LIKE (SELECT '%' + @fileTemplateName + @filePatternExtension)

/* Return Value To SSIS
 * Output Variable Name In SSIS : countRow
 */
select @countRow