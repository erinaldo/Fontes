#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT110GRV()

LOCALIZA��O : Function A110GRAVA - Fun��o da Solicita��o de Compras 
responsavel pela grava��o das SCs.

EM QUE PONTO : No laco de grava��o dos itens da SC na fun��o A110GRAVA, 
executado ap�s gravar o item da SC, a cada item gravado da SC o ponto � 
executado.

@param		Nenhum 
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		02/02/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT110GRV()
lExp1 :=  PARAMIXB[1]

U_ASCOMA40()// Fun��o utilizada para liberar as solicita��es de compra 

Return

