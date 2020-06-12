#include "rwmake.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA17()

Programa para separar a c/c do codigo de barra
Cnab Bradesco a pagar (PagFor) - Posições (105-119)

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_CtaCed = Conta Corrente
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA17()

SetPrvt("_CTACED,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4,_NPOSDV")
SetPrvt("_DIG5,_DIG6,_DIG7,_MULT,_RESUL,_RESTO")
SetPrvt("_DIGITO,")

_CtaCed := "000000000000000"
_cBanco := SUBSTR(SE2->E2_CODBAR,1,3)
Do Case
   Case _cBanco == "237" // BRADESCO

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
		
		nPosDV := AT("-",SA2->A2_NUMCON)
	    
	   
		/*
		IF _nPosDV == 0
			 _CtaCed := REPL("0",15-LEN(LTRIM(RTRIM(SA2->A2_NUMCON))))+LTRIM(RTRIM(SA2->A2_NUMCON)) 
		     MsgAlert("Digito da conta corrente "+ALLTRIM(SA2->A2_NUMCON)+" nao informado! Verifique o cadastro do fornecedor " + SA2->A2_NREDUZ + ".","Atencao!")		 
		ELSE
			_CtaCed := SUBSTR(SA2->A2_NUMCON,1,_nPosDV-1)
			_CtaCed := REPL("0",13-LEN(_CtaCed))+_CtaCed
			_CtaCed := _CtaCed+SUBSTR(SA2->A2_NUMCON,_nPosDV+1,2)
			IIF(EMPTY(SUBSTR(SA2->A2_NUMCON,_nPosDV+1,2)),MsgAlert("Digito da conta corrente "+ALLTRIM(SA2->A2_NUMCON)+" nao informado! Verifique o cadastro do fornecedor " + SA2->A2_NREDUZ + ".","Atencao!"),"")		 
		ENDIF
		
		_CtaCed := REPL("0",13-LEN(LTRIM(RTRIM(SA2->A2_NUMCON))))+LTRIM(RTRIM(SA2->A2_NUMCON))
        
		
		
  	   
  		IF SEA->EA_MODELO$"01/03/05/41/43/07/08"
  			_CtaCed := STRZERO(VAL(ALLTRIM(SA2->A2_NUMCON)+ALLTRIM(SA2->A2_DVCTA)),14)
		ENDIF
		
		*/
		
		IF SE2->E2_FORMPAG$"01/03/05/41/43/07/08"
  			_CtaCed := STRZERO(VAL(ALLTRIM(SE2->E2_FORCTA)+ALLTRIM(SE2->E2_FCTADV)),14)
		ENDIF
		
ENDCASE


Return(_CtaCed)