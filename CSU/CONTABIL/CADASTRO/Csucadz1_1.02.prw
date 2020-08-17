#INCLUDE "rwmake.ch"

// *** Rotina de manuten��o do cadastro SZ1 - Conf. Naturezas Financeiras X C.Contabil
// *** Este cadastro ser� utilizado pelos Lan�amentos Padr�es referentes ao m�dulo
// *** Financeiro. No mesmo ser� informado a amarra��o Naturezas Financeiras X
// *** C.Contabil.
// *** Data: 19/04/2002

User Function CSUCADZ1

cArea := Alias()

DbSelectArea("SZ1")

AxCadastro("SZ1"," Conf. Naturezas Financeiras X C.Cont�beis",".T.","ExecBlock('VLINC_Z1')")

DbSelectArea(cArea)

Return

// **********************************************
User Function VLINC_Z1
// Fun��o de valida��o da inclus�o / altera��o no SZ1.

lOk := .t.

If Empty(M->Z1_NATUREZ) .and. lOk = .t.
	MsgAlert("O campo Natureza Financeira DEVE ser preenchido !!!","Atencao!")
	lOk := .f.
EndIf

If SED->ED_RECDEP = "D" .and. Empty(M->Z1_GRUPOCC) .and. lOk = .t.
	MsgAlert("O campo Grupo CC DEVE ser preenchido para Natureza Financeira de Despesa !!!","Atencao!")
	lOk := .f.
EndIf

If SED->ED_RECDEP = "R" .and. ALLTRIM(M->Z1_GRUPOCC)<>"00" .and. lOk = .t.
	//If SED->ED_RECDEP = "R" .and. !Empty(M->Z1_GRUPOCC) .and. lOk = .t.
	MsgAlert("O campo Grupo CC N�O DEVE ser preenchido para Natureza Financeira de Receita !!!","Atencao!")
	lOk := .f.
EndIf

If Empty(M->Z1_CCONTAB) .and. lOk = .t.
	MsgAlert("O campo C.Cont�bil DEVE ser preenchido !!!","Atencao!")
	lOk := .f.
EndIf

If lOk = .t.
	
	_aAreaSZ1 := {}
	
	DbSelectArea("SZ1")
	
	If ALTERA = .t.
		
		_aAreaSZ1 := GetArea()
		//		cArea := Alias()
		//		nInd  := SetIndex()
		//		nREg  := REcno()
	EndIf
	
	DbSetOrder(1)
	DbSeek( xFilial()+M->Z1_NATUREZ+M->Z1_GRUPOCC,.F. )
	
	If Found()
		MsgAlert("Registro j� cadastrado !!! Verifique.","Atencao!")
		lOk := .f.
	EndIf
	
	If ALTERA = .t.
		
		RestArea(_aAreaSZ1)
		//		DbSelectArea(cArea)   04/07/02
		//		DbSetOrder(nInd)
		//		Go nREg
	EndIf
	
EndIf

Return lOk
