User Function F240Tit

Local _lRet := .T.
Local _cQuery
Static  _ContV
//Static _lVer
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MONTA QUERY DE VERIFICACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



_cQuery := "SELECT COUNT(*) as REGS FROM " + RETSQLNAME('SE2') + " "
_cQuery += "WHERE E2_FILIAL = '"  + xFILIAL('SE2')  + "' "
_cQuery += "  AND E2_FORNECE = '" + SE2->E2_FORNECE + "' "
_cQuery += "  AND E2_LOJA    = '" + SE2->E2_LOJA    + "' "
_cQuery += "  AND E2_TIPO    = 'PA' "
_cQuery += "  AND E2_SALDO   > 0 "
_cQuery += "  AND D_E_L_E_T_ = ' '"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXECUTAR QUERY            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.f.,.t.)

If _ContV <> 2 .AND. ( TRB->REGS != 0 )
	_ContV := 2
	MsgAlert("No Periodo Selecionado Existem Titulos com Pagamentos já Adiantados. Verifique!")
	_lRet := .T.
ELSE
	IF ( TRB->REGS == 0 )
		_lRet := .T.
	ENDIF
	
END

If ( TRB->REGS != 0 ) .AND. _ContV == 2
	_lRet := .T. // O Retorno True não negativa o valor do cálculo
	Alert("Atenção: Existem Pagamentos Antecipados em aberto para este fornecedor. Verifique as compensações.")
EndIf

IF Select("TRB") > 0
	dbCloseArea("TRB")
ENDIF


IF ALLTRIM(SE2->E2_NATUREZ) == "9.99.99"
//	If Empty(_lVer)
		MsgAlert("Titulo(s) Classificado(s) com natureza 9.99.99, Reclassifique!!!")
		_lVer := "1"
//	Endif
	_lRet := .F.
	Reclock("SE2",.F.) // Trava o registro
	SE2->E2_OK:=" "
	Msunlock() // Destrava o registro
Endif


Return(_lRet)
