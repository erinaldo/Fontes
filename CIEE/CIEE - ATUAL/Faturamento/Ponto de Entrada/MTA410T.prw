#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
                        
// Ponto de entrada para complementar a gravação de dados nas tabelas SC5 e SC6
User Function MTA410T()

Local aArea := GetArea()
Local aAreaSC5 := SC5->(GetArea())

If Empty(SC5->C5_XUSERLG)
	RecLock("SC5",.F.)
	SC5->C5_XUSERLG := UsrRetName(RetCodUsr())
	SC5->(MsUnLock())
EndIf

RestArea(aAreaSC5)
RestArea(aArea)

Return(.T.)