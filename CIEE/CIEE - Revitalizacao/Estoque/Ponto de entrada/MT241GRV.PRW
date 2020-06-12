#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT241GRV
Ponto de entrada Após a gravação dos dados (aCols) no SD3.
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