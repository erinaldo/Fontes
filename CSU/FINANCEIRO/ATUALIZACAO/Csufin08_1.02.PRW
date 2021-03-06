
// Execblock que tem a fun��o de gerar o n�mero dos T�tulos a Receber de forma 
// autom�tica.
// Para a gera��o automatica do n�mero dos titulos, ser� verificado o parametro 
// MV_NRAUTCR. O mesmo guarda a rela��o de Tipos de Titulos que devem ter gera��o
// automatica. Os Tipos de Titulos que n�o estivem relacionados neste parametro, n�o
// ter�o gera��o automatica. O n�mero dever� ser digitado pelos usuarios.
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
	MsgAlert("N�o encontrado o par�metro MV_NRAUTCR, espec�fico CSU, o mesmo deve conter a rela��o dos Tipo de T�tulos a Receber que ter�o a gera��o do n�mero de forma autom�tica !!!","Atencao!")
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