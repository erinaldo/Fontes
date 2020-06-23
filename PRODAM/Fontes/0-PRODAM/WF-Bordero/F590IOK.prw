#Include 'Protheus.ch'

User Function F590IOK()

_cTipoBord	:= PARAMIXB[1] //Tipo de Bordero ("P" - Pagar / "R" - Receber)
_cBordero	:= PARAMIXB[2] //Numero do Bordero
_lRet		:= .T.
_cArqSE2 := CriaTrab(nil,.f.)

If _cTipoBord = "P"

	// verifica se esta totalmente liberado
	_cQuery := "SELECT E2_XSTSAPV, E2_NUMBOR FROM "+RetSqlName("SE2")+" "
	_cQuery += "WHERE D_E_L_E_T_ = ' ' AND E2_NUMBOR = '"+_cBordero+"' AND E2_XSTSAPV IN ('2','3') "
	_cQuery := ChangeQuery(_cQuery)
			
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqSE2,.t.,.t.)

	IF (_cArqSE2)->(Eof())
		_lRet		:= .T.
	Else
		msginfo("Bordero passou por processo de Aprovação!!!  Não permitido inclusão de novos Titulos.")
		_lRet		:= .F.		
	EndIf
EndIf

Return(_lRet)

