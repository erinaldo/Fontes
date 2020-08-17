User Function ACB003()
Local 	aSay       := {}
Local 	aButton    := {}
Local 	nOpc       := 0
Local 	cTitulo    := ""
Local	cDesc1     := "Esta rotina ira tentar preencher o nome da mãe"
Local	cDesc2 	   := "de dependentes que não estejam cadastradas."
Local	cDesc3 	   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oGeraTxt
Private cAlias    := "SRB"   //alias do arquivo a exportar
Private cDir      := ''


dbSelectArea(cAlias)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpc := 0
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aButton, { 1, .T., { || NOPC := 1, FechaBatch()            } } )
aAdd( aButton, { 2, .T., { || nOpc := 2, FechaBatch()            } } )
	
FormBatch( cTitulo, aSay, aButton )
	
If nOpc <> 1
	Return NIL
EndIf

Processa({|| OkGeraTxt() },"Processando...")

Return Nil


Static Function OkGeraTxt()
Local cNome  := ""
Local nPos   := 0 
Local cFilRB := ""
Local cMatRB := ""

dbSelectArea("SRB")
dbSetOrder(1)

ProcRegua(RecCount())

While !Eof()
	IncProc()
	If Empty(SRB->RB_MAE) .and. SRB->RB_GRAUPAR = "F" .AND. SRB->RB_ASSIMED = "S"
		cNome := ""
		dbSelectArea("SRA")
		dbSetOrder(1)
		if dbSeek(SRB->RB_FILIAL + SRB->RB_MAT)
			if SRA->RA_SEXO = "F"
				cNome := SRA->RA_NOME
			Endif
		Endif
		dbSelectArea("SRB")		
	    nPos := Recno()
	    cFilRB := SRB->RB_FILIAL
	    cMatRB := SRB->RB_MAT
	    if Empty(cNome) 
	    	dbSeek( cFilRB + cMatRB)
			While !eof() .and. cMatRB == SRB->RB_MAT .and. cFilRB == SRB->RB_FILIAL
				If SRB->RB_GRAUPAR = "C" .and. SRB->RB_SEXO = "F" .and. SRB->(recno()) <> nPos
					cNome := SRB->RB_NOME
				Endif
				dbSkip()
			End
            dbGoto(nPos)
	    Endif
	    if !Empty(cNome)
	    	RecLock("SRB", .F.)
	    	SRB->RB_MAE := cNome
	    	MsUnlock()
	    Endif
	Endif
	dbSkip()
End

Return nil