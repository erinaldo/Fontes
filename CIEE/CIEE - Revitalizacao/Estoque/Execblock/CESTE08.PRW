#INCLUDE "rwmake.ch"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE08
Consistir requisicao de estoque sem repeticao de codigo, ativado no ValidUser SX3 do campo D3_COD  
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera��es Realizadas desde a Estrutura��o Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
USER FUNCTION CESTE08()
local _cRet
local _nI
                           
_cRet:= .T.
For _nI:=1 to Len(Acols)                           
   If Acols[_nI,2] == Acols[n,2] .And. _nI<>n                 
   	  MsgAlert("Produto:"+AllTrim(Acols[n,2])+" j� utilizado no Documento", OemToAnsi("Aten��o"))
      _cRet := .F.
   EndIf   
Next _nI

Return(_cRet)   