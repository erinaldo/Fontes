#INCLUDE "PROTHEUS.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA55()

Retorna Valor liquido para SE1

@param		Nenhum
@return		nValor = Valor do título a receber
@author 	Fabiano Albuquerque
@since 		29/03/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------


User Function ASFINA55()

Local nValor := 0

nValor := SE1->E1_SALDO - SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDataBase,,,,,,,SE1->E1_FILIAL)

Return nValor
