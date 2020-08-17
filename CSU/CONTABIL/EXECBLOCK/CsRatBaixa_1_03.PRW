*------------------------------------------------------------------------------
user function fRatBaixa(_nValBaixa,_cLanpad,_cKeyTitP)
* Retorna o valor correspondente para cada linha do rateio de titulos a pagar
* Ricardo Luiz da Rocha - 28/09/2004 - GNSJC
*------------------------------------------------------------------------------
local _vAmbSev,_vAmbSez,_nReturn:=0,_nPosic,_cCCusto
static _cKeyTit,_vRateio,_cUltimo,_nContagem,_cUltLan
public _cPublEmpC
_cPublEmpC:="Er"
		
if _cKeyTit==nil
   if _cKeyTitP==nil
      if empty(se2->e2_csukey)
         _cKeyTit:=se2->(e2_filial+e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)
      else // Se titulo de imposto, considera a chave do titulo principal
         _nLen:=len(se2->(e2_filial+e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja))
         _cKeyTit:=padr(left(se2->e2_csukey,_nLen),_nLen)
      endif
   else
      _cKeyTit:=_cKeyTitP
   endif
endif

if _cUltimo==nil.or._cUltimo<>_cKeyTit.or._cUltLan<>_cLanPad
   _nContagem:=1
   _cUltimo:=_cKeyTit
   _cUltLan:=_cLanPad
   _vRateio:={}

   _vAmbSev:=sev->(getarea())
   _vAmbSez:=sez->(getarea())

   sev->(dbsetorder(1)) // EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
   sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
   sez->(dbseek(_cKeyTit,.f.))
   do while sez->(!eof().and.EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA==_cKeyTit)
      if sez->ez_recpag=="P"
         // posicionar SEV
         if sev->(dbseek(sez->(ez_filial+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ),.f.))
            // Agrupar pela empresa, de acordo com o centro de custo
            //_cCCusto:=posicione("CTT",1,xfilial("CTT")+sez->ez_ccusto,"ctt_empres")
            _cCCusto:=sez->ez_empr
            
            if (_nPosic:=ascan(_vRateio,{|_vAux|_vAux[1]==_cCCusto}))==0
               aadd(_vRateio,{_cCCusto,sev->ev_perc*sez->ez_perc,0})
            else
               _vRateio[_nPosic][2]+=(sev->ev_perc*sez->ez_perc)
            endif   
         endif   
      endif
      sez->(dbskip(1))
   enddo
   if len(_vRateio)==0
      aadd(_vRateio,{"",1,0})
   endif

   // Ajuste de eventuais diferencas de arredondamento
   _nDif:=_nValBaixa
   for _nVez:=1 to len(_vRateio)
       _nValLinha:=round(_nValBaixa*_vRateio[_nVez][2],2)
       if _nVez==len(_vRateio)
          _nValLinha:=_nDif
       else
          _nDif-=_nValLinha
       endif
       _vRateio[_nVez][3]:=_nValLinha
   next

   //_nReturn:=_nValBaixa*_vRateio[_nContagem][2]
   _nReturn:=_vRateio[_nContagem][3]
   _cPublEmpC:=_vRateio[_nContagem][1]
else
   _nContagem++
   if _nContagem<=len(_vRateio)
      //_nReturn:=_nValBaixa*_vRateio[_nContagem][2]
      _nReturn:=_vRateio[_nContagem][3]
      _cPublEmpC:=_vRateio[_nContagem][1]
   endif
endif

return _nReturn