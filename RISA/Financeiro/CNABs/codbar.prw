#include "rwmake.ch"   

User Function CODBAR() 

/*
*****************************************************************************
* Programa...: CODBAR.PRX
* Objetivo...: Transformar linha digitavel em codigo de barras
*****************************************************************************
*/

IF !EMPTY(SE2->E2_CODBAR) .OR. !EMPTY(SE2->E2_LINDIG)//VAZIO
   //If Len(AllTrim(SE2->E2_CODBAR))<34
      //_cCodBar    :=""
   //Else
      IF !EMPTY(SE2->E2_LINDIG)
         _cLinDig    := SE2->E2_LINDIG
      ELSE
         _cLinDig    := SE2->E2_CODBAR
      ENDIF
      _cBanco     := SubStr(_cLinDig,01,03)
      _cCampo1    := SubStr(_cLinDig,05,05)
      _cCampo2    := SubStr(_cLinDig,11,10)
      _cCampo3    := SubStr(_cLinDig,22,10)
      _cCampoLivre:= _cCampo1+_cCampo2+_cCampo3
      _cMoeda     := SubStr(_cLinDig,04,01)
      _cValor     := StrZero(Val(SubStr(_cLinDig,34,14)),14)
      _cDAC       := SubStr(_cLinDig,33,01)
      _cCodBar    := AllTrim(_cBanco+_cMoeda+_cDAC+_cValor+_cCampoLivre)
   //Endif
ELSE
   MSGALERT( "Linha digitaval não informado no título: "+SE2->E2_NUM+"-"+SE2->E2_PARCELA, "ATENÇÃO" )
   _cCodBar    :="0erro"
ENDIF

Return(_cCodBar)
