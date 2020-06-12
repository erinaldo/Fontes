#INCLUDE "RWMAKE.CH"

user Function F050TMP2()

Local _calias 	:= Alias()
Local _nOrder 	:= IndexOrd()
Local _nRecno 	:= Recno()
Local _xVal_FL 	:= 0

If Alltrim(FunName()) == "IMP_FFQ"
	If TRA->(DbSeek(_CPREFIXO+_CNUM+_CPARCELA+_CTIPO+_CFORNECE+_CLOJA))
		Return(_nValor)
	Else
		RecLock("TRA",.T.)
		TRA->xPREFIXO	:= 'FFQ'
		TRA->xNUM 		:= _cNR
		TRA->xPARCELA	:= ' '
		TRA->xTIPO		:= 'FFQ'
		TRA->xFORNECE	:= _cCodFor
		TRA->xLOJA		:= _cLojFor
		TRA->xNATUREZ	:= '9.99.99'
		TRA->xEMISSAO	:= dDataBase
		TRA->xVALOR		:= _nValor
		MsUnLock()
	EndIf

	dbSelectArea("TMP")

	_aRateio := {}

	AADD(_aRateio,{_cContKM  , _cCC, "301040300006", _nValKM  	})
	AADD(_aRateio,{_cContTaxi, _cCC, "301040300003", _nValTaxi	})
	AADD(_aRateio,{_cContRef , _cCC, "301040300017", _nValRef	})
	AADD(_aRateio,{_cContEst , _cCC, "301040300022", _nValEst	})
	AADD(_aRateio,{_cContPed , _cCC, "301040300020", _nValPed	})

	/* // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015
	If _cCPMF 
		AADD(_aRateio,{"32029" , _cCC, "30104030029", _nVCPMF	})
	EndIf
	*/

	For _nI := 1 to Len(_aRateio)
		If _aRateio[_nI,4] > 0
			RecLock("TMP",.T.)	
			TMP->CTJ_ITEMD 	:= _aRateio[_nI,1]
			TMP->CTJ_CCD	 	:= _aRateio[_nI,2]
			TMP->CTJ_DEBITO 	:= _aRateio[_nI,3]
			TMP->CTJ_CREDIT 	:= ""
			TMP->CTJ_HIST		:= ""
			TMP->CTJ_VALOR 	:= _aRateio[_nI,4]
			TMP->CTJ_PERCEN 	:= Round((_aRateio[_nI,4] / _nValor) * 100,2)
			TMP->CTJ_FLAG 		:= .F.
			MsUnLock()
		EndIf
	Next _nI

	dbSelectArea(_cAlias)
	dbSetOrder(_nOrder)
	dbGoto(_nRecno)
Else
	//Process de FL - Contas a Pagar
	DbSelectArea("TCIEE") 
	DbGoTop()
	_nValor	:= 0
	Do while !EOF()
		_nValor+=TCIEE->xVALOR
		DbSkip()
	EndDo

	DbSelectArea("TCIEE")   
	Dbgotop()
	Do while !EOF()
		RecLock("TMP",.T.)	
		TMP->CTJ_ITEMD 	:= TCIEE->xITEMD
		TMP->CTJ_CCD	 	:= TCIEE->xCCD
		TMP->CTJ_DEBITO 	:= TCIEE->xCTACON
		TMP->CTJ_CREDIT 	:= TCIEE->xCTACOC
		TMP->CTJ_HIST		:= ""
		TMP->CTJ_VALOR 		:= TCIEE->xVALOR
		TMP->CTJ_PERCEN 	:= Round((TCIEE->xVALOR / _nValor) * 100,2)
		TMP->CTJ_FLAG 		:= .F.
		TMP->CTJ_HIST		:= TCIEE->xHIST
		MsUnLock()
		DbSelectArea("TCIEE")
		DbSkip()
	EndDo
EndIf

Return(_nValor)