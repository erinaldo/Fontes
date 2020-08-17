user function AjPos(_nValor)

_vAmbSe2:=se2->(getarea())

if se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)<>;
   sez->(ez_prefixo+ez_num+ez_parcela+ez_tipo+ez_clifor +ez_loja)
   // posicionar se2 

   se2->(dbsetorder(1))
   IF se2->(dbseek(xfilial()+sez->(ez_prefixo+ez_num+ez_parcela+ez_tipo+ez_clifor+ez_loja),.f.))
      _nValor:=&_nValor
   endif   
else
   _nValor:=&_nValor
endif
/*if sev->(ev_prefixo+ev_num+ev_parcela+ev_tipo+ev_clifor +ev_loja)<>;
   sez->(ez_prefixo+ez_num+ez_parcela+ez_tipo+ez_clifor +ez_loja)
   
   //SET(11,"OFF")
   sev->(dbsetorder(1))
   sev->(dbseek(xfilial()+sez->(ez_prefixo+ez_num+ez_parcela+ez_tipo+ez_clifor+ez_loja),.f.))
   //sev->(reclock(alias(),.f.))
   //sev->(dbrecall())
   //sev->(msunlock())
endif
*/
_cTipo:=valtype(_nValor)
if _cTipo<>"N"
   _nValor:=0
endif   
return _nValor