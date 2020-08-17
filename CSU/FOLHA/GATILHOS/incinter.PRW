#include "rwmake.ch"

User Function IncInter

Local	oDlg	:= NIL


@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Preenche campo Dt.Inclusao Intermedica")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(" Essa rotina fara o preenchimento do campo Data de Inclusao na  ")
@ 030,020 SAY OemToAnsi(" Intermedica, conf. a funcao do funcionario  ")
@ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )
@ 095,072 BUTTON OemToAnsi(" Preenche Data " ) SIZE 55,13 ACTION Eval( { || MigraSra() }  )
@ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

Static function MigraSra()

#IFDEF WINDOWS
	Processa({|| ImpSra() },"Preenchendo Campo...Aguarde !!!")
#ENDIF


Static Function Impsra()

Local aArea   := GetArea()
Local dMdDtin := Ctod("//")
Local cPlanos := "35*36"


dbSelectArea("SRA")
dbGoTop()
ProcRegua(RecCount())

WHILE !EOF()
	
	If (Sra->Ra_SitFolh == "D") .or. ( !(Alltrim(Sra->Ra_AsMedic) $ cPlanos) .and. !(Empty(Sra->Ra_MdDtIn)) )
		dbSkip()
		Loop
	Endif
	
	If  !(Alltrim(Sra->Ra_AsMedic) $ cPlanos)
		dbSkip()
		Loop
	Endif
	
	If  !(Empty(Sra->Ra_MdDtIn))
		dbSkip()
		Loop
	Endif
	
	If AllTrim(Posicione("SRJ",1,xFilial("SRJ")+Sra->Ra_CodFunc,"RJ_NIVEL")) == "O"
		dMdDtin :=STOD(ANOMES(Sra->RA_ADMISSA+120)+"01")
	Else
		dMdDtin := Sra->Ra_Admissa
	Endif
	
	RecLock("SRA",.F.)
	Sra->Ra_MdDtIn := dMdDtin
	msUnlock()
	
	Sra->(dbskip())
	
EndDo

#IFDEF WINDOWS
	MsgAlert ("Preenchimento Finalizado")
#ELSE
	Alert("Preenchimento Finalizado")
#ENDIF

RETURN
