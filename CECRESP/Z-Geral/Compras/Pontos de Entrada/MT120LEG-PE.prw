#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//------------------------------------------------------------------------------
/*/{Protheus.doc} MT120LEG()
Manipula apresenta��o das cores na mBrowse

LOCALIZA��O : Function A120Legend - Fun��o da dialog de legendas da mbrowse do 
Pedido de Compras e Autoriza��o de Entrega.

EM QUE PONTO : Ap�s a montagem do Array contendo as legendas da tabela SC7 e 
antes da execu��o da fun��o Brwlegenda que monta a dialog com as legendas, 
utilizado para adicionar legendas na dialog. Deve ser usado em conjunto com o 
ponto MT120COR que manipula o Array com as regras para apresenta��o das cores 
dos status na mBrowse.

aNewLegenda(vetor)
Array de retorno contendo as novas legendas para a apresenta��o das cores do 
status do pedido de compras na mbrowse j� manipuladas pelo usuario. 

@param		aNewLegenda = Array de retorno contendo as novas legendas para a apresenta��o das cores 
@return		aRet = Legendas alteradas
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/

USER FUNCTION MT120LEG()
	LOCAL aNewLegenda  := aClone(PARAMIXB[1])  
	LOCAL aRet			:= {}

	aRet := U_ASCOMA09(aNewLegenda)

RETURN aRet