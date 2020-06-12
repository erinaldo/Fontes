#INCLUDE "rwmake.ch"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE09 
Gatilho no campo SD3->D3_COD para o campo D3_SLDEST
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
USER FUNCTION CESTE09()

_nQtdDisp	:= 0
_cAnoCont	:= Year(dDataBase)+1
_nSaldo 	:= CalcEst(SB1->B1_COD, SB1->B1_LOCPAD, LastDay(ctod("01/12/"+Str(_cAnoCont,4))))

_nQtdDisp 	:= iif(!Empty(_nSaldo),_nSaldo[1],0)

Return(_nQtdDisp)