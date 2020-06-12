SELECT 'CV0_FILIAL' as CV0_FILIAL
	  ,'CV0_PLANO' AS CV0_PLANO
	  ,'CV0_ITEM' AS CV0_ITEM
      ,'CV0_CODIGO'	AS CV0_CODIGO
      ,'CV0_DESC' AS CV0_DESC
      ,'CV0_CLASSE' AS CV0_CLASSE
      ,'CV0_NORMAL' AS CV0_NORMAL
      ,'CV0_ENTSUP'  AS CV0_ENTSUP
      ,'CV0_BLOQUE'   AS CV0_BLOQUE
      ,'CV0_DTIBLQ' AS CV0_DTIBLQ
      ,'CV0_DTFBLQ' AS CV0_DTFBLQ
      ,'CV0_DTIEXI' AS CV0_DTIEXI
      ,'CV0_DTFEXI' AS CV0_DTFEXI
      ,'CV0_LUCPER'   AS CV0_LUCPER
      ,'CV0_PONTE'  AS CV0_PONTE
	  ,'CV0_ECVM'           AS CV0_ECVM
	  ,'CV0_ECRED'           AS CV0_ECRED
      ,'CV0_XTPUNI' AS CV0_XTPUNI
      ,'CV0_XGERUN' AS CV0_XGERUN
      ,'CV0_XSPUNI' AS CV0_XSPUNI
UNION ALL
SELECT [CTD_FILIAL] as CV0_FILIAL
	  ,'05' AS CV0_PLANO
	  ,REPLICATE('0',(6 - Len(Cast(rank() OVER (ORDER BY [CTD_ITEM], [CTD_ITSUP] ) as Varchar)))) + Cast(rank() OVER (ORDER BY [CTD_ITEM], [CTD_ITSUP] ) as Varchar) AS CV0_ITEM
      ,[CTD_ITEM]	AS CV0_CODIGO
      ,[CTD_DESC01] AS CV0_DESC
      ,[CTD_CLASSE] AS CV0_CLASSE
      ,[CTD_NORMAL] AS CV0_NORMAL
      ,[CTD_ITSUP]  AS CV0_ENTSUP
      ,[CTD_BLOQ]   AS CV0_BLOQUE
      ,[CTD_DTBLIN] AS CV0_DTIBLQ
      ,[CTD_DTBLFI] AS CV0_DTFBLQ
      ,[CTD_DTEXIS] AS CV0_DTIEXI
      ,[CTD_DTEXSF] AS CV0_DTFEXI
      ,[CTD_ITLP]   AS CV0_LUCPER
      ,[CTD_ITPON]  AS CV0_PONTE
	  ,''           AS CV0_ECVM
	  ,''           AS CV0_ECRED
      ,[CTD_XTPUNI] AS CV0_XTPUNI
      ,[CTD_XGERUN] AS CV0_XGERUN
      ,[CTD_XSPUNI] AS CV0_XSPUNI
  FROM [dbo].[CTD010]
  