
User Function MT103FIM()

Local lRet       := .T.
Local cTESAnula  := SuperGetMv("MV_TESANUL",,"")

If IsInCallStack("U_DTMS004")

	_cCFAnul := Posicione("SF4", 1, xFilial("SF4")+cTESAnula, "F4_CF")
	_cEstCli := Posicione("SA1", 1, xFilial("SA1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV, "A1_EST")
	_cEstEmp := SM0->M0_ESTCOB

	If _cEstCli == "EX"
		_cCFAnul := "3"+Substr(_cCFAnul,2,3)
	ElseIf _cEstCli == _cEstEmp
		_cCFAnul := "1"+Substr(_cCFAnul,2,3)
	ElseIf _cEstCli <> _cEstEmp
		_cCFAnul := "2"+Substr(_cCFAnul,2,3)
	Else
		_cCFAnul := _cCFAnul
	EndIf

	RecLock("SD1",.F.)
	SD1->D1_CF      := _cCFAnul
	MsUnLock()
		
	RecLock("SF3",.F.)
	SF3->F3_CFO     := _cCFAnul
	MsUnLock()
		
	RecLock("SFT",.F.)
	SFT->FT_CFOP    := _cCFAnul
	MsUnLock()

EndIf

Return(lRet)