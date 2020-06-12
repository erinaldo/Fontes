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

User Function IMP_END()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oLeTxt

dbSelectArea("SZS")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
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

Local nTamFile, nTamLin, cBuffer, nBtLidos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
FT_FUSE("C:\Ap8\Protheus_Data\CSV\Contatos.txt")
*/
FT_FUSE("C:\Ap8\Protheus_Data\CSV\Entidade.txt")
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

    IncProc()

	cBuffer := Alltrim(FT_FREADLN())
	_cContat	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cNome		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cEND  		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cBAIRRO	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cMUN		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cEST	  	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cCEP  		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDDD 		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cFCOM1 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cFAX  		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cEMAIL		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	
	dbSelectArea("SZS")
	RecLock("SZS",.T.)
	SZS->ZS_FILIAL 	:= "01"
	SZS->ZS_ITEM   	:= "" //"0001"
//	SZS->ZS_CODCONT	:= _cContat
	SZS->ZS_CODENT	:= _cContat
	SZS->ZS_TIPO	:= "J" //"F"
	SZS->ZS_END		:= _cEND
	SZS->ZS_TIPOEND	:= "2" //IIF(SUBSTR(_cTIPOEND,1,1)=="R","1","2")
	SZS->ZS_BAIRRO	:= _cBAIRRO
	SZS->ZS_MUN		:= _cMUN
	SZS->ZS_EST  	:= _cEST
	SZS->ZS_CEP  	:= _cCEP
	SZS->ZS_DDD 	:= _cDDD
	SZS->ZS_FONE 	:= ""//_cFONE
	SZS->ZS_FCOM1 	:= _cFCOM1
	SZS->ZS_FAX  	:= _cFAX 
	SZS->ZS_ENDPAD  := "2" //"1"
//	SZS->ZS_NOMCONT := _cNome
	SZS->ZS_NOMENT  := _cNome
	MSUnLock()

	FT_FSKIP()
EndDo

FT_FUSE()

Close(oLeTxt)

Return

/*

CAMPOS DO CADASTRO DE CONTATO

	cBuffer := Alltrim(FT_FREADLN())
	_cContat	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cNome		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)	
	_cSEXO		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cEND  		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cBAIRRO	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cMUN		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cEST	  	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cCEP  		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDDD 		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cFONE 		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cFCOM1 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cFAX  		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cEMAIL		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDESC		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDTINCLU	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDTALTER	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDNIVEL 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cTIPOEND	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDGRUPO 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cDECISAO	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cTITULO	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cPAIS		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cAC		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cAUTORIZ	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cMOTIVO 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),300)
	_cMAILPAD	:= 	alltrim(cBuffer)
*/