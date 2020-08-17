#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120ALT()

LOCALIZA��O : Function A120PEDIDO - Fun��o do Pedido de Compras e 
Autoriza��o de Entrega responsavel pela inclus�o, altera��o, exclus�o e 
c�pia dos PCs.

EM QUE PONTO : No inico da Fun��o, antes de executar as opera��es de 
inclus�o, altera��o exclus�o e c�pia, deve ser utilizado para validar o 
registro posicionado do PC e retornar .T. se deve continuar e executar as 
opera��es de inclus�o, altera��o, exclus�o e c�pia ou retornar .F. para 
interromper o processo.

@param		Nenhum 
@return		L�gico = Exibe ou n�o exibe o item do pedido na importa��o do pedido de compras
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
	// Controles do processo do pedido de compras � Altera��o
	//-----------------------------------------------------------------------
	IF lRet
		lRet := U_ASCOMA12(nOpcPE)
	ENDIF

RETURN lRet