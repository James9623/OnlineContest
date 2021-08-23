USE [JudgementAppNew]
GO
/****** Object:  StoredProcedure [dbo].[prc_GetProblem]    Script Date: 22/08/2021 6:44:26 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[prc_GetProblem]
	-- Add the parameters for the stored procedure here
	@FKCompany as bigint,
	@ProblemName as varchar(500)=null
AS
BEGIN

Declare @table as table(id int)

Insert into @table(id)
select 1
union
select 2
union
Select 3
union
Select 4
union
Select 5

Select Id  into #temp from @table where  ID not in (Select QuestionNo from CreateProblemArchive as c where C.FKCompany=@FKCompany and C.ProblemName=@ProblemName )

	if (len(ltrim(rtrim(@ProblemName)))<1 or @ProblemName='')
	begin
	set @ProblemName=null;
	end

	Select Q.Title,Q.[Type],ROW_NUMBER() OVER(ORDER BY [Type]) as Row_Num,C.ProblemName,  PKQuestion as ID
	,C.P1,C.P2,C.P3,C.P4,isnull(IsPublish,'0')as IsPublish,isnull(C.IsExpired,'0') as IsExpired
	from Questions as Q
	left Join CreateProblem as C on C.QuestionNo=Q.PKQuestion and C.FKCompany=@FKCompany and (@ProblemName is null or C.ProblemName=@ProblemName) 
	Where (C.FKCompany=@FKCompany or Q.PKQuestion in (Select ID from #temp)) and (C.IsExpired is null or C.IsExpired<>'1')
	
	Order By [Type],Row_Num

	Drop table #temp
END
