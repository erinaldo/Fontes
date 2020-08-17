#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA12()

Controles do processo do pedido de compras – Alteração
Chamado pelo PE MT120ALT

@param		nOpcPE	= 3 Inclusão, 4 Alteração, 5 Exclusão 
@return		lRet = Continua ou não a operação
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCOMA12(nOpcPE)
	LOCAL lRet := .T.

	IF !IsInCallStack("MATA121") 
		RETURN .T.
	ENDIF

	IF lRet
		IF nOpcPE == 4 // alteração

			IF !EMPTY(SC7->C7_XCNTTOP)
				lRet := .F.
				Help('',1,'Inconsistência - ' + PROCNAME(),,'Este pedido não pode ser alterado pois tem contrato no TOP gerado a partir dele',4,1)
			ELSE
				//-----------------------------------------------------------------------
				// Não será permitido efetuar alteração neste pedido, já que:
				// I = a primeira aprovação já foi efetuada
				// A = pedido aprovado
				// R = pedido reprovado
				//-----------------------------------------------------------------------
				IF SC7->C7_XSFLUIG $ "I|A|R" // pedido de compras com aprovação iniciada, aprovado ou reprovado reprovado
					lRet := .F.
					Help('',1,'Inconsistência - ' + PROCNAME(),,'Este pedido não pode ser alterado pois '+  IIF(SC7->C7_XSFLUIG $ 'I|A','já teve aprovação iniciada','foi reprovado') + ' no Fluig',4,1)
				ENDIF
			ENDIF
		ENDIF
	ENDIF

RETURN lRet