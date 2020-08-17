
// Execblock que tem a função de gerar o número dos Títulos a Receber de forma 
// automática.
// Para a geração automatica do número dos titulos, será verificado o parametro 
// MV_NRAUTCR. O mesmo guarda a relação de Tipos de Titulos que devem ter geração
// automatica. Os Tipos de Titulos que não estivem relacionados neste parametro, não
// terão geração automatica. O número deverá ser digitado pelos usuarios.
// Data: 28/05/2002.    
// Ponto de Disparo: Gatilho disparado do campo E1_TIPO.

User Function CSUFIN08()

_cArINI := GetArea()
_lOk    := .f.
_nNum   := ""

DbSelectArea("SX6")
DbSetOrder(1)
DbSeek( xFilial()+"MV_NRAUTCR",.F.)

If Found()
	If M->E1_TIPO $ AllTrim(SX6->X6_CONTEUD)
		_lOk := .t.
	EndIf		
Else
	MsgAlert("Não encontrado o parâmetro MV_NRAUTCR, específico CSU, o mesmo deve conter a relação dos Tipo de Títulos a Receber que terão a geração do número de forma automática !!!","Atencao!")
EndIf	

If _lOk = .t.  

	DbSelectArea("SE1")
	
	_cAreaE1 := GetArea()
	_cTipoE1 := M->E1_TIPO
	
	DbSetOrder(15)
	DbSeek( xFilial()+_cTipoE1+"999999",.T. )

	DbSkip(-1)

	If SE1->E1_TIPO = _cTipoE1
		_nNum := StrZero(Val(SE1->E1_NUM)+1,6)
	Else 
		_nNum := "000001"
	EndIf
       
	RestArea(_cAreaE1)       
	
EndIf	

RestArea(_cArINI)

Return _nNum