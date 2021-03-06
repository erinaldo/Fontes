// Execblock que tem a fun��o de validar a inclus�o no campo E2_TIPO.
// Para valida��o ser� checado o parametro espec�fico CSU denominado MV_TPTITCP.
// O parametro MV_TPTITCP contem a rela��o de Tipos de t�tulos utilizados pelo 
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
		MsgAlert("O Tipo de T�tulo informado n�o � previsto para o Contas a Pagar !!!","Atencao!")
	EndIf
Else
	MsgAlert("N�o encontrado o par�metro MV_TPTITCP, espec�fico CSU, o mesmo deve conter a rela��o dos Tipo de T�tulos a serem utilizados pelo Contas a Pagar !!!","Atencao!")
EndIf	

DbSelectArea(_cArea)

Return _lOk