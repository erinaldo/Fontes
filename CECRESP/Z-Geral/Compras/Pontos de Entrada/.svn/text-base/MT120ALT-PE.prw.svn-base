#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120ALT()

LOCALIZAÇÃO : Function A120PEDIDO - Função do Pedido de Compras e 
Autorização de Entrega responsavel pela inclusão, alteração, exclusão e 
cópia dos PCs.

EM QUE PONTO : No inico da Função, antes de executar as operações de 
inclusão, alteração exclusão e cópia, deve ser utilizado para validar o 
registro posicionado do PC e retornar .T. se deve continuar e executar as 
operações de inclusão, alteração, exclusão e cópia ou retornar .F. para 
interromper o processo.

@param		Nenhum 
@return		Lógico = Exibe ou não exibe o item do pedido na importação do pedido de compras
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT120ALT()
	LOCAL nOpcPE	:= PARAMIXB[1]
	LOCAL lRet		:= .T.

	//-----------------------------------------------------------------------
	// Controles do processo do pedido de compras – Alteração
	//-----------------------------------------------------------------------
	IF lRet
		lRet := U_ASCOMA12(nOpcPE)
	ENDIF

RETURN lRet