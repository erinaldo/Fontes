#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA15()

Funcao para retornar o valor do juros diario dos cnab a
receber

Chamado no arquivo de configuração do CNAB Receber

@param		Nenhum
@return		_cRetorno = Valor do juros diario
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA15()

Local _nAbat
Local _cRetorno 
Local _TxJur := IF(EMPTY(SE1->E1_VALJUR),GetMv("AS_MORAD"),SE1->E1_VALJUR)
Local _DiaAtr:=0


IF date() > SE1->E1_VENCTO
	_DiaAtr := date() - SE1->E1_VENCTO
EndIF

_nAbat    := SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,"R", 1,, SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
_cRetorno := SE1->E1_SALDO - _nAbat
_cRetorno := ROUND( ( _cRetorno*(_TxJur/100) ) * _DiaAtr, 2 )
_cRetorno := Substr(Strzero(_cRetorno*100,16,2),1,13)


Return _cRetorno