#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PROCR030 บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Quadro de Licita็๕es                          บฑฑ
ฑฑบ          ณ GCP -> RELATORIOS -> LICITACOES -> Licita็๕es - Hist๓rico  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function PROCR030()

Local   oReport		:= nil
Private cTitulo		:= "Quadro de Licita็๕es" //"Quadro de Licita็๕es"
Private cPerg		:= "GCR002"   
Private cAliasQry 	:= GetNextAlias()

If TRepInUse()
	oReport:= ReportDef()
	oReport:PrintDialog()  // Imprime o Relat๓rio
Else
	Alert("Este relat๓rio s๓ estแ disponํvel a partir da Release 4.")//"Este relat๓rio s๓ estแ disponํvel a partir da Release 4."
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDefบAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega as defini็oes do relatorio                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport  	:= nil
Local oCO1 	   	:= nil
Local cDesc		:= ""
Local oBreak	:= nil 

cDesc += "Este programa tem como objetivo imprimir a  "
cDesc += "listagem dos editais e os produtos "

DEFINE REPORT oReport NAME "GCPR002" TITLE cTitulo PARAMETER cPerg ACTION {|oReport|RepGCP(oReport)} DESCRIPTION cDesc 
		DEFINE SECTION oCO1 			OF oReport TITLE "Licita็ใo" TABLES "CO1"//"Licita็ใo"
		DEFINE CELL NAME "CO1_CODEDT"  	OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_NUMPRO"   OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "CO1_DTABER" 	OF oCO1 ALIAS "CO1" 
		DEFINE CELL NAME "CO1_DTPUBL" 	OF oCO1 ALIAS "CO1"
		DEFINE CELL NAME "REGRA"	    OF oCO1 BLOCK {|| U_XGCPR02REG() } SIZE 25 TITLE "Regra" LINE BREAK AUTO SIZE  //"Modalidade"
		DEFINE CELL NAME "MODALIDADE"	OF oCO1 BLOCK {|| U_XGCPR02MOD() } SIZE 25 TITLE "Modalidade" LINE BREAK AUTO SIZE  //"Modalidade"
		DEFINE CELL NAME "TIP MODAL"	OF oCO1 BLOCK {|| U_XGCPR022TP() } SIZE 25 TITLE "Tipo Modal" LINE BREAK AUTO SIZE  //"Tipo Modal"
		DEFINE CELL NAME "ETAPA"		OF oCO1 BLOCK {|| U_XGCPR02ETP() } SIZE 25 TITLE "Etapa" LINE BREAK AUTO SIZE  //"Etapa"
		
		DEFINE SECTION oCO2 OF oCO1 TITLE "Produtos do Edital" TABLES "CO2","SB1" //"Produtos do Edital"
			DEFINE CELL NAME "CO2_ITEM" 		OF oCO2 ALIAS "CO2" LINE BREAK AUTO SIZE
			DEFINE CELL NAME "CO2_CODPRO" 		OF oCO2 ALIAS "CO2" LINE BREAK AUTO SIZE
			DEFINE CELL NAME "B1_DESC" 	   		OF oCO2 ALIAS "SB1" LINE BREAK AUTO SIZE
//			DEFINE CELL NAME 'CO2_QUANT' 		OF oCO2 ALIAS "CO2" LINE BREAK AUTO SIZE
			DEFINE CELL NAME 'CO2_QUANT' 		OF oCO2 BLOCK {|| U_XGCPR02TOT("2") } LINE BREAK AUTO SIZE

			DEFINE CELL NAME 'CO2_LOTE' 		OF oCO2 ALIAS "CO2" LINE BREAK AUTO SIZE
			
			DEFINE SECTION oCO3 OF oCO2 TITLE "Forcedores/Clientes" TABLES "CO3" //"Forcedores/Clientes"
				DEFINE CELL NAME 'TIPO' 			   	OF oCO3 BLOCK {|| U_XGCPR02TIP() } SIZE 25 TITLE "Tipo" LINE BREAK AUTO SIZE //"Tipo"
				DEFINE CELL NAME 'CO3_CODIGO' 			OF oCO3 ALIAS "CO3" LINE BREAK AUTO SIZE
				DEFINE CELL NAME 'CO3_LOJA' 	   		OF oCO3 ALIAS "CO3" LINE BREAK AUTO SIZE
				DEFINE CELL NAME 'NOME' 	   	   		OF oCO3 BLOCK {|| U_XGCPR02FOR() } SIZE TamSX3("A1_NOME")[1] TITLE "Nome" LINE BREAK AUTO SIZE //"Nome"
				DEFINE CELL NAME 'CO3_VLUNIT' 	   		OF oCO3 ALIAS "SB1" LINE BREAK AUTO SIZE
				DEFINE CELL NAME 'VALOR_TOTAL' 	   		OF oCO3 BLOCK {|| U_XGCPR02TOT() }  TITLE "Valor Total" LINE BREAK AUTO SIZE PICTURE X3Picture("CO3_VLUNIT") //"Valor Total"
				DEFINE CELL NAME 'CLASSIFICACAO'   		OF oCO3 BLOCK {|| IIF ( ((cAliasQry)->CO3_CLASS=='1' .Or. (cAliasQry)->CO3_CLAANT=='1' ), "Ganhador","Nao Classificado" )  } SIZE 15 TITLE "Classifica็ใo" LINE BREAK AUTO SIZE //"Ganhador"##"Nao Classificado"##"Classifica็ใo"

		oCO1:SetAutoSize()
		oCO2:SetAutoSize()
		oCO3:SetAutoSize()		
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCPR02ETP บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a etapa do Edital                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCPR02ETP()
Local aArea := GetArea()
Local cRet	:= ""

dbSelectArea("SX5")
dbSetOrder(1)
If MsSeek(xFilial()+"LE"+(cAliasQry)->CO1_ETAPA)
	cRet := (cAliasQry)->CO1_ETAPA + " - " + AllTrim(X5Descri())
EndIf

RestArea( aArea )
Return cRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCPR02TIP บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a Tipo Modalidade                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XGCPR022TP()
Local aArea := GetArea()
Local cRet	:= ""

dbSelectArea("SX5")
dbSetOrder(1)

If MsSeek(xFilial()+"LG"+(cAliasQry)->CO1_TIPO)
	cRet := (cAliasQry)->CO1_TIPO + " - " + AllTrim(X5Descri())
EndIf

RestArea( aArea )
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCPR02MOD บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a modalidade do Edital                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCPR02MOD()
Local aArea := GetArea()
Local cRet	:= ""

dbSelectArea("SX5")
dbSetOrder(1)
If MsSeek(xFilial()+"LF"+(cAliasQry)->CO1_MODALI)
	cRet := (cAliasQry)->CO1_MODALI + " - " + AllTrim(X5Descri())
EndIf

RestArea( aArea )
Return cRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCPR02FOR บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o fornecedor do edital                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCPR02FOR()
Local aArea := GetArea()
Local cRet	:= ""
Local cModCli := SuperGetMV("MV_GCPMCLI",,"LL\") 

If !(Empty( (cAliasQry)->CO3_CODIGO ))
    If (cAliasQry)->CO3_TIPO == "2" 
		If (cAliasQry)->CO1_MODALI $ cModCli
			cRet:= GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+(cAliasQry)->(CO3_CODIGO+CO3_LOJA)	,1) 
	    Else
	    	cRet:= GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+(cAliasQry)->(CO3_CODIGO+CO3_LOJA)	,1)
	    EndIf
	 Else
	 	cRet:= GetAdvFVal("CO6",'CO6_NOME',xFilial("CO6")+(cAliasQry)->(CO3_CODIGO)	,1)
	 EndIf
EndIf

RestArea( aArea )
Return cRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCPR02FOR บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o fornecedor do edital                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCPR02REG()
Local aArea := GetArea()
Local cRet	:= ""

If !(Empty( (cAliasQry)->CO1_REGRA ))
			cRet:= (cAliasQry)->CO1_REGRA+' - '+GetAdvFVal("CO0","CO0_DSCRGR",xFilial("CO0")+(cAliasQry)->CO1_REGRA,1) 
EndIf

RestArea( aArea )
Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCPR02TIP บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o tipo do fornecedor   		                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCPR02TIP()
Local aArea := GetArea()
Local cRet	:= ""
Local cModCli := SuperGetMV("MV_GCPMCLI",,"LL\") 

If (cAliasQry)->CO1_MODALI $ cModCli
	cRet:= IIF ( (cAliasQry)->CO3_TIPO == '1' , "Pre-Cliente","Cliente" )//"Pre-Cliente"##"Cliente"
Else
   	cRet:= IIF ( (cAliasQry)->CO3_TIPO == '1' , "Pre-Fornecedor","Fornecedor" )//"Pre-Fornecedor"##"Fornecedor"
EndIf

RestArea( aArea )
Return cRet 
//-------------------------------------------------------------------
/*{Protheus.doc} GCPR02TOT
Retorna totais conforme avaliacao do edital

@author Alex Egydio
@since 09/04/2013
@version P11.80
*/
//-------------------------------------------------------------------
User Function XGCPR02TOT(cAcao)
Local nRet		:= 0
Local nQuant	:= (cAliasQry)->CO2_QUANT 
Local aSldItem	:= {(cAliasQry)->CO1_CODEDT,(cAliasQry)->CO1_NUMPRO,(cAliasQry)->CO2_CODPRO}
Default cAcao := "1"

GCPSldItem("3",aSldItem)
//-- Se nao efetuou a entrega total, abate a quantidade ja entregue (CO2_QUANT - C7_QUJE)
//-- Se efetuou a entrega total devera permanecer com a quantidade original CO2_QUANT
If	aSldItem[1]<nQuant
	nQuant -= aSldItem[1]
EndIf		

If	cAcao == "1"
	//-- Avaliacao por Item
	If	(cAliasQry)->CO1_AVAL$" 1"
	
		nRet := (cAliasQry)->CO3_VLUNIT * nQuant
	//-- Avaliacao por lote ou edital
	Else
	
		If	(cAliasQry)->CO3_CLASS=='1' .Or. (cAliasQry)->CO3_CLAANT=='1'
			nRet := (cAliasQry)->CO3_VLUNIT * nQuant
		EndIf
	
	EndIf
ElseIf cAcao == "2"
	nRet := nQuant
EndIf
	
Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRepGCP  บAutor  ณ Totvs              บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega as defini็oes as informa็๕es do relatorio          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCP - Gestใo de Compras Publicas                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RepGCP(oReport)
Local oCO1 		:= oReport:Section(1)
Local oCO2 		:= oReport:Section(1):Section(1)
Local oCO3 		:= oReport:Section(1):Section(1):Section(1)

Pergunte(cPerg,.F.)

BEGIN REPORT QUERY oCO1

BeginSql alias cAliasQry

SELECT 
	CO1_CODEDT,
	CO1_NUMPRO,
	CO1_ETAPA,
	CO1_MODALI,
	CO1_AVAL,
	CO1_TIPO,
	CO1_REGRA,
	CO2_CODEDT,
	CO2_NUMPRO,
	CO2_ITEM,
	CO2_CODPRO,
	CO2_CODPRO,
	CO2_QUANT,
	CO2_LOTE,
	CO3_CODEDT,
	CO3_NUMPRO,
	CO3_CODPRO,
	CO3_CODIGO,
	CO3_LOJA,
	CO3_VLUNIT,
	CO3_TIPO,
	CO3_CLASS,
	CO3_CLAANT
	
FROM 
	%table:CO1% CO1 
INNER JOIN %table:CO2% CO2 ON
	CO1_CODEDT 	= CO2_CODEDT AND 
	CO1_NUMPRO	= CO2_NUMPRO AND
	CO1_FILIAL   = %xfilial:CO1% AND
	CO2_FILIAL   = %xfilial:CO2% AND
	CO1.%NotDel% AND
	CO2.%NotDel%
LEFT JOIN %table:CO3% CO3 ON
	CO2_CODEDT 	= CO3_CODEDT AND 
	CO2_NUMPRO	= CO3_NUMPRO AND
	CO2_CODPRO 	= CO3_CODPRO AND
	CO3_FILIAL	= %xfilial:CO3% AND
	CO3_REVOGA <> '1' AND
	CO3.%NotDel%
WHERE 
	CO1_CODEDT >= %EXP:MV_PAR01%   //	AND
	/*CO1_NUMPRO >= %EXP:MV_PAR02%	AND
	CO1_CODEDT <= %EXP:MV_PAR03%	AND
	CO1_NUMPRO <= %EXP:MV_PAR04%	AND
	CO1_DTABER >= %EXP:MV_PAR05%	AND
	CO1_DTABER <= %EXP:MV_PAR06%    AND
	CO1_REGRA   = %EXP:MV_PAR07%    AND
	CO1_MODALI >= %EXP:MV_PAR08%	AND
	CO1_MODALI <= %EXP:MV_PAR09%	AND
	CO1_TIPO   >= %EXP:MV_PAR10%	AND
	CO1_TIPO   <= %EXP:MV_PAR11%  */		
						
//ORDER BY CO1_CODEDT, CO1_NUMPRO

EndSql

END REPORT QUERY oCO1

oCO2:SetParentQuery()
oCO2:SetParentFilter({|cParam| (cAliasQry)->(CO2_CODEDT + CO2_NUMPRO) == cParam},{|| (cAliasQry)->(CO1_CODEDT + CO1_NUMPRO)})
oCO3:SetParentQuery()
oCO3:SetParentFilter({|cParam| (cAliasQry)->(CO3_CODEDT + CO3_NUMPRO + CO3_CODPRO) == cParam},{|| (cAliasQry)->(CO2_CODEDT + CO2_NUMPRO + CO2_CODPRO)})

TRPosition():New(oCO2, "SB1", 1, {|| xFilial("SB1") + (cAliasQry)->CO2_CODPRO }) //B1_FILIAL+B1_COD

oCO1:Print() 
	
Return
