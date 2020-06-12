#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA100DEL   บAutor  ณMicrosiga           บ Data ณ  08/22/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A100DEL()

Local _aArea	:= GetArea()
Local _lRet		:= .T.
Local _cQuery

IF !INCLUI .and. !ALTERA

	_cQuery := "SELECT COUNT(E1_NUM) AS NUMREG "
	_cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
	_cQuery += "WHERE SE1.D_E_L_E_T_ = '' "
	_cQuery += "AND SE1.E1_ORIGEM = 'MATA103' "
	_cQuery += "AND SE1.E1_BAIXA <> '' "
	_cQuery += "AND SE1.E1_SITUACA = '0' "
	_cQuery += "AND SE1.E1_NUMBOR = '' "
	_cQuery += "AND SE1.E1_NUM = '"+SF1->F1_DOC+"' "
	_cQuery += "AND SE1.E1_PREFIXO= '"+SF1->F1_SERIE+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBSE1",.t.,.t.)
	
	DbSelectArea("TRBSE1")
	DbGotop()
	If TRBSE1->NUMREG > 0
		msgbox("Existem Titulos a Receber Baixados!!")
		_lRet		:= .F.
	EndIf
	DbSelectArea("TRBSE1")
	TRBSE1->(DbCloseArea())
EndIf

RestArea(_aArea)

Return(_lRet)