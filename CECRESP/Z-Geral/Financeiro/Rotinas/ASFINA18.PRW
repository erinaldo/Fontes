#include "rwmake.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA18()

Programa para separar a agencia do codigo de barras
Cnab Bradesco a Pagar (PagFor) - Posições 99 - 104

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_Agencia = Agencia
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA18()

SetPrvt("_AGENCIA,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4")
SetPrvt("_MULT,_RESUL,_RESTO,_DIGITO,")

_Agencia := "000000"
_cBanco := SUBSTR(SE2->E2_CODBAR,1,3)

Do Case 

   Case _cBanco == "237" // BRADESCO
      _Agencia  :=  "0" + SUBSTR(SE2->E2_CODBAR,20,4)

      _RETDIG := " "
      _DIG1   := SUBSTR(SE2->E2_CODBAR,20,1)
      _DIG2   := SUBSTR(SE2->E2_CODBAR,21,1)
      _DIG3   := SUBSTR(SE2->E2_CODBAR,22,1)
      _DIG4   := SUBSTR(SE2->E2_CODBAR,23,1)
      _MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
      _RESUL  := INT(_MULT /11 )
      _RESTO  := INT(_MULT % 11)
      _DIGITO := 11 - _RESTO

      _RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",ALLTRIM(STR(_DIGITO))))

      _Agencia:= _Agencia + _RETDIG

   Otherwise               
		
		/*
        IF SEA->EA_MODELO$"01/03/05/41/43/07/08"
         	 	_Agencia :=  STRZERO(VAL(SA2->A2_AGENCIA),5)+SUBSTR(SA2->A2_DVAGE,1,1)
		ENDIF
		*/
		
		IF SE2->E2_FORMPAG$"01/03/05/41/43/07/08"
         	 	_Agencia :=  STRZERO(VAL(SE2->E2_FORAGE),5)+SUBSTR(SE2->E2_FAGEDV,1,1)
		ENDIF
		
Endcase
   

Return(_Agencia)     
