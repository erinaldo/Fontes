#INCLUDE "rwmake.ch"         

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA21()

Programa para gravar informações complementares
Cnab a Pagar Bradesco (Posições 374 - 413)

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_Doc
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA21()        

SetPrvt("_Doc,_Mod,")

//_Mod := SUBSTR(SEA->EA_MODELO,1,2)
_Mod := SUBSTR(SE2->E2_FORMPAG,1,2)

IF _Mod == "  "
   IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
      _Mod == "30"
   ELSE
      _Mod == "31"                              
   ENDIF
ENDIF

DO CASE
   CASE _Mod == "03" 
	  _Doc := IIF(SUBSTR(SA2->A2_CGC,1,8)==SUBSTR(SM0->M0_CGC,1,8) ,"D","C")+"000000"+"01"+"01"+SPACE(29)
   CASE _Mod == "07" .OR. _Mod == "08" .OR. _Mod == "41" .OR. _Mod == "43"
	  _Doc := IIF(SUBSTR(SA2->A2_CGC,1,8)==SUBSTR(SM0->M0_CGC,1,8) ,"D","C")+"000000"+"01"+"01"+SPACE(29)
   CASE _Mod == "30"  .OR. _Mod == "31"
        _Doc := SUBSTR(SE2->E2_CODBAR,20,25)+SUBSTR(SE2->E2_CODBAR,5,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
   OTHERWISE
        _Doc := SPACE(40)
ENDCASE

Return(_Doc)