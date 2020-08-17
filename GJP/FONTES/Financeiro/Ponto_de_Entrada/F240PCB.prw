
User Function F240PCB()

Local _lRet     := .T.
Local _xGetArea := GetArea()

Public _xArray := {}

_cQuery := "SELECT SE2.R_E_C_N_O_ AS SE2_RECNO "
_cQuery += "FROM " + RetSqlName("SE2") + " SE2 "
_cQuery += "WHERE SE2.D_E_L_E_T_ = '' "
_cQuery += "AND SE2.E2_NUMBOR = '"+mv_par01+"' "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"SE2TRB",.T.,.T.)

Do While SE2TRB->(!EOF())
	AADD(_xArray, SE2TRB->SE2_RECNO)
	SE2TRB->(DbSkip())
EndDo

SE2TRB->(DbCloseArea())

RestArea(_xGetArea)

Return(_lRet)