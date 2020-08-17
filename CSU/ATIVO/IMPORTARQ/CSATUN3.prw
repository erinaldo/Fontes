#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±³Programa  ³ CSATUN3  ³ Autor ³ANDERSON CIRIACO       ³ Data ³ 26/02/13 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSATUN3()
Private nOpc      := 0
Private cCadastro := "Ler arquivo CSV"
Private aSay      := {}
Private aButton   := {}

lRet := .F.

aAdd( aSay, "O objetivo desta rotina e efetuar a leitura e importacao de um arquivo csv Atualizando as taxas de depreciação da tabela SN3" )

aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch()}})

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	Processa( {|| lRet:=Import() }, "Importando Arquivo CSV.......")
	If lRet
		Processa( {|| Atualiza()}, "Atualizando as taxas de depreciação da tabela SN3...")
	EndIf
Endif

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Import   ³ Autor ³ANDERSON CIRIACO       ³ Data ³ 26/02/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa Lista de Precos (.CSV)                             ³±±
±±³          ³ Leitura do CSV e montagem da tabela temporaria             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
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
AADD(aESTRUT1,{"TXM01"   ,"N",12,4})
AADD(aESTRUT1,{"TXM02"   ,"N",12,4})
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
	nPos4	:= at(";",subs(cBuffer,nPos1+nPos2+nPos3+1))	// TX MOEDA 1
	nPos5	:= at(";",subs(cBuffer,nPos1+nPos2+nPos3+nPos4+1))	// TX MOEDA 2
	
	_cfilial 	:= subs(cBuffer,01,nPos1-1)					// filia
	_ccbase  	:= subs(cBuffer,nPos1+1,nPos2-1)				// cbase
	_citem   	:= subs(cBuffer,nPos1+nPos2+1,nPos3-1)			// item
	_ntxm01 	:= subs(cBuffer,nPos1+nPos2+nPos3+1,nPos4-1) 	//,TAXA MOEDA 1
	_ntxm02 	:= subs(cBuffer,nPos1+nPos2+nPos3+nPos4+1) 		//,TAXA MOEDA 2
	
	_ntxm01 := strtran(_ntxm01,",",".")
	_ntxm02 := strtran(_ntxm02,",",".")
	
	//	_nPreco  := subs(cBuffer,nPos1+1)
	
	RecLock("TMP",.T.)
	TMP->FILIAL := REPLICATE("0",02-LEN(Alltrim(_CFILIAL)))+Alltrim(_CFILIAL)
	TMP->CBASE 	:= REPLICATE("0",10-LEN(Alltrim(_CCBASE)))+Alltrim(_CCBASE)
	TMP->ITEM 	:= REPLICATE("0",04-LEN(Alltrim(_CITEM)))+Alltrim(_CITEM)
	TMP->TXM01 	:= NOROUND(val(_nTXM01),4)
	TMP->TXM02 	:= NOROUND(val(_NTXM02),4)
	MsUnlock()
	
	FT_FSKIP()  
EndDo

FT_FUSE() 

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Atualiza ³ Autor ³ANDERSON CIRIACO       ³ Data ³ 26/02/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Atualiza as tabelas de acordo com a tabela temp.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga  -                      ³±±
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
		SN3->N3_TXDEPR1 := TMP->TXM01
		SN3->N3_TXDEPR2 := TMP->TXM02
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

Return()

