#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA14()

Funcao para retornar o valor do titulo nos Cnabs Receber

Chamado no arquivo de configuração do CNAB Receber

@param		Nenhum
@return		_cRetorno = Valor do título a receber
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA14()

_nAbat    := SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,"R", 1,, SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
_cRetorno := SE1->(E1_VALOR + E1_ACRESC - E1_DECRESC)- _nAbat
_cRetorno := Substr(Strzero(_cRetorno*100,16,2),1,13)

Return _cRetorno
