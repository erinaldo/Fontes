#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA13
Utilizado para contabilização do documento de entrada

@param		
@return		Conta de Despesa
@author 	Fabiano Albuquerque
@since 		13/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ASCTBA13()

Local cConta := ""
Local cRat	 := SD1->D1_RATEIO
 
IF cRat == "2"
	CTT->(MsSeek(xFilial("CTT")+SD1->D1_CC))
		
	IF CTT->CTT_XCLASS == "3" // Projeto Estoque PPI
		cConta := SB1->B1_XCTAPJP
	ElseIF CTT->CTT_XCLASS == "2"
		cConta := SB1->B1_XCTAPRJ // Projeto Estoque
	Else
		cConta := SB1->B1_CONTA // Despesas
	EndIF

EndIF


IF cRat == "1"
	CTT->(MsSeek(xFilial("CTT")+SDE->DE_CC))
	
	IF CTT->CTT_XCLASS == "3" // Projeto Estoque PPI
		cConta := SB1->B1_XCTAPJP
	ElseIF CTT->CTT_XCLASS == "2"
		cConta := SB1->B1_XCTAPRJ // Projeto Estoque
	Else
		cConta := SB1->B1_CONTA // Despesas
	EndIF

EndIF
	
Return cConta