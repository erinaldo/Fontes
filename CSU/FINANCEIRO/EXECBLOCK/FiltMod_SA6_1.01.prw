/*	MTdO - SET./ 2004 - CSU
	Rotina de validação de cadastro de bancos
	Condição : Se modulo GPE filtra todos os BANCOS com SA6_USOA6=2, 
	caso contrario mostra somente os demais.
*/

user function filModA6()

local _lReturn:=.f.

if cModulo=='GPE'
   _lReturn:=(SA6->A6_usoA6=='2')
else
   _lReturn:=(SA6->A6_usoA6<>'2')
endif
return _lReturn