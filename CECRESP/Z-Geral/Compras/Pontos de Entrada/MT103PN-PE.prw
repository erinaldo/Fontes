#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT103PN()
Inclus�o de documento de entrada

Este ponto de entrada pertence � rotina de manuten��o de documentos de 
entrada, MATA103. � executada em A103NFISCAL, na inclus�o de um documento 
de entrada. Ela permite ao usu�rio decidir se a inclus�o ser� executada 
ou n�o.

@param		Nenhum  
@return		lRet(logico) .T. executar a inclus�o, .F. n�o executar.
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

