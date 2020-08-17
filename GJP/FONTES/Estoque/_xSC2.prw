#Include 'Protheus.ch'
#include "TopConn.ch"
#include "Ap5Mail.ch"
                                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJPJOB04  บAutor  ณMicrosiga           บ Data ณ  10/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _xSC2

_cQuery := "SELECT (C2_NUM+C2_ITEM+C2_SEQUEN) AS OP , C2_NUM"
_cQuery += "FROM SC2040 "
_cQuery += "WHERE C2_BATROT <> 'MATA650' "
_cQuery += "AND C2_EMISSAO BETWEEN '20161201' AND '20161201' AND D_E_L_E_T_ = ' ' "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SC2TRB",.T.,.T.)

Do While SC2TRB->(!EOF())


	_cUpdSc2 := "UPDATE SC2040 SET D_E_L_E_T_ = '*' FROM SC2040 WHERE D_E_L_E_T_ = '' AND C2_NUM = '"+SC2TRB->C2_NUM+"' " 
	TcSQLExec(_cUpdSc2)


	_cUpdSd2 := "UPDATE SD2040 SET D2_OP = '', D2_XAUTOP = '1' FROM SD2040 WHERE D_E_L_E_T_ = '' AND D2_OP = '"+SC2TRB->OP+"' " 
	TcSQLExec(_cUpdSd2)


	_cUpdSd3 := "UPDATE SD3040 SET D_E_L_E_T_ = '*' FROM SD3040 WHERE D_E_L_E_T_ = '' AND D3_OP = '"+SC2TRB->OP+"' " 
	TcSQLExec(_cUpdSd3)

	_cUpdSd4 := "UPDATE SD4040 SET D_E_L_E_T_ = '*' FROM SD4040 WHERE D_E_L_E_T_ = '' AND D4_OP = '"+SC2TRB->OP+"' " 
	TcSQLExec(_cUpdSd4)

	SC2TRB->(DbSkip())

EndDo

SC2TRB->(dbCloseArea())


Return