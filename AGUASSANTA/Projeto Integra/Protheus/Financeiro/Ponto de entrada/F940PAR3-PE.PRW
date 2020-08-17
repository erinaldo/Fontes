#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} F940PAR3()

Ponto de entrada na rotina de Cálculo do AVP-CR, permite adicionar condições na Query
@param		Paramixb[1] -  	Array com as perguntas atuais
@return		cQuery		= 	Query complementar
@author 	Zema
@since 		14/08/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F940PAR3                        
LOCAL aPergs := PARAMIXB[1]
LOCAL cQuery := ""

IF LEN(aPergs) > 17
	IF !EMPTY(aPergs[18])
		cQuery += " E1_XCONTRA = '"+aPergs[18]+"' AND "
	ENDIF
ENDIF	

IF LEN(aPergs) > 18
	IF !EMPTY(aPergs[19])
		cQuery += " E1_XEMPRE = '"+aPergs[19]+"' AND "
	ENDIF
ENDIF	
	
RETURN(cQuery)