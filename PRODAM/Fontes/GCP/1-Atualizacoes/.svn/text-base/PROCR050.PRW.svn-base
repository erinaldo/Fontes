#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PROCR050  ºAutor  ³ Kaique Schiller     º Data ³  26/01/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Licitações por Produto.                       º±±
±±º          ³ COMPRAS -> Relatorios -> Especificos -> Mapa de Valores Ed.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROCR050()

Local   oReport		:= nil
Private cTitulo		:= "Mapa de Valores Edital" //"Quadro de Licitações"
Private cPerg		:= "XCOMT"   
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
±±ºPrograma  ³ReportDefºAutor  ³ Kaique Schiller     º Data ³  26/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega as definiçoes do relatorio                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                           º±±
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

DEFINE REPORT oReport NAME "XCOMTRP01" TITLE cTitulo PARAMETER cPerg ACTION {|oReport|RepGCP(oReport)} DESCRIPTION cDesc 
		DEFINE SECTION oSB1 			OF oReport TITLE "Licitação" TABLES "CO1","CO2","CO3"//"Licitação"
		DEFINE CELL NAME "CO1_CODEDT"  	OF oSB1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_NUMPRO"   OF oSB1 ALIAS "CO1"
		DEFINE CELL NAME "CO3_CODIGO" 	OF oSB1 ALIAS "CO3" 
		DEFINE CELL NAME "TIPO"			OF oSB1 BLOCK {|| IIF((cAliasQry)->CO3_TIPO == "1","PRÉ-LICI","LICI")} SIZE 25 TITLE "Tipo" LINE BREAK AUTO SIZE  // Tipo
		DEFINE CELL NAME "CO3_LOJA" 	OF oSB1 ALIAS "CO3"
		DEFINE CELL NAME "CO2_CODPRO" 	OF oSB1 ALIAS "CO2"
		DEFINE CELL NAME "CO2_QUANT" 	OF oSB1 ALIAS "CO2"
		DEFINE CELL NAME "CO3_VLUNIT" 	OF oSB1 ALIAS "CO3"
		DEFINE CELL NAME "CO3_VALATU" 	OF oSB1 ALIAS "CO3"
		DEFINE CELL NAME "CO1_MODALI" 	OF oSB1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_DTPUBL" 	OF oSB1 ALIAS "CO1"
		DEFINE CELL NAME "GRUPO"	    OF oSB1 BLOCK {|| XCOMTRPA1() } SIZE 25 TITLE "Desc. Grupo" LINE BREAK AUTO SIZE  //"Grupo Prod."
				
		oSB1:SetAutoSize()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RepGCP  ºAutor  ³ Kaique Schiller    º Data ³  26/01/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega as definiçoes as informações do relatorio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                 

Static Function RepGCP(oReport)
Local oSB1 := oReport:Section(1)

Pergunte(cPerg,.F.)

BEGIN REPORT QUERY oSB1

BeginSql alias cAliasQry


SELECT 
	CO1_CODEDT,
	CO1_NUMPRO,
	CO1_ETAPA,
	CO1_MODALI,
	CO1_DTPUBL,
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
	CO3_TIPO
FROM 
	%table:CO2% CO2
INNER JOIN %table:CO1% CO1 ON
	CO2_CODEDT = CO1_CODEDT AND 
	CO2_NUMPRO = CO1_NUMPRO	AND
	CO2_FILIAL = %xfilial:CO2% AND
	CO1_FILIAL = %xfilial:CO1% AND
	CO2.%NotDel% AND
	CO1.%NotDel%
INNER JOIN %table:CO3% CO3 ON
	CO2_CODEDT 	= CO3_CODEDT AND 
	CO2_NUMPRO	= CO3_NUMPRO AND
	CO2_CODPRO 	= CO3_CODPRO AND
	CO3_FILIAL	= %xfilial:CO3% AND
	CO3.%NotDel%
WHERE 
	CO2_CODPRO >= %EXP:MV_PAR01% AND
	CO2_CODPRO <= %EXP:MV_PAR02%

ORDER BY CO1_CODEDT, CO1_NUMPRO

EndSql

END REPORT QUERY oSB1

oSB1:Print() 
	
Return

/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria perguntas no SX1							          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
*/

Static Function CriaSX1(cPerg)

putSx1(cPerg, '01', 'Produto de?'  , '', '', 'mv_ch1', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par01')
putSx1(cPerg, '02', 'Produto até?' , '', '', 'mv_ch2', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par02')

Return(.T.)

Static Function XCOMTRPA1()
Local aArea := GetArea()
Local cRet	:= ""

If !(Empty((cAliasQry)->CO2_CODPRO))
	cRet:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+(cAliasQry)->CO2_CODPRO,1) 
	cRet:= GetAdvFVal("SBM","BM_DESC",xFilial("SBM")+cRet,1)
EndIf

RestArea(aArea)

Return(cRet)