#include "rwmake.ch"
*-------------------------------------------------------------------------------------------
user function F050alt()
* Ponto de entrada na geracao de titulos a pagar com rateio de centros de custo
* MTdO - 13/09/2004 - power by RLdR 
*-------------------------------------------------------------------------------------------
local _cKeySe2:=se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja),;
      _vAmbSev:=sev->(getarea()),;
      _vAmbSez:=sez->(getarea())
sev->(dbsetorder(1)) // EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
// Atualiza SEZ- campo ez_empr - com area de negocio CSU
sev->(dbseek(xfilial()+_cKeySe2,.f.))
do while sev->(!eof().and.EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA==xfilial()+_cKeySe2)
   if sev->ev_recpag=="P"
      _cKeySev:=sev->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ)
      sez->(dbseek(xfilial()+_cKeySev,.f.))
      do while sez->(!eof().and.EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ==;
                                xfilial()+_cKeySeV)
         if sez->ez_recpag=="P"
            do while sez->(!reclock(alias(),.f.))
            enddo
			SEZ->EZ_EMPR :=POSICIONE("CTT",1,XFILIAL("CTT")+SEZ->(EZ_CCUSTO),"CTT_EMPRES")
            sez->(msunlock())
         endif      
         sez->(dbskip(1))
      enddo
   endif   
   sev->(dbskip(1))
enddo

sev->(restarea(_vAmbSev))
sez->(restarea(_vAmbSez))
return(.T.)