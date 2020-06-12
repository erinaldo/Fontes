#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
                        
// Ponto de entrada para validar Inclusão/Alteração do Produto antes da gravação
User Function A010TOK()

Local aArea := GetArea()
Local _lRet	:= .T.

// Valida o campo B1_XUNIFRH
If Left(M->B1_COD,4,1)=="05.0"		// quando grupo for 05=Uniformes e posição 4 do código for 0=controla estoque
	If Empty(M->B1_XUNIFRH)			// campo obrigatório
		MsgAlert("Campo 'Uniforme RH' é obrigatório","Atenção!")
		_lRet := .F.
	EndIf
EndIf

RestArea(aArea)

Return(_lRet)