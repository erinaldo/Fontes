#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMPET3 º Autor ³ Patricia Fontaneziº Data ³  06/09/12      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Validacao na digitacao de meses e ano no campo EV_XCOMPET º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER FUNCTION COMPET3()

Local _cRet	:= .T.
Local _aArea:= GetArea()
Local _cNature	:= aScan(aHeader, {|x| AllTrim(x[2]) == "EV_NATUREZ"})  


IF !EMPTY(M->EV_XCOMPET) .AND. !EMPTY(aCols[n][_cNature])
	If Substr(alltrim(aCols[n][_cNature]),1,4) $ "6.10|6.11"
		IF VAL(SUBSTR(M->EV_XCOMPET,1,2)) < 01 .OR. VAL(SUBSTR(M->EV_XCOMPET,1,2)) > 12
			MSGINFO("Mês Incorreto. Digite novamente !") 
			_cRet	:= .F.
		ELSE
			If VAL(SUBSTR(M->EV_XCOMPET,4,4)) < 2012 .OR. VAL(SUBSTR(M->EV_XCOMPET,4,4)) > 2100
				MSGINFO("Ano Incorreto. Digite novamente !")
				_cRet	:= .F.
			Endif
		ENDIF 
	Endif	
Endif

RestArea(_aArea)

RETURN(_cRet)


