#INCLUDE "TOTVS.CH" 
#INCLUDE "REPORT.CH"
#INCLUDE "TOPCONN.CH"  
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CPCOR02
Relat๓rio acompanhamento or็amentแrio por CR+SETOR
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum
@obs       	Nenhum
Altera็๕es	Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	  |Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	  |				      | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CPCOR02()
LOCAL oReport  	:= NIL 
Local oSection01	:= NIL 
LOCAL cPerg		:= ""
Local aOrdem		:= {"CR + SETOR + CONTA"}
local aGrpRecFin	:= StrTokArr(TRIM(GETMV("CI_GRRECFI")),",",.T.) 
local nTipoRel	:= 0
Private cTab		:= GetNextAlias()


if len(aGrpRecFin) < 2
	msgalert("Problema com o parโmetro CI_GRRECFI, verifique...")
	return
Endif

IF (nTipoRel:= Aviso("Acompanhamento or็amentแrio por CR+SETOR","Informe qual relat๓rio deseja imprimir ?",{"Contแbil","Gerencial"})) > 0
	
	cPerg:= iif(nTipoRel==1,"CPCOR02C","CPCOR02G")  
	C9R02SX1(cPerg,nTipoRel)
	Pergunte(cPerg,.F.)
	
	oReport := TReport():New("CPCOR02","Relat๓rio de acompanhamento or็amentแrio por CR+SETOR",cPerg,{|oReport| C9R02IMP(oReport,cTab,aGrpRecFin[nTipoRel],nTipoRel)},"Este relat๓rio irแ imprimir o relat๓rio de acompanhamento or็amentแrio por CR+SETOR.")
	oReport:SetTotalInLine(.F.)      
	oReport:SetDynamic()
	oReport:PageTotalBefore(.T.) 
	oReport:bTotalCanPrint:= {|| }
	oReport:SetCustomText( {|| IIF(oReport:NDEVICE==4,{},C9R02CAB(oReport)) } )
	 
	oSection01:= TRSection():New(oReport, "Contribui็๕es e Receitas",{cTab}, aOrdem)	
	TRCell():New(oSection01, "DESCTA"		, cTab	, "Descri็ใo"			,/*Picture*/						, 60	, /*lPixel*/, /*bBlock*/	) 	
	TRCell():New(oSection01, "ORCADO"  	, cTab	, "Or็ado"				,PESQPICT("AKD","AKD_VALOR1") 	, 15	, /*lPixel*/, /*bBlock*/	)	
	TRCell():New(oSection01, "REALIZADO"	, cTab	, "Realizado"			,PESQPICT("AKD","AKD_VALOR1")	, 15	, /*lPixel*/, /*bBlock*/	) 	
	TRCell():New(oSection01, "NOMINAL"  	, cTab	, "Nominal"			,PESQPICT("AKD","AKD_VALOR1")	, 15	, /*lPixel*/, /*bBlock*/	) 	
	TRCell():New(oSection01, "PERCENT"  	, cTab	, "Percent"			,PESQPICT("AKD","AKD_VALOR1")	, 05	, /*lPixel*/, /*bBlock*/	)	
	TRCell():New(oSection01, "ORCADOAC"	, cTab	, "Or็ado Acum."		,PESQPICT("AKD","AKD_VALOR1")	, 15	, /*lPixel*/,	/*bBlock*/	)	
	TRCell():New(oSection01, "REALIZADOAC"	, cTab	, "Realizado Acum."	,PESQPICT("AKD","AKD_VALOR1")	, 15	, /*lPixel*/, /*bBlock*/	)
	TRCell():New(oSection01, "NOMINALAC"	, cTab	, "Nominal Acum."		,PESQPICT("AKD","AKD_VALOR1")	, 15	, /*lPixel*/, /*bBlock*/	)
	TRCell():New(oSection01, "PERCENTAC"	, cTab	, "Percent Acum."		,PESQPICT("AKD","AKD_VALOR1")	, 05	, /*lPixel*/, /*bBlock*/	)
	
	oSection01:SetTotalInLine(.F.)
	oSection01:SetCols(10)     
	oSection01:SetAutoSize(.T.)         
	oSection01:Cell("ORCADO"):SetAutoSize(.T.)
	oSection01:Cell("REALIZADO"):SetAutoSize(.T.)
	oSection01:Cell("NOMINAL"):SetAutoSize(.T.)
	oSection01:Cell("PERCENT"):SetAutoSize(.T.)
	oSection01:Cell("ORCADOAC"):SetAutoSize(.T.)
	oSection01:Cell("REALIZADOAC"):SetAutoSize(.T.)
	oSection01:Cell("NOMINALAC"):SetAutoSize(.T.)
	oSection01:Cell("PERCENTAC"):SetAutoSize(.T.)
	oSection01:Cell("DESCTA"):SetLineBreak()
	oSection01:SetTotalText('TOTAL CONTRIBUIวีES E RECEITAS')   
	
	oReport:PrintDialog()
	
Endif

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C9R02IMP	  บAutor  ณCarlos Hnerique	  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime relat๓rio	    								  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C9R02IMP(oReport,cTab,cGrpRecFin,nTipoRel) 
LOCAL oSection01	:= oReport:Section(1) 
LOCAL cQry			:= ""  
LOCAL cQryCt1		:= ""    
LOCAL nTot			:= 0   
local cAtividades	:= ""
Local dDataIni	:= CTOD("01/"+LEFT(MV_PAR01,2)+"/"+RIGHT(MV_PAR01,4)) 	// Primeiro dia do m๊s de refer๊ncia
Local dDataFim	:= LastDate(dDataIni)									 	// Ultimo dia do m๊s de refer๊ncia 
Local cCR			:= ""
Local cSet			:= ""
Local cCO			:= ""
Local nSubAte		:= 0
local aTotCR		:= {0,0,0,0,0,0,0,0}
local aTotSetor	:= {0,0,0,0,0,0,0,0}
local aTotConta	:= {0,0,0,0,0,0,0,0}
local aTotReceita	:= {0,0,0,0,0,0,0,0}
local aTotDespesa	:= {0,0,0,0,0,0,0,0}
local aTotMargDir	:= {0,0,0,0,0,0,0,0}
local aTotReceFin	:= {0,0,0,0,0,0,0,0}
local aTotSupAvit	:= {0,0,0,0,0,0,0,0}
local cCampConta	:= iif(nTipoRel==1,"CT1_CONTA","CT1_XCTAGE") 
local cCampDesc	:= iif(nTipoRel==1,"CT1_DESC01","CT1_XDESGE")
local cFilCont	:= iif(nTipoRel==1,TRIM(GETMV("CI_FILCTB1"))+","+TRIM(GETMV("CI_FILCTB2")),TRIM(GETMV("CI_FILGER1"))+","+TRIM(GETMV("CI_FILGER2")))
local lRecDesp	:= .T. 
local cContax		:= ""
local lFechConta	:= .T.
local lFechSetor	:= .T.
local cCustoHie	:= U_C9R01CTT(MV_PAR04)
PRIVATE cDescCR	:= ""
PRIVATE cDescSet	:= ""
PRIVATE cDescCO	:= ""	

if oReport:NDEVICE==4
	oSection01:lHeaderSection:= .f.
Endif

			  				  				  				  		
IF MV_PAR08 == 1
	cAtividades:= C9R02ATV()
	IF EMPTY(cAtividades)
		MSGALERT("Nenhuma atividade selecionada.")
		Return
	ENDIF
ENDIF	

oReport:CTITLE:= "SISTEMA DE ACOMPANHAMENTO ORCAMENTมRIO" 

// Filtra CT1

IF MV_PAR09 == 1
	if MV_PAR10 == 1
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+")= 3 THEN CT1."+cCampConta+" END"+CRLF
	ELSE
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+")= 1 THEN CT1."+cCampConta+" END"+CRLF
	ENDIF		
ElseIf MV_PAR09 == 2
	if MV_PAR10 == 1
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+")> 3 AND LEN(CT1."+cCampConta+")<= 5 THEN CT1."+cCampConta+" END"+CRLF
	ELSE
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+")= 3 THEN CT1."+cCampConta+" END"+CRLF
	ENDIF	
ElseIf MV_PAR09 == 3
	if MV_PAR10 == 1
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+")> 5 AND LEN(CT1."+cCampConta+")<= 9 THEN CT1."+cCampConta+" END"+CRLF
	ELSE
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+")= 5 THEN CT1."+cCampConta+" END"+CRLF
	ENDIF	
ElseIf MV_PAR09 == 4
	IF MV_PAR10 == 1
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+") > 9 THEN CT1."+cCampConta+" END"+CRLF
	ELSE
		cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+")= 9 THEN CT1."+cCampConta+" END"+CRLF
	ENDIF		
 ElseIf MV_PAR09 == 5
	cQryCt1+= " 		AND CT1."+cCampConta+" = CASE WHEN LEN(CT1."+cCampConta+") > 9 THEN CT1."+cCampConta+" END"+CRLF		
Endif

cQryCt1+= " 		AND CT1."+cCampConta+" NOT IN " + FormatIn(cFilCont,",")+CRLF


IF MV_PAR09 == 1
	nSubAte:= 1
ElseIf MV_PAR09 == 2
	nSubAte:= 3
ElseIf MV_PAR09 == 3
	nSubAte:= 5
ElseIf MV_PAR09 == 4
	nSubAte:= 9
ElseIf MV_PAR09 == 5
	nSubAte:= TAMSX3(cCampConta)[1]	
Endif

                          
// Monta SQL
cQry:= " WITH ACOORC(CONTA,DESCTA,CCUSTO,SETOR,TIPO,ORCADO,REALIZADO,ORCADOAC,REALIZADOAC)"+CRLF
cQry+= " AS("+CRLF
cQry+= " 	SELECT CT1."+cCampConta+" AS CONTA"+CRLF
cQry+= " 		  ,CT1."+cCampDesc+" AS DESCTA"+CRLF
cQry+= " 		  ,'"+MV_PAR04+"' AS CCUSTO"+CRLF
cQry+= " 		  ,AKD1.AKD_ITCTB AS SETOR"+CRLF
cQry+= " 		  ,AKD1.AKD_TIPO AS TIPO"+CRLF
cQry+= " 		  ,SUM(AKD1.AKD_VALOR1) AS ORCADO"+CRLF
cQry+= " 		  ,0 AS REALIZADO"+CRLF
cQry+= " 		  ,0 AS ORCADOAC"+CRLF
cQry+= " 		  ,0 AS REALIZADOAC"+CRLF	    
cQry+= " 	FROM "+RETSQLNAME("CT1")+" CT1"+CRLF
cQry+= " 	INNER JOIN "+RETSQLNAME("AKD")+" AKD1 ON AKD1.AKD_FILIAL='"+XFILIAL("AKD")+"'"+CRLF 
cQry+= " 		AND LEFT(AKD1.AKD_CO,LEN(CT1.CT1_CONTA)) = RTRIM(CT1.CT1_CONTA)"+CRLF
cQry+= " 		AND AKD1.AKD_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"'"+CRLF
cQry+= " 		AND AKD1.AKD_CC IN " + FormatIn(cCustoHie,",")+CRLF

if MV_PAR05 == 1
	cQry+= " 		AND AKD1.AKD_ITCTB BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'"+CRLF
endif

IF !EMPTY(cAtividades)
	cQry+= " 		AND AKD1.AKD_CLVLR IN " + FormatIn(cAtividades,",")+CRLF
ENDIF

cQry+= " 		AND AKD1.AKD_TPSALD = 'OR'"+CRLF
cQry+= " 		AND AKD1.AKD_STATUS != '3'"+CRLF  		
cQry+= " 		AND AKD1.D_E_L_E_T_= ' '"+CRLF
cQry+= " 	WHERE CT1.CT1_FILIAL='"+XFILIAL("CT1")+"'"+CRLF
cQry+= " 		AND CT1."+cCampConta+" BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"+CRLF

cQry+= cQryCt1	

cQry+= " 		AND CT1.D_E_L_E_T_=''"+CRLF
cQry+= " 	GROUP BY CT1."+cCampConta+",CT1."+cCampDesc+",AKD1.AKD_CC,AKD1.AKD_ITCTB,AKD1.AKD_TIPO"+CRLF
cQry+= " 	UNION ALL"+CRLF
cQry+= " 	SELECT CT1."+cCampConta+" AS CONTA"+CRLF
cQry+= " 		  ,CT1."+cCampDesc+" AS DESCTA"+CRLF
cQry+= " 		  ,'"+MV_PAR04+"' AS CCUSTO"+CRLF
cQry+= " 		  ,AKD2.AKD_ITCTB AS SETOR"+CRLF
cQry+= " 		  ,AKD2.AKD_TIPO AS TIPO"+CRLF
cQry+= " 		  ,0 AS ORCADO"+CRLF
cQry+= " 		  ,SUM(AKD2.AKD_VALOR1) AS REALIZADO"+CRLF
cQry+= " 		  ,0 AS ORCADOAC"+CRLF
cQry+= " 		  ,0 AS REALIZADOAC"+CRLF	    
cQry+= " 	FROM "+RETSQLNAME("CT1")+" CT1"+CRLF
cQry+= " 	INNER JOIN "+RETSQLNAME("AKD")+" AKD2 ON AKD2.AKD_FILIAL='"+XFILIAL("AKD")+"'"+CRLF 
cQry+= " 		AND LEFT(AKD2.AKD_CO,LEN(CT1.CT1_CONTA)) = RTRIM(CT1.CT1_CONTA)"+CRLF
cQry+= " 		AND AKD2.AKD_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"'"+CRLF
cQry+= " 		AND AKD2.AKD_CC IN " + FormatIn(cCustoHie,",")+CRLF

if MV_PAR05 == 1
	cQry+= " 		AND AKD2.AKD_ITCTB BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'"+CRLF
endif

IF !EMPTY(cAtividades)
	cQry+= " 		AND AKD2.AKD_CLVLR IN " + FormatIn(cAtividades,",")+CRLF
ENDIF

cQry+= " 		AND AKD2.AKD_TPSALD = 'RE'"+CRLF
cQry+= " 		AND AKD2.AKD_STATUS != '3'"+CRLF	
cQry+= " 		AND AKD2.D_E_L_E_T_= ' '"+CRLF
cQry+= " 	WHERE CT1.CT1_FILIAL='"+XFILIAL("CT1")+"'"+CRLF
cQry+= " 		AND CT1."+cCampConta+" BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"+CRLF

cQry+= cQryCt1

cQry+= " 		AND CT1.D_E_L_E_T_=''"+CRLF
cQry+= " 	GROUP BY CT1."+cCampConta+",CT1."+cCampDesc+",AKD2.AKD_CC,AKD2.AKD_ITCTB,AKD2.AKD_TIPO"+CRLF
cQry+= " 	UNION ALL"+CRLF
cQry+= " 	SELECT CT1."+cCampConta+" AS CONTA"+CRLF
cQry+= " 		  ,CT1."+cCampDesc+" AS DESCTA"+CRLF
cQry+= " 		  ,'"+MV_PAR04+"' AS CCUSTO"+CRLF
cQry+= " 		  ,AKD1.AKD_ITCTB AS SETOR"+CRLF
cQry+= " 		  ,AKD1.AKD_TIPO AS TIPO"+CRLF
cQry+= " 		  ,0 AS ORCADO"+CRLF
cQry+= " 		  ,0 AS REALIZADO"+CRLF
cQry+= " 		  ,SUM(AKD1.AKD_VALOR1) AS ORCADOAC"+CRLF
cQry+= " 		  ,0 AS REALIZADOAC"+CRLF	    
cQry+= " 	FROM "+RETSQLNAME("CT1")+" CT1"+CRLF
cQry+= " 	INNER JOIN "+RETSQLNAME("AKD")+" AKD1 ON AKD1.AKD_FILIAL='"+XFILIAL("AKD")+"'"+CRLF 
cQry+= " 		AND LEFT(AKD1.AKD_CO,LEN(CT1.CT1_CONTA)) = RTRIM(CT1.CT1_CONTA)"+CRLF
cQry+= " 		AND AKD1.AKD_DATA<='"+DTOS(dDataFim)+"'"+CRLF
cQry+= " 		AND AKD1.AKD_CC IN " + FormatIn(cCustoHie,",")+CRLF	

if MV_PAR05 == 1
	cQry+= " 		AND AKD1.AKD_ITCTB BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'"+CRLF
endif

IF !EMPTY(cAtividades)
	cQry+= " 		AND AKD1.AKD_CLVLR IN " + FormatIn(cAtividades,",")+CRLF
ENDIF

cQry+= " 		AND AKD1.AKD_TPSALD = 'OR'"+CRLF
cQry+= " 		AND AKD1.AKD_STATUS != '3'"+CRLF  		
cQry+= " 		AND AKD1.D_E_L_E_T_= ' '"+CRLF
cQry+= " 	WHERE CT1.CT1_FILIAL='"+XFILIAL("CT1")+"'"+CRLF
cQry+= " 		AND CT1."+cCampConta+" BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"+CRLF

cQry+= cQryCt1

cQry+= " 		AND CT1.D_E_L_E_T_=''"+CRLF
cQry+= " 	GROUP BY CT1."+cCampConta+",CT1."+cCampDesc+",AKD1.AKD_CC,AKD1.AKD_ITCTB,AKD1.AKD_TIPO"+CRLF
cQry+= " 	UNION ALL"+CRLF
cQry+= " 	SELECT CT1."+cCampConta+" AS CONTA"+CRLF
cQry+= " 		  ,CT1."+cCampDesc+" AS DESCTA"+CRLF
cQry+= " 		  ,'"+MV_PAR04+"' AS CCUSTO"+CRLF
cQry+= " 		  ,AKD2.AKD_ITCTB AS SETOR"+CRLF
cQry+= " 		  ,AKD2.AKD_TIPO AS TIPO"+CRLF 
cQry+= " 		  ,0 AS ORCADO"+CRLF
cQry+= " 		  ,0 AS REALIZADO"+CRLF
cQry+= " 		  ,0 AS ORCADOAC"+CRLF
cQry+= " 		  ,SUM(AKD2.AKD_VALOR1) AS REALIZADOAC"+CRLF	    
cQry+= " 	FROM "+RETSQLNAME("CT1")+" CT1"+CRLF
cQry+= " 	INNER JOIN "+RETSQLNAME("AKD")+" AKD2 ON AKD2.AKD_FILIAL='"+XFILIAL("AKD")+"'"+CRLF 
cQry+= " 		AND LEFT(AKD2.AKD_CO,LEN(CT1.CT1_CONTA)) = RTRIM(CT1.CT1_CONTA)"+CRLF
cQry+= " 		AND AKD2.AKD_DATA<='"+DTOS(dDataFim)+"'"+CRLF
cQry+= " 		AND AKD2.AKD_CC IN " + FormatIn(cCustoHie,",")+CRLF

if MV_PAR05 == 1
	cQry+= " 		AND AKD2.AKD_ITCTB BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'"+CRLF
endif

IF !EMPTY(cAtividades)
	cQry+= " 		AND AKD2.AKD_CLVLR IN " + FormatIn(cAtividades,",")+CRLF
ENDIF

cQry+= " 		AND AKD2.AKD_TPSALD = 'RE'"+CRLF
cQry+= " 		AND AKD2.AKD_STATUS != '3'"+CRLF	
cQry+= " 		AND AKD2.D_E_L_E_T_= ' '"+CRLF
cQry+= " 	WHERE CT1.CT1_FILIAL='"+XFILIAL("CT1")+"'"+CRLF
cQry+= " 		AND CT1."+cCampConta+" BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'"+CRLF

cQry+= cQryCt1

cQry+= " 		AND CT1.D_E_L_E_T_=''"+CRLF
cQry+= " 	GROUP BY CT1."+cCampConta+",CT1."+cCampDesc+",AKD2.AKD_CC,AKD2.AKD_ITCTB,AKD2.AKD_TIPO"+CRLF
cQry+= " )"+CRLF
cQry+= " SELECT	CONTA"+CRLF
cQry+= " 		,DESCTA"+CRLF
cQry+= " 		,CCUSTO"+CRLF
cQry+= " 		,CTT_DESC01"+CRLF
cQry+= " 		,(CASE WHEN SETOR = '' THEN 'ND' ELSE SETOR END) AS SETOR"+CRLF
cQry+= " 		,(CASE WHEN SETOR = '' THEN 'NรO DEFINIDO' ELSE CTD_DESC01 END) AS CTD_DESC01 "+CRLF
//cQry+= " 		,SETOR"+CRLF
//cQry+= " 		,CTD_DESC01"+CRLF			
cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN ORCADO ELSE 0 END) - SUM(CASE WHEN TIPO = '2' THEN ORCADO ELSE 0 END) AS ORCADO"+CRLF
cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN REALIZADO ELSE 0 END) - SUM(CASE WHEN TIPO = '2' THEN REALIZADO ELSE 0 END) AS REALIZADO"+CRLF
cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN ORCADOAC ELSE 0 END) - SUM(CASE WHEN TIPO = '2' THEN ORCADOAC ELSE 0 END) AS ORCADOAC"+CRLF
cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN REALIZADOAC ELSE 0 END) - SUM(CASE WHEN TIPO = '2' THEN REALIZADOAC ELSE 0 END) AS REALIZADOAC"+CRLF		 		
//cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN ORCADO ELSE ORCADO * -1 END) AS ORCADO"+CRLF
//cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN REALIZADO ELSE REALIZADO * -1 END) AS REALIZADO"+CRLF
//cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN ORCADOAC ELSE ORCADOAC * -1 END) AS ORCADOAC"+CRLF
//cQry+= " 		,SUM(CASE WHEN TIPO = '1' THEN REALIZADOAC ELSE REALIZADOAC * -1 END) AS REALIZADOAC"+CRLF
cQry+= " FROM ACOORC"+CRLF
cQry+= " LEFT JOIN "+RETSQLNAME("CTT")+" CTT ON CTT_FILIAL='"+XFILIAL("CTT")+"'"+CRLF
cQry+= " 	AND CTT_CUSTO=CCUSTO"+CRLF
cQry+= " 	AND CTT.D_E_L_E_T_=''"+CRLF
cQry+= " LEFT JOIN "+RETSQLNAME("CTD")+" CTD ON CTD_FILIAL='"+XFILIAL("CTD")+"'"+CRLF
cQry+= " 	AND CTD_ITEM=SETOR"+CRLF
cQry+= " 	AND CTD.D_E_L_E_T_=''"+CRLF
cQry+= " GROUP BY CONTA,DESCTA,CCUSTO,CTT_DESC01,SETOR,CTD_DESC01"+CRLF
cQry+= " ORDER BY CCUSTO ASC,SETOR ASC,SUBSTRING(CONTA,1,1) DESC,CONTA ASC "+CRLF

oReport:SetMsgPrint("Realizando consulta na base de dados...")

TcQuery cQry NEW ALIAS (cTab) 
Count To nTot      
oReport:SetMeter(nTot)			
oReport:SetMsgPrint("Imprimindo...")                                                  
(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())           

cDescCR	:= (cTab)->CTT_DESC01
cDescSet	:= (cTab)->CTD_DESC01
cDescCO	:= POSICIONE("CT1",1,XFILIAL("CT1")+ SUBSTR((cTab)->CONTA,1,nSubAte) ,cCampDesc )
cContax	:= LEFT((cTab)->CONTA,1)

if (cTab)->(!EOF())                    	
	WHILE (cTab)->(!EOF()) .AND. !oReport:Cancel()	 
		
		oReport:IncMeter()
		
		// ATUALIZA TOTALIZADORES RECEITAS FINANCEIRAS
		IF cGrpRecFin == SUBSTR((cTab)->CONTA,1,LEN(cGrpRecFin))
			aTotReceFin[1]+= (cTab)->ORCADO
			aTotReceFin[2]+= (cTab)->REALIZADO
			aTotReceFin[3]:= aTotReceFin[2] - aTotReceFin[1]
			aTotReceFin[4]:= ((aTotReceFin[2] - aTotReceFin[1]) * 100) / aTotReceFin[1]
			aTotReceFin[5]+= (cTab)->ORCADOAC
			aTotReceFin[6]+= (cTab)->REALIZADOAC
			aTotReceFin[7]:= aTotReceFin[6] - aTotReceFin[5]
			aTotReceFin[8]:= ((aTotReceFin[6] - aTotReceFin[5]) * 100) / aTotReceFin[5]
			
			(cTab)->(dbSkip())	
			LOOP		
		Endif
		
		lFechConta:= .T.
		lFechSetor:= .T.	  	
		IF cCR!=(cTab)->CCUSTO
			
			// Fecha totalizador por conta
			IF !EMPTY(cCO) .AND. MV_PAR10 == 1 .AND. MV_PAR09 != 5
				oSection01:Init()
				oSection01:Cell("DESCTA"			):SetBlock({|| space(4)+"TOTAL " + cDescCO })
				oSection01:Cell("ORCADO"			):Show()
				oSection01:Cell("REALIZADO"		):Show()
				oSection01:Cell("NOMINAL"		):Show()
				oSection01:Cell("PERCENT"		):Show()
				oSection01:Cell("ORCADOAC"		):Show()
				oSection01:Cell("REALIZADOAC"	):Show()
				oSection01:Cell("NOMINALAC"		):Show()
				oSection01:Cell("PERCENTAC"		):Show()	
				oSection01:Cell("ORCADO"			):SetBlock({|| aTotConta[1] 	})
				oSection01:Cell("REALIZADO"		):SetBlock({|| aTotConta[2]		})
				oSection01:Cell("NOMINAL"		):SetBlock({|| aTotConta[3] 	})
				oSection01:Cell("PERCENT"		):SetBlock({|| aTotConta[4] 	})
				oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotConta[5] 	})
				oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotConta[6] 	})
				oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotConta[7] 	})
				oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotConta[8] 	})
				oSection01:PrintLine()
				
				// Zera totalizadores por CR
				aTotConta:= {0,0,0,0,0,0,0,0}
				cDescCO:= POSICIONE("CT1",1,XFILIAL("CT1")+ SUBSTR((cTab)->CONTA,1,nSubAte) ,cCampDesc)
				oReport:SkipLine(1)
				lFechConta:= .F.
			Endif
			
			// Fecha totalizador por SETOR
			IF !EMPTY(cSet)
				oSection01:Init()
				oSection01:Cell("DESCTA"			):SetBlock({|| space(2)+"TOTAL SETOR " + cDescSet 	})
				oSection01:Cell("ORCADO"			):Show()
				oSection01:Cell("REALIZADO"		):Show()
				oSection01:Cell("NOMINAL"		):Show()
				oSection01:Cell("PERCENT"		):Show()
				oSection01:Cell("ORCADOAC"		):Show()
				oSection01:Cell("REALIZADOAC"	):Show()
				oSection01:Cell("NOMINALAC"		):Show()
				oSection01:Cell("PERCENTAC"		):Show()	
				oSection01:Cell("ORCADO"			):SetBlock({|| aTotSetor[1] 	})
				oSection01:Cell("REALIZADO"		):SetBlock({|| aTotSetor[2]		})
				oSection01:Cell("NOMINAL"		):SetBlock({|| aTotSetor[3] 	})
				oSection01:Cell("PERCENT"		):SetBlock({|| aTotSetor[4] 	})
				oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotSetor[5] 	})
				oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotSetor[6] 	})
				oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotSetor[7] 	})
				oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotSetor[8] 	})
				oSection01:PrintLine()
				
				// Zera totalizadores por SETOR
				aTotSetor:= {0,0,0,0,0,0,0,0}
				cDescSet:= (cTab)->CTD_DESC01
				oReport:SkipLine(1)	
				lFechSetor:= .F.		
			ENDIF			
			
			// Fecha totalizador por CR
			IF !EMPTY(cCR)
				oSection01:Init()
				oSection01:Cell("DESCTA"			):SetBlock({|| "TOTAL CR " + cDescCR 	})
				oSection01:Cell("ORCADO"			):Show()
				oSection01:Cell("REALIZADO"		):Show()
				oSection01:Cell("NOMINAL"		):Show()
				oSection01:Cell("PERCENT"		):Show()
				oSection01:Cell("ORCADOAC"		):Show()
				oSection01:Cell("REALIZADOAC"	):Show()
				oSection01:Cell("NOMINALAC"		):Show()
				oSection01:Cell("PERCENTAC"		):Show()	
				oSection01:Cell("ORCADO"			):SetBlock({|| aTotCR[1] 	})
				oSection01:Cell("REALIZADO"		):SetBlock({|| aTotCR[2]		})
				oSection01:Cell("NOMINAL"		):SetBlock({|| aTotCR[3] 	})
				oSection01:Cell("PERCENT"		):SetBlock({|| aTotCR[4] 	})
				oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotCR[5] 	})
				oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotCR[6] 	})
				oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotCR[7] 	})
				oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotCR[8] 	})
				oSection01:PrintLine()
				
				// Zera totalizadores por CR
				aTotCR:= {0,0,0,0,0,0,0,0}
				cDescCR:= (cTab)->CTT_DESC01
				oReport:SkipLine(1)	
				
				C9R02FEC(2,oReport,oSection01,aTotReceita,aTotDespesa,aTotMargDir,aTotReceFin,aTotSupAvit)
				oReport:EndPage()
				oReport:StartPage()				
				lRecDesp:= .T.			
			ENDIF
			
			// Fecha total contribui็๕es e receitas
			IF MV_PAR10 != 1  .AND. lRecDesp .and. cContax != LEFT((cTab)->CONTA,1)
				C9R02FEC(1,oReport,oSection01,aTotReceita,aTotDespesa,aTotMargDir,aTotReceFin,aTotSupAvit)
				cContax:= LEFT((cTab)->CONTA,1)
				lRecDesp:= .F.	
			ENDIF	
			
			oSection01:Init()
			oSection01:Cell("DESCTA"			):SetBlock({|| "CR "+ trim((cTab)->CCUSTO) +" - " +(cTab)->CTT_DESC01 	})		
			oSection01:Cell("ORCADO"			):Hide()
			oSection01:Cell("REALIZADO"		):Hide()
			oSection01:Cell("NOMINAL"		):Hide()
			oSection01:Cell("PERCENT"		):Hide()
			oSection01:Cell("ORCADOAC"		):Hide()
			oSection01:Cell("REALIZADOAC"	):Hide()
			oSection01:Cell("NOMINALAC"		):Hide()
			oSection01:Cell("PERCENTAC"		):Hide()	
			oSection01:PrintLine()
			//oReport:SkipLine(1)
			cCR:= (cTab)->CCUSTO
		ENDIF	
		
		IF cSet!=(cTab)->SETOR
		
			// Fecha totalizador por conta
			IF !EMPTY(cCO) .AND. MV_PAR10 == 1 .AND. MV_PAR09 != 5
				oSection01:Init()
				oSection01:Cell("DESCTA"			):SetBlock({|| Space(4)+"TOTAL " + cDescCO })
				oSection01:Cell("ORCADO"			):Show()
				oSection01:Cell("REALIZADO"		):Show()
				oSection01:Cell("NOMINAL"		):Show()
				oSection01:Cell("PERCENT"		):Show()
				oSection01:Cell("ORCADOAC"		):Show()
				oSection01:Cell("REALIZADOAC"	):Show()
				oSection01:Cell("NOMINALAC"		):Show()
				oSection01:Cell("PERCENTAC"		):Show()	
				oSection01:Cell("ORCADO"			):SetBlock({|| aTotConta[1] 	})
				oSection01:Cell("REALIZADO"		):SetBlock({|| aTotConta[2]		})
				oSection01:Cell("NOMINAL"		):SetBlock({|| aTotConta[3] 	})
				oSection01:Cell("PERCENT"		):SetBlock({|| aTotConta[4] 	})
				oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotConta[5] 	})
				oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotConta[6] 	})
				oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotConta[7] 	})
				oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotConta[8] 	})
				oSection01:PrintLine()
				
				// Zera totalizadores por CR
				aTotConta:= {0,0,0,0,0,0,0,0}
				cDescCO:= POSICIONE("CT1",1,XFILIAL("CT1")+ SUBSTR((cTab)->CONTA,1,nSubAte) ,cCampDesc)
				oReport:SkipLine(1)
				lFechConta:= .F.
			Endif		
			
			// Fecha totalizador por SETOR
			IF !EMPTY(cSet) .and. lFechSetor
				oSection01:Init()
				oSection01:Cell("DESCTA"			):SetBlock({|| Space(2)+"TOTAL SETOR " + cDescSet 	})
				oSection01:Cell("ORCADO"			):Show()
				oSection01:Cell("REALIZADO"		):Show()
				oSection01:Cell("NOMINAL"		):Show()
				oSection01:Cell("PERCENT"		):Show()
				oSection01:Cell("ORCADOAC"		):Show()
				oSection01:Cell("REALIZADOAC"	):Show()
				oSection01:Cell("NOMINALAC"		):Show()
				oSection01:Cell("PERCENTAC"		):Show()	
				oSection01:Cell("ORCADO"			):SetBlock({|| aTotSetor[1] 	})
				oSection01:Cell("REALIZADO"		):SetBlock({|| aTotSetor[2]		})
				oSection01:Cell("NOMINAL"		):SetBlock({|| aTotSetor[3] 	})
				oSection01:Cell("PERCENT"		):SetBlock({|| aTotSetor[4] 	})
				oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotSetor[5] 	})
				oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotSetor[6] 	})
				oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotSetor[7] 	})
				oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotSetor[8] 	})
				oSection01:PrintLine()
				
				// Zera totalizadores por SETOR
				aTotSetor:= {0,0,0,0,0,0,0,0}
				cDescSet:= (cTab)->CTD_DESC01
				oReport:SkipLine(1)			
			ENDIF
			
			// Fecha total contribui็๕es e receitas
			IF lRecDesp .and. cContax != LEFT((cTab)->CONTA,1)
				C9R02FEC(1,oReport,oSection01,aTotReceita,aTotDespesa,aTotMargDir,aTotReceFin,aTotSupAvit)
				cContax:= LEFT((cTab)->CONTA,1)
				lRecDesp:= .F.	
			ENDIF							
			
			oSection01:Init()
			oSection01:Cell("DESCTA"			):SetBlock({|| Space(2)+"SETOR "+ trim((cTab)->SETOR) +" - " +(cTab)->CTD_DESC01 	})		
			oSection01:Cell("ORCADO"			):Hide()
			oSection01:Cell("REALIZADO"		):Hide()
			oSection01:Cell("NOMINAL"		):Hide()
			oSection01:Cell("PERCENT"		):Hide()
			oSection01:Cell("ORCADOAC"		):Hide()
			oSection01:Cell("REALIZADOAC"	):Hide()
			oSection01:Cell("NOMINALAC"		):Hide()
			oSection01:Cell("PERCENTAC"		):Hide()	
			oSection01:PrintLine()					
		
			cSet:= (cTab)->SETOR
		ENDIF			
		
		IF MV_PAR10 == 1  .AND. MV_PAR09 != 5 .AND. cCO!= SUBSTR((cTab)->CONTA,1,nSubAte)
		
			// Fecha totalizador por conta
			IF !EMPTY(cCO) .AND. lFechConta
				oSection01:Init()
				oSection01:Cell("DESCTA"			):SetBlock({|| space(4)+"TOTAL " + cDescCO })
				oSection01:Cell("ORCADO"			):Show()
				oSection01:Cell("REALIZADO"		):Show()
				oSection01:Cell("NOMINAL"		):Show()
				oSection01:Cell("PERCENT"		):Show()
				oSection01:Cell("ORCADOAC"		):Show()
				oSection01:Cell("REALIZADOAC"	):Show()
				oSection01:Cell("NOMINALAC"		):Show()
				oSection01:Cell("PERCENTAC"		):Show()	
				oSection01:Cell("ORCADO"			):SetBlock({|| aTotConta[1] 	})
				oSection01:Cell("REALIZADO"		):SetBlock({|| aTotConta[2]		})
				oSection01:Cell("NOMINAL"		):SetBlock({|| aTotConta[3] 	})
				oSection01:Cell("PERCENT"		):SetBlock({|| aTotConta[4] 	})
				oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotConta[5] 	})
				oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotConta[6] 	})
				oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotConta[7] 	})
				oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotConta[8] 	})
				oSection01:PrintLine()
				
				// Zera totalizadores por CR
				aTotConta:= {0,0,0,0,0,0,0,0}
				cDescCO:= POSICIONE("CT1",1,XFILIAL("CT1")+ SUBSTR((cTab)->CONTA,1,nSubAte) ,cCampDesc) 
				oReport:SkipLine(1)
			Endif
			
			// Fecha total contribui็๕es e receitas
			IF lRecDesp .and. cContax != LEFT((cTab)->CONTA,1)
				C9R02FEC(1,oReport,oSection01,aTotReceita,aTotDespesa,aTotMargDir,aTotReceFin,aTotSupAvit)
				cContax:= LEFT((cTab)->CONTA,1)
				lRecDesp:= .F.	
			ENDIF				
		
			oSection01:Init()
			oSection01:Cell("DESCTA"			):SetBlock({|| space(4)+ POSICIONE("CT1",1,XFILIAL("CT1")+ SUBSTR((cTab)->CONTA,1,nSubAte) ,cCampDesc) })  		
			oSection01:Cell("ORCADO"			):Hide()
			oSection01:Cell("REALIZADO"		):Hide()
			oSection01:Cell("NOMINAL"		):Hide()
			oSection01:Cell("PERCENT"		):Hide()
			oSection01:Cell("ORCADOAC"		):Hide()
			oSection01:Cell("REALIZADOAC"	):Hide()
			oSection01:Cell("NOMINALAC"		):Hide()
			oSection01:Cell("PERCENTAC"		):Hide()	
			oSection01:PrintLine()
			
			cCO:= SUBSTR((cTab)->CONTA,1,nSubAte)	
			
		Else		
			
			// Fecha total contribui็๕es e receitas
			IF (MV_PAR09 == 5 .or. (MV_PAR09 != 5 .and. MV_PAR10==2)) .AND. lRecDesp .and. cContax != LEFT((cTab)->CONTA,1)
				oReport:SkipLine(1)
				C9R02FEC(1,oReport,oSection01,aTotReceita,aTotDespesa,aTotMargDir,aTotReceFin,aTotSupAvit)
				cContax:= LEFT((cTab)->CONTA,1)
				lRecDesp:= .F.	
			ENDIF	
				
		Endif	
		
		oSection01:Init()
		oSection01:Cell("ORCADO"			):Show()
		oSection01:Cell("REALIZADO"		):Show()
		oSection01:Cell("NOMINAL"		):Show()
		oSection01:Cell("PERCENT"		):Show()
		oSection01:Cell("ORCADOAC"		):Show()
		oSection01:Cell("REALIZADOAC"	):Show()
		oSection01:Cell("NOMINALAC"		):Show()
		oSection01:Cell("PERCENTAC"		):Show()	
		oSection01:Cell("DESCTA"			):SetBlock({|| space(6)+(cTab)->DESCTA 	})
		oSection01:Cell("ORCADO"			):SetBlock({|| (cTab)->ORCADO 	})
		oSection01:Cell("REALIZADO"		):SetBlock({|| (cTab)->REALIZADO 	})
		oSection01:Cell("NOMINAL"		):SetBlock({|| (cTab)->REALIZADO - (cTab)->ORCADO })
		oSection01:Cell("PERCENT"		):SetBlock({|| (((cTab)->REALIZADO - (cTab)->ORCADO) * 100) / (cTab)->ORCADO })
		oSection01:Cell("ORCADOAC"		):SetBlock({|| (cTab)->ORCADOAC 	})
		oSection01:Cell("REALIZADOAC"	):SetBlock({|| (cTab)->REALIZADOAC 	})
		oSection01:Cell("NOMINALAC"		):SetBlock({|| (cTab)->REALIZADOAC - (cTab)->ORCADOAC 	})
		oSection01:Cell("PERCENTAC"		):SetBlock({|| (((cTab)->REALIZADOAC - (cTab)->ORCADOAC) * 100) / (cTab)->ORCADOAC 	})
		oSection01:PrintLine()	
		
		// Atualiza totalizadores por CR
		aTotCR[1]+= (cTab)->ORCADO
		aTotCR[2]+= (cTab)->REALIZADO
		aTotCR[3]:= aTotCR[2] - aTotCR[1]
		aTotCR[4]:= ((aTotCR[2] - aTotCR[1]) * 100) / aTotCR[1]
		aTotCR[5]+= (cTab)->ORCADOAC
		aTotCR[6]+= (cTab)->REALIZADOAC
		aTotCR[7]:= aTotCR[6] - aTotCR[5]
		aTotCR[8]:= ((aTotCR[6] - aTotCR[5]) * 100) / aTotCR[5]	
		
		// Atualiza totalizadores por CR
		aTotSetor[1]+= (cTab)->ORCADO
		aTotSetor[2]+= (cTab)->REALIZADO
		aTotSetor[3]:= aTotSetor[2] - aTotSetor[1]
		aTotSetor[4]:= ((aTotSetor[2] - aTotSetor[1]) * 100) / aTotSetor[1]
		aTotSetor[5]+= (cTab)->ORCADOAC
		aTotSetor[6]+= (cTab)->REALIZADOAC
		aTotSetor[7]:= aTotSetor[6] - aTotSetor[5]
		aTotSetor[8]:= ((aTotSetor[6] - aTotSetor[5]) * 100) / aTotSetor[5]				
		
		// Atualiza totalizadores por Conta
		aTotConta[1]+= (cTab)->ORCADO
		aTotConta[2]+= (cTab)->REALIZADO
		aTotConta[3]:= aTotConta[2] - aTotConta[1]
		aTotConta[4]:= ((aTotConta[2] - aTotConta[1]) * 100) / aTotConta[1]
		aTotConta[5]+= (cTab)->ORCADOAC
		aTotConta[6]+= (cTab)->REALIZADOAC
		aTotConta[7]:= aTotConta[6] - aTotConta[5]
		aTotConta[8]:= ((aTotConta[6] - aTotConta[5]) * 100) / aTotConta[5]			
		
		// ATUALIZA TOTALIZADORES RECEITAS
		IF cContax$"5"
			aTotReceita[1]+= (cTab)->ORCADO
			aTotReceita[2]+= (cTab)->REALIZADO
			aTotReceita[3]:= aTotReceita[2] - aTotReceita[1]
			aTotReceita[4]:= ((aTotReceita[2] - aTotReceita[1]) * 100) / aTotReceita[1]
			aTotReceita[5]+= (cTab)->ORCADOAC
			aTotReceita[6]+= (cTab)->REALIZADOAC
			aTotReceita[7]:= aTotReceita[6] - aTotReceita[5]
			aTotReceita[8]:= ((aTotReceita[6] - aTotReceita[5]) * 100) / aTotReceita[5]
		ENDIF		
		
		// ATUALIZA TOTALIZADORES DESPESAS
		IF cContax$"3,4"
			aTotDespesa[1]+= (cTab)->ORCADO
			aTotDespesa[2]+= (cTab)->REALIZADO
			aTotDespesa[3]:= aTotDespesa[2] - aTotDespesa[1]
			aTotDespesa[4]:= ((aTotDespesa[2] - aTotDespesa[1]) * 100) / aTotDespesa[1]
			aTotDespesa[5]+= (cTab)->ORCADOAC
			aTotDespesa[6]+= (cTab)->REALIZADOAC
			aTotDespesa[7]:= aTotDespesa[6] - aTotDespesa[5]
			aTotDespesa[8]:= ((aTotDespesa[6] - aTotDespesa[5]) * 100) / aTotDespesa[5]
		ENDIF	
							
	(cTab)->(dbSkip())	
	ENDDO  
	(cTab)->(dbCloseArea())
	
	IF MV_PAR10 == 1  .AND. MV_PAR09 != 5 
	
		// Fecha totalizador por conta
		IF !EMPTY(cCO) .AND. lFechConta
			oSection01:Init()
			oSection01:Cell("DESCTA"			):SetBlock({|| space(4)+"TOTAL " + cDescCO })
			oSection01:Cell("ORCADO"			):Show()
			oSection01:Cell("REALIZADO"		):Show()
			oSection01:Cell("NOMINAL"		):Show()
			oSection01:Cell("PERCENT"		):Show()
			oSection01:Cell("ORCADOAC"		):Show()
			oSection01:Cell("REALIZADOAC"	):Show()
			oSection01:Cell("NOMINALAC"		):Show()
			oSection01:Cell("PERCENTAC"		):Show()	
			oSection01:Cell("ORCADO"			):SetBlock({|| aTotConta[1] 	})
			oSection01:Cell("REALIZADO"		):SetBlock({|| aTotConta[2]		})
			oSection01:Cell("NOMINAL"		):SetBlock({|| aTotConta[3] 	})
			oSection01:Cell("PERCENT"		):SetBlock({|| aTotConta[4] 	})
			oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotConta[5] 	})
			oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotConta[6] 	})
			oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotConta[7] 	})
			oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotConta[8] 	})
			oSection01:PrintLine()
			oReport:SkipLine(1)
		Endif
	Endif
	
	// Fecha totalizador por SETOR
	IF !EMPTY(cSet) .and. lFechSetor
		oSection01:Init()
		oSection01:Cell("DESCTA"			):SetBlock({|| Space(2)+"TOTAL SETOR " + cDescSet 	})
		oSection01:Cell("ORCADO"			):Show()
		oSection01:Cell("REALIZADO"		):Show()
		oSection01:Cell("NOMINAL"		):Show()
		oSection01:Cell("PERCENT"		):Show()
		oSection01:Cell("ORCADOAC"		):Show()
		oSection01:Cell("REALIZADOAC"	):Show()
		oSection01:Cell("NOMINALAC"		):Show()
		oSection01:Cell("PERCENTAC"		):Show()	
		oSection01:Cell("ORCADO"			):SetBlock({|| aTotSetor[1] 	})
		oSection01:Cell("REALIZADO"		):SetBlock({|| aTotSetor[2]		})
		oSection01:Cell("NOMINAL"		):SetBlock({|| aTotSetor[3] 	})
		oSection01:Cell("PERCENT"		):SetBlock({|| aTotSetor[4] 	})
		oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotSetor[5] 	})
		oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotSetor[6] 	})
		oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotSetor[7] 	})
		oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotSetor[8] 	})
		oSection01:PrintLine()
		oReport:SkipLine(1)			
	ENDIF	
		
	// FECHA TOTALIZADOR POR CR
	oSection01:Init()
	oSection01:Cell("DESCTA"			):SetBlock({|| "TOTAL CR " + cDescCR 	})
	oSection01:Cell("ORCADO"			):Show()
	oSection01:Cell("REALIZADO"		):Show()
	oSection01:Cell("NOMINAL"		):Show()
	oSection01:Cell("PERCENT"		):Show()
	oSection01:Cell("ORCADOAC"		):Show()
	oSection01:Cell("REALIZADOAC"	):Show()
	oSection01:Cell("NOMINALAC"		):Show()
	oSection01:Cell("PERCENTAC"		):Show()	
	oSection01:Cell("ORCADO"			):SetBlock({|| aTotCR[1] 	})
	oSection01:Cell("REALIZADO"		):SetBlock({|| aTotCR[2]		})
	oSection01:Cell("NOMINAL"		):SetBlock({|| aTotCR[3] 	})
	oSection01:Cell("PERCENT"		):SetBlock({|| aTotCR[4] 	})
	oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotCR[5] 	})
	oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotCR[6] 	})
	oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotCR[7] 	})
	oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotCR[8] 	})
	oSection01:PrintLine()
	oReport:SkipLine(1)
	
	C9R02FEC(2,oReport,oSection01,aTotReceita,aTotDespesa,aTotMargDir,aTotReceFin,aTotSupAvit)
	
endif	

RETURN 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C9R02FEC	  บAutor  ณCarlos Hnerique	  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Fecha totalizadores	    								  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C9R02FEC(nTipo,oReport,oSection01,aTotReceita,aTotDespesa,aTotMargDir,aTotReceFin,aTotSupAvit)

if nTipo == 1				
	oSection01:Init()
	oSection01:Cell("DESCTA"			):SetBlock({|| "TOTAL CONTRIBUIวีES E RECEITAS" })
	oSection01:Cell("ORCADO"			):Show()
	oSection01:Cell("REALIZADO"		):Show()
	oSection01:Cell("NOMINAL"		):Show()
	oSection01:Cell("PERCENT"		):Show()
	oSection01:Cell("ORCADOAC"		):Show()
	oSection01:Cell("REALIZADOAC"	):Show()
	oSection01:Cell("NOMINALAC"		):Show()
	oSection01:Cell("PERCENTAC"		):Show()	
	oSection01:Cell("ORCADO"			):SetBlock({|| aTotReceita[1] 	})
	oSection01:Cell("REALIZADO"		):SetBlock({|| aTotReceita[2]		})
	oSection01:Cell("NOMINAL"		):SetBlock({|| aTotReceita[3] 	})
	oSection01:Cell("PERCENT"		):SetBlock({|| aTotReceita[4] 	})
	oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotReceita[5] 	})
	oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotReceita[6] 	})
	oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotReceita[7] 	})
	oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotReceita[8] 	})
	oSection01:PrintLine()
	oReport:SkipLine(1)	

else
	// FECHA TOTAL DAS DESPESAS
	aTotDespesa[3]:= aTotDespesa[2] - aTotDespesa[1]
	aTotDespesa[4]:= ((aTotDespesa[2] - aTotDespesa[1]) * 100) / aTotDespesa[1]
	aTotDespesa[7]:= aTotDespesa[6] - aTotDespesa[5]
	aTotDespesa[8]:= ((aTotDespesa[6] - aTotDespesa[5]) * 100) / aTotDespesa[5]
			
	oSection01:Init()
	oSection01:Cell("DESCTA"			):SetBlock({|| "TOTAL DAS DESPESAS" })
	oSection01:Cell("ORCADO"			):Show()
	oSection01:Cell("REALIZADO"		):Show()
	oSection01:Cell("NOMINAL"		):Show()
	oSection01:Cell("PERCENT"		):Show()
	oSection01:Cell("ORCADOAC"		):Show()
	oSection01:Cell("REALIZADOAC"	):Show()
	oSection01:Cell("NOMINALAC"		):Show()
	oSection01:Cell("PERCENTAC"		):Show()	
	oSection01:Cell("ORCADO"			):SetBlock({|| aTotDespesa[1] 	})
	oSection01:Cell("REALIZADO"		):SetBlock({|| aTotDespesa[2]		})
	oSection01:Cell("NOMINAL"		):SetBlock({|| aTotDespesa[3] 	})
	oSection01:Cell("PERCENT"		):SetBlock({|| aTotDespesa[4] 	})
	oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotDespesa[5] 	})
	oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotDespesa[6] 	})
	oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotDespesa[7] 	})
	oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotDespesa[8] 	})
	oSection01:PrintLine()
	oReport:SkipLine(1)	
	
	// FECHA TOTAL MARGEM DIRETA
	aTotMargDir[1]:= aTotReceita[1] - aTotDespesa[1]
	aTotMargDir[2]:= aTotReceita[2] - aTotDespesa[2]
	aTotMargDir[3]:= aTotMargDir[2] - aTotMargDir[1]
	aTotMargDir[4]:= ((aTotMargDir[2] - aTotMargDir[1]) * 100) / aTotMargDir[1]
	aTotMargDir[5]:= aTotReceita[5] - aTotDespesa[5]
	aTotMargDir[6]:= aTotReceita[6] - aTotDespesa[6]
	aTotMargDir[7]:= aTotMargDir[6] - aTotMargDir[5]
	aTotMargDir[8]:= ((aTotMargDir[6] - aTotMargDir[5]) * 100) / aTotMargDir[5]	
		
	oSection01:Init()
	oSection01:Cell("DESCTA"			):SetBlock({|| "MARGEM DIRETA" })
	oSection01:Cell("ORCADO"			):Show()
	oSection01:Cell("REALIZADO"		):Show()
	oSection01:Cell("NOMINAL"		):Show()
	oSection01:Cell("PERCENT"		):Show()
	oSection01:Cell("ORCADOAC"		):Show()
	oSection01:Cell("REALIZADOAC"	):Show()
	oSection01:Cell("NOMINALAC"		):Show()
	oSection01:Cell("PERCENTAC"		):Show()	
	oSection01:Cell("ORCADO"			):SetBlock({|| aTotMargDir[1] 	})
	oSection01:Cell("REALIZADO"		):SetBlock({|| aTotMargDir[2]	})
	oSection01:Cell("NOMINAL"		):SetBlock({|| aTotMargDir[3] 	})
	oSection01:Cell("PERCENT"		):SetBlock({|| aTotMargDir[4] 	})
	oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotMargDir[5] 	})
	oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotMargDir[6] 	})
	oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotMargDir[7] 	})
	oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotMargDir[8] 	})
	oSection01:PrintLine()
	oReport:SkipLine(1)	
	
	// FECHA TOTAL RECEITAS FINANCEIRAS
	aTotReceFin[3]:= aTotReceFin[2] - aTotReceFin[1]
	aTotReceFin[4]:= ((aTotReceFin[2] - aTotReceFin[1]) * 100) / aTotReceFin[1]
	aTotReceFin[7]:= aTotReceFin[6] - aTotReceFin[5]
	aTotReceFin[8]:= ((aTotReceFin[6] - aTotReceFin[5]) * 100) / aTotReceFin[5]	
	
	oSection01:Init()
	oSection01:Cell("DESCTA"			):SetBlock({|| "RECEITAS FINANCEIRAS" })
	oSection01:Cell("ORCADO"			):Show()
	oSection01:Cell("REALIZADO"		):Show()
	oSection01:Cell("NOMINAL"		):Show()
	oSection01:Cell("PERCENT"		):Show()
	oSection01:Cell("ORCADOAC"		):Show()
	oSection01:Cell("REALIZADOAC"	):Show()
	oSection01:Cell("NOMINALAC"		):Show()
	oSection01:Cell("PERCENTAC"		):Show()	
	oSection01:Cell("ORCADO"			):SetBlock({|| aTotReceFin[1] 	})
	oSection01:Cell("REALIZADO"		):SetBlock({|| aTotReceFin[2]	})
	oSection01:Cell("NOMINAL"		):SetBlock({|| aTotReceFin[3] 	})
	oSection01:Cell("PERCENT"		):SetBlock({|| aTotReceFin[4] 	})
	oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotReceFin[5] 	})
	oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotReceFin[6] 	})
	oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotReceFin[7] 	})
	oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotReceFin[8] 	})
	oSection01:PrintLine()
	oReport:SkipLine(1)	
	
	// FECHA TOTAL SUPERAVIT
	aTotSupAvit[1]:= aTotMargDir[1] + aTotReceFin[1]
	aTotSupAvit[2]:= aTotMargDir[2] + aTotReceFin[2]
	aTotSupAvit[3]:= aTotSupAvit[2] - aTotSupAvit[1]
	aTotSupAvit[4]:= ((aTotSupAvit[2] - aTotSupAvit[1]) * 100) / aTotSupAvit[1]
	aTotSupAvit[5]:= aTotMargDir[5] + aTotReceFin[5]
	aTotSupAvit[6]:= aTotMargDir[6] + aTotReceFin[6]
	aTotSupAvit[7]:= aTotSupAvit[6] - aTotSupAvit[5]
	aTotSupAvit[8]:= ((aTotSupAvit[6] - aTotSupAvit[5]) * 100) / aTotSupAvit[5]		
	
	oSection01:Init()
	oSection01:Cell("DESCTA"			):SetBlock({|| "SUPERAVIT(DEFICIT) FINAL" })
	oSection01:Cell("ORCADO"			):Show()
	oSection01:Cell("REALIZADO"		):Show()
	oSection01:Cell("NOMINAL"		):Show()
	oSection01:Cell("PERCENT"		):Show()
	oSection01:Cell("ORCADOAC"		):Show()
	oSection01:Cell("REALIZADOAC"	):Show()
	oSection01:Cell("NOMINALAC"		):Show()
	oSection01:Cell("PERCENTAC"		):Show()	
	oSection01:Cell("ORCADO"			):SetBlock({|| aTotSupAvit[1] 	})
	oSection01:Cell("REALIZADO"		):SetBlock({|| aTotSupAvit[2]	})
	oSection01:Cell("NOMINAL"		):SetBlock({|| aTotSupAvit[3] 	})
	oSection01:Cell("PERCENT"		):SetBlock({|| aTotSupAvit[4] 	})
	oSection01:Cell("ORCADOAC"		):SetBlock({|| aTotSupAvit[5] 	})
	oSection01:Cell("REALIZADOAC"	):SetBlock({|| aTotSupAvit[6] 	})
	oSection01:Cell("NOMINALAC"		):SetBlock({|| aTotSupAvit[7] 	})
	oSection01:Cell("PERCENTAC"		):SetBlock({|| aTotSupAvit[8] 	})
	oSection01:PrintLine()
	oReport:SkipLine(1)			
	
	oSection01:Finish()
	
	// Zera totalizadores
	aTotReceita	:= {0,0,0,0,0,0,0,0}
	aTotDespesa	:= {0,0,0,0,0,0,0,0}
	aTotMargDir	:= {0,0,0,0,0,0,0,0}
	aTotReceFin	:= {0,0,0,0,0,0,0,0}
	aTotSupAvit	:= {0,0,0,0,0,0,0,0}
endif

return   
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C9R02SX1  บAutor  ณCarlos Hnerique	  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza parametros        								  	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE	                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C9R02SX1(cPerg,nTipoRel)
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aDados	:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

if nTipoRel == 1      

	AADD(aDados,{cPerg,'01','Mes e Ano Referencia?','Mes e Ano Referencia?','Mes e Ano Referencia?','MV_CH1','C',6,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','@R 99/9999',''} )
	AADD(aDados,{cPerg,'02','Conta contแbil de ?','Conta contแbil de ?','Conta contแbil de ?','MV_CH2','C',TAMSX3("AKD_CO")[1],0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','CT1','','','','',''} )
	AADD(aDados,{cPerg,'03','Conta contแbil at้ ?','Conta contแbil at้ ?','Conta contแbil at้ ?','MV_CH3','C',TAMSX3("AKD_CO")[1],0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','CT1','','','','',''} )
	AADD(aDados,{cPerg,'04','CR ?','CR ?','CR ?','MV_CH4','C',TAMSX3("AKD_CC")[1],0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','CTT','','','','',''} )
	AADD(aDados,{cPerg,'05','Considera Setor ?','Considera Setor ?','Considera Setor ?','MV_CH5','C',1,0,0,'C','','MV_PAR05','Sim','Sim','Sim','','','Nใo','Nใo','Nใo','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'06','Setor de ?','Setor de ?','Setor de ?','MV_CH6','C',TAMSX3("AKD_ITCTB")[1],0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','CTD','','','','',''} )
	AADD(aDados,{cPerg,'07','Setor at้ ?','Setor at้ ?','Setor at้ ?','MV_CH7','C',TAMSX3("AKD_ITCTB")[1],0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','CTD','','','','',''} )
	AADD(aDados,{cPerg,'08','Selec. Atividade ?','Selec. Atividade ?','Selec. Atividade ?','MV_CH8','C',1,0,0,'C','','MV_PAR08','Sim','Sim','Sim','','','Nใo','Nใo','Nใo','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'09','Nivel conta ?','Nivel conta ?','Nivel conta ?','MV_CH9','C',1,0,0,'C','','MV_PAR09','Nivel 1','Nivel 1','Nivel 1','','','Nivel 2','Nivel 2','Nivel 2','','','Nivel 3','Nivel 3','Nivel 3','','','Nivel 4','Nivel 4','Nivel 4','','','Nivel 5','Nivel 5','Nivel 5','','','','','','',''} )
	AADD(aDados,{cPerg,'10','Pr๓ximo nivel ?','Pr๓ximo nivel ?','Pr๓ximo nivel ?','MV_CHA','C',1,0,0,'C','','MV_PAR10','Sim','Sim','Sim','','','Nใo','Nใo','Nใo','','','','','','','','','','','','','','','','','','','','','',''} )
                         
else

	AADD(aDados,{cPerg,'01','Mes e Ano Referencia?','Mes e Ano Referencia?','Mes e Ano Referencia?','MV_CH1','C',6,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','@R 99/9999',''} )
	AADD(aDados,{cPerg,'02','Conta Gerencial de ?','Conta Gerencial de ?','Conta Gerencial de ?','MV_CH2','C',TAMSX3("AKD_CO")[1],0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','CT1GER','','','','',''} )
	AADD(aDados,{cPerg,'03','Conta Gerencial at้ ?','Conta Gerencial at้ ?','Conta Gerencial at้ ?','MV_CH3','C',TAMSX3("AKD_CO")[1],0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','CT1GER','','','','',''} )
	AADD(aDados,{cPerg,'04','CR de ?','CR de ?','CR de ?','MV_CH4','C',TAMSX3("AKD_CC")[1],0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','CTT','','','','',''} )
	AADD(aDados,{cPerg,'05','Considera Setor ?','Considera Setor ?','Considera Setor ?','MV_CH5','C',1,0,0,'C','','MV_PAR05','Sim','Sim','Sim','','','Nใo','Nใo','Nใo','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'06','Setor de ?','Setor de ?','Setor de ?','MV_CH6','C',TAMSX3("AKD_ITCTB")[1],0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','CTD','','','','',''} )
	AADD(aDados,{cPerg,'07','Setor at้ ?','Setor at้ ?','Setor at้ ?','MV_CH7','C',TAMSX3("AKD_ITCTB")[1],0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','CTD','','','','',''} )	
	AADD(aDados,{cPerg,'08','Selec. Atividade ?','Selec. Atividade ?','Selec. Atividade ?','MV_CH8','C',1,0,0,'C','','MV_PAR08','Sim','Sim','Sim','','','Nใo','Nใo','Nใo','','','','','','','','','','','','','','','','','','','','','',''} )
	AADD(aDados,{cPerg,'09','Nivel conta ?','Nivel conta ?','Nivel conta ?','MV_CH9','C',1,0,0,'C','','MV_PAR09','Nivel 1','Nivel 1','Nivel 1','','','Nivel 2','Nivel 2','Nivel 2','','','Nivel 3','Nivel 3','Nivel 3','','','Nivel 4','Nivel 4','Nivel 4','','','Nivel 5','Nivel 5','Nivel 5','','','','','','',''} )
	AADD(aDados,{cPerg,'10','Pr๓ximo nivel ?','Pr๓ximo nivel ?','Pr๓ximo nivel ?','MV_CHA','C',1,0,0,'C','','MV_PAR10','Sim','Sim','Sim','','','Nใo','Nใo','Nใo','','','','','','','','','','','','','','','','','','','','','',''} )
		
endif
//
// Atualizando dicionแrio
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

// Atualiza Helps
IF lAtuHelp        
	if nTipoRel == 1 
		AADD(aHelp, {'01',{'M๊s e ano de refer๊ncia.'},{''},{''}})
		AADD(aHelp, {'02',{'Informe a conta contแbil inicial.'},{''},{''}}) 
		AADD(aHelp, {'03',{'Informe a conta contแbil final.'},{''},{''}}) 
		AADD(aHelp, {'04',{'Informe o CR.'},{''},{''}}) 
		AADD(aHelp, {'05',{'Informe o Setor inicial.'},{''},{''}}) 
		AADD(aHelp, {'06',{'Informe o Setor final.'},{''},{''}})
		AADD(aHelp, {'07',{'Informe o nivel da conta.'},{''},{''}})		
		AADD(aHelp, {'08',{'Informe se seleciona as atividades.'},{''},{''}}) 
		AADD(aHelp, {'09',{'Informe o nivel da conta.','Para o Nivel 5 o parametro pr๓ximo','้ desconsiderado.'},{''},{''}})
		AADD(aHelp, {'10',{'Informe serแ impresso o pr๓ximo nivel da conta.'},{''},{''}})
	else
		AADD(aHelp, {'01',{'M๊s e ano de refer๊ncia.'},{''},{''}})
		AADD(aHelp, {'02',{'Informe a conta gerencial inicial.'},{''},{''}}) 
		AADD(aHelp, {'03',{'Informe a conta gerencial final.'},{''},{''}}) 
		AADD(aHelp, {'04',{'Informe o CR.'},{''},{''}}) 
		AADD(aHelp, {'05',{'Informe o Setor inicial.'},{''},{''}}) 
		AADD(aHelp, {'06',{'Informe o Setor final.'},{''},{''}})
		AADD(aHelp, {'07',{'Informe o nivel da conta.'},{''},{''}})		
		AADD(aHelp, {'08',{'Informe se seleciona as atividades.'},{''},{''}}) 
		AADD(aHelp, {'09',{'Informe o nivel da conta.','Para o Nivel 5 o parametro pr๓ximo','้ desconsiderado.'},{''},{''}})
		AADD(aHelp, {'10',{'Informe serแ impresso o pr๓ximo nivel da conta.'},{''},{''}})
		
	endif   
		
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN       
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C9R02ATV  บAutor  ณCarlos Henrique	  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Monta tela de sele็ใo das atividades 						  	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE	                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C9R02ATV()
local oDlg			:= ""	
local aHeadAux	:= {} 
local aColsAux	:= {}
local aCampUtil	:= {"CTH_CLVL","CTH_DESC01","CTH_XATICO"}  
local cRet			:= ""	
Private nPosMark	:= 1
Private nPosAtiv	:= 0
Private nPosAtvR	:= 0           
Private oGetD01	:= nil
Private cLbNo		:= "LBNO"
Private cLbOk		:= "LBOK" 

Aadd(aHeadAux,{"","TMP_XMARK","@BMP",1,0,"",,"C","","V","","",,"V","",,}) 

DBSELECTAREA("SX3")        
SX3->(DBSETORDER(1))
SX3->(DBSEEK("CTH"))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "CTH"
	IF X3USO(SX3->X3_USADO) .and. ASCAN(aCampUtil,{|x| x==TRIM(SX3->X3_CAMPO) }) > 0   		
		Aadd(aHeadAux,{	AllTrim(X3Titulo()),;
						TRIM(SX3->X3_CAMPO),;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX,;
						"",;
						SX3->X3_WHEN,;
						SX3->X3_VISUAL,;
						SX3->X3_VLDUSER,;
						SX3->X3_PICTVAR,;
						SX3->X3_OBRIGAT})			
	ENDIF
SX3->(dbSkip())		
EndDo	

nPosAtiv:= ascan(aHeadAux,{|x| TRIM(UPPER(x[2]))=="CTH_CLVL" })
nPosAtvR:= ascan(aHeadAux,{|x| TRIM(UPPER(x[2]))=="CTH_XATICO" })
 	                          		
C2E01ACS(aHeadAux,@aColsAux)

DEFINE MSDIALOG oDlg TITLE "Selecione as Atividades" FROM 0,0 TO 300,800 OF oMainWnd PIXEL  
	EnchoiceBar(oDlg,{|| iif(C2E01VAL(@cRet),oDlg:End(),nil) },{||  oDlg:End()},,)
	oGetD01:= MsNewGetDados():New(1,1,1,1,0,"AllwaysTrue","AllwaysTrue",,,,999,"AllwaysTrue()",,,oDlg,aHeadAux,aColsAux)
	oGetD01:oBrowse:blDblClick 	:= {|| C9R02MARK() }
	oGetD01:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT			
ACTIVATE MSDIALOG oDlg CENTERED 

RETURN cRet
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2E01VAL   บAutor  ณCarlos Henrique	  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valida atividades correlacionadas   						  	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE	                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2E01VAL(cRet)
Local lOk	:= .t.
Local nCnt		:= 0
Local cAtvRel	:= ""

For nCnt:= 1 to len(oGetD01:ACOLS)
	IF oGetD01:ACOLS[nCnt][nPosMark]==cLbOk
		
		// Verifica-se as atividades sใo relacionadas
		if !empty(cAtvRel) .and. cAtvRel != trim(oGetD01:ACOLS[nCnt][nPosAtvR])
			lOk:= .f.
			cRet:= ""
			msgalert("Nใo ้ permitido marcar atividades que nใo estใo relacionadas.")
			exit
		endif
		
		cAtvRel:= trim(oGetD01:ACOLS[nCnt][nPosAtvR])
		cRet+= oGetD01:ACOLS[nCnt][nPosAtiv]+","	
	Endif
Next nCnt

return lOk  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2E01ACS   บAutor  ณCarlos Henrique	  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Monta acols					    						  	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE	                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2E01ACS(aHeadAux,aColsAux)
Local cTab		:= GetNextAlias()
Local nUsado	:= 0  
Local nLin		:= 0
Local nCnt		:= 0
 
BeginSQL Alias cTab
	SELECT * FROM %Table:CTH% CTH
	WHERE CTH_FILIAL = %xFilial:CTH% AND CTH.D_E_L_E_T_='' 
	ORDER BY CTH_CLVL	
EndSQL

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
While (cTab)->(!Eof())        		
	
	nUsado:= len(aHeadAux)
	AADD(aColsAux,Array(nUsado+1))
	nLin:= len(aColsAux)   	       				
	For nCnt:= 1 TO nUsado  
		IF trim(aHeadAux[nCnt][2])=="TMP_XMARK"
			aColsAux[nLin][nCnt]:= cLbNo			
		ELSE
			aColsAux[nLin][nCnt]:= (cTab)->&(aHeadAux[nCnt][2])				
		ENDIF	
	NEXT nCntc    
	aColsAux[nLin][nUsado+1]:= .F.					    	   	   	   
(cTab)->(dbSkip())	
End  
(cTab)->(dbCloseArea()) 

return 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C9R02MARK บAutor  ณCarlos Henrique	  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ marca registro posicionado		    						  	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE	                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C9R02MARK()
      
oGetD01:ACOLS[oGetD01:nAt][nPosMark]:= IIF(oGetD01:ACOLS[oGetD01:nAt][nPosMark]==cLbNo,oGetD01:ACOLS[oGetD01:nAt][nPosMark]:=cLbOk,oGetD01:ACOLS[oGetD01:nAt][nPosMark]:=cLbNo) 
oGetD01:oBrowse:Refresh()
	
return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C9R02CAB บAutor  ณCarlos Henrique	  บ Data ณ01/01/2015     บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Monta cabe็alho do relat๓rio	     						  	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE	                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C9R02CAB(oReport)
Local cChar	:= chr(160) 
Local cLogo  	:= FisxLogo("1")
local nRowAtu	:= oReport:nRow
local cMesAno	:= UPPER(MesExtenso(VAL(LEFT(MV_PAR01,2)))+ "/" + CVALTOCHAR(YEAR(CTOD("01/"+LEFT(MV_PAR01,2)+"/"+RIGHT(MV_PAR01,4)))))
Local aCabec 	:= {	""; 
			        , "                     ";
			        + "         " + cChar + AllTrim(oReport:CTITLE) ;
			        + "         " + cChar;										
					, "         " + cChar + "                                      DETALHAMENTO DAS CONTRIBUIวีES/DESPESAS POR CENTRO DE RESPONSABILIDADE E SETOR                      "  ;					
		  			+ "         " + cChar; 
			        , "      CENTRO DE INTEGRAวรO EMPRESA-ESCOLA" +cChar+"                                                                            "+ cMesAno ;
          			+ "         " + cChar;
          			, "                 "  ;
          			+ cChar + "Impresso em " + Dtoc(dDataBase)+" - "+time()+" - "+ "Pแg: "+ alltrim(TRANSFORM(oReport:Page(),'9999')) }           			       			       

oReport:SayBitmap(10,105,cLogo,200,100) 

return aCabec