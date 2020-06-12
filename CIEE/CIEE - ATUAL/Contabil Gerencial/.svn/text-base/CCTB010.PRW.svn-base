#include "rwmake.ch"

User Function CCONM002()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,NHDL,CLIN")
SetPrvt("AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ GERATXT  º Autor ³ Antonio Gendra     º Data ³  14/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Programa para geracao de arquivo .TXT                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para CIEE                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

cPerg := "CONM02"

ValidPerg()

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
@ 03,10 TO 088,180
@ 12,014 Say " Este programa ir  gerar arquivos texto, conforme os parametros"
@ 21,014 Say " definidos  pelo usuario.                               "
@ 70,088 BMPBUTTON TYPE 01 ACTION Continua()
@ 70,118 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 70,148 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
Activate Dialog oDlg Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Fun‡„o   ³ CONTINUA º Autor ³ Antonio Gendra     º Data ³   14/06/05  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para continuacao do processamento (na confirmacao)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para CIEE                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Continua()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da pesquisa no arquivo de dados                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont()},"Processando... ")
Return
Static Function RunCont()

aCampos := {}
cArqTrb := " "

AADD(aCampos,{"NOMELOT","C",08,0})
AADD(aCampos,{"DATAL"  ,"D",08,0})
AADD(aCampos,{"QTDLAN" ,"N",02,0})
AADD(aCampos,{"VALTOT" ,"N",16,0})
AADD(aCampos,{"TOTDEB" ,"N",16,0})
AADD(aCampos,{"TOTCRD" ,"N",16,0})

cArqTrb := CriaTrab(aCampos,.t.)
dbUseArea(.T.,,cArqTrb,"TRB",.T.)
IndRegua("TRB",cArqTrb,"NOMELOT",,,"Criando Arquivo...")

bCampos := {}
bArqTrb := " "

AADD(bCampos,{"NOMELOT","C",08,0})
AADD(bCampos,{"NUMIDEN","N",10,0})
AADD(bCampos,{"CODCONT","C",20,0})
AADD(bCampos,{"HISTOR" ,"C",03,0})
AADD(bCampos,{"COMHIST","C",80,0})
AADD(bCampos,{"VALOR"  ,"N",16,0})
AADD(bCampos,{"IDENT"  ,"C",01,0})

bArqTrb := CriaTrab(bCampos,.t.)
dbUseArea(.T.,,bArqTrb,"TR2",.T.)
IndRegua("TR2",bArqTrb,"NOMELOT",,,"Criando Arquivo...")

_Lote     := Space(06)
_QtdLan   := 0
_Data     := CTOD("  /  /  ")
_nArqTXT  := 0
_cNomeLot := Space(08)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina para geracao do arquivo temporario que aglutina os lancamentos de credito do LP 6666,³
//³qdo. contabilizacao do estoque, se nao segue registros gravados pelo padrao do Microsiga.   ³
//³CFB 07/07/05                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CTLP666(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06) // Funcao para Geracao arquivo temporarrio

DBSELECTAREA("TRT")
TRT->(DBGOTOP())

While !TRT->(EOF() )
	
	IncProc()
	
	If DtoS(_Data) <> DtoS(TRT->CT2_DATA)
		
		_QtdLan  := 0
		_Lote    := Space(06)
		
		DbSelectArea("SM2")
		DbSetOrder(1)
		DbSeek(TRT->CT2_DATA)
		
		If !Empty(SM2->M2_ARQTXT)
			_nArqTXT := Val(Subs(SM2->M2_ARQTXT,5,2)) + 1
		Else
			_nArqTXT := 1
		EndIf
		
		_cNomeLot := Subs(DtoS(TRT->CT2_DATA),5,4)+StrZero(_nArqTXT,2)
		
		DbSelectArea("SM2")
		RecLock("SM2",.F.)
		SM2->M2_ARQTXT := _cNomeLot
		MsunLock()
		
	EndIf
	
	If _Lote <> TRT->CT2_LOTE
		_QtdLan := _QtdLan + 1
	EndIf
	
	DbSelectArea("TRB")
	DbSeek("MS"+AllTrim(_cNomeLot))
	If Found()
		RecLock("TRB",.F.)
	Else
		RecLock("TRB",.T.)
	EndIf
	TRB->NOMELOT := "MS"+AllTrim(_cNomeLot)
	TRB->DATAL   := TRT->CT2_DATA
	TRB->QTDLAN  := _QtdLan
	TRB->VALTOT  := TRB->VALTOT + IIF(TRT->CT2_DC $ "23",TRT->CT2_VLR01*100,0)
	TRB->TOTDEB  := TRB->TOTDEB + VAL(ALLTRIM(TRT->CT2_ITEMD)+ALLTRIM(TRT->CT2_CCD))
	TRB->TOTCRD  := TRB->TOTCRD + VAL(ALLTRIM(TRT->CT2_ITEMC)+ALLTRIM(TRT->CT2_CCC))
	MsunLock()
	
	If TRT->CT2_DC $ "13"
		DbSelectArea("TR2")
		RecLock("TR2",.T.)
		TR2->NOMELOT := "MS"+AllTrim(_cNomeLot)
		TR2->NUMIDEN := _QtdLan
		TR2->CODCONT := ALLTRIM(TRT->CT2_ITEMD)+ALLTRIM(TRT->CT2_CCD)
		TR2->HISTOR  := Subs(TRT->CT2_ORIGEM,1,3)
		TR2->COMHIST := TRT->CT2_HIST
		TR2->VALOR   := TRT->CT2_VLR01*100
		TR2->IDENT   := "D"
		MsunLock()
		DbSelectArea("TRT")
		DbSkip()
		If TRT->CT2_DC == "4"
			DbSelectArea("TR2")
			RecLock("TR2",.F.)
			TR2->COMHIST := ALLTRIM(TR2->COMHIST)+TRT->CT2_HIST
			MsunLock()
		EndIf
		DbSelectArea("TRT")
		DbSkip(-1)
	EndIf
	
	If TRT->CT2_DC $ "23"
		DbSelectArea("TR2")
		RecLock("TR2",.T.)
		TR2->NOMELOT := "MS"+AllTrim(_cNomeLot)
		TR2->NUMIDEN := _QtdLan
		TR2->CODCONT := ALLTRIM(TRT->CT2_ITEMC) + ALLTRIM(TRT->CT2_CCC)
		TR2->HISTOR  := Subs(TRT->CT2_ORIGEM,1,3)
		TR2->COMHIST := TRT->CT2_HIST
		TR2->VALOR   := TRT->CT2_VLR01*100
		TR2->IDENT   := "C"
		MsunLock()
		DbSelectArea("TRT")
		DbSkip()
		If TRT->CT2_DC == "4"
			DbSelectArea("TR2")
			RecLock("TR2",.F.)
			TR2->COMHIST := ALLTRIM(TR2->COMHIST)+TRT->CT2_HIST
			MsunLock()
		EndIf
		DbSelectArea("TRT")
		DbSkip(-1)
	EndIf
	
	// Obs.: Tratar flag para geracao de arquivo  !!! CFB
	
	/*
	DbSelectArea("TRT")
	RecLock("TRT",.F.)
	TRT->CT2_GERARQ := "S"
	MsunLock()
    */	

	_Lote     := TRT->CT2_LOTE
	_Data     := TRT->CT2_DATA
	
	DbSelectArea("TRT")
	DbSkip()
	
End

_cNomeLot  := Space(08)
_cMensagem := Space(300)
cLin := Space(64)
DbSelectArea("TRB")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof()
	
	IncProc()
	
	If _cNomeLot <> AllTrim(TRB->NOMELOT)
		_nomArq := "M:\CONTABIL\LT"+(Subs(TRB->NOMELOT,3,6))+".TXT"
		_FinLin := CHR(13)+CHR(10)
		
		nHdl    := fCreate(_nomArq)
		
		If nHdl == -1
			MsgAlert("O arquivo de nome "+_nomArq+" n„o p“de ser executado! Verifique os parƒmetros.","Aten‡„o!")
			Return
		Endif
	EndIf
	
	cLin := ALLTRIM(TRB->NOMELOT)+"|"
	cLin := cLin+ALLTRIM(DTOC(TRB->DATAL))+"|"
	cLin := cLin+ALLTRIM(STR(TRB->QTDLAN))+"|"
	cLin := cLin+ALLTRIM(STR(TRB->VALTOT))+"|"
	cLin := cLin+ALLTRIM(STR(TRB->VALTOT))+"|"
	cLin := cLin+"1||"
	cLin := cLin+ALLTRIM(STR(TRB->TOTDEB))+"|"
	cLin := cLin+ALLTRIM(STR(TRB->TOTCRD))+"|"+_FinLin
	
	_cNomeLot := TRB->NOMELOT
	
	DbSelectArea("TRB")
	DbSkip()
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na grava‡„o do arquivo "+_nomArq+".   Continua?","Aten‡„o!")
			Exit
		Endif
	EndIf
	
	If _cNomeLot <> TRB->NOMELOT
		fClose(nHdl)
		If Empty(_cMensagem)
			_cMensagem := "LT"+Subs(_cNomeLot,3,6)
		Else
			_cMensagem := AllTrim(_cMensagem)+", LT"+Subs(_cNomeLot,3,6)
		EndIf
	EndIf
	
	DbSelectArea("TRB")
	
EndDo

DbSelectArea("TR2")
DbGoTop()
ProcRegua(LastRec())
_cNomeLot := Space(08)
cLin := Space(300)

Do While !Eof()
	
	IncProc()
	If _cNomeLot <> AllTrim(TR2->NOMELOT)
		_nomArq := "M:\CONTABIL\LC"+(Subs(TR2->NOMELOT,3,6))+".TXT"
		_FinLin := CHR(13)+CHR(10)
		
		nHdl    := fCreate(_nomArq)
		
		If nHdl == -1
			MsgAlert("O arquivo de nome "+_nomArq+" n„o p“de ser executado! Verifique os parƒmetros.","Aten‡„o!")
			Return
		Endif
	EndIf
	
	cLin := ALLTRIM(TR2->NOMELOT)+"*"
	cLin := cLin+ALLTRIM(STR(TR2->NUMIDEN))+"|"
	cLin := cLin+ALLTRIM(TR2->CODCONT)+"|"
	cLin := cLin+ALLTRIM(TR2->HISTOR)+"|"
	cLin := cLin+ALLTRIM(TR2->COMHIST)+"|"
	cLin := cLin+ALLTRIM(STR(TR2->VALOR))+"|"
	cLin := cLin+ALLTRIM(TR2->IDENT)+"|"+_FinLin
	
	_cNomeLot := TR2->NOMELOT
	
	DbSelectArea("TR2")
	DbSkip()
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na grava‡„o do arquivo "+_nomArq+".   Continua?","Aten‡„o!")
			Exit
		Endif
	EndIf
	
	If _cNomeLot <> TR2->NOMELOT
		fClose(nHdl)
		_cMensagem := AllTrim(_cMensagem)+", LC"+Subs(_cNomeLot,3,6)
	EndIf
	
	DbSelectArea("TR2")
	
EndDo

If !Empty(_cMensagem)
	_cMensagem := AllTrim(_cMensagem)+".   Favor solicitar arquivos gerados para a informatica para importacao no ambiente Contabil."
	MsgStop("Arquivos Gerados : "+AllTrim(_cMensagem))
Else
	MsgStop("Nao existem lancamentos contabeis para este periodo")
EndIf

Close(oDlg)

DbSelectArea("TRB")
DbCloseArea()
DbSelectArea("TR2")
DbCloseArea()

DbSelectArea("CT2")
RetIndex("CT2")
DbSelectArea("SM2")
RetIndex("SM2")

If File(bArqTrb+".DBF")
	Ferase(bArqTrb+".DBF")
	Ferase(bArqTrb+".NTX")
EndIf

If File(cArqTrb+".DBF")
	Ferase(cArqTrb+".DBF")
	Ferase(cArqTrb+".NTX")
EndIf


If File(dArqTrb+".DBF")
	Ferase(dArqTrb+".DBF")
	Ferase(dArqTrb+".NTX")
EndIf

If Select("TRT") > 0
	TRT->(DBCLOSEAREA())
EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³ Antonio Gendra        ³ Data ³ 14/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para CIEE                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function ValidPerg()

Local aRegs   := {}
LOCAL _nIndex := IndexOrd(), I, J
cPerg         := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Data            ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Data         ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Lote            ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate o Lote         ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Documento       ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate o Documento    ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

LValidPerg(aRegs)

Return


Static Function CTLP666(pPar01,pPar02,pPar03,pPar04,pPar05,pPar06)


Local _cQuery := ""
Local _cFol   := CHR(13)+CHR(10)
Local _cAlias := GetArea()
Local _aStru := {}
Local _nTotCred :=0
Local _cRedCre
Local _cConCre
Private dArqTrb

AADD(_aStru,{"CT2_FILIAL", "C",  2,0})
AADD(_aStru,{"CT2_DATA",   "D",  8,0})
AADD(_aStru,{"CT2_LOTE",   "C",  6,0})
AADD(_aStru,{"CT2_SBLOTE", "C",  3,0})
AADD(_aStru,{"CT2_DOC",    "C",  6,0})
AADD(_aStru,{"CT2_LINHA",  "C",  3,0})
AADD(_aStru,{"CT2_DC",      "C" ,1,0})
AADD(_aStru,{"CT2_ITEMD",  "C"  , 9,0})
AADD(_aStru,{"CT2_CCD","C"      , 9,0})
AADD(_aStru,{"CT2_ITEMC","C"    , 9,0})
AADD(_aStru,{"CT2_CCC","C"      , 9,0})
AADD(_aStru,{"CT2_DCD","C"      , 1,0})
AADD(_aStru,{"CT2_DCC","C"      , 1,0})
AADD(_aStru,{"CT2_VLR01","N"    , 17,2})
AADD(_aStru,{"CT2_HP","C"       , 3,0})
AADD(_aStru,{"CT2_HIST","C"     , 40,0})
AADD(_aStru,{"CT2_CRITER","C"   , 4, 0})
AADD(_aStru,{"CT2_CLVLDB","C"   , 9, 0})
AADD(_aStru,{"CT2_CLVLCR ","C"  , 9, 0})
AADD(_aStru,{"CT2_VLR02",  "N"  , 17,2})
AADD(_aStru,{"CT2_VLR03","N"     , 17,2})
AADD(_aStru,{"CT2_VLR04","N"    ,  17,2})
AADD(_aStru,{"CT2_VLR05","N"    ,  17,2})
AADD(_aStru,{"CT2_DEBITO", "C"  ,  20,0})
AADD(_aStru,{"CT2_CREDIT","C"   ,  20,0})
AADD(_aStru,{"CT2_ATIVDE","C"   ,  40,0})
AADD(_aStru,{"CT2_ATIVCR","C"   ,  40,0})
AADD(_aStru,{"CT2_EMPORI","C"   ,  2,0})
AADD(_aStru,{"CT2_FILORI","C"   ,  2,0})
AADD(_aStru,{"CT2_INTERC","C"   ,  1,0})
AADD(_aStru,{"CT2_IDENTC","C"   ,  16,0})
AADD(_aStru,{"CT2_TPSALD","C"   ,  1,0})
AADD(_aStru,{"CT2_ORIGEM","C"   ,  100,0})
AADD(_aStru,{"CT2_ROTINA","C"   ,  10,0})
AADD(_aStru,{"CT2_SEQUEN","C"   ,  10,0})
AADD(_aStru,{"CT2_MANUAL","C"   ,  1,0})
AADD(_aStru,{"CT2_LP","C"       ,  3,0})
AADD(_aStru,{"CT2_DTVENC", "D"  ,  8,0})
AADD(_aStru,{"CT2_AGLUT",  "C"  ,  1,0})
AADD(_aStru,{"CT2_KEY",    "C"  ,  100,0})
AADD(_aStru,{"CT2_SEQHIS  ","C" ,  3,0})
AADD(_aStru,{"CT2_SEQLAN","C"   ,  3,0})
AADD(_aStru,{"CT2_SLBASE", "C"  ,  1,0})
AADD(_aStru,{"CT2_DTLP",   "D"  ,  8,0})
AADD(_aStru,{"CT2_GERARQ", "C"  ,  1,0})
AADD(_aStru,{"CT2_MOEDLC", "C"  ,  2,0})
AADD(_aStru,{"CT2_MOEDAS", "C"  ,  5,0})
dArqTrb := CriaTrab(_aStru,.t.)
dbUseArea(.T.,,dArqTrb,"TRT",.T.)
IndRegua("TRT",dArqTrb,"CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE++CT2_DOC+CT2_LINHA",,,"Criando Arquivo...")



_cQuery := " SELECT * FROM CT2010  "
_cQuery += " WHERE D_E_L_E_T_ = ' ' "
_cQuery += " AND CT2_DATA BETWEEN '"+pPar01+"' AND '"+pPar02+"' "
_cQuery += " AND CT2_LOTE BETWEEN '"+pPar03+"' AND '"+pPar04+"' "
_cQuery += " AND CT2_DOC  BETWEEN '"+pPar05+"' AND '"+pPar06+"' "
_cQuery += " AND CT2_TPSALD = '1' AND CT2_DC =  '123'  "
_cQuery += " AND CT2_GERARQ = ' ' "
_cQuery += " ORDER BY CT2_CREDIT,CT2_DEBITO,CT2_CCD, CT2_LOTE "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRS',.T.,.T.)


TcSetField("_cQuery","CT2_DATA","D",8, 0 )
TcSetField("_cQuery","CT2_DTVENC","D",8, 0 )
TcSetField("_cQuery","CT2_DTLP","D",8, 0 )



WHILE !TRS->(EOF())
	
	IF ALLTRIM(TRS->CT2_LP) == "666"
		_nTotCred :=0
		_cRedCre := TRS->CT2_ITEMC
		_cConCre := TRS->CT2_CREDIT
		WHILE  TRS->CT2_ITEMC == _cContaC
			RecLock("TRT",.T.)
			TRT->CT2_FILIAL := TRS->CT2_FILIAL
			TRT->CT2_DATA   := TRS->CT2_DATA
			TRT->CT2_LOTE   := TRS->CT2_LOTE
			TRT->CT2_SBLOTE := TRS->CT2_SBLOTE
			TRT->CT2_DOC    := TRS->CT2_DOC
			TRT->CT2_LINHA  := TRS->CT2_LINHA
			TRT->CT2_DC		:= "1"  //TRS->CT2_DC
			TRT->CT2_ITEMD	:= TRS->CT2_ITEMD
			TRT->CT2_CCD	:= TRS->CT2_CCD
			//			TRT->CT2_ITEMC	:= TRS->CT2_ITEMC
			//			TRT->CT2_CCC	:= TRS->CT2_CCC
			TRT->CT2_DCD	:= TRS->CT2_DCD
			TRT->CT2_DCC	:= TRS->CT2_DCC
			TRT->CT2_VLR01	:= TRS->CT2_VLR01
			TRT->CT2_HP		:= TRS->CT2_HP
			TRT->CT2_HIST	:= TRS->CT2_HIST
			TRT->CT2_CRITER	:= TRS->CT2_CRITER
			TRT->CT2_CLVLDB	:= TRS->CT2_CLVLDB
			TRT->CT2_CLVLCR	:= TRS->CT2_CLVLCR
			TRT->CT2_VLR02	:= TRS->CT2_VLR02
			TRT->CT2_VLR03	:= TRS->CT2_VLR03
			TRT->CT2_VLR04	:= TRS->CT2_VLR04
			TRT->CT2_VLR05	:= TRS->CT2_VLR05
			TRT->CT2_DEBITO	:= TRS->CT2_DEBITO
			TRT->CT2_CREDIT	:= TRS->CT2_CREDIT
			TRT->CT2_ATIVDE	:= TRS->CT2_ATIVDE
			TRT->CT2_ATIVCR	:= TRS->CT2_ATIVCR
			TRT->CT2_EMPORI	:= TRS->CT2_EMPORI
			TRT->CT2_FILORI	:= TRS->CT2_FILORI
			TRT->CT2_INTERC	:= TRS->CT2_INTERC
			TRT->CT2_IDENTC	:= TRS->CT2_IDENTC
			TRT->CT2_TPSALD	:= TRS->CT2_TPSALD
			TRT->CT2_ORIGEM	:= TRS->CT2_ORIGEM
			TRT->CT2_ROTINA	:= TRS->CT2_ROTINA
			TRT->CT2_SEQUEN	:= TRS->CT2_SEQUEN
			TRT->CT2_MANUAL	:= TRS->CT2_MANUAL
			TRT->CT2_LP		:= TRS->CT2_LP
			TRT->CT2_DTVENC	:= TRS->CT2_DTVENC
			TRT->CT2_AGLUT	:= TRS->CT2_AGLUT
			TRT->CT2_KEY	:= TRS->CT2_KEY
			TRT->CT2_SEQHIS	:= TRS->CT2_SEQHIS
			TRT->CT2_SEQLAN	:= TRS->CT2_SEQLAN
			TRT->CT2_SLBASE	:= TRS->CT2_SLBASE
			TRT->CT2_DTLP	:= TRS->CT2_DTLP
			TRT->CT2_GERARQ	:= TRS->CT2_GERARQ
			TRT->CT2_MOEDLC	:= TRS->CT2_MOEDLC
			TRT->CT2_MOEDAS	:= TRS->CT2_MOEDAS
			TRT->(MsUnlock())
			_nTotCred += TRS->CT2_VLR01
			TRS->(DBSKIP())
		END
		TRS->(DBSKIP(-1))
		
		TRT->CT2_FILIAL := TRS->CT2_FILIAL
		TRT->CT2_DATA   := TRS->CT2_DATA
		TRT->CT2_LOTE   := TRS->CT2_LOTE
		TRT->CT2_SBLOTE := TRS->CT2_SBLOTE
		TRT->CT2_DOC    := TRS->CT2_DOC
		TRT->CT2_LINHA  := TRS->CT2_LINHA
		TRT->CT2_DC		:= "2"  //TRT->CT2_DC
		//			TRT->CT2_ITEMD	:= TRT->CT2_ITEMD
		//			TRT->CT2_CCD	:= TRT->CT2_CCD
		TRT->CT2_ITEMC	:= _cRedCre //TRT->CT2_ITEMC
		TRT->CT2_CCC	:= TRS->CT2_CCC
		TRT->CT2_DCD	:= TRS->CT2_DCD
		TRT->CT2_DCC	:= TRS->CT2_DCC
		TRT->CT2_VLR01	:= _nTotCred //TRT->CT2_VLR01
		TRT->CT2_HP		:= TRS->CT2_HP
		TRT->CT2_HIST	:= TRS->CT2_HIST
		TRT->CT2_CRITER	:= TRS->CT2_CRITER
		TRT->CT2_CLVLDB	:= TRS->CT2_CLVLDB
		TRT->CT2_CLVLCR	:= TRS->CT2_CLVLCR
		TRT->CT2_VLR02	:= TRS->CT2_VLR02
		TRT->CT2_VLR03	:= TRS->CT2_VLR03
		TRT->CT2_VLR04	:= TRS->CT2_VLR04
		TRT->CT2_VLR05	:= TRS->CT2_VLR05
		//			TRT->CT2_DEBITO	:= TRT->CT2_DEBITO
		TRT->CT2_CREDIT	:= _cConCre   //TRT->CT2_CREDIT
		TRT->CT2_ATIVDE	:= TRS->CT2_ATIVDE
		TRT->CT2_ATIVCR	:= TRS->CT2_ATIVCR
		TRT->CT2_EMPORI	:= TRS->CT2_EMPORI
		TRT->CT2_FILORI	:= TRS->CT2_FILORI
		TRT->CT2_INTERC	:= TRS->CT2_INTERC
		TRT->CT2_IDENTC	:= TRS->CT2_IDENTC
		TRT->CT2_TPSALD	:= TRS->CT2_TPSALD
		TRT->CT2_ORIGEM	:= TRS->CT2_ORIGEM
		TRT->CT2_ROTINA	:= TRS->CT2_ROTINA
		TRT->CT2_SEQUEN	:= TRS->CT2_SEQUEN
		TRT->CT2_MANUAL	:= TRS->CT2_MANUAL
		TRT->CT2_LP		:= TRS->CT2_LP
		TRT->CT2_DTVENC	:= TRS->CT2_DTVENC
		TRT->CT2_AGLUT	:= TRS->CT2_AGLUT
		TRT->CT2_KEY	:= TRS->CT2_KEY
		TRT->CT2_SEQHIS	:= TRS->CT2_SEQHIS
		TRT->CT2_SEQLAN	:= TRS->CT2_SEQLAN
		TRT->CT2_SLBASE	:= TRS->CT2_SLBASE
		TRT->CT2_DTLP	:= TRS->CT2_DTLP
		TRT->CT2_GERARQ	:= TRS->CT2_GERARQ
		TRT->CT2_MOEDLC	:= TRS->CT2_MOEDLC
		TRT->CT2_MOEDAS	:= TRS->CT2_MOEDAS
		TRT->(MsUnlock())
		TRS->(DBSKIP())
		
	ELSE
		RecLock("TRT",.T.)
		TRT->CT2_FILIAL := TRS->CT2_FILIAL
		TRT->CT2_DATA   := TRS->CT2_DATA
		TRT->CT2_LOTE   := TRS->CT2_LOTE
		TRT->CT2_SBLOTE := TRS->CT2_SBLOTE
		TRT->CT2_DOC    := TRS->CT2_DOC
		TRT->CT2_LINHA  := TRS->CT2_LINHA
		TRT->CT2_DC		:= TRS->CT2_DC
		TRT->CT2_ITEMD	:= TRS->CT2_ITEMD
		TRT->CT2_CCD	:= TRS->CT2_CCD
		TRT->CT2_ITEMC	:= TRS->CT2_ITEMC
		TRT->CT2_CCC	:= TRS->CT2_CCC
		TRT->CT2_DCD	:= TRS->CT2_DCD
		TRT->CT2_DCC	:= TRS->CT2_DCC
		TRT->CT2_VLR01	:= TRS->CT2_VLR01
		TRT->CT2_HP		:= TRS->CT2_HP
		TRT->CT2_HIST	:= TRS->CT2_HIST
		TRT->CT2_CRITER	:= TRS->CT2_CRITER
		TRT->CT2_CLVLDB	:= TRS->CT2_CLVLDB
		TRT->CT2_CLVLCR	:= TRS->CT2_CLVLCR
		TRT->CT2_VLR02	:= TRS->CT2_VLR02
		TRT->CT2_VLR03	:= TRS->CT2_VLR03
		TRT->CT2_VLR04	:= TRS->CT2_VLR04
		TRT->CT2_VLR05	:= TRS->CT2_VLR05
		TRT->CT2_DEBITO	:= TRS->CT2_DEBITO
		TRT->CT2_CREDIT	:= TRS->CT2_CREDIT
		TRT->CT2_ATIVDE	:= TRS->CT2_ATIVDE
		TRT->CT2_ATIVCR	:= TRS->CT2_ATIVCR
		TRT->CT2_EMPORI	:= TRS->CT2_EMPORI
		TRT->CT2_FILORI	:= TRS->CT2_FILORI
		TRT->CT2_INTERC	:= TRS->CT2_INTERC
		TRT->CT2_IDENTC	:= TRS->CT2_IDENTC
		TRT->CT2_TPSALD	:= TRS->CT2_TPSALD
		TRT->CT2_ORIGEM	:= TRS->CT2_ORIGEM
		TRT->CT2_ROTINA	:= TRS->CT2_ROTINA
		TRT->CT2_SEQUEN	:= TRS->CT2_SEQUEN
		TRT->CT2_MANUAL	:= TRS->CT2_MANUAL
		TRT->CT2_LP		:= TRS->CT2_LP
		TRT->CT2_DTVENC	:= TRS->CT2_DTVENC
		TRT->CT2_AGLUT	:= TRS->CT2_AGLUT
		TRT->CT2_KEY	:= TRS->CT2_KEY
		TRT->CT2_SEQHIS	:= TRS->CT2_SEQHIS
		TRT->CT2_SEQLAN	:= TRS->CT2_SEQLAN
		TRT->CT2_SLBASE	:= TRS->CT2_SLBASE
		TRT->CT2_DTLP	:= TRS->CT2_DTLP
		TRT->CT2_GERARQ	:= TRS->CT2_GERARQ
		TRT->CT2_MOEDLC	:= TRS->CT2_MOEDLC
		TRT->CT2_MOEDAS	:= TRS->CT2_MOEDAS
		TRT->(MsUnlock())
		TRS->(DBSKIP())
	ENDIF
END



If Select("TRS") > 0
	TRS->(DBCLOSEAREA())
EndIf

DBSELECTAREA("TRT")

Return




