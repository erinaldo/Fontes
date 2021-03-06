#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT100GRV()

PE na confirma��o do documento de entrada, antes da grava��o

@param		PARAMIXB	= Array contendo: { lDeleta } - Indica se a op��o � Dele��o
@return		L�gico - .T. / .F.
@author 	Zema
@since 		19/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function MT100GRV
	Local lDeleta := PARAMIXB[1]
	Local lRet	:= .T.
	
	If	!lDeleta
		If TYPE("l103Class") <> "U"
			If l103Class
				Return lRet
			Else          
				// Valida as informa��es da dedu��o do Pedido de Compras vindo do RM-TOP
				lRet := U_ASTOP201("N")
			Endif
		Else
			// Valida as informa��es da dedu��o do Pedido de Compras vindo do RM-TOP
			lRet := U_ASTOP201("N")
		Endif
	EndIf
	
Return(lRet)


