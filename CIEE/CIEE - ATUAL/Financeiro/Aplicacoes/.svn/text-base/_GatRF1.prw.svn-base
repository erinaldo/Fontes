
//Gatilho para campo ZS_REND
User Function _GatRF1()

If SZS->ZS_TPAPL == "POS"
	_cDU2	 := Iif((mv_par01 - M->ZS_DTAPL)>0,(mv_par01 - M->ZS_DTAPL),0)
	_cRend	 := Round((((M->ZS_VLAPL * ((((mv_par02*M->ZS_30DD)/100)/31) * (_cDU2/100))) + M->ZS_VLAPL) - M->ZS_VLAPL),2)
	_cVlAtu  := Round(((M->ZS_VLAPL * ((((mv_par02*M->ZS_30DD)/100)/31) * (_cDU2/100))) + M->ZS_VLAPL),2)
ElseIf SZS->ZS_TPAPL == "BRA"
	_cDU3	 := Iif((mv_par01 - M->ZS_DTAPL)>0,(mv_par01 - M->ZS_DTAPL),0)
	_cRend	 := Round(((((M->ZS_VLAPL * ((mv_par03/M->ZS_DIAS)*_cDU3))/100) + M->ZS_VLAPL) - M->ZS_VLAPL),2)
	_cVlAtu  := Round((((M->ZS_VLAPL * ((mv_par03/M->ZS_DIAS)*_cDU3))/100) + M->ZS_VLAPL),2)
EndIf

Return(_cRend)

//Gatilho para campo ZS_VLATU
User Function _GatRF2()

If SZS->ZS_TPAPL == "POS"
	_cDU2	 := Iif((mv_par01 - M->ZS_DTAPL)>0,(mv_par01 - M->ZS_DTAPL),0)
	_cRend	 := Round((((M->ZS_VLAPL * ((((mv_par02*M->ZS_30DD)/100)/31) * (_cDU2/100))) + M->ZS_VLAPL) - M->ZS_VLAPL),2)
	_cVlAtu  := Round(((M->ZS_VLAPL * ((((mv_par02*M->ZS_30DD)/100)/31) * (_cDU2/100))) + M->ZS_VLAPL),2)
ElseIf SZS->ZS_TPAPL == "BRA"
	_cDU3	 := Iif((mv_par01 - M->ZS_DTAPL)>0,(mv_par01 - M->ZS_DTAPL),0)
	_cRend	 := Round(((((M->ZS_VLAPL * ((mv_par03/M->ZS_DIAS)*_cDU3))/100) + M->ZS_VLAPL) - M->ZS_VLAPL),2)
	_cVlAtu  := Round((((M->ZS_VLAPL * ((mv_par03/M->ZS_DIAS)*_cDU3))/100) + M->ZS_VLAPL),2)
EndIf

Return(_cVlAtu)