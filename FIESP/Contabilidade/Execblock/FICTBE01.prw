#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBE01  บAutor  ณTOTVS               บ Data ณ  07/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao de campo nao permitindo a digitacao de Item      บฑฑ
ฑฑบ          ณ Contabil nao cadastrado nas rotina de Projeto              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FICTBE01(_cCampo)

Local _lRet 	:= .T.
Local _cSZB 	:= RetSqlName('SZB')
Local _cSZA 	:= RetSqlName('SZA')
Local _aAreaSC1	:= GetArea()

Default _cCampo := Nil

If _cCampo <> Nil

	SZA->(DbSetOrder(1))
	If SZA->(DbSeek(xFilial("SZA")+__CUSERID))
		If SZA->ZA_TIPO == "2"	//Usuario igual a 2(NAO) nใo ้ MASTER entao faz a analise do Item Contabil
			cQuery := "SELECT SZB.* "
			cQuery += "FROM "+_cSZB+" SZB, "
			cQuery += "WHERE SZB.D_E_L_E_T_ = ''  "
			cQuery += "AND SZB.ZB_USERID = '"+__CUSERID+"' "
			cQuery += "AND ZB_ITEM = '"+_cCampo+"' "
			cQuery := ChangeQuery( cQuery )
			TCQUERY cQuery ALIAS "TMPSZB" NEW
			TMPSZB->(DbGotop())
			If TMPSZB->(!EOF())
				_lRet := .T.
			Else
				_lRet := .F.
				msgbox("Item Contabil nใo autorizado.","Alert")
			EndIf
			TMPSZB->(DbCloseArea())
		EndIf
	EndIf
EndIf

RestArea(_aAreaSC1)

Return(_lRet)