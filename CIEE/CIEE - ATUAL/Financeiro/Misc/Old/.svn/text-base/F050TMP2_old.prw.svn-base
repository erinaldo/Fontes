#INCLUDE "RWMAKE.CH"

user Function F050TMP2()

Local _calias := Alias()
Local _nOrder := IndexOrd()
Local _nRecno := Recno()

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

dbSelectArea("TMP1")

_aRateio := {}

AADD(_aRateio,{_cContKM  , _cCC, "30104030006", _nValKM  	})
AADD(_aRateio,{_cContTaxi, _cCC, "30104030003", _nValTaxi	})
AADD(_aRateio,{_cContRef , _cCC, "30104030017", _nValRef	})
AADD(_aRateio,{_cContEst , _cCC, "30104030022", _nValEst	})
AADD(_aRateio,{_cContPed , _cCC, "30104030020", _nValPed	})
If _cCPMF
	AADD(_aRateio,{"32029" , _cCC, "30104030029", _nVCPMF	})
EndIf

For _nI := 1 to Len(_aRateio)
	If _aRateio[_nI,4] > 0
		RecLock("TMP1",.T.)	
		TMP1->CTJ_ITEMD 	:= _aRateio[_nI,1]
		TMP1->CTJ_CCD	 	:= _aRateio[_nI,2]
		TMP1->CTJ_DEBITO 	:= _aRateio[_nI,3]
		TMP1->CTJ_CREDIT 	:= ""
		TMP1->CTJ_HIST		:= ""
		TMP1->CTJ_VALOR 	:= _aRateio[_nI,4]
		TMP1->CTJ_PERCEN 	:= Round((_aRateio[_nI,4] / _nValor) * 100,2)
		TMP1->CTJ_FLAG 	:= .F.
		MsUnLock()
	EndIf
Next _nI

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)
dbGoto(_nRecno)

Return(_nValor)