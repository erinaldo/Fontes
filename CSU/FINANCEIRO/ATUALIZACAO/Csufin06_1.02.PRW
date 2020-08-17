// Execblock que tem a função de validar a inclusão no campo E1_TIPO.
// Para validação será checado o parametro específico CSU denominado MV_TPTITCR.
// O parametro MV_TPTITCR contem a relação de Tipos de títulos utilizados pelo 
// Contas a Receber.
// Data: 24/05/2002.

User Function CSUFIN06()

_cArea := Alias()
_lOk   := .f.

DbSelectArea("SX6")
DbSetOrder(1)
DbSeek( xFilial()+"MV_TPTITCR",.F.)

If Found()
	If M->E1_TIPO $ AllTrim(SX6->X6_CONTEUD)
		_lOk := .t.
	Else
		MsgAlert("O Tipo de Título informado não é previsto para o Contas a Receber !!!","Atencao!")
	EndIf
Else
	MsgAlert("Não encontrado o parâmetro MV_TPTITCR, específico CSU, o mesmo deve conter a relação dos Tipo de Títulos a serem utilizados pelo Contas a Receber !!!","Atencao!")
EndIf	

DbSelectArea(_cArea)

Return _lOk