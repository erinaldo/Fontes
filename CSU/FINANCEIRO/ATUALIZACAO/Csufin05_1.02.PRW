// Execblock que tem a função de validar a inclusão no campo E2_TIPO.
// Para validação será checado o parametro específico CSU denominado MV_TPTITCP.
// O parametro MV_TPTITCP contem a relação de Tipos de títulos utilizados pelo 
// Contas a Pagar.
// Data: 24/05/2002.

User Function CSUFIN05()

_cArea := Alias()
_lOk   := .f.

DbSelectArea("SX6")
DbSetOrder(1)
DbSeek( xFilial()+"MV_TPTITCP",.F.)

If Found()
	If M->E2_TIPO $ AllTrim(SX6->X6_CONTEUD)
		_lOk := .t.
	Else
		MsgAlert("O Tipo de Título informado não é previsto para o Contas a Pagar !!!","Atencao!")
	EndIf
Else
	MsgAlert("Não encontrado o parâmetro MV_TPTITCP, específico CSU, o mesmo deve conter a relação dos Tipo de Títulos a serem utilizados pelo Contas a Pagar !!!","Atencao!")
EndIf	

DbSelectArea(_cArea)

Return _lOk