#include "rwmake.ch"
*---------------------------------------------------------------------------------------------------------------
User Function F290Fil()
* Ponto de entrada em Fina290 (Bordero de pagamentos) filtragem do browse
* Ricardo Luiz da Rocha - Dts Consulting - 13/07/2004 GNSJC
*---------------------------------------------------------------------------------------------------------------
local _cPrefFat:="FF"
if cPrefix<>_cPrefFat
   msgbox("Nao e permitido alterar o prefixo de faturas a pagar. O prefixo original sera restaurado")
   cPrefix:=_cPrefFat
endif   
return ".T."