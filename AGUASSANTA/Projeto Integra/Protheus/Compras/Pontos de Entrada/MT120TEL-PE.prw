#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT120TEL()

Adiciona campos no cabe�alho do pedido de compras

LOCALIZA��O : Function A120PEDIDO - Fun��o do Pedido de Compras 
responsavel pela inclus�o, altera��o, exclus�o e c�pia dos PCs.

EM QUE PONTO : Se encontra dentro da rotina que monta a dialog do pedido 
de compras antes  da montagem dos folders e da chamada da getdados.

@param		oNewDialog  = 	Objeto da Dialog do Pedido de Compras
			aPosGet     = 	Array contendo a posi��o dos gets do pedido de 
							compras
			aObj        = 	Array contendo os objetos relacionados aos 
							campos dos folders do Pedido de Compras
			nOpcx       = 	Op��o Selecionada no Pedido de Compras (inclus�o,
			 				altera��o, exclus�o, etc ..)
			nReg        = 	N�mero do recno do registro do pedido de compras 
							selecionado. 
 
@return		Nenhum
@author 	Fabio Cazarini
@since 		23/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT120TEL()
	LOCAL oNewDialog  := PARAMIXB[1]
	LOCAL aPosGet     := PARAMIXB[2]
	LOCAL aObj        := PARAMIXB[3]
	LOCAL nOpcx       := PARAMIXB[4]
	LOCAL nReg        := PARAMIXB[5] 

	//-----------------------------------------------------------------------
	//Se copia (nOpcX == 6), limpa campos de controle customizados
	//-----------------------------------------------------------------------
	U_ASCOMA27(oNewDialog, aPosGet, aObj, nOpcx, nReg)

	//-----------------------------------------------------------------------
	//Adiciona campos no cabe�alho do pedido de compras
	//-----------------------------------------------------------------------
	U_ASCOMA13(oNewDialog, aPosGet, aObj, nOpcx, nReg)

RETURN