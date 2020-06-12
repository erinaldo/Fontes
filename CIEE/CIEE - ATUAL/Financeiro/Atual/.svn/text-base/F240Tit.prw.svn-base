User Function F240Tit

Local _lRet 	:= .T.
Local _cQuery     
Local _N1  		:= 0
Local _aArray	:= {}
Local cNat999 := SuperGetMV("CI_NAT999",.T.,"99999999",)
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
_cQuery += "  AND D_E_L_E_T_ = ' ' "


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


IF ALLTRIM(SE2->E2_NATUREZ) == cNat999				//"9.99.99"
//	If Empty(_lVer)
		MsgAlert("Titulo(s) Classificado(s) com natureza "+cNat999+", Reclassifique!!!")
		_lVer := "1"
//	Endif
	_lRet := .F.
	Reclock("SE2",.F.) // Trava o registro
	SE2->E2_OK:=" "
	Msunlock() // Destrava o registro
Endif

//IF ALLTRIM(SE2->E2_NATUREZ) == "8.88.88" .and. SE2->E2_MULNATU = '1'
IF ALLTRIM(SE2->E2_MULNATU) == '1'
	_xAlias 	:= GetArea()
	_lSemNat 	:= .F.
	DbSelectArea("SEV")
	DbSetOrder(1)
	If DbSeek(xFilial("SEV")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
		Do While SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) == SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
			If Empty(Alltrim(SEV->EV_NATUREZ))
				_lSemNat := .T.
			EndIf
			DbSelectArea("SEV")
			SEV->(DbSkip())
		EndDo
	EndIf

	If _lSemNat
		MsgAlert("Existe rateio de natureza sem classificacao. Ajustar rateio de Multi-Natureza!!!")
		_lRet := .F.
		Reclock("SE2",.F.) // Trava o registro
		SE2->E2_OK:=" "
		Msunlock() // Destrava o registro
	EndIf

	RestArea(_xAlias)
EndIf

Return(_lRet)
