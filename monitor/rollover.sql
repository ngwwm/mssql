DECLARE @RunDate Date = cast('2022-01-01' as date)

SELECT [IsCalendarYearDataGenerated], count(1) as Cnt, 
	max(UpdatedDtm) as LastUpdatedDtm,
	cast(round(count(1) * 1.0 / sum(count(1)) over(),2) as decimal(8,2))*2 as Progress
FROM [SB].[CreateNewHolidayYearAudit] with (nolock)
WHERE [JobRunDate] = @RunDate
	AND [IsProcessed] = 1
Group By [IsCalendarYearDataGenerated] 
With rollup

Select top 300 CompanyId, min(UpdatedDtm) as StartedDtm, max(UpdatedDtm) as LastUpdatedDtm, 
	datediff(minute, min(UpdatedDtm),max(UpdatedDtm)) as Elapsed
FROM	[SB].[CreateNewHolidayYearAudit] with (nolock)
WHERE [JobRunDate] = @RunDate
	AND [IsProcessed] = 1
Group By CompanyId
Order by LastUpdatedDtm desc
GO
