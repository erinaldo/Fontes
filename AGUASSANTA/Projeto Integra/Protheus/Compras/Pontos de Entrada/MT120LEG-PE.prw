#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//------------------------------------------------------------------------------
/*/{Protheus.doc} MT120LEG()
Manipula apresentação das cores na mBrowse

LOCALIZAÇÃO : Function A120Legend - Função da dialog de legendas da mbrowse do 
Pedido de Compras e Autorização de Entrega.

EM QUE PONTO : Após a montagem do Array contendo as legendas da tabela SC7 e 
antes da execução da função Brwlegenda que monta a dialog com as legendas, 
utilizado para adicionar legendas na dialog. Deve ser usado em conjunto com o 
ponto MT120COR que manipula o Array com as regras para apresentação das cores 
dos status na mBrowse.

aNewLegenda(vetor)
Array de retorno contendo as novas legendas para a apresentação das cores do 
status do pedido de compras na mbrowse já manipuladas pelo usuario. 

@param		aNewLegenda = Array de retorno contendo as novas legendas para a apresentação das cores 
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