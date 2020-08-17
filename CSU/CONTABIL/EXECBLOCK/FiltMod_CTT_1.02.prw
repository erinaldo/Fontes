/*	MTdO - SET./ 2004 - CSU
	Rotina de validação de centro de custo
	Condição : Se modulo GPE filtra todos os CC com CTT_usocc=2, 
	caso contrario mostra somente os demais.
*/

user function filModCC()

local _lReturn:=.f.
//CTT->CTT_CLASSE <> "1" .AND. (CTT->CTT_FIL == SM0->M0_CODFIL)       
if cModulo=='GPE'
   _lReturn:=(CTT->CTT_FIL == SM0->M0_CODFIL .AND. ctt->ctt_usocc=='2' .AND. CTT->CTT_CLASSE <> "1")
else
   _lReturn:=(ctt->ctt_usocc<>'2' .AND. CTT->CTT_CLASSE <> "1")
endif
return _lReturn