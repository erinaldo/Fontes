#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//------------------------------------------------------------------------------
/*/{Protheus.doc} MT120COR()
Manipula regras de cores de status na mBrowse

LOCALIZA��O : Function MATA120 - Fun��o do Pedido de Compras e Autoriza��o de 
Entrega.

EM QUE PONTO : Ap�s a montagem do Filtro da tabela SC7 e antes da execu��o da 
mBrowse do PC, utilizado para manipular o Array com as regras para apresenta��o 
das cores dos estatus na mBrowse.

Retorno
aNewCores(vetor)
Array de retorno contendo as regras para a apresenta��o das cores do status do 
pedido de compras na mbrowse j� manipuladas pelo usuario. 

@param		aPadrao = Regras para a apresenta��o das cores do status do pedido de compras na mbrowse 
@return		aRet = Regras alteradas
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
USER FUNCTION MT120COR()
	LOCAL aPadrao	:= PARAMIXB[1]
	LOCAL aRet		:= {}

	aRet := U_ASCOMA08(aPadrao)

RETURN aRet