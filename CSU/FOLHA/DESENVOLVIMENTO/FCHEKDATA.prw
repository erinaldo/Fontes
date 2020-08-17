USER FUNCTION FChekData(_dNasc,_dAdmi)
LOCAL _lRet  := .T.
LOCAL _cDia  := STRZERO(DAY(_dNasc),2)
LOCAL _cMes  := STRZERO(MONTH(_dNasc),2)
LOCAL _cAno  := STRZERO(YEAR(_dNasc)+18,4)
LOCAL _d18An := CTOD(_cDia+'/'+_cMes+'/'+_cAno)

If ! empty(_dNasc) .and. ! empty(_dAdmi)
	IF _dAdmi >= _d18an
		_lRet := .T.
	ELSE
		AVISO('Espec�fico CSU - ATEN��O!','Esse Funcion�rio N�O T�m 18 anos Completos!',{'Ok'},1,'Data Adm. Inv�lida!')
	ENDIF
Else

_lRet  := .T.

ENDIF
RETURN(_lRet)