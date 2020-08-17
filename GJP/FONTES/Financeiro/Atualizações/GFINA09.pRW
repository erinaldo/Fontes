#include "rwmake.ch"      

User Function GFINA09()   //PAGFOR


SetPrvt("_CTACED,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4,_NPOSDV")
SetPrvt("_DIG5,_DIG6,_DIG7,_MULT,_RESUL,_RESTO")
SetPrvt("_DIGITO,")

/////  PROGRAMA PARA SEPARAR A C/C DO CODIGO DE BARRA
/////  CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (105-119)

_CtaCed := "000000000000000"
_cBanco := SUBSTR(SE2->E2_CODBAR,1,3)
Do Case
   Case _cBanco == "237"	// BRADESCO

    _CtaCed  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
    
    _RETDIG := " "
    _DIG1   := SUBSTR(SE2->E2_CODBAR,37,1)
    _DIG2   := SUBSTR(SE2->E2_CODBAR,38,1)
    _DIG3   := SUBSTR(SE2->E2_CODBAR,39,1)
    _DIG4   := SUBSTR(SE2->E2_CODBAR,40,1)
    _DIG5   := SUBSTR(SE2->E2_CODBAR,41,1)
    _DIG6   := SUBSTR(SE2->E2_CODBAR,42,1)
    _DIG7   := SUBSTR(SE2->E2_CODBAR,43,1)
    
    _MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
    _RESUL  := INT(_MULT /11 )
    _RESTO  := INT(_MULT % 11)
    _DIGITO := STRZERO((11 - _RESTO),1,0)

    _RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))

    _CtaCed := _CtaCed + _RETDIG
   
OTHERWISE        

	_CtaCed := STRZERO(VAL(SUBSTR(SE2->E2_FORCTA,1,10)),13)+substr(SE2->E2_FCTADV,1,2)
  

ENDCASE

Return(_CtaCed) 