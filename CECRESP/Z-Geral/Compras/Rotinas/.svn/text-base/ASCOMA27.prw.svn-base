#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA27()

Se copia (nOpcX == 6), limpa campos de controle customizados
Chamado pelo PE MT120TEL

@param		oNewDialog  = 	Objeto da Dialog do Pedido de Compras
			aPosGet     = 	Array contendo a posição dos gets do pedido de 
							compras
			aObj        = 	Array contendo os objetos relacionados aos 
							campos dos folders do Pedido de Compras
			nOpcx       = 	Opção Selecionada no Pedido de Compras (inclusão,
			 				alteração, exclusão, etc ..)
			nReg        = 	Número do recno do registro do pedido de compras 
							selecionado. 
 
@return		Nenhum
@author 	Fabio Cazarini
@since 		21/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA27(oNewDialog, aPosGet, aObj, nOpcx, nReg)
	LOCAL nX := 0
	
	IF nOpcx == 6 // copia
		FOR nX := 1 TO LEN(aCols)
			GDFieldPut("C7_XNFLUIG", SPACE(TAMSX3("C7_XNFLUIG")[1]), nX)
			GDFieldPut("C7_XAPROVA", SPACE(TAMSX3("C7_XAPROVA")[1]), nX)
			GDFieldPut("C7_XAPRNIV", SPACE(TAMSX3("C7_XAPRNIV")[1]), nX)
			GDFieldPut("C7_XAPRNOM", SPACE(TAMSX3("C7_XAPRNOM")[1]), nX)
			GDFieldPut("C7_XSFLUIG", SPACE(TAMSX3("C7_XSFLUIG")[1]), nX)
		NEXT nX
	ENDIF
	
RETURN