#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
                        
// Ponto de entrada para complementar a gravação de dados nas tabelas SC5 e SC6
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