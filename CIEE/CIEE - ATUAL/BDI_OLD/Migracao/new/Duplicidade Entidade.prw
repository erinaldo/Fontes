#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  11/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DUP_ENT()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oLeTxt

dbSelectArea("SUM")

dbSelectArea("SU5")

dbSelectArea("SZM")

dbSelectArea("SZR")

DbSelectArea("AC8")

DbSelectArea("SZY")
                   
DbSelectArea("SZS")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Verifica Duplicidade na Entidade")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "                                                            "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  11/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt

Processa({|| RunCont() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  11/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont
/*
alert("ITEM AC8")
DbSelectArea("AC8")
DbSetOrder(1)
DbGotop()
ProcRegua(RecCount())

_nCod := 0

Do While !EOF()
	IncProc()

	_cCodCon := AC8->AC8_CODCON
	_nCod+=1
	_nItem := 0

	Do While AC8->AC8_CODCON == _cCodCon
		_nItem++
		RecLock("AC8",.F.)
		AC8->AC8_ITEM := strzero(_nItem,4)
		MSUnLock()
		DbSelectArea("AC8")
		DbSkip()
	EndDo

EndDo

alert("ITEM SZY")
DbSelectArea("SZY")
DbSetOrder(2)
DbGotop()
ProcRegua(RecCount())

_nCod := 0

Do While !EOF()
	IncProc()

	_cCodCon := SZY->ZY_CODCONT
	_nCod+=1
	_nItem := 0

	Do While SZY->ZY_CODCONT == _cCodCon
		_nItem++
		RecLock("SZY",.F.)
		SZY->ZY_ITEM := strzero(_nItem,4)
		MSUnLock()
		DbSelectArea("SZY")
		DbSkip()
	EndDo

EndDo

alert("SZS-J")
dbSelectArea("SZM")
dbSetOrder(1)
dbSeek(xFilial("SZM")+"006116")
dbskip()
ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()
	IncProc()

	RecLock("SZS",.T.)
	SZS->ZS_FILIAL 	:= "01"
	SZS->ZS_ITEM   	:= "0001"
	SZS->ZS_CODENT	:= SZM->ZM_CODENT
	SZS->ZS_TIPO	:= "J"
	SZS->ZS_END		:= SZM->ZM_END
	SZS->ZS_TIPOEND	:= "2"
	SZS->ZS_BAIRRO	:= SZM->ZM_BAIRRO
	SZS->ZS_MUN		:= SZM->ZM_MUN
	SZS->ZS_EST  	:= SZM->ZM_EST
	SZS->ZS_CEP  	:= SZM->ZM_CEP
	SZS->ZS_DDD 	:= SZM->ZM_DDD
	SZS->ZS_FONE 	:= ""
	SZS->ZS_FCOM1 	:= SZM->ZM_FCOM1
	SZS->ZS_FAX  	:= SZM->ZM_FAX
	SZS->ZS_ENDPAD  := "2"
	SZS->ZS_NOMENT  := SZM->ZM_NOME
	MSUnLock()

	dbSelectArea("SZM")
	DbSkip()
EndDo

alert("SZS-F")
dbSelectArea("SU5")
dbSetOrder(1)
dbSeek(xFilial("SU5")+"016181")
dbskip()
ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()
	IncProc()

	RecLock("SZS",.T.)
	SZS->ZS_FILIAL 	:= "01"
	SZS->ZS_ITEM   	:= "0001"
	SZS->ZS_CODCONT := SU5->U5_CODCONT
	SZS->ZS_CODENT	:= ""
	SZS->ZS_TIPO	:= "F"
	SZS->ZS_END		:= SU5->U5_END
	SZS->ZS_TIPOEND	:= SU5->U5_TIPOEND
	SZS->ZS_BAIRRO	:= SU5->U5_BAIRRO
	SZS->ZS_MUN		:= SU5->U5_MUN
	SZS->ZS_EST  	:= SU5->U5_EST
	SZS->ZS_CEP  	:= SU5->U5_CEP
	SZS->ZS_DDD 	:= SU5->U5_DDD
	SZS->ZS_FONE 	:= SU5->U5_FONE
	SZS->ZS_FCOM1 	:= SU5->U5_FCOM1
	SZS->ZS_FAX  	:= SU5->U5_FAX
	SZS->ZS_ENDPAD  := "2"
	SZS->ZS_NOMCONT := SU5->U5_CONTAT
	MSUnLock()

	dbSelectArea("SU5")
	DbSkip()
EndDo

alert("SZR")
DbSelectArea("SZQ")
DbSetOrder(2)
DbSeek(xFilial("SZQ")+ "016180")
DbSkip()

ProcRegua(RecCount())

Do While !EOF()
	IncProc()

	_CFILIAL 	:= SZQ->ZQ_FILIAL
	_CITEM 		:= SZQ->ZQ_ITEM
	_CCODCONT	:= SZQ->ZQ_CODCONT
	_CCODENT 	:= SZQ->ZQ_CODENT
	_CGRUPO 	:= SZQ->ZQ_GRUPO

	DbSelectArea("SU5")
	DbSetOrder(1)
	If DbSeek(xFilial("SU5")+ SZQ->ZQ_CODCONT)
		_CCARGO		:= SU5->U5_CARGO
		_CDESCCAR	:= SU5->U5_DESC
		_CCODTRAT	:= SU5->U5_NIVEL
		_CDESCRI	:= SU5->U5_DNIVEL
	EndIf

	RecLock("SZR",.T.)
	SZR->ZR_FILIAL 	:= _CFILIAL
	SZR->ZR_ITEM 	:= _CITEM
	SZR->ZR_CODCONT	:= _CCODCONT
	SZR->ZR_CODENT 	:= _CCODENT
	SZR->ZR_GRUPO 	:= _CGRUPO
	SZR->ZR_CARGO 	:= _CCARGO
	SZR->ZR_DESC 	:= _CDESCCAR
	SZR->ZR_CODTRAT	:= _CCODTRAT
	SZR->ZR_DESCRI 	:= _CDESCRI
	SZR->ZR_TRAT 	:= ""

	MsUnLock()

	DbSelectArea("SZQ")
	DbSkip()

EndDo

alert("SZT")
DbSelectArea("SZQ")
DbSetOrder(2)
DbSeek(xFilial("SZQ")+ "016180") 
DbSkip()

ProcRegua(RecCount())

Do While !EOF()
	IncProc()

	_CFILIAL 	:= SZQ->ZQ_FILIAL
	_CITEM 		:= SZQ->ZQ_ITEM
	_CCODCONT	:= SZQ->ZQ_CODCONT
	_CCODENT 	:= SZQ->ZQ_CODENT
	_CGRUPO 	:= SZQ->ZQ_GRUPO

	RecLock("SZT",.T.)
	SZT->ZT_FILIAL 	:= ""//_CFILIAL
	SZT->ZT_ITEM 	:= _CITEM
	SZT->ZT_CODCONT	:= _CCODCONT
	SZT->ZT_CODENT 	:= _CCODENT
	SZT->ZT_CODEND 	:= _CITEM
	DbSelectArea("SZS")
	DbSetOrder(2)
	_cEnd  := ""
	If DbSeek(xFilial("SZS")+"J"+SZT->ZT_CODENT)
		_cEnd  := SZS->ZS_END
	EndIf
	SZT->ZT_END 	:= _cEnd
	SZT->ZT_ENDPAD 	:= "2"
	MsUnLock()

	DbSelectArea("SZQ")
	DbSkip()

EndDo

alert("AJUSTA SZT COM END PADRAO")
DbSelectArea("SZS")
DbSetOrder(1)
DbSeek(xFilial("SZS")+"F"+"016181")
ProcRegua(RecCount())
Do While !EOF()
	IncProc()
	If SZS->ZS_TIPO = "F"
		DbSelectArea("SZT")
		DbSetOrder(1)
		If DbSeek(xFilial("SZT")+SZS->ZS_CODCONT)
			DbSelectArea("SZT")
			RecLock("SZT",.F.)
			SZT->ZT_ENDPAD := "1"
			MsUnLock()
			DbSelectArea("SZS")
			RecLock("SZS",.F.)
			SZS->ZS_ENDPAD := "2"
			MsUnLock()
		EndIf
	Else
		Exit
	EndIf
	DbSelectArea("SZS")
	DbSkip()
	
EndDo
*/
ALERT("CEP - SU5")
DbSelectArea("SU5")
DbSetOrder(9) //ID
DbGotop()

dbUseArea(.T., "DBFCDX", "NCEPCONT" , "TMP", .F., .F.)
DbGotop()

ProcRegua(RecCount())

Do While !EOF()
	IncProc()

	DbSelectArea("SU5")
	DbSetOrder(9) //ID
	If DbSeek(xFilial("SU5")+alltrim(str(TMP->ID)))
		RecLock("SU5",.F.)
		SU5->U5_CEP := ALLTRIM(STRZERO(TMP->CEP,8))
		MsUnLock()	
	EndIf

	DbSelectArea("TMP") 
	DbSkip()
EndDo
/*
ALERT("CEP - SZM") 
DbSelectArea("SZM")
DbSetOrder(3) //NOME
DbGotop()

dbUseArea(.T., "DBFCDX", "NCEPENT" , "TMP1", .F., .F.)
DbGotop()

ProcRegua(RecCount())

Do While !EOF()
	IncProc()

	RecLock("SZM",.F.)
	SZM->ZM_CEP := ALLTRIM(STRZERO(TMP1->ZM_CEP,8))
	MsUnLock()	

	DbSelectArea("SZM")
	DbSkip()

	DbSelectArea("TMP1")
	DbSkip()

EndDo
*/
Close(oLeTxt)

Return

/*
------------------------------------------------------------------------------
DUPLICIDADE NA TABELA E DELETA O REGISTRO ENTIDADE
------------------------------------------------------------------------------
dbSelectArea("SZM")
dbSetOrder(2)

ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()

	IncProc()
	_nCont   := 0
	_cNomEnt := SZM->ZM_NOME

	Do While SZM->ZM_NOME == _cNomEnt
		_nCont++
		If _nCont > 1
			RecLock("SZM",.F.)
			dbDelete()
			MSUnLock()
		EndIf
		DbSkip()
	EndDo

EndDo
------------------------------------------------------------------------------
REPLICA NOVA SEQUENCIA DE CODIGO DA TABELA DE ENTIDADE
------------------------------------------------------------------------------
dbSelectArea("SZM")
dbSetOrder(2)

ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()

	IncProc()
	_cNomEnt := SZM->ZM_NOME
	_nCod+=1

	Do While SZM->ZM_NOME == _cNomEnt
		RecLock("SZM",.F.)
		SZM->ZM_OBS := strzero(_nCod,6)
		MSUnLock()
		DbSkip()
	EndDo

EndDo
------------------------------------------------------------------------------
GRAVA O NUMERO DO ITEM E O NOVO CODIGO DA ENTIDADE NO CADASTRO DE ENDERECOS
------------------------------------------------------------------------------
dbSelectArea("SZS")
dbSetOrder(5)

ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()

	IncProc()

	If SZS->ZS_TIPO == "F"
		DbSkip()
		Loop
	EndIf

	_cNomEnt := SZS->ZS_NOMENT
	_nCod+=1
	_nItem := 0

	Do While SZS->ZS_NOMENT == _cNomEnt
		_nItem++
		RecLock("SZS",.F.)
		SZS->ZS_ITEM := strzero(_nItem,4)
//		SZS->ZS_FONE := strzero(_nCod,6)
		MSUnLock()
		DbSkip()
	EndDo

EndDo
------------------------------------------------------------------------------
DELETAR DUPLICIDADE NO CADASTRO DE ENDERECOS
------------------------------------------------------------------------------
dbSelectArea("SZS")
dbSetOrder(5)

ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()
	IncProc()
	If SZS->ZS_TIPO == "F"
		DbSkip()
		Loop
	EndIf
	_cNomEnt := SZS->ZS_NOMENT
	Do While SZS->ZS_NOMENT == _cNomEnt
		_nCont   := 0
		_cEndEnt := SZS->ZS_END
		Do While SZS->ZS_END == _cEndEnt
			_nCont++
			If _nCont > 1
				RecLock("SZS",.F.)
				dbDelete()
				MSUnLock()
			EndIf
			DbSkip()
			If !(SZS->ZS_NOMENT == _cNomEnt)
				Exit
			EndIf
		EndDo
	EndDo
EndDo
------------------------------------------------------------------------------
IMPORTA CONTATO X ENDERECO POR ENTIDADE
------------------------------------------------------------------------------

dbSelectArea("SZT")
dbGotop()

ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()
	IncProc()

	DbSelectArea("SU5")
	DbSetOrder(1) // FILIAL + CODIGO CONTATO
	If DbSeek(xFilial("SU5")+SZT->ZT_CODCONT)
		_cID := SU5->U5_ID				//ID do Contato
	Else
		_cID := ""
	EndIf
	
	If !Empty(_cID)
		DbSelectArea("SZM")
		DbSetOrder(8) //FILIAL + ID DO CONTATO
		If DbSeek(xFilial("SZM")+_cID)
			_CODEND	:= SZM->ZM_CODENT		//Codigo do Endereco 
			_END	:= SZM->ZM_END			//Endereco
		Else
			_CODEND  := ""
		EndIf
	EndIf

	If !Empty(_CODEND)
		DbSelectArea("SZS")
		DbSetOrder(6) // FILIAL + COD ENTIDADE + ENDERECO
		If DbSeek(xFilial("SZS")+_CODEND+_END)
			RecLock("SZT",.F.)
			SZT->ZT_CODEND  := SZS->ZS_ITEM
			SZT->ZT_END     := SZS->ZS_END
			MSUnLock()
		EndIf
	EndIf

	dbSelectArea("SZT")
	DbSkip()
EndDo

------------------------------------------------------------------------------
GRAVA OS ENDERECOS DA ENTIDADE
------------------------------------------------------------------------------
dbSelectArea("SZM")

ProcRegua(RecCount())

_nCod  := 0

Do While !EOF()
	IncProc()

	RecLock("SZS",.T.)
	SZS->ZS_FILIAL 	:= "01"
	SZS->ZS_ITEM   	:= ""
	SZS->ZS_CODENT	:= SZM->ZM_CODENT
	SZS->ZS_TIPO	:= "J"
	SZS->ZS_END		:= SZM->ZM_END
	SZS->ZS_TIPOEND	:= "2"
	SZS->ZS_BAIRRO	:= SZM->ZM_BAIRRO
	SZS->ZS_MUN		:= SZM->ZM_MUN
	SZS->ZS_EST  	:= SZM->ZM_EST
	SZS->ZS_CEP  	:= SZM->ZM_CEP
	SZS->ZS_DDD 	:= SZM->ZM_DDD
	SZS->ZS_FONE 	:= ""
	SZS->ZS_FCOM1 	:= SZM->ZM_FCOM1
	SZS->ZS_FAX  	:= SZM->ZM_FAX
	SZS->ZS_ENDPAD  := "2"
	SZS->ZS_NOMENT  := SZM->ZM_NOME
	MSUnLock()

	dbSelectArea("SZM")
	DbSkip()
EndDo

------------------------------------------------------------------------------
DE_PARA NO CADASTRO DE CONTATO COM OS NOVOS CARGOS
------------------------------------------------------------------------------

Local nTamFile, nTamLin, cBuffer, nBtLidos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FT_FUSE("C:\Ap8\Protheus_Data\CSV\Cargos DE_PARA.txt")
FT_FGOTOP()

nRec := 0
While !FT_FEOF()
	nRec++
	FT_FSKIP()
End

ProcRegua(nRec) 

FT_FGOTOP()

FT_FSKIP()

While !FT_FEOF()
//ID;NOME;SEXO;CARGO ANTERIOR;CARGO ATUAL
    IncProc()
	cBuffer   := Alltrim(FT_FREADLN())
	_cID	  := Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer	  := Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cNome	  := Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer	  := Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cSexo	  := Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer	  := Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cCargAnt := Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer	  := Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cCargAtu := alltrim(cBuffer)

	dbSelectArea("SU5")
	dbSetOrder(9) //ID
	If dbSeek(xFilial("SU5")+_cID)
		If alltrim(SU5->U5_CONTAT) == _cNome
			dbSelectArea("SUM")
			dbSetOrder(2) //DESCRICAO
			If dbSeek(xFilial("SUM")+_cCargAtu)
				Do While alltrim(SUM->UM_DESC) == _cCargAtu
					If SU5->U5_SEXO == SUM->UM_SEXO
						_cCodCargo := SUM->UM_CARGO
						Exit
					Else
						dbSelectArea("SUM")
						DbSkip()
						Loop
					EndIf
					dbSelectArea("SUM")
					DbSkip()
				EndDo
			EndIf
			RecLock("SU5",.F.)
			SU5->U5_CARGO	:= _cCodCargo
			SU5->U5_DESC	:= _cCargAtu
			MSUnLock()
		EndIf
	EndIf
	
	FT_FSKIP()
EndDo

FT_FUSE()

Close(oLeTxt)

-----------------------------------------------------------------------------------------
GRAVA DO/DA/DE NA TABELA DE PERFIL
-----------------------------------------------------------------------------------------
dbUseArea(.T., "DBFCDX", "DE_PARA" , "TMP", .F., .F.)
IndRegua("TMP", "DE_PARA", "ID",,, "Criando indice...", .T.)

DbSelectArea("SZQ")
DbSetOrder(1)
DbGotop()
ProcRegua(RecCount())

Do While !EOF()
	IncProc()

	_CFILIAL 	:= SZQ->ZQ_FILIAL
	_CITEM 		:= SZQ->ZQ_ITEM
	_CCODCONT	:= SZQ->ZQ_CODCONT
	_CCODENT 	:= SZQ->ZQ_CODENT
	_CGRUPO 	:= SZQ->ZQ_GRUPO


	DbSelectArea("SU5")
	DbSetOrder(1)
	If DbSeek(xFilial("SU5")+ SZQ->ZQ_CODCONT)

		_CCARGO		:= SU5->U5_CARGO
		_CDESCCAR	:= SU5->U5_DESC
		_CCODTRAT	:= SU5->U5_NIVEL
		_CDESCRI	:= SU5->U5_DNIVEL

		DbSelectArea("TMP")
		If DbSeek(SU5->U5_ID)
			_cDesc	:= Alltrim(TMP->CARGO_ANTE)
			_y 		:= Len(_cDesc)
			For nI := 1 to _y
				If Substr(Alltrim(TMP->CARGO_ANTE),_y,1) $ "a|o|A|O"
					_y := _y -1
					If Substr(Alltrim(TMP->CARGO_ANTE),_y,1) $ "d|D"
						_y := _y -1
						If Substr(Alltrim(TMP->CARGO_ANTE),_y,1) $ " "
							_cDesc	:= Substr(Alltrim(TMP->CARGO_ANTE),_y+1,23)
							Exit
						EndIf
					EndIf
				EndIf
				Exit
			Next
		EndIf
	EndIf

	_cNDesc := ""
	_CTRAT  := ""
	Do Case
		Case _cDesc == "do"
			_cNDesc := "1"
		Case _cDesc == "da"
			_cNDesc := "2"
		Case _cDesc == "de"
			_cNDesc := "3"
	EndCase			

	If !Empty(_cNDesc)
		_CTRAT 	:= _cNDesc
	EndIf

	RecLock("SZR",.T.)
	SZR->ZR_FILIAL 	:= _CFILIAL
	SZR->ZR_ITEM 	:= _CITEM
	SZR->ZR_CODCONT	:= _CCODCONT
	SZR->ZR_CODENT 	:= _CCODENT
	SZR->ZR_GRUPO 	:= _CGRUPO
	SZR->ZR_CARGO 	:= _CCARGO
	SZR->ZR_DESC 	:= _CDESCCAR
	SZR->ZR_CODTRAT	:= _CCODTRAT
	SZR->ZR_DESCRI 	:= _CDESCRI
	SZR->ZR_TRAT 	:= _CTRAT

	MsUnLock()

	DbSelectArea("SZQ")
	DbSkip()

EndDo

------------------------------------------------------------------------------------
ITEM NA TABELA DE AMARRACAO CONTATOS X BDI 
E
ITEM NA TABELA DE CONTATOS X CATEGORIAS
------------------------------------------------------------------------------------

DbSelectArea("AC8")
DbSetOrder(1)
DbGotop()
ProcRegua(RecCount())

_nCod := 0

Do While !EOF()
	IncProc()

	_cCodCon := AC8->AC8_CODCON
	_nCod+=1
	_nItem := 0

	Do While AC8->AC8_CODCON == _cCodCon
		_nItem++
		RecLock("AC8",.F.)
		AC8->AC8_ITEM := strzero(_nItem,4)
		MSUnLock()
		DbSelectArea("AC8")
		DbSkip()
	EndDo

EndDo

DbSelectArea("SZY")
DbSetOrder(2)
DbGotop()
ProcRegua(RecCount())

_nCod := 0

Do While !EOF()
	IncProc()

	_cCodCon := SZY->ZY_CODCONT
	_nCod+=1
	_nItem := 0

	Do While SZY->ZY_CODCONT == _cCodCon
		_nItem++
		RecLock("SZY",.F.)
		SZY->ZY_ITEM := strzero(_nItem,4)
		MSUnLock()
		DbSelectArea("SZY")
		DbSkip()
	EndDo

EndDo

------------------------------------------------------------------------------------
CORRECAO DO CEP NAS TABELAS SU5 E SZM (CONTATOS E ENTIDADES)
------------------------------------------------------------------------------------

DbSelectArea("SU5")
DbSetOrder(2) //NOME
DbGotop()

dbUseArea(.T., "DBFCDX", "NCEPCONT" , "TMP", .F., .F.)
DbGotop()

ProcRegua(RecCount())

Do While !EOF()
	IncProc()

	RecLock("SU5",.F.)
	SU5->U5_CEP := ALLTRIM(STRZERO(TMP->U5_CEP,8))
	MsUnLock()	

	DbSelectArea("SU5") 
	DbSkip()

	DbSelectArea("TMP") 
	DbSkip()
EndDo

DbSelectArea("SZM")
DbSetOrder(3) //NOME
DbGotop()

dbUseArea(.T., "DBFCDX", "NCEPENT" , "TMP1", .F., .F.)
DbGotop()

ProcRegua(RecCount())

Do While !EOF()
	IncProc()

	RecLock("SZM",.F.)
	SZM->ZM_CEP := ALLTRIM(STRZERO(TMP1->ZM_CEP,8))
	MsUnLock()	

	DbSelectArea("SZM")
	DbSkip()

	DbSelectArea("TMP1")
	DbSkip()

EndDo
  
------------------------------------------------------------------------------------
CORRECAO DO CEP NA TABELA SZS
------------------------------------------------------------------------------------

dbSelectArea("SZS")
dbSetOrder(1)
dbGotop()

ProcRegua(RecCount())

Do While !EOF()

	IncProc()

	If SZS->ZS_TIPO == "F"
		DbSelectArea("SU5")
		DbSetOrder(1)
		If DbSeek(xFilial("SU5")+SZS->ZS_CODCONT)
			RecLock("SZS",.F.)
			SZS->ZS_CEP := SU5->U5_CEP
			MsUnLock()
		EndIf
	Else
		Exit	
	EndIf
	
	dbSelectArea("SZS")
	DbSkip()
	
EndDo

dbSelectArea("SZS")
dbSetOrder(1)
dbSeek(xFilial("SZS")+"J")

ProcRegua(RecCount())

Do While !EOF()

	IncProc()

	If SZS->ZS_TIPO == "J"
		DbSelectArea("SZM")
		DbSetOrder(9) //CODENT + ENDERECO
		If DbSeek(xFilial("SZM")+SZS->ZS_CODENT+ALLTRIM(SZS->ZS_END))
			RecLock("SZS",.F.)
			SZS->ZS_CEP := SZM->ZM_CEP
			MsUnLock()
		EndIf
	Else
		Exit	
	EndIf
	
	dbSelectArea("SZS")
	DbSkip()
	
EndDo

------------------------------------------------------------------------------------
ENDERECOS PADRAO 
------------------------------------------------------------------------------------
  
DbSelectArea("SZS")
DbSetOrder(1)
DbGotop()

Do While !EOF()

	If ZS_TIPO = "F"
		DbSelectArea("SZT")
		DbSetOrder(1)
		If DbSeek(xFilial("SZT")+SZS->ZS_CODCONT)
			DbSelectArea("SZT")
			RecLock("SZT",.F.)
			SZT->ZT_ENDPAD := "1"
			MsUnLock()
			DbSelectArea("SZS")
			RecLock("SZS",.F.)
			SZS->ZS_ENDPAD := "2"
			MsUnLock()
		EndIf
	Else
		Exit
	EndIf
	DbSelectArea("SZS")
	DbSkip()
	
EndDo


*/