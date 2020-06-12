#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA12()

Controles do processo do pedido de compras � Altera��o
Chamado pelo PE MT120ALT

@param		nOpcPE	= 3 Inclus�o, 4 Altera��o, 5 Exclus�o 
@return		lRet = Continua ou n�o a opera��o
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
		IF nOpcPE == 4 // altera��o

			IF !EMPTY(SC7->C7_XCNTTOP)
				lRet := .F.
				Help('',1,'Inconsist�ncia - ' + PROCNAME(),,'Este pedido n�o pode ser alterado pois tem contrato no TOP gerado a partir dele',4,1)
			ELSE
				//-----------------------------------------------------------------------
				// N�o ser� permitido efetuar altera��o neste pedido, j� que:
				// I = a primeira aprova��o j� foi efetuada
				// A = pedido aprovado
				// R = pedido reprovado
				//-----------------------------------------------------------------------
				IF SC7->C7_XSFLUIG $ "I|A|R" // pedido de compras com aprova��o iniciada, aprovado ou reprovado reprovado
					lRet := .F.
					Help('',1,'Inconsist�ncia - ' + PROCNAME(),,'Este pedido n�o pode ser alterado pois '+  IIF(SC7->C7_XSFLUIG $ 'I|A','j� teve aprova��o iniciada','foi reprovado') + ' no Fluig',4,1)
				ENDIF
			ENDIF
		ENDIF
	ENDIF

RETURN lRet