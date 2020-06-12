#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA16()

Funcao para retornar o valor do juros mora

Chamado na função (Impressao de Boleto)

@param		Nenhum
@return		_cRetorno = Valor do juros mora
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA16()

_nAbat    := SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,"R", 1,, SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
_cRetorno := SE1->E1_SALDO - _nAbat
_cRetorno := ((_cRetorno*GetMv("MV_MORAD"))/30)         
_cRetorno := Substr(Strzero(_cRetorno*100,16,2),1,13)
_cRetorno := NoRound(Val(_cRetorno)/100,2)
_cRetorno := "Apos Vencimento Cobrar Mora Diaria de R$ "+Alltrim(STR(_cRetorno,12,2))

Return _cRetorno