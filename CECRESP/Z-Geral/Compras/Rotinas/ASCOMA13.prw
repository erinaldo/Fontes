#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA13()

Adiciona campos no cabeçalho do pedido de compras
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
@since 		23/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA13(oNewDialog, aPosGet, aObj, nOpcx, nReg)
	LOCAL _oEHCT

	PUBLIC _cEHCT	:= ""

	SX3->( dbSetOrder(2) )
	IF SX3->( MsSeek("C7_XEHCT") )
		_cEHCT := IIF(nOpcx == 3,"2",IIF(!EMPTY(SC7->C7_XEHCT),SC7->C7_XEHCT,"2"))

		@ aPosGet[1][1]+41,aPosGet[2,5]-12 SAY RetTitle("C7_XEHCT") OF oNewDialog PIXEL SIZE 60,06 // Contrato TOP 1=SIM, 2=NÃO

		@ aPosGet[1][1]+40,aPosGet[2,6]-25 COMBOBOX _oEHCT VAR _cEHCT ITEMS StrTokArr(x3cbox(),';') PIXEL SIZE 60,06  ;
		WHEN (nOpcx == 3 .OR. nOpcx == 4) OF oNewDialog PIXEL
	ENDIF

RETURN