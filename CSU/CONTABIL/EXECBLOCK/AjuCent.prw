user function AjuCent(_nValor,_cRef)
static _nTotal

_cRef:=upper(alltrim(_cRef))

if _nTotal==nil.or._cRef=="PRIMEIRO"
   _nTotal:=_nValor
else
   _nTotal+=_nValor   
endif   

if _cRef=="ULTIMO"
   if _nTotal<>sez->ez_valor
      _nValor+=(sez->ez_valor-_nTotal)
   endif   
ENDIF
Return _nValor
