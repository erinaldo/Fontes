#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±³Programa  ³ CDEPREC ³ Autor ³Douglas David 		    ³ Data ³ 29/09/17 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para atualizar a conta de despesa                 º±±
±±º          ³ no campo N3_CDEPREC. OS 2774/17                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CDEPREC()
Private nOpc      := 0
Private cCadastro := "Ler arquivo CSV"
Private aSay      := {}
Private aButton   := {}

lRet := .F.

aAdd( aSay, "O objetivo desta rotina é efetuar a leitura e importação de um arquivo csv")
aAdd( aSay, "Atualizando as contas de despesa da tabela SN3.")
aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch()}})

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	Processa( {|| lRet:=Import() }, "Importando Arquivo CSV.......")
	If lRet
		Processa( {|| Atualiza()}, "Atualizando as contas de despesa da tabela SN3...")
	EndIf
Endif

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Import   ³ Autor ³Douglas David          ³ Data ³ 29/09/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa Lista de Precos (.CSV)                             ³±±
±±³          ³ Leitura do CSV e montagem da tabela temporaria             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CSU									                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Import()
Local cBuffer   := ""
Local cFileOpen := ""
Local cTitulo1  := "Selecione o arquivo"
Local cExtens	:= "Arquivo CSV | *.csv"

aESTRUT1 := {}
AADD(aESTRUT1,{"FILIAL"  ,"C",02,0})
AADD(aESTRUT1,{"CBASE"   ,"C",10,0})
AADD(aESTRUT1,{"ITEM"    ,"C",04,0})
AADD(aESTRUT1,{"CDEPREC" ,"C",20,0})
AADD(aESTRUT1,{"IMP"     ,"C",01,0})
_NOMETRB := Criatrab(aESTRUT1,.t.)
USE &_NOMETRB Alias TMP new

cFileOpen := cGetFile(cExtens,cTitulo1,2,,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)

If !File(cFileOpen)
	MsgAlert("Arquivo texto: "+cFileOpen+" não localizado",cCadastro)
	Return(.F.)
Endif

FT_FUSE(cFileOpen)
FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While !FT_FEOF()
	IncProc()
	
	// Capturar dados
	cBuffer := FT_FREADLN()
	
	nPos1	:= at(";",cBuffer)               				// FILIAL
	nPos2	:= at(";",subs(cBuffer,nPos1+1))				// CBASE
	nPos3	:= at(";",subs(cBuffer,nPos1+nPos2+1))			// ITEM
	nPos4	:= at(";",subs(cBuffer,nPos1+nPos2+nPos3+1))	// CDEPREC
	
	_cfilial 	:= subs(cBuffer,01,nPos1-1)					// filial
	_ccbase  	:= subs(cBuffer,nPos1+1,nPos2-1)				// cbase
	_citem   	:= subs(cBuffer,nPos1+nPos2+1,nPos3-1)			// item
	_cDeprec 	:= subs(cBuffer,nPos1+nPos2+nPos3+1)		 	// CDEPREC
	
	
	RecLock("TMP",.T.)
	TMP->FILIAL := REPLICATE("0",02-LEN(Alltrim(_CFILIAL)))+Alltrim(_CFILIAL)
	TMP->CBASE 	:= REPLICATE("0",10-LEN(Alltrim(_CCBASE)))+Alltrim(_CCBASE)
	TMP->ITEM 	:= REPLICATE("0",04-LEN(Alltrim(_CITEM)))+Alltrim(_CITEM)
	TMP->CDEPREC:= Alltrim(_CDEPREC)
	MsUnlock()
	
	FT_FSKIP()
EndDo

FT_FUSE()

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Atualiza ³ Autor ³Douglas David          ³ Data ³ 29/09/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Atualiza as tabelas de acordo com a tabela temp.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CSU                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Obs       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Atualiza()

Local nItem001 := "A4RA"
Local nItem002 := "9G8U"
Local nItem003 := "9FFH"
Local nLoc     := 0

dbSelectArea("SN3")
SN3->(DBSETORDER(1) )

dbSelectArea("TMP")
dbgotop()
ProcRegua(LASTREC())
While !EOF()
	
	IncProc()
	
	If SN3->(dbSeek(TMP->FILIAL+TMP->CBASE+TMP->ITEM,.F.))
		RECLOCK("SN3",.F.)
		SN3->N3_CDEPREC := TMP->CDEPREC
		SN3->(MSUNLOCK())
		dbSelectArea("TMP")
		RecLock("TMP",.F.)
		TMP->IMP := "S"
		MsUnLock()
		nLoc ++
	ENDIF
	
	TMP->(dbskip())
EndDo

Alert("Total de Itens " + StrZero(nLoc,10) )
dbSelectArea("TMP")
dbGoTop()
copy to NAOLOCA
TMP->(DbCloseArea())

Return()