#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DATAINTER º Autor ³ Isamu Kawakami     º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina temporaria que preenchera a Dt.Inclusao no Plano     ±±
±±º          ³ Intermedica, conf. a funcao: Operacionais 90 dias           ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DataInter

Local oDlg	:= NIL

@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Preenche data inicio vigencia na Intermedica")
@ 008,010 TO 084,222
//@ 018,020 SAY OemToAnsi(" A conversao dos arquivos serão realizados apos confirmacao no botao ")
//@ 030,020 SAY OemToAnsi(" de OK ")
//@ 095,042 BMPBUTTON TYPE 5 					    ACTION Eval( { || fPergConv() , Pergunte(cPerg,.T.) } )
@ 095,072 BUTTON OemToAnsi(" Inicia Processo " ) SIZE 55,13 ACTION Eval( { || Intermed() }  )
@ 095,187 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return( NIL )


Static Function Intermed

#IFDEF WINDOWS
	Processa({|| ImpInt() },"Preenchendo Datas...Aguarde !!!")
#ENDIF

Return


Static Function ImpInt


dbSelectarea("SRA")
dbSetOrder(1)

ProcRegua(Sra->(RecCount()))

While !Eof()
	
	
	If Sra->Ra_AsMedic == "27".AND.SRA->RA_SITFOLH<>'D'.AND.SRA->RA_ADMISSA>=CTOD("01/02/2010")
			
		If AllTrim(Posicione("SRJ",1,xFilial("SRJ")+Sra->Ra_CodFunc,"RJ_NIVEL")) == "O"
			RecLock("SRA",.F.)
			Sra->Ra_MdDtIn := STOD(ANOMES(Sra->RA_ADMISSA+120)+"01")
			MsUnlock()
		Else
			RecLock("SRA",.F.)
			Sra->Ra_MdDtIn := Sra->Ra_Admissa
			MsUnlock()
		Endif
		
	Endif
	
	Sra->(dbSkip())
	
EndDo


#IFDEF WINDOWS
	MsgAlert ("Campo Inicio Vigencia Intermedica preenchido com sucesso !!!")
#ELSE
	Alert("Campo Inicio Vigencia Intermedica preenchido com sucesso !!!")
#ENDIF


Return
