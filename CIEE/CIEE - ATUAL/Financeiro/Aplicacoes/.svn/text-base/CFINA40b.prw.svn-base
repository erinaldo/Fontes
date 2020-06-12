#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40b  บAutor  ณEmerson Natali      บ Data ณ  26/03/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para verificar as Aplicacoes vencidas para gerar    บฑฑ
ฑฑบ          ณautomaticamente as Cotacoes                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA40b()

LOCAL cCadastro := OemToAnsi("Gera Cota็ใo")
LOCAL aSays		:= {}
LOCAL aButtons	:= {}
LOCAL nOpca 	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Janela Principal                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aSays,OemToAnsi( "Este rotina analisa as Aplica็๕es existentes que estใo " ) )
AADD(aSays,OemToAnsi( "vencidas e gera uma nova cota็ใo automแticamente"		) )

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()		}})
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()				}})
//AADD(aButtons, { 5,.T.,{||  Pergunte(cPerg,.T.)		}})

FormBatch( cCadastro, aSays, aButtons )

If nOpca ==1
	Processa({||Proces_cota()})
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40B  บAutor  ณMicrosiga           บ Data ณ  03/26/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Proces_cota()

LOCAL _cQuery	:= ""

_cQuery	:= "SELECT * "
_cQuery	+= "FROM " + RetSqlName("SZS")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND ZS_RESGAT = '"+DTOS(dDataBase)+"' "
_cQuery += "AND ZS_COTAC <> '1' "
_cQuery += "AND ZS_TPAPL = 'PRE' "
TCQUERY _cQuery ALIAS "TMPCOT" NEW

DbSelectArea("TMPCOT")
DbGotop()
If TMPCOT->(EOF())
	MsgBox(OemToAnsi("Nใo existem Aplica็๕es Vencidas no dia "+Dtoc(dDataBase)), "Aviso", "ALERT")
	DbSelectArea("TMPCOT")
	TMPCOT->(DbCloseArea())
	Return
EndIF

DbSelectArea("SZO")
_cNumero	:= GetSx8Num("SZO","ZO_NUMERO")
_nItem		:= 1
_nCont		:= 0

DbSelectArea("TMPCOT")
DbGotop()
Do While !EOF()

	DbSelectArea("SA6")
	DbSetOrder(5) //FILIAL + NUMERO DA CONTA
	If DbSeek(xFilial("SA6")+TMPCOT->ZS_CONTA)
		_cBanco 	:= SA6->A6_COD
		_cAgencia 	:= SA6->A6_AGENCIA
	Else
		_cBanco 	:= ""
		_cAgencia 	:= ""
	EndIf
	
	DbSelectArea("SZO")
	RecLock("SZO",.T.)
	SZO->ZO_FILIAL 	:= xFilial("SZO")
	SZO->ZO_NUMERO 	:= _cNumero
	SZO->ZO_FLAG 	:= ""
	SZO->ZO_ITEM 	:= STRZERO(_nItem,2)
	SZO->ZO_RENOVA 	:= "N"
	SZO->ZO_BANCO 	:= _cBanco
	SZO->ZO_AGENCIA	:= _cAgencia
	SZO->ZO_CONTA 	:= TMPCOT->ZS_CONTA
	SZO->ZO_NOMBCO 	:= TMPCOT->ZS_NOMBCO
	SZO->ZO_NREST 	:= 0
	SZO->ZO_VLAPL 	:= TMPCOT->ZS_VLNOM //Round(((((TMPCOT->ZS_TXPER/100)+1)^((dDataBase - Stod(TMPCOT->ZS_DTAPL))/TMPCOT->ZS_DIAS))*TMPCOT->ZS_VLAPL),2)
	SZO->ZO_VLORI 	:= TMPCOT->ZS_VLNOM
	SZO->ZO_DTAPL 	:= Stod(TMPCOT->ZS_RESGAT)
	SZO->ZO_TXCDI 	:= 0
	SZO->ZO_DIAS 	:= 0
	SZO->ZO_DU 		:= 0
	SZO->ZO_TXANO 	:= 0
	SZO->ZO_TXDIA 	:= 0
	SZO->ZO_30DD 	:= 0
	SZO->ZO_TXPER 	:= 0
	SZO->ZO_VENCT 	:= CTOD("")
	SZO->ZO_VLNOM 	:= 0
	SZO->ZO_APRV1 	:= ""
	SZO->ZO_APRV2 	:= ""
	SZO->ZO_CANCELA	:= ""
	SZO->ZO_PROCESS	:= ""
	SZO->ZO_ORIGEM 	:= ""
	SZO->ZO_COD    	:= TMPCOT->ZS_COD
	SZO->ZO_ORIGEM 	:= "DEMONS"
	MsUnLock()

	_nItem++
	_nCont++
	
	DbSelectArea("TMPCOT")
	TMPCOT->(DbSkip())
EndDo

ConfirmSX8()

DbSelectArea("TMPCOT")
TMPCOT->(DbCloseArea())

_cQuery	:= "UPDATE "+ RetSqlName("SZS")+" SET ZS_COTAC = '1' "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND ZS_RESGAT = '"+DTOS(dDataBase)+"' "
_cQuery += "AND ZS_COTAC <> '1' "
TcSQLExec(_cQuery)

If _nCont > 0
	DbSelectArea("SZO")
	u_VALCOT('SZO', Recno(), 4) //Tela de Alteracao
EndIf

Return