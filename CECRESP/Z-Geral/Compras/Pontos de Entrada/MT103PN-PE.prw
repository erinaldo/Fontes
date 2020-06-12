#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT103PN()
Inclusão de documento de entrada

Este ponto de entrada pertence à rotina de manutenção de documentos de 
entrada, MATA103. É executada em A103NFISCAL, na inclusão de um documento 
de entrada. Ela permite ao usuário decidir se a inclusão será executada 
ou não.

@param		Nenhum  
@return		lRet(logico) .T. executar a inclusão, .F. não executar.
@author 	Fabio Cazarini
@since 		24/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT103PN()
	LOCAL lRet		:= .T.

	IF lRet
		U_ASCOMA21()
	ENDIF	

RETURN lRet

