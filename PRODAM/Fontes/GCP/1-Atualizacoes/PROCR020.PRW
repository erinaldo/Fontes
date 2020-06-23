#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PROCR020   ºAutor  ³ Kaique Schiller     º Data ³  26/01/15º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Edital x Contrato                             º±±
±±º          ³ COMPRAS -> RELATÓRIOS-> ESPECIFICOS -> EDITAL X CONTRATO   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROCR020()

Local   oReport		:= nil
Private cTitulo		:= "Edital x Contrato"
Private cPerg		:= "XGCPT"   
Private cAliasQry 	:= GetNextAlias()

If TRepInUse()
	CriaSX1(cPerg)
	oReport:= ReportDef()
	oReport:PrintDialog()  // Imprime o Relatório
Else
	Alert("Este relatório só está disponível a partir da Release 4.")//"Este relatório só está disponível a partir da Release 4."
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDefºAutor  ³ Totvs              º Data ³  01/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega as definiçoes do relatorio                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()
Local oReport  	:= nil
Local oSB1 	   	:= nil
Local cDesc		:= ""
Local oBreak	:= nil 

cDesc += "Este programa tem como objetivo imprimir o  "
cDesc += "Mapa de Valores dos editais e os produtos "

DEFINE REPORT oReport NAME "XGCPTRP01" TITLE cTitulo PARAMETER cPerg ACTION {|oReport|RepGCP(oReport)} DESCRIPTION cDesc 
		DEFINE SECTION oCO1 			OF oReport TITLE "Licitação" TABLES "CO1","CO2","CO3"//"Licitação"
		DEFINE CELL NAME "CO1_CODEDT"  	OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_NUMPRO"   OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_REGRA"	OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_DTADJU"	OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CO2_CODPRO" 	OF oCO1 ALIAS "CO2" 
		DEFINE CELL NAME "DESCRI"		OF oCO1 BLOCK {|| GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+(cAliasQry)->CO2_CODPRO,1) } SIZE 25 TITLE "Descri. Prod." LINE BREAK AUTO SIZE
		DEFINE CELL NAME "CO3_VLUNIT" 	OF oCO1 ALIAS "CO3"
		DEFINE CELL NAME "CO3_VALATU" 	OF oCO1 ALIAS "CO3"
		DEFINE CELL NAME "CO3_CODIGO" 	OF oCO1 ALIAS "CO3" 
		DEFINE CELL NAME "CO3_LOJA" 	OF oCO1 ALIAS "CO3"
		DEFINE CELL NAME "CO1_MODALI" 	OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_DTPUBL" 	OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CONTRATO"	    OF oCO1 BLOCK {|| IIF((cAliasQry)->CO3_STATUS == "5", (cAliasQry)->CN9_NUMERO, "")} SIZE 25 TITLE "Num. Contrato" LINE BREAK AUTO SIZE  //"Num. Contrato

		oCO1:SetAutoSize()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RepGCP  ºAutor  ³ Totvs              º Data ³  01/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega as definiçoes as informações do relatorio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                 

Static Function RepGCP(oReport)
Local oCO1 := oReport:Section(1)

Pergunte(cPerg,.F.)

BEGIN REPORT QUERY oCO1

BeginSql alias cAliasQry

SELECT 
	CO1_CODEDT,
	CO1_NUMPRO,
	CO1_ETAPA,
	CO1_MODALI,
	CO1_REVISA,
	CO1_REGRA,
	CO1_DTADJU,
	CO2_CODEDT,
	CO2_NUMPRO,
	CO2_ITEM,
	CO2_CODPRO,
	CO2_QUANT,
	CO3_CODEDT,
	CO3_NUMPRO,
	CO3_CODPRO,
	CO3_CODIGO,
	CO3_LOJA,
	CO3_VLUNIT,
	CO3_VALATU,
	CO3_TIPO,
	CO3_STATUS,
	CN9_NUMERO,
	CN9_REVISA,
	CN9_CODED,
	CN9_CODENT,
	CN9_NUMERO,
	CN9_REVISA
FROM
	%table:CO2% CO2
INNER JOIN CO1010 CO1 ON
	CO2_CODEDT = CO1_CODEDT AND 
	CO2_NUMPRO = CO1_NUMPRO	AND
	CO2_FILIAL = %xfilial:CO2% AND
	CO1_FILIAL = %xfilial:CO1% AND
	CO2.%NotDel% AND
	CO1.%NotDel%
INNER JOIN CO3010 CO3 ON
	CO2_CODEDT 	= CO3_CODEDT AND 
	CO2_NUMPRO	= CO3_NUMPRO AND
	CO2_CODPRO 	= CO3_CODPRO AND
	CO3_FILIAL = %xfilial:CO3% AND
	CO3.%NotDel% 
LEFT JOIN CN9010 CN9 ON
	CO1_CODEDT = CN9_CODED AND
	CO1_NUMPRO = CN9_NUMPR AND
	CO1_REVISA = CN9_REVISA AND
	CN9_FILIAL = %xfilial:CN9% AND
	CN9.%NotDel% 
WHERE
	CO1_CODEDT  >= %EXP:MV_PAR01% AND
	CO1_CODEDT <= %EXP:MV_PAR02%

ORDER BY CO1_CODEDT, CO1_NUMPRO

EndSql

END REPORT QUERY oCO1

oCO1:Print() 
	
Return

Static Function CriaSX1(cPerg)

putSx1(cPerg, '01', 'Edital de?'  , '', '', 'mv_ch1', 'C', 15, 0, 0, 'G', '', 'CO1', '', '', 'mv_par01')
putSx1(cPerg, '02', 'Edital até?' , '', '', 'mv_ch2', 'C', 15, 0, 0, 'G', '', 'CO1', '', '', 'mv_par02')

Return(.T.)

Return(cRet)