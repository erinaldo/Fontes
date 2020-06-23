#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PROCR010  ºAutor  ³ Tiago Prata          º Data ³  24/01/15º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Solicitação x Análise de Mercado                 º±±
±±º          ³ COMPRAS -> RELATÓRIOS-> ESPECIFICOS -> Solicitação x An.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROCR010()

Local   oReport		:= nil
Private cTitulo		:= "Solicitação x Análise de Mercado" 
Private cPerg		:= "XGCPR001"   
Private cAliasQry 	:= GetNextAlias()

If TRepInUse()
	CriaSX1(cPerg)
	oReport:= ReportDef()
	oReport:PrintDialog()  // Imprime o Relatório
Else
	Alert("Este relatório só está disponível a partir da Release 4.")//"Este relatório só está disponível a partir da Release 4."
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef  ºAutor  ³ Tiago Prata         º Data ³  24/01/15º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Solicitação x Análise de Mercado                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport  	:= nil
Local oSB1 	   	:= nil
Local cDesc		:= ""
Local oBreak	:= nil 

cDesc += "Este programa tem como objetivo imprimir o  "
cDesc += "as Solicitações x Análise de Mercado "

DEFINE REPORT oReport NAME "PROCR010" TITLE cTitulo PARAMETER cPerg ACTION {|oReport|RepGCP(oReport)} DESCRIPTION cDesc 
		DEFINE SECTION oSB1 			OF oReport TITLE "Solicitação x Análise de Mercado" TABLES "SC1","COO","CON","COP","COM"//Análise de Mercado
		DEFINE CELL NAME "C1_FILIAL"  	OF oSB1 ALIAS "SC1"
		DEFINE CELL NAME "C1_NUM   "    OF oSB1 ALIAS "SC1"
		DEFINE CELL NAME "C1_ITEM" 		OF oSB1 ALIAS "SC1" 
		DEFINE CELL NAME "ANMERCADO"	OF oSB1 BLOCK {|| (cAliasQry)->COO_CODIGO } SIZE 25 TITLE "An.Mercado" LINE BREAK AUTO SIZE	
//		DEFINE CELL NAME "COO_CODIGO" 	OF oSB1 ALIAS "COO"
		DEFINE CELL NAME "COM_REGRA" 	OF oSB1 ALIAS "COM"
		DEFINE CELL NAME "COM_DATA" 	OF oSB1 ALIAS "COM"
		DEFINE CELL NAME "CON_CODPRO" 	OF oSB1 ALIAS "CON"
		DEFINE CELL NAME "CON_QUANT" 	OF oSB1 ALIAS "CON"
		DEFINE CELL NAME "COP_CODFOR" 	OF oSB1 ALIAS "COP"
		DEFINE CELL NAME "COP_LOJFOR" 	OF oSB1 ALIAS "COP" 
		DEFINE CELL NAME "COP_PRCUN" 	OF oSB1 ALIAS "COP"
		DEFINE CELL NAME "COP_VALTOT" 	OF oSB1 ALIAS "COP"
				
		oSB1:SetAutoSize()

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RepGCP    ºAutor  ³ Tiago Prata          º Data ³  24/01/15º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Solicitação x Análise de Mercado                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GCP - Gestão de Compras Publicas                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 

Static Function RepGCP(oReport)
Local oSB1 		:= oReport:Section(1)

Pergunte(cPerg,.F.)

BEGIN REPORT QUERY oSB1

BeginSql alias cAliasQry

SELECT 
	C1_NUM,
	C1_ITEM,
	C1_PRODUTO,	
	COO_CODIGO,
	COO_CODPRO,
	COO_NUMSC,
	COO_ITEMSC,
	COM_REGRA,
	COM_DATA,
	CON_CODPRO,
	CON_QUANT,
	COP_CODFOR,
	COP_LOJFOR,
	COP_PRCUN,
	COP_VALTOT
FROM 
	%table:SC1% SC1
INNER JOIN %table:COO% COO ON
	C1_NUM = COO_NUMSC AND 
	C1_ITEM = COO_ITEMSC	AND
	C1_PRODUTO = COO_CODPRO AND
	C1_FILIAL = %xfilial:SC1% AND
	COO_FILIAL = %xfilial:COO% AND
	SC1.%NotDel% AND
	COO.%NotDel%
INNER JOIN %table:CON% CON ON
	COO_CODIGO 	= CON_CODIGO AND
	COO_CODPRO = CON_CODPRO AND 
	CON_FILIAL	= %xfilial:CON% AND
	CON.%NotDel%
INNER JOIN %table:COP% COP ON
	CON_CODIGO 	= COP_CODIGO AND
	CON_CODPRO = COP_CODPRO AND	 
	COP_FILIAL	= %xfilial:COP% AND
	COP.%NotDel%
INNER JOIN %table:COM% COM ON
	COP_CODIGO 	= COM_CODIGO AND 
	COM_FILIAL	= %xfilial:COM% AND
	COM.%NotDel%
WHERE 
	C1_NUM >= %EXP:MV_PAR01% AND
	C1_NUM <= %EXP:MV_PAR02% AND
	C1_EMISSAO >= %EXP:MV_PAR03% AND
	C1_EMISSAO <= %EXP:MV_PAR04%

ORDER BY C1_NUM, C1_ITEM, C1_PRODUTO

EndSql

END REPORT QUERY oSB1

//TRPosition():New(oSB1, "SB1", 1, {|| xFilial("SB1") + (cAliasQry)->CO2_NUMPRO }) //B1_FILIAL+B1_COD

oSB1:Print() 
	
Return

Static Function CriaSX1(cPerg)

putSx1(cPerg, '01', 'Solicitação de?'          , '', '', 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'SC1', '', '', 'mv_par01')
putSx1(cPerg, '02', 'Solicitação até?'         , '', '', 'mv_ch2', 'C', 6, 0, 0, 'G', '', 'SC1', '', '', 'mv_par02') 
putSx1(cPerg, '03', 'Emissão de?'              , '', '', 'mv_ch3', 'D', 8, 0, 0, 'G', '', '' , '', '', 'mv_par03')
putSx1(cPerg, '04', 'Emissão até?'             , '', '', 'mv_ch4', 'D', 8, 0, 0, 'G', '', '' , '', '', 'mv_par04')
                                          
Return(.T.)