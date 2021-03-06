#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT241GRV
Ponto de entrada Ap�s a grava��o dos dados (aCols) no SD3.
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
User Function MT241GRV()
Local aArea := GetArea()
Local aAreaSD3 := SD3->(GetArea())

If Empty(SD3->D3_XUSERLG)
	RecLock("SD3",.F.)
	SD3->D3_XUSERLG := UsrRetName(RetCodUsr())
	SD3->(MsUnLock())
EndIf

RestArea(aAreaSD3)
RestArea(aArea)
Return(.T.)