#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA04()

Valida se o t�tulo a pagar foi enviado para o Fluig e liberado

Chamado pelo PE FA080TIT

@param		Nenhum
@return		cRet	=	Express�o caracter com o filtro desejado 
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA04()
	LOCAL lRet	:= .T.
	
	IF lRet
		IF !(SE2->E2_XSFLUIG $ ' |N|A') // se o t�tulo foi enviado ao Fluig, mas n�o est� aprovado
			Help('',1,'Inconsist�ncia - ' + PROCNAME(),,'Este t�tulo n�o pode ser baixado pois foi enviado ao Fluig e ainda n�o est� aprovado',4,1)
			lRet := .F.
		ENDIF
	ENDIF
	
RETURN lRet