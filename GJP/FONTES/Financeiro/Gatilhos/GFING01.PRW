#include "rwmake.ch"   

User Function GFING01() //GATILHO PAGFOR

/*
*****************************************************************************
* Programa...: CODBAR.PRX
* Objetivo...: Transformar linha digitavel em codigo de barras
*****************************************************************************
*/


If Len(AllTrim(M->E2_XLINDIG))<34
   _cCodBar    :=""
Else
   _cLinDig    := M->E2_XLINDIG
   _cBanco     := SubStr(_cLinDig,01,03)
   _cCampo1    := SubStr(_cLinDig,05,05)
   _cCampo2    := SubStr(_cLinDig,11,10)
   _cCampo3    := SubStr(_cLinDig,22,10)
   _cCampoLivre:= _cCampo1+_cCampo2+_cCampo3
   _cMoeda     := SubStr(_cLinDig,04,01)
   _cValor     := StrZero(Val(SubStr(_cLinDig,34,14)),14)
   _cDAC       := SubStr(_cLinDig,33,01)
   _cCodBar    := AllTrim(_cBanco+_cMoeda+_cDAC+_cValor+_cCampoLivre)
Endif

Return(_cCodBar)
