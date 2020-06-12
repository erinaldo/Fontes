#include "rwmake.ch"
#include "TOPCONN.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DTMSA006  ºAutor  ³TOTVS               º Data ³  XX/XX/XX   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação CT-e (TMS) funcao TMSIMPDOC                     º±±
±±           ³aCabDTC   DTC                                               º±±
±±           ³aItem     DTC (pode haver mais de 1 registro do Cliente)    º±±
±±           ³                                                            º±±
±±           ³aVetDoc   DT6                                               º±±
±±           ³aVetVlr   DT8 (2 registros)                                 º±±
±±           ³aVetNFc   DTC                                               º±±
±±           ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DHL                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DTMS006()

Local aCores    := {	{ 'ZZ0_STATUS == "1"'  , "BR_AMARELO"},;
						{ 'ZZ0_STATUS == "2"'  , "BR_VERDE"},;
						{ 'ZZ0_STATUS == "3"'  , "BR_VERMELHO"},;
						{ 'ZZ0_STATUS == "4"'  , "BR_AZUL"}}

LOCAL cAlias		:= "ZZ0"
//Local bTimer		:= {|| atubrw() }

Private cCadastro  := "Importação CT-e"
Private aRotina    :=  GCTE01Mnu()
Private aPos       := {15, 1, 70, 315}

Private xChvCteOrig	:= ""
Private xDocTMS		:= ""
Private xDocOri		:= ""
Private xSerOri		:= ""
Private xCodNFe		:= ""
Private _lCTeComp		:= .F.
Private _lCTeAnul		:= .F.
Private _lCTeCanc		:= .F.
Private X6_FILDOC		:= ""
Private X6_DOC		:= ""
Private X6_SERIE		:= ""
Private XC_DEVFRE 	:= ""
Private X6_CHVCTE    := ""
Private X6_CODNFE    := ""
Private X8_XCFOP     := ""
Private _Cliente     := ""
Private _Loja        := ""

dbSelectArea(cAlias)
dbOrderNickname('ZZ0IND2')

/*
mBrowse(,,,,cAlias,,,,,,aCores,,,,,,,,,2000,bTimer)
*/
mBrowse(,,,,cAlias,,,,,,aCores,,,,,,,,,)

Return

static function atubrw()
 	_obrw:= GetObjBrow()
 	_obrw:Default() 
 	_obrw:Refresh()
return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Mnu ºAutor  ³TOTVS               º Data ³  XX/XX/XX   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao de Menu                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DHL                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GCTE01Mnu()
Local _aRet := {}

aAdd( _aRet ,{"Pesquisar" 			,'AxPesqui'		,0,1})
aAdd( _aRet ,{"Visualizar"			,'u_GCTE01Vis'	,0,2})
aAdd( _aRet ,{"Importacao"         ,'U_GCTE01Imp'	,0,3})
aAdd( _aRet ,{"Limpar Log"			,'U_GCTE01Limp'	,0,4})
aAdd( _aRet ,{"Reprocessar"			,'U_GCTE01Repr'	,0,4})
aAdd( _aRet ,{"Limpa Base"			,'U_GCTE01Clea'	,0,4})
aAdd( _aRet ,{"Legenda"   			,'U_GCTE01Leg'	,0,6})

Return(_aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIGCTX01  ºAutor  ³TOTVS               º Data ³  XX/XX/XX   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visualizar                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DHL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCTE01Vis()
Local aButtons := {}

AxVisual("ZZ0", ZZ0->(Recno()),1,,,,, aButtons, .T.)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Leg   ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Legenda                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCTE01Leg()
Local aCor := {}

aAdd(aCor,{"BR_AMARELO"		,"Importado"			})	//1-Importado
aAdd(aCor,{"BR_VERDE" 		,"Processado"			})	//2-Processamento
aAdd(aCor,{"BR_VERMELHO"		,"Invalido"			})	//3-Invalido
aAdd(aCor,{"BR_AZUL"			,"Em Processamento"	})	//4-Em Processamento

BrwLegenda(cCadastro,OemToAnsi("Importação CT-e"),aCor)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Limp  ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Limpar Log Registros com erro                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCTE01Limp

aPerguntas := {}
aRetorno   := {}

//Perguntas
Aadd(aPerguntas,{ 1,"Filial De"  ,Space(4),"@!","","","",0,	.T.})
Aadd(aPerguntas,{ 1,"Filial Ate"  ,Space(4),"@!","","","",0,	.T.})

If !ParamBox(aPerguntas,"Limpa Log",@aRetorno)
	Return(Nil)
EndIf

If !MsgYesNo("Apagar LOG Registros com problema. Deseja continuar?")
	Return
Else
	
	_cQuery := "UPDATE "+RetSqlName("ZZA")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE ZZA_NUMERO IN (SELECT ZZ0_NUMERO FROM "+RetSqlName("ZZ0")+" WHERE D_E_L_E_T_ = '' AND ZZ0_STATUS = '3')"
	_cQuery += "AND ZZA_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "UPDATE "+RetSqlName("ZZB")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE ZZB_NUMERO IN (SELECT ZZ0_NUMERO FROM "+RetSqlName("ZZ0")+" WHERE D_E_L_E_T_ = '' AND ZZ0_STATUS = '3')"
	_cQuery += "AND ZZB_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "UPDATE "+RetSqlName("ZZC")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE ZZC_NUMERO IN (SELECT ZZ0_NUMERO FROM "+RetSqlName("ZZ0")+" WHERE D_E_L_E_T_ = '' AND ZZ0_STATUS = '3')"
	_cQuery += "AND ZZC_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "UPDATE "+RetSqlName("ZZ0")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE D_E_L_E_T_ = '' AND ZZ0_STATUS = '3'"
	_cQuery += "AND ZZ0_FILDOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)
	
	//Pack na Base de Importação
	//--------------------------------------------------------------------------------------------------------------------------------
	_cQuery := "DELETE "+RetSqlName("ZZ0")+" WHERE D_E_L_E_T_ = '*' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "DELETE "+RetSqlName("ZZA")+" WHERE D_E_L_E_T_ = '*' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "DELETE "+RetSqlName("ZZB")+" WHERE D_E_L_E_T_ = '*' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "DELETE "+RetSqlName("ZZC")+" WHERE D_E_L_E_T_ = '*' "
	TCSQLEXEC(_cQuery)
	//--------------------------------------------------------------------------------------------------------------------------------
	
	alert("tabelas apagadas!!!")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Repr  ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Reprocessa Registros que ficaram no Status 4               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCTE01Repr()

aPerguntas := {}
aRetorno   := {}

//Perguntas
Aadd(aPerguntas,{ 1,"Filial De"  ,Space(4),"@!","","","",0,	.T.})
Aadd(aPerguntas,{ 1,"Filial Ate"  ,Space(4),"@!","","","",0,	.T.})

If !ParamBox(aPerguntas,"Reprocessar",@aRetorno)
	Return(Nil)
EndIf

If !MsgYesNo("Reprocessar registros Pendetes. Deseja continuar?")
	Return
Else
	_cQuery := "UPDATE "+RetSqlName("ZZ0")+" SET ZZ0_STATUS = '1' "
	_cQuery += "WHERE D_E_L_E_T_ = '' AND ZZ0_STATUS = '4' "
	_cQuery += "AND ZZ0_FILDOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' " 	
	TCSQLEXEC(_cQuery)
	
	alert("Finalizado!!!")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Clea  ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Limpa Base que ficaram no Status 4     	                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCTE01Clea()

aPerguntas := {}
aRetorno   := {}

//Perguntas
Aadd(aPerguntas,{ 1,"Filial De"  ,Space(4),"@!","","","",0,	.T.})
Aadd(aPerguntas,{ 1,"Filial Ate"  ,Space(4),"@!","","","",0,	.T.})

If !ParamBox(aPerguntas,"Limpa Base",@aRetorno)
	Return(Nil)
EndIf

If !MsgYesNo("Limpa Base registros Importados/Processados. Deseja continuar?")
	Return
Else

	_cQuery := "UPDATE "+RetSqlName("ZZA")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE ZZA_NUMERO IN (SELECT ZZ0_NUMERO FROM "+RetSqlName("ZZ0")+" WHERE D_E_L_E_T_ = '' AND (ZZ0_STATUS = '1' OR ZZ0_STATUS = '4'))"
	_cQuery += "AND ZZA_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "UPDATE "+RetSqlName("ZZB")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE ZZB_NUMERO IN (SELECT ZZ0_NUMERO FROM "+RetSqlName("ZZ0")+" WHERE D_E_L_E_T_ = '' AND (ZZ0_STATUS = '1' OR ZZ0_STATUS = '4'))"
	_cQuery += "AND ZZB_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "UPDATE "+RetSqlName("ZZC")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE ZZC_NUMERO IN (SELECT ZZ0_NUMERO FROM "+RetSqlName("ZZ0")+" WHERE D_E_L_E_T_ = '' AND (ZZ0_STATUS = '1' OR ZZ0_STATUS = '4'))"
	_cQuery += "AND ZZC_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)
	
	_cQuery := "UPDATE "+RetSqlName("ZZ0")+" SET D_E_L_E_T_ = '*' "
	_cQuery += "WHERE D_E_L_E_T_ = '' AND (ZZ0_STATUS = '1' OR ZZ0_STATUS = '4')"
	_cQuery += "AND ZZ0_FILDOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	TCSQLEXEC(_cQuery)

	alert("Finalizado!!!")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Imp   ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCTE01Imp()

Private oDlg     := NIL
Private cAnexo   := Space(200)
Private cMask    := "Todos os arquivos (*.*) |*.*|"
Private nOpc     := 2

Private _cDtIni  := Date()
Private _cHrIni  := TIME()

	DEFINE MSDIALOG oDlg TITLE "Importação CT-e" FROM 0,0 TO 350,570 OF oDlg PIXEL
	
	@ 051,003 SAY "Arquivo"    SIZE 30,7 PIXEL OF oDlg
	
	@ 050,035 MSGET cAnexo   PICTURE "@" SIZE 233, 8 PIXEL OF oDlg
	@ 049,269 BUTTON "..." SIZE 13,11 PIXEL OF oDlg ACTION cAnexo:=AllTrim(cGetFile(cMask,"Inserir anexo"))
	
	@ 100,060 BUTTON "&OK" SIZE 36,13 PIXEL ACTION (nOpc:=1,oDlg:End())
	@ 100,180 BUTTON "&Cancelar" SIZE 36,13 PIXEL ACTION (nOpc:=2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 2 //Cancelar
	Return
Else
	Processa( {|| GCTE01Run(cAnexo) }, "Processando Importação..." )
EndIf

DbSelectArea("ZZ0")
DbGotop()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Run   ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a Importacao                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GCTE01Run(cAnexo)

Private _cNumero := GetSxeNum("ZZ0","ZZ0_NUMERO") //Numero de Controle Amarrado nos Canais A, B e C

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o arquivo a ser importado                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArea   := GetArea()
MV_PAR01 := cAnexo
If (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	Help(" ",1,"NOFILE")
	Return
EndIf

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

_nLi	  := 1 //Linhas processadas
_lProc   := .F.

//Inicio Processamento arquivo
Do While !FT_FEOF()
	_cBuffer := FT_FREADLN()

	IncProc("Numero de Linhas "+ alltrim(strzero(_nLi,6)))
	
	Begin Transaction
		cFil := Substr(_cBuffer,032,004)
		cAliasQry := GetNextAlias()
		_cQuery := "SELECT COUNT(ZZ0_NUMERO) AS ZZ0_NREG FROM "+RetSqlName("ZZ0") "
		_cQuery += "WHERE D_E_L_E_T_ = '' AND ZZ0_STATUS = '4' AND ZZ0_FILDOC = '"+cFil+"' "
		_cQuery := ChangeQuery(_cQuery)
		DbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery), cAliasQry, .F., .T. )
		_nContReg := (cAliasQry)->ZZ0_NREG
		(cAliasQry)->( DbCloseArea() )
		If _nContReg > 0
			Aviso(cCadastro, "Ja existe Processamento para a "+CHR(13)+CHR(10)+"Filial "+cFil+" ", {"Sair"} )
			_lProc := .T.
		Else
			GCTE01Grv(_cNumero)
		EndIf

	End Transaction
	
	If _lProc
		Exit
	EndIf
	
	_nLi++
	FT_FSKIP()
	
EndDo

FT_FUSE()

_cQuery := "UPDATE "+RetSqlName("ZZ0")+" SET ZZ0_PROC = 'S' "
_cQuery += "WHERE D_E_L_E_T_ = '' AND ZZ0_NOMARQ = '"+cAnexo+"' "
TCSQLEXEC(_cQuery)

Aviso(cCadastro, "Importacao Arquivo"+CHR(13)+CHR(10)+"Iniciado em : "+dtoc(_cDtIni)+CHR(13)+CHR(10)+"Finalizado em: "+dtoc(Date())+" "+ELAPTIME(_cHrIni,TIME()), {"Sair"} )

RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Grv   ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação/Importacao                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GCTE01Grv()

If Substr(_cBuffer,1,1) == "A"
	GCTE01LerA(_cNumero)
ElseIf Substr(_cBuffer,1,1) == "B"
	GCTE01LerB(_cNumero)

	X6_DEVFRE  := Substr(_cBuffer,425,001)//1- REMENTENTE; 2-DESTINATARIO; 3-CONSIGNATARIO
	X6_CLIREM  := Substr(_cBuffer,353,014)//1
	X6_LOJREM  := Substr(_cBuffer,367,004)
	X6_CLIDES  := Substr(_cBuffer,371,014)//2
	X6_LOJDES  := Substr(_cBuffer,385,004)
	X6_CLIDEV  := Substr(_cBuffer,389,014)//3
	X6_LOJDEV  := Substr(_cBuffer,403,004)
	If X6_DEVFRE == "1"
		_Cliente	:= X6_CLIREM
		_Loja		:= X6_LOJREM
	ElseIf X6_DEVFRE == "2"
		_Cliente 	:= X6_CLIDES
		_Loja		:= X6_LOJDES
	ElseIf X6_DEVFRE == "3"
		_Cliente 	:= X6_CLIDEV
		_Loja		:= X6_LOJDEV
	EndIf
			
	X6_FILDOC  := Substr(_cBuffer,187,004)
	X6_DOC     := Substr(_cBuffer,191,009)
	X6_SERIE   := Substr(_cBuffer,200,003)
	X6_CHVCTE  := Substr(_cBuffer,492,044)
	X6_CODNFE  := Substr(_cBuffer,466,008)
	
	If !Empty(xChvCteOrig)
		If (xDocTMS == "8" .or. xDocTMS == "P") //Se este campo estiver preenchido é CT-e Complementar ou Substituição
			_lCTeComp	:= .T.
		ElseIf xDocTMS == "M" //Se este campo estiver preenchido é CT-e Anulação
			_lCTeAnul	:= .T.
		EndIf
	EndIf

	If substr(alltrim(xCodNFe),1,3) $ "101|102" //Cancelado e Inutilizado
		_lCTeCanc := .T.
	EndIf

ElseIf Substr(_cBuffer,1,1) == "C"
	GCTE01LerC(_cNumero)
	X8_XCFOP   := Substr(_cBuffer,146,004)
	
	GCTE01Tela(_cNumero,_Cliente,_Loja)
			
	ConfirmSx8()  //RollBackSX8()
	_cNumero := GetSxeNum("ZZ0","ZZ0_NUMERO")
			
EndIf

Return(_cNumero)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01Tela  ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela                                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GCTE01Tela(_cNumero,_Cliente,_Loja)

RecLock("ZZ0",.T.)
	ZZ0->ZZ0_FILIAL := xFilial("ZZ0")
	ZZ0->ZZ0_STATUS := "1"					//Importado
	ZZ0->ZZ0_NUMERO := _cNumero
	
	//1=Normal;2=Complem;3=Anulacao;4=Cancelado
	If _lCTeComp
		ZZ0->ZZ0_CTE    := "2"						//Complementar
	ElseIf _lCTeAnul
		ZZ0->ZZ0_CTE    := "3"						//Anulacao
	ElseIf _lCTeCanc
		ZZ0->ZZ0_CTE    := "4"						//Cancelado
	Else
		ZZ0->ZZ0_CTE    := "1"						//Normal
	EndIf
	ZZ0->ZZ0_FILDOC := X6_FILDOC
	ZZ0->ZZ0_DOC    := X6_DOC
	ZZ0->ZZ0_SERIE  := X6_SERIE
	ZZ0->ZZ0_NOMARQ  := cAnexo
	ZZ0->ZZ0_CLIENT  := _Cliente
	ZZ0->ZZ0_LOJA    := _Loja
	ZZ0->ZZ0_CHVCTE  := X6_CHVCTE
	ZZ0->ZZ0_CODRSE :=  X6_CODNFE
	ZZ0->ZZ0_CFOP    := X8_XCFOP
	ZZ0->ZZ0_PROC    := "N" //Sim ou Nao
	
ZZ0->(MsUnLock())

_lCTeComp	:= .F.
_lCTeAnul	:= .F.
_lCTeCanc	:= .F.
X6_FILDOC	:= ""
X6_DOC		:= ""
X6_SERIE	:= ""
XC_DEVFRE 	:= ""

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01LerA  ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Canal A                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GCTE01LerA(_cNumero)

RecLock("ZZA",.T.)
	
	ZZA_NUMERO := _cNumero
	
	ZZA_FILIAL := Substr(_cBuffer,032,004)
	ZZA_DATENT := Substr(_cBuffer,036,008)
	ZZA_NUMNFC := Substr(_cBuffer,044,009)
	ZZA_SERNFC := "   "
	ZZA_MOENFC := Substr(_cBuffer,053,001)
	ZZA_CODPRO := Substr(_cBuffer,054,018)
	ZZA_CODEMB := Substr(_cBuffer,072,003)
	ZZA_EMINFC := Substr(_cBuffer,075,008)
	ZZA_QTDVOL := Substr(_cBuffer,083,005)
	ZZA_PESO   := Substr(_cBuffer,088,010)
	ZZA_VALOR  := Substr(_cBuffer,099,013)
	ZZA_CLIREM := Substr(_cBuffer,113,014)
	ZZA_CLIDES := Substr(_cBuffer,127,014)
	ZZA_DEVFRE := Substr(_cBuffer,141,001) // Devedor do Frete
	ZZA_CLIDEV := Substr(_cBuffer,142,014)
	ZZA_LOJDEV := Substr(_cBuffer,156,004)
	ZZA_CLICAL := Substr(_cBuffer,160,014)
	ZZA_LOJCAL := Substr(_cBuffer,174,004)
	ZZA_TIPFRE := Substr(_cBuffer,178,001)
	ZZA_SERTMS := Substr(_cBuffer,179,001)
	ZZA_TIPTRA := Substr(_cBuffer,180,001)
	ZZA_SERVIC := Substr(_cBuffer,181,003)
	ZZA_TIPNFC := Substr(_cBuffer,184,001)
	ZZA_SELORI := Substr(_cBuffer,185,001)
	ZZA_CDRORI := Substr(_cBuffer,186,006)
	ZZA_REGORI := Substr(_cBuffer,192,030)
	ZZA_CDRDES := Substr(_cBuffer,222,006)
	ZZA_REGDES := Substr(_cBuffer,228,030)
	ZZA_CDRCAL := Substr(_cBuffer,258,006)
	ZZA_REGCAL := Substr(_cBuffer,264,030)
	ZZA_FILDOC := Substr(_cBuffer,294,004)
	ZZA_DOC    := Substr(_cBuffer,298,009)
	ZZA_SERIE  := Substr(_cBuffer,307,003)
	ZZA_MOEDA  := Substr(_cBuffer,310,002)
	ZZA_NFEID  := Substr(_cBuffer,312,044)
	ZZA_LOJREM := Substr(_cBuffer,356,004)
	ZZA_LOJDES := Substr(_cBuffer,360,004) 
	ZZA_CLICON := ""
	ZZA_LOJCON := ""
ZZA->(MsUnLock())

XC_DEVFRE := Substr(_cBuffer,141,001) //Devedor do Frete

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01LerB  ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Canal B                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GCTE01LerB(_cNumero)

RecLock("ZZB",.T.)

	ZZB_NUMERO := _cNumero

	ZZB_FILIAL  := Substr(_cBuffer,032,004)
	ZZB_AMBIEN  := Substr(_cBuffer,036,001)
	ZZB_RETCTE  := Substr(_cBuffer,037,150)
	ZZB_FILDOC  := Substr(_cBuffer,187,004)
	ZZB_DOC     := Substr(_cBuffer,191,009)
	ZZB_SERIE   := Substr(_cBuffer,200,003)
	ZZB_DATEMI  := Substr(_cBuffer,203,008)
	ZZB_HOREMI  := Substr(_cBuffer,211,004)
	ZZB_VOLORI  := Substr(_cBuffer,215,005)
	ZZB_QTDVOL  := Substr(_cBuffer,220,005)
	ZZB_PESO    := Substr(_cBuffer,225,009)
	ZZB_VALMER  := Substr(_cBuffer,235,013)
	ZZB_VALFRE  := Substr(_cBuffer,249,013)
	ZZB_VALIMP  := Substr(_cBuffer,263,013)
	ZZB_VALTOT  := Substr(_cBuffer,277,013)
	ZZB_SERTMS  := Substr(_cBuffer,291,001)
	ZZB_TIPTRA  := Substr(_cBuffer,292,001)
	ZZB_DOCTMS  := Substr(_cBuffer,293,001) //Documento de Transporte ( 2=CTRC;5=NF;8=COMPLEMENTAR;M=ANULAÇÃO;P=SUBSTITUIÇÃO )
	ZZB_CDRORI  := Substr(_cBuffer,294,006)
	ZZB_CDRDES  := Substr(_cBuffer,300,006)
	ZZB_CDRCAL  := Substr(_cBuffer,306,006)
	ZZB_TABFRE  := Substr(_cBuffer,312,004)
	ZZB_TIPTAB  := Substr(_cBuffer,316,002)
	ZZB_TIPFRE  := Substr(_cBuffer,318,001)
	ZZB_NCONTR  := Substr(_cBuffer,319,015)
	ZZB_PRZENT  := Substr(_cBuffer,334,008)
	ZZB_FILORI  := Substr(_cBuffer,342,004)
	ZZB_FILDES  := Substr(_cBuffer,346,004)
	ZZB_FIMP    := Substr(_cBuffer,350,001)
	ZZB_BLQDOC  := Substr(_cBuffer,351,001)
	ZZB_PRIPER  := Substr(_cBuffer,352,001)
	ZZB_CLIREM  := Substr(_cBuffer,353,014)
	ZZB_LOJREM  := Substr(_cBuffer,367,004)
	ZZB_CLIDES  := Substr(_cBuffer,371,014)
	ZZB_LOJDES  := Substr(_cBuffer,385,004)
	ZZB_CLIDEV  := Substr(_cBuffer,389,014)
	ZZB_LOJDEV  := Substr(_cBuffer,403,004)
	ZZB_CLICAL  := Substr(_cBuffer,407,014)
	ZZB_LOJCAL  := Substr(_cBuffer,421,004)
	ZZB_DEVFRE  := Substr(_cBuffer,425,001)
	ZZB_SERVIC  := Substr(_cBuffer,426,003)
	ZZB_CODMSG  := Substr(_cBuffer,429,006)
	ZZB_STATUS  := Substr(_cBuffer,435,001)
	ZZB_FILDEB  := Substr(_cBuffer,436,004)
	ZZB_PESLIQ  := Substr(_cBuffer,440,009)
	ZZB_NFELET  := Substr(_cBuffer,450,008)
	ZZB_EMINFE  := Substr(_cBuffer,458,008)
	ZZB_CODNFE  := Substr(_cBuffer,466,008) //Codigo do SEFAZ (100 - Normal ou 101|102 Cancelado e Inutilizado
	ZZB_IDRCTE  := Substr(_cBuffer,474,003)
	ZZB_PROCTE  := Substr(_cBuffer,477,015)
	ZZB_CHVCTE  := Substr(_cBuffer,492,044)
	ZZB_SITCTE  := Substr(_cBuffer,536,001)
	ZZB_XCNORI  := Substr(_cBuffer,537,044) //Chave Cte NF Origem
	ZZB_CLICON  := ""
	ZZB_LOJCON  := ""
ZZB->(MsUnLock())

xChvCteOrig 	:= Substr(_cBuffer,537,044) //Chave Cte NF Origem
xDocTMS		:= Substr(_cBuffer,293,001) //Documento de Transporte ( 2=CTRC;5=NF;8=COMPLEMENTAR;M=ANULAÇÃO;P=SUBSTITUIÇÃO )
xDocOri    	:= Substr(Substr(_cBuffer,537,044),26,9) //NUMERO DA NOTA Dentro da Chave CTe NF Origem
xSerOri    	:= Substr(Substr(_cBuffer,537,044),23,3) //SERIE Dentro da Chave CTe NF Origem
xCodNFe		:= Substr(_cBuffer,466,008) //Codigo do SEFAZ (100 - Normal ou 101|102 Cancelado e Inutilizado

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCTE01LerC  ºAutor  ³Totvs               º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Canal C                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³DHL                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GCTE01LerC(_cNumero)

RecLock("ZZC",.T.)

	ZZC_NUMERO := _cNumero

	ZZC_FILIAL  := Substr(_cBuffer,032,004)
	ZZC_CODPAS  := Substr(_cBuffer,036,002)
	ZZC_VALPAS  := Substr(_cBuffer,038,013)
	ZZC_VALIMP  := Substr(_cBuffer,052,013)
	ZZC_VALTOT  := Substr(_cBuffer,066,013)
	ZZC_FILDOC  := Substr(_cBuffer,080,004)
	ZZC_DOC     := Substr(_cBuffer,084,009)
	ZZC_SERIE   := Substr(_cBuffer,093,003)
	ZZC_ITEMD2  := Substr(_cBuffer,096,002)
	ZZC_FILORI  := Substr(_cBuffer,098,004)
	ZZC_CDRORI  := Substr(_cBuffer,102,006)
	ZZC_CDRDES  := Substr(_cBuffer,108,006)
	ZZC_CODPRO  := Substr(_cBuffer,114,018)
	ZZC_TABFRE  := Substr(_cBuffer,132,004)
	ZZC_TIPTAB  := Substr(_cBuffer,136,002)
	ZZC_XALIQ   := Substr(_cBuffer,138,005)
	ZZC_XTES    := Substr(_cBuffer,143,003)
	ZZC_XCFOP   := Substr(_cBuffer,146,004)
ZZC->(MsUnLock())

Return