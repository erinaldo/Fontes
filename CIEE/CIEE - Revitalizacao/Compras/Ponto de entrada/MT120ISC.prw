#include "protheus.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT120ISC
Ponto de Entrada no Pedido de Compras <F4> para trazer as Solicitacoes de Compras em aberto 
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT120ISC()
Local _lRet			:= .T.
Local _nPosaCols 	:= ASCAN(ACOLS,{|X| X[2]+X[3]+X[4] == SC1->C1_NUM+ SC1->C1_ITEM+SC1->C1_PRODUTO })
Local _nPosaHeader 	:= ASCAN(AHEADER,{|X| alltrim(X[2]) == "C7_XESPEC" })

If _nPosaCols > 0
	aCols[_nPosaCols, _nPosaHeader] := SC1->C1_XESPEC
EndIf

Return(_lRet)