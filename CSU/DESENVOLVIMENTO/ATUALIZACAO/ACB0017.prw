#INCLUDE "PROTHEUS.CH"

User Function ACB0017()
Local 	aSay       := {}
Local 	aButton    := {}
Local 	nOpc       := 0
Local 	cTitulo    := ""
Local	cDesc1     := "Acerto dos flags de exportacao utilizados "
Local	cDesc2 	   := "para controle com a Intermedica e Notredame"
Local	cDesc3 	   := "Marcar para exportar Notredame"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oGeraTxt
Private cAlias    := "SRA"   //alias do arquivo a exportar
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

Processa({|| RunProc() },"Processando...")

Return nil

Static Function runProc()
Local aAreaAnt  := GetArea()

ProcRegua(SRA->(RecCount()))
dbSelectArea("SRA")
dbSetOrder(1)
dbGotop()
While !eof()
	IncProc("Processando 1...")
	if Empty(SRA->RA_MDDTIN) .and. SRA->RA_ASMEDIC$"28/29/30/31/32"
		dDtIni := RetIni()
		RecLock("SRA", .F.)
		SRA->RA_MDDTIN := dDtIni
	    Msunlock()
	Endif
	dbSelectArea("SRA")
	dbSkip()
End


ProcRegua(SRA->(RecCount()))
dbSelectArea("SRA")
dbSetOrder(1)
dbGotop()
While !eof()
	IncProc("Processando 2...")
	if left(dtos(SRA->RA_MDDTIN),6) >= "200707" .and. SRA->RA_ASMEDIC$"28/29/30/31/32"
		RecLock("SRA", .F.)
		SRA->RA_MDINC := "N"
	    Msunlock()
	Endif
	dbSelectArea("SRA")
	dbSkip()
End

ProcRegua(SRB->(RecCount()))
dbSelectArea("SRB")
dbSetOrder(1)
dbGotop()
While !eof()
	IncProc("Processando 3...")
	dbSelectArea("SRA")
	dbSetOrder(1)
	if dbSeek( SRB->(RB_FILIAL+RB_MAT) )
		if left(dtos(SRA->RA_MDDTIN),6) >= "200707" .and. SRA->RA_ASMEDIC$"28/29/30/31/32"
			RecLock("SRB", .F.)
			SRB->RB_MDINC := "N"
		    Msunlock()
		Endif
	Endif
	dbSelectArea("SRB")
	dbSkip()
End


RestArea(aAreaAnt)
Return nil



Static Function RetIni()
local dRet := ctod( " " )
Local aArea := GetArea()
Local dDtAdms := SRA->RA_ADMISSA
dbSelectArea("SRJ")
dbSetOrder(1)

if dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC )
    if aLLTRIM(SRJ->RJ_NIVEL) == "O"  
    	dDtAdms := SRA->RA_ADMISSA + GetMv("ES_PRZINI",,90)
    	dDtAdms := cTod( "01/" + strZero(month(dDtAdms),2) + "/" + strZero(Year(dDtAdms),4) )
    Endif
Endif

dRet := dDtAdms
RestArea(aArea)
Return(dRet)
