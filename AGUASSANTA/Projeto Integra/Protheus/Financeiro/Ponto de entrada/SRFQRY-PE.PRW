#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'                  
//-----------------------------------------------------------------------
/*/{Protheus.doc} SRFQRY()

Ponto de entrada na rotina FINRSRF
Permite alterar a query na sele��o dos titulos na gera��o do DARF

@param		Nenhum
@return		Express�o complementando a query
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function SRFQRY
Local cQry := Paramixb[1] 
	IF !EMPTY(cQry)
		cQry := U_ASFINA64(cQry)  // Exibe tela MarkBrowse para sele��o dos registrose  retorna o complemento da query
	ENDIF
Return(cQry)