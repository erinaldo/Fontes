#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

#Define ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIGCTX01  บAutor  ณClaudinei Ferreira  บ Data ณ  10/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina especifica para Manutencao na Solicitacao de Contratoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFIESP                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIGCTX01()
Local aCores    := {	{ 'Z7_STATUS == "1"'  , "BR_AMARELO"},;
{ 'Z7_STATUS == "2"'  , "PMSEDT3"},;
{ 'Z7_STATUS == "3"'  , "BR_CANCEL"},;
{ 'Z7_STATUS == "4"'  , "BR_AZUL"},;
{ 'Z7_STATUS == "5"'  , "BR_MARROM"},;
{ 'Z7_STATUS == "6"'  , "BR_VERDE"},;
{ 'Z7_STATUS == "7"'  , "BR_VERMELHO"},;
{ 'Z7_STATUS == "8"'  , "BR_PRETO"}}

Private nUsado     := 0
Private cCadastro  := "Solicitacao de Contrato"
Private cFilSZ7    := ""
Private aRotina    :=  GCTE01Mnu()
Private aPos       := {15, 1, 70, 315}
Private oCliente   := Nil
Private oTotal     := Nil
Private cCliente   := ""
Private nTotal     := 0

dbSelectArea('SZ7')
dbSetOrder(1)

mBrowse(,,,,"SZ7",,,,,,aCores,,, )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Inc  บAutor  ณMicrosiga           บ Data ณ  09/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida inclusao da Solicitacao                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Inc()
Local aButtons := {}

Private cAliasTrb  := GetNextAlias()

xRateio(3)

aAdd(aButtons, {"Filtro", {|| GCT01Rat(3)}, "Rateio"})

AxInclui("SZ7", , , , , ,"U_GCTE01TOK(3)", , , aButtons, , ,.T.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIGCTX01  บAutor  ณFelipe Alves        บ Data ณ  27/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Vis()
Local aButtons := {}

Private cAliasTrb  := GetNextAlias()

xRateio(2)

aAdd(aButtons, {"Filtro", {|| GCT01Rat(2)}, "Rateio"})

  AxVisual("SZ7", SZ7->(Recno()), 2,        ,           ,           ,         , aButtons, .T.)
//AxVisual( <cAlias>, <nReg>    , <2, <aAcho>, <nColMens>, <cMensagem>, <cFunc>, <aButtons>, <lMaximized>)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Alt  บAutor  ณMicrosiga           บ Data ณ  09/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida altera็ใo da Solicitacao                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Alt()
Local aButtons := {}

Private cAliasTrb  := GetNextAlias()

xRateio(4)

aAdd(aButtons, {"Filtro", {|| GCT01Rat(4)}, "Rateio"})

IF SZ7->Z7_STATUS == "1" // Em Elaboracao
	AxAltera('SZ7',SZ7->(Recno()),4,,,,,"U_GCTE01TOK(4)", , , aButtons, , ,.T.)
ELSE
	Aviso(cCadastro, "Somente solicita็๕es em elabora็ใo podem ser alteradas!", {"Sair"} )
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Del บAutor  ณMicrosiga           บ Data ณ 10/09/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valida exclusao da Solicitacao                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Del(nReg,nOpc)

IF SZ7->Z7_STATUS == "1" // Em Elaboracao
	AxDeleta('SZ7',SZ7->(Recno()),5)
ELSE
	Aviso(cCadastro, "Somente solicita็๕es em elabora็ใo podem ser excluํdas!", {"Sair"} )
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01EfetบAutor  ณClaudinei Ferreira  บ Data ณ  24/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAvalia Aprovacao da Solicitacao e consulta saldo do PCO     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GCT                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Efet()
Local nRecnoSZ7 	:= SZ7->(Recno())
Local _cWfDir   	:= Alltrim(GetNewPar("MV_WFDIRWF","\workflow") )
Local lGeraCont		:= .F.
Local lSldOrc		:= .F.
Local _lContinua 	:= .F.
Local lRet          := .T.

IF SZ7->Z7_STATUS <> "1" // Em Elaboracao
	Aviso(cCadastro, "Somente solicita็๕es em elabora็ใo podem ser efetivadas!", {"Sair"} )
	Return()
ENDIF

IF Aviso(cCadastro,"Confirma efetiva็ใo da Solicita็ใo "+SZ7->Z7_NUM, {"Sim","Nใo"} ) <> 1
	Return()
ENDIF

PcoIniLan("000051")
DbSelectArea("SZ8")
SZ8->(DbSetOrder(1))
If (SZ8->(DbSeek(xFilial("SZ8") + SZ7->Z7_NUM)))
	While ((SZ8->(!Eof())) .And. (xFilial("SZ8") == SZ8->Z8_FILIAL) .And. (SZ7->Z7_NUM == SZ8->Z8_NUMSC))
		_lSaldoOK := PcoVldLan('900001','01','FIGCTX01',,, .T.)
		
		If (_lSaldoOK)
			PcoIniLan('000051')
			MsgRun("Gerando Movimentos. Aguarde... ","",{|| PcoDetLan('900001','01','FIGCTX01') })
			PcoFinLan('000051')
			
			RecLock("SZ8",.F.)
			SZ8->Z8_CONTLIB := .T.
			SZ8->(MsUnlock())
		Else
			lRet := .F.
		Endif
		
		SZ8->(DbSkip())
	Enddo
Endif
PcoFinLan("000051")

If !(lRet)
	RecLock("SZ7", .F.)
	SZ7->Z7_STATUS := "2"
	SZ7->(MsUnlock())
Else
	// Gera Al็ada
	MsgRun("Gerando Al็ada. Aguarde... ","",{|| U_GCTE01Scr() })
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Scr บAutor  ณTOTVS               บ Data ณ  24/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera controle de alcada                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Scr()
Local _cAreaCTT := CTT->(GetArea())

SCR->(dbSetOrder(1))

CTT->(dbSetOrder(1))
CTT->(dbSeek(XFilial("CTT")+SZ7->Z7_CUSTO))

IF !Empty(CTT->CTT_XAPROV)
	// Gravar Alcada SCR
	IF !SCR->(dbSeek(xFilial("SCR")+"GC"+SZ7->Z7_NUM))
		MaAlcDoc({SZ7->Z7_NUM,"GC",SZ7->Z7_VLINI,,,CTT->CTT_XAPROV,,1,1,SZ7->Z7_DTSOL},,1)
	Endif
	
	// Verifica se nao entrou em nenhum al็ada, e altera status para Pendente
	IF !SCR->(dbSeek(xFilial("SCR")+"GC"+SZ7->Z7_NUM))
		RecLock("SZ7",.F.)
		SZ7->Z7_STATUS := '6' // Pendente
		SZ7->(MsUnlock())
		Aviso("Aten็ใo", "Libera็ใo direta por falta de aprovadores (valores)!", {"Ok"} )
	Endif
	
ELSE
	RecLock("SZ7",.F.)
	SZ7->Z7_STATUS := '6' // Pendente
	SZ7->(MsUnlock())
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Can บAutor  ณMicrosiga           บ Data ณ 10/09/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valida cancelamento da SOlicitacao                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Can()

IF SZ7->Z7_STATUS$("5/6") // Aguardando Aprova็ใo e Pendentes
	
	IF Aviso(cCadastro,"Confirma cancelamento da Solicita็ใo "+SZ7->Z7_NUM, {"Sim","Nใo"} ) <> 1
		Return()
	ENDIF
	
	MsgRun("Estornando Movimentos da Solicita็ใo","",{|| PcoIniLan('900001'), PcoDetLan('900001','01','FIGCTX01',.T.), PcoFinLan('900001') })
	MsgRun("Estornando Empenhos da Solicita็ใo","",{|| PcoIniLan("000356"), PcoDetLan("000356",'02',"PCOA530",.T.), PcoFinLan("000356") })
	
	// Altera status para
	RecLock("SZ7",.F.)
	SZ7->Z7_STATUS := '8' // Cancelado
	SZ7->(MsUnlock())
ELSE
	Aviso(cCadastro, "Somente solicita็๕es pendentes de contrato e/ou reprovadas na al็ada podem ser canceladas!", {"Sair"} )
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Ctr บAutor  ณMicrosiga           บ Data ณ 10/09/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valida geracao de contrato                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Ctr()

IF SZ7->Z7_STATUS <> "6" // Pendente
	Aviso(cCadastro, "Somente solicita็๕es pendentes podem gerar contrato!", {"Sair"} )
	Return()
ENDIF

IF Aviso(cCadastro,"Confirma gera็ใo de contrato da Solicita็ใo "+SZ7->Z7_NUM, {"Sim","Nใo"} ) <> 1
	Return()
ENDIF

//Abertura das Tabelas de Contrato
ChkFile("CN9")
ChkFile("CNA")
ChkFile("CNB")
ChkFile("CNN")
ChkFile("CNZ")

//Reserva o numero da planilha
cPlanilha := GetSxENum("CNA","CNA_NUMERO")
CNA->(ConfirmSX8()) //Alterado 09/10/2013. Acrescentado essa linha
cPlanilha := StrZero( 1, Len(cPlanilha))

Begin Transaction

cContrato := GetSXENum("CN9","CN9_NUMERO")
CN9->(ConfirmSX8()) //Alterado 09/10/2013. Tirado bloco abaixo
/*
While CN9->(dbSeek(xFilial("CN9")+cContrato))
	CN9->(ConfirmSX8())
	cContrato := GetSXENum("CN9","CN9_NUMERO")
EndDo
*/
nItem := 1

//Grava CNA - Planilha Contrato
RecLock("CNA", .T.)
CNA->CNA_FILIAL := xFilial("CNA")
CNA->CNA_CONTRA := cContrato
CNA->CNA_NUMERO := cPlanilha
CNA->CNA_FORNEC := SZ7->Z7_FORNECE
CNA->CNA_LJFORN := SZ7->Z7_LOJA
CNA->CNA_DTINI  := dDataBase
CNA->CNA_VLTOT  := SZ7->Z7_VLINI
CNA->CNA_SALDO  := SZ7->Z7_VLINI
CNA->(MsUnLock())

//Grava CNB - Itens Contrato
RecLock("CNB", .T.)
CNB->CNB_FILIAL := xFilial("CNB")
CNB->CNB_NUMERO := cPlanilha
CNB->CNB_ITEM   := StrZero(1,TamSX3("CNB_ITEM")[1])
CNB->CNB_PRODUT := SZ7->Z7_PRODUTO
CNB->CNB_DESCRI := Posicione("SB1",1,xFilial("SB1")+SZ7->Z7_PRODUTO,"B1_DESC")
CNB->CNB_UM     := Posicione("SB1",1,xFilial("SB1")+SZ7->Z7_PRODUTO,"B1_UM")
CNB->CNB_QUANT  := 1
CNB->CNB_VLUNIT := SZ7->Z7_VLINI
CNB->CNB_VLTOT  := SZ7->Z7_VLINI
CNB->CNB_CONTRA := cContrato
CNB->CNB_DTCAD  := dDataBase
CNB->CNB_SLDMED := 1
CNB->CNB_SLDREC := 1
CNB->CNB_CONTA  := SZ7->Z7_CONTA
CNB->CNB_CC     := SZ7->Z7_CUSTO
CNB->CNB_ITEMCT := SZ7->Z7_ITEMCTB
CNB->CNB_CLVL   := SZ7->Z7_CLVL
CNB->CNB_XNUM	:= SZ7->Z7_NUM
CNB->(MsUnlock())

//Grava CNC - Fornecedor x Contrato
RecLock("CNC", .T.)
CNC->CNC_FILIAL := xFilial("CNC")
CNC->CNC_NUMERO := cContrato
CNC->CNC_CODIGO := SZ7->Z7_FORNECE
CNC->CNC_LOJA   := SZ7->Z7_LOJA
CNC->(MsUnLock())

//Grava CN9 - Cabe็alho Contrato
RecLock("CN9", .T.)
CN9->CN9_FILIAL := xFilial("CN9")
CN9->CN9_NUMERO := cContrato
CN9->CN9_VLINI  := SZ7->Z7_VLINI
CN9->CN9_VLATU  := SZ7->Z7_VLINI
CN9->CN9_SALDO	:= SZ7->Z7_VLINI
CN9->CN9_SITUAC	:= "02" // EM ELABORACAO
CN9->CN9_DTINIC := dDataBase
CN9->CN9_TPCTO	:= SZ7->Z7_TPCTO // Tipo de Contrato
CN9->CN9_MOEDA	:= 1
CN9->CN9_XNUMCT := SZ7->Z7_NUM
CN9->(MsUnlock())

//Grava CNN - Usuario x Contrato
RecLock("CNN", .T.)
CNN->CNN_FILIAL := xFilial("CNN")
CNN->CNN_CONTRA := cContrato
CNN->CNN_USRCOD := __CUSERID
CNN->CNN_TRACOD := "001"
CNN->CNN_GRPCOD := ""
CNN->(MsUnLock())

DbSelectArea("SZ8")
SZ8->(DbSetOrder(1))
If (SZ8->(DbSeek(xFilial("SZ8") + SZ7->Z7_NUM)))
	While ((SZ8->(!Eof())) .And. (xFilial("SZ8") == SZ8->Z8_FILIAL) .And. (SZ7->Z7_NUM == SZ8->Z8_NUMSC))
		RecLock("CNZ", .T.)
		CNZ->CNZ_FILIAL := xFilial("CNZ")
		CNZ->CNZ_CONTRA := cContrato
		CNZ->CNZ_CODPLA := cPlanilha
		CNZ->CNZ_FORNEC := SZ7->Z7_FORNECE
		CNZ->CNZ_LJFORN := SZ7->Z7_LOJA
		CNZ->CNZ_ITCONT := StrZero(1,TamSX3("CNB_ITEM")[1])
		CNZ->CNZ_ITEM   := SubStr(SZ8->Z8_ITEM, 3, 2)
		CNZ->CNZ_PERC   := SZ8->Z8_PERC
		CNZ->CNZ_CC     := SZ8->Z8_CUSTO
		CNZ->CNZ_CONTA  := SZ8->Z8_CONTA
		CNZ->CNZ_ITEMCT := SZ8->Z8_ITEMCTB
		CNZ->CNZ_CLVL   := SZ8->Z8_CLVL
		CNZ->CNZ_VALOR1 := SZ8->Z8_VALOR
		CNZ->(MsUnlock())

		SZ8->(DbSkip())
	Enddo
Endif

RecLock("SZ7",.F.)
SZ7->Z7_STATUS  := '7' // Atendido
SZ7->Z7_CONTRAT := cContrato
SZ7->(MsUnlock())

End Transaction

Aviso( "Gera็ใo de Contrato", "Contrato n๚mero: " + cContrato + " gerado com sucesso.", {"Ok"} )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Res บAutor  ณMicrosiga           บ Data ณ 10/09/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gera revisao do contrato                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Res()

IF SZ7->Z7_STATUS <> "7" // Pendente
	Aviso(cCadastro, "Somente solicita็๕es com contrato gerado podem ser revisadas!", {"Sair"} )
	Return()
ENDIF

IF Empty(SZ7->Z7_CONTRAT)
	Aviso(cCadastro, "Campo de contrato nใo informado. Verifique!", {"Sair"} )
	Return()
ENDIF

IF !Empty(SZ7->Z7_REVISAO) .and. Aviso(cCadastro,"Este contrato jแ possui revisใo. Deseja incluir/alterar revisใo ?", {"Sim","Nใo"} ) <> 1
	Return()
ENDIF

IF Empty(SZ7->Z7_REVISAO) .and. Aviso(cCadastro,"Confirma revisใo do contrato "+Alltrim(SZ7->Z7_CONTRAT)+" ?", {"Sim","Nใo"} ) <> 1
	Return()
ENDIF

CN9->(dbSetOrder(1))
IF CN9->(dbSeek(XFilial("CN9")+SZ7->(Z7_CONTRAT+Z7_REVISAO)))
	CN140Manut("CN9",CN9->(Recno()),3)
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01TOK  บAutor  ณMicrosiga           บ Data ณ  09/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao TudoOK                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01TOK(_nOpc)
Local _aArea    := {GetArea(), SZ8->(GetArea()), CTT->(GetArea())}
Local _lRet     := .T.
Local lAchou    := .F.

IF _nOpc == 3 .or. _nOpc == 4 // Inclusao ou Alteracao
	CTT->(dbSetOrder(1))
	IF CTT->(dbSeek(XFilial("CTT")+M->Z7_CUSTO))
		IF Empty(CTT->CTT_XAPROV)
			Aviso(cCadastro, "O centro de custo informado nใo possui Grupo de Aprova็ใo!", {"Sair"} )
			_lRet := .F.
		ENDIF
	ENDIF
ENDIF

If ((_nOpc == 3) .Or. (_nOpc == 4))
	DbSelectArea((cAliasTrb))
	(cAliasTrb)->(DbGoTop())
	
	While ((cAliasTrb)->(!Eof()))
		DbSelectArea("SZ8")
		SZ8->(DbSetOrder(1))
		lAchou := SZ8->(DbSeek(xFilial("SZ8") + M->Z7_NUM + (cAliasTrb)->(Z8_ITEM)))
		
		RecLock("SZ8", !(lAchou))
		
		If (!(cAliasTrb)->(Z8_DEL))
			SZ8->Z8_FILIAL  := xFilial("SZ8")
			SZ8->Z8_NUMSC   := M->Z7_NUM
			SZ8->Z8_ITEM    := (cAliasTrb)->(Z8_ITEM)
			SZ8->Z8_CONTA   := (cAliasTrb)->(Z8_CONTA)
			SZ8->Z8_CUSTO   := (cAliasTrb)->(Z8_CUSTO)
			SZ8->Z8_ITEMCTB := (cAliasTrb)->(Z8_ITEMCTB)
			SZ8->Z8_CLVL    := (cAliasTrb)->(Z8_CLVL)
			SZ8->Z8_PERC    := (cAliasTrb)->(Z8_PERC)
			SZ8->Z8_VALOR   := (cAliasTrb)->(Z8_VALOR)
			SZ8->Z8_CODCONT := ""
			SZ8->Z8_CONTLIB := .F.
		Elseif ((lAchou) .And. (cAliasTrb)->(Z8_DEL))
			SZ8->(DbDelete())
		Endif
		
		SZ8->(MsUnlock())
		
		(cAliasTrb)->(DbSkip())
	Enddo
Endif

aEval(_aArea, {|x| RestArea(x)})
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Mnu บAutor  ณMicrosiga           บ Data ณ  09/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao de Menu                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GCTE01Mnu()
Local _aRet := {}

aAdd( _aRet ,{"Pesquisar" 			,'AxPesqui'  	,0,1})
aAdd( _aRet ,{"Visualizar"			,'u_GCTE01Vis'	,0,2})
aAdd( _aRet ,{"Incluir"   			,'U_GCTE01Inc'  ,0,3})
aAdd( _aRet ,{"Alterar"   			,'U_GCTE01Alt'	,0,4})
aAdd( _aRet, {"Excluir"   			,'U_GCTE01Del'	,0,5})
aAdd( _aRet ,{"Efetivar Solicita็ใo",'U_GCTE01Efet'	,0,4})
aAdd( _aRet ,{"Cancelar Solicita็ใo",'U_GCTE01Can'	,0,4})
aAdd( _aRet ,{"Consultar Aprova็ใo" ,'U_FIGCTA01(4)',0,4})
aAdd( _aRet ,{"Gerar Contrato"		,'U_GCTE01Ctr'	,0,4})
aAdd( _aRet ,{"Revisar Contrato"	,'U_GCTE01Res'	,0,4})
aAdd( _aRet ,{"Legenda"   			,'U_GCTE01Leg'	,0,6})

Return(_aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGCTE01Leg   บAutor  ณTotvs               บ Data ณ  10/08/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualizacao da legenda (Solicitacao de Contrato            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFIESP                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GCTE01Leg()
Local aCor := {}

aAdd(aCor,{"BR_AMARELO"		,"Em Elabora็ใo"           })
aAdd(aCor,{"PMSEDT3"		,"Aguardando Conting๊ncia" })
aAdd(aCor,{"BR_CANCEL"		,"Or็amento Reprovado"     })
aAdd(aCor,{"BR_AZUL"		,"Aguardando Aprova็ใo"    })
aAdd(aCor,{"BR_MARROM"		,"Solicita็ใo Reprovada"   })
aAdd(aCor,{"BR_VERDE" 		,"Solicita็ใo Pendente"    })
aAdd(aCor,{"BR_VERMELHO"	,"Solicita็ใo Atendida"    })
aAdd(aCor,{"BR_PRETO"		,"Solicita็ใo Cancelada"   })

BrwLegenda(cCadastro,OemToAnsi("Solicita็ใo"),aCor)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIGCTX01  บAutor  ณFelipe Alves        บ Data ณ  26/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRateio(nOpc)
Local lRet := .T.
Local aEstrut := {{"Z8_ITEM" , "C", 4 , 0}, ;
				{"Z8_CONTA"  , "C", 20 , 0}, ;
				{"Z8_CUSTO"  , "C", 9 , 0}, ;
				{"Z8_ITEMCTB", "C", 9 , 0}, ;
				{"Z8_CLVL"   , "C", 9 , 0}, ;
				{"Z8_PERC"   , "N", 6 , 2}, ;
				{"Z8_VALOR"  , "N", 14, 2}, ;
				{"Z8_DEL"    , "L", 1 , 0}}
Local cChave := "Z8_ITEM+Z8_CONTA+Z8_CUSTO+Z8_ITEMCTB+Z8_CLVL"

Private oArqRateio := CriaTrab(aEstrut, .T.)

If (Select((cAliasTrb)) > 0)
	(cAliasTrb)->(DbCloseArea())
Endif

DbUseArea(.T., , oArqRateio, cAliasTrb, .F., .F.)

IndRegua(cAliasTrb, oArqRateio, cChave, , , "Selecionando Registros...")
DbSelectArea(cAliasTrb)
DbSetIndex(oArqRateio+OrdBagExt())
DbSetOrder(1)

If !(nOpc == 3)
	DbSelectArea("SZ8")
	SZ8->(DbSetOrder(1))
	If (SZ8->(DbSeek(xFilial("SZ8") + SZ7->Z7_NUM)))
		While ((SZ8->(!Eof())) .And. (xFilial("SZ8") == SZ8->Z8_FILIAL) .And. (SZ7->Z7_NUM == SZ8->Z8_NUMSC))
			RecLock((cAliasTrb), .T.)
			(cAliasTrb)->(Z8_ITEM)    := SZ8->Z8_ITEM
			(cAliasTrb)->(Z8_CONTA)   := SZ8->Z8_CONTA
			(cAliasTrb)->(Z8_CUSTO)   := SZ8->Z8_CUSTO
			(cAliasTrb)->(Z8_ITEMCTB) := SZ8->Z8_ITEMCTB
			(cAliasTrb)->(Z8_CLVL)    := SZ8->Z8_CLVL
			(cAliasTrb)->(Z8_PERC)    := SZ8->Z8_PERC
			(cAliasTrb)->(Z8_VALOR)   := SZ8->Z8_VALOR
			(cAliasTrb)->(Z8_DEL)     := .F.
			(cAliasTrb)->(MsUnlock())

			SZ8->(DbSkip())
		Enddo
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIGCTX01  บAutor  ณFelipe Alves        บ Data ณ  26/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GCT01Rat(nOpc)
Local aArea    := {GetArea()}
Local lRet     := .T.
Local aButtons := {}
Local aHeader  := {}
Local aCols    := {}
Local cNoCpos  := "Z8_NUMSC;Z8_CODCONT;Z8_CONTLIB"

Private oRateio

Default nOpc := 3

aButtons := {{'AUTOM', {|| AdmRatExt(aHeader,oRateio:aCols,{ |x,y,z,w| X01CarCC(x,y,@z,w) }) }, "Rateio pr้-configurado"}}

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ8"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ8"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeader,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

DbSelectArea((cAliasTrb))
(cAliasTrb)->(DbGoTop())

While ((cAliasTrb)->(!Eof()))
	aAdd(aCols, {(cAliasTrb)->(Z8_ITEM), ;
				(cAliasTrb)->(Z8_CONTA), ;
				(cAliasTrb)->(Z8_CUSTO), ;
				(cAliasTrb)->(Z8_ITEMCTB), ;
				(cAliasTrb)->(Z8_CLVL), ;
				(cAliasTrb)->(Z8_PERC), ;
				(cAliasTrb)->(Z8_VALOR), ;
				(cAliasTrb)->(Z8_DEL)})

	(cAliasTrb)->(DbSkip())
Enddo

If ((Len(aCols) == 0) .And. (nOpc == 3))
	aAdd(aCols, {"0001", M->Z7_CONTA, M->Z7_CUSTO, M->Z7_ITEMCTB, M->Z7_CLVL, 100, M->Z7_VLINI, .F.})
Endif

Define MsDialog oDlg Title "Rateio de Solicit. de Contrato" From 0, 0 To 300, 600 Pixel

oRateio := MsNewGetDados():New(0, 0, 140, 302, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue()", "AllwaysTrue()", ;
							"+Z8_ITEM", , , 999, "AllwaysTrue()", , , oDlg, aHeader, aCols)
If (nOpc == 2)
	oRateio:Disable()
Endif

Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| FIGCTRat(oRateio:aCols), oDlg:End()}, {|| oDlg:End()}, , @aButtons))

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIGCTX01  บAutor  ณFelipe Alves        บ Data ณ  27/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FIGCTRat(oRat)
Local aArea := {GetArea()}
Local lRet := .T.
Local nI := 0

DbSelectArea((cAliasTrb))
(cAliasTrb)->(DbSetOrder(1))

For nI := 1 To Len(oRat)
	If ((cAliasTrb)->(DbSeek(oRat[nI][1])))
		If !(oRat[nI][8])
			RecLock((cAliasTrb), .F.)
			(cAliasTrb)->Z8_ITEM    := oRat[nI][1]
			(cAliasTrb)->Z8_CONTA   := oRat[nI][2]
			(cAliasTrb)->Z8_CUSTO   := oRat[nI][3]
			(cAliasTrb)->Z8_ITEMCTB := oRat[nI][4]
			(cAliasTrb)->Z8_CLVL    := oRat[nI][5]
			(cAliasTrb)->Z8_PERC    := oRat[nI][6]
			(cAliasTrb)->Z8_VALOR   := oRat[nI][7]
			(cAliasTrb)->Z8_DEL     := .F.
			(cAliasTrb)->(MsUnlock())
		Else
			RecLock((cAliasTrb), .F.)
			(cAliasTrb)->Z8_DEL     := .T.
			(cAliasTrb)->(MsUnlock())
		Endif
	Else
		If !(oRat[nI][8])
			RecLock((cAliasTrb), .T.)
			(cAliasTrb)->Z8_ITEM    := oRat[nI][1]
			(cAliasTrb)->Z8_CONTA   := oRat[nI][2]
			(cAliasTrb)->Z8_CUSTO   := oRat[nI][3]
			(cAliasTrb)->Z8_ITEMCTB := oRat[nI][4]
			(cAliasTrb)->Z8_CLVL    := oRat[nI][5]
			(cAliasTrb)->Z8_PERC    := oRat[nI][6]
			(cAliasTrb)->Z8_VALOR   := oRat[nI][7]
			(cAliasTrb)->Z8_DEL     := .F.
			(cAliasTrb)->(MsUnlock())
		Endif
	Endif
Next nI

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIGCTX01  บAutor  ณFelipe Alves        บ Data ณ  27/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function X01CarCC(aCols, aHeader, cItem, lPrimeiro)
Local lCusto		:= CtbMovSaldo("CTT")
Local lItem	 		:= CtbMovSaldo("CTD")
Local lCLVL	 		:= CtbMovSaldo("CTH")
Local nPosPerc		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z8_PERC" } )
Local nPosItem		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z8_ITEM" } )
Local nPosCC		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z8_CUSTO"} )
Local nPosConta		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z8_CONTA"} )
Local nPosItemCta	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z8_ITEMCTB"} )
Local nPosCLVL		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z8_CLVL"} )
Local nPosValor     := aScan(aHeader,{|x| AllTrim(x[2]) == "Z8_VALOR"} )
Local nHeader       := 0
Local aMT103PRE     := {}

If lPrimeiro
	//-- Se ja foi informado algum rateio, limpar o aCols
	If aCols[Len(aCols)][nPosPerc] <> 0
		aCols := {}
		Aadd(aCols, Array(Len(aHeader) + 1))
		For nHeader := 1 To Len(aHeader)
			If Trim(aHeader[nHeader][2]) <> "CH_ALI_WT" .And. Trim(aHeader[nHeader][2]) <> "CH_REC_WT"
				aCols[Len(aCols)][nHeader] := CriaVar(aHeader[nHeader][2])
			Endif
		Next
	EndIf
	cItem := Soma1(cItem)
	aCols[Len(aCols)][nPosItem]  := StrZero(Val(cItem), TamSX3("Z8_ITEM")[1])
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
Else
	If aCols[Len(aCols)][nPosPerc] = 0
		nCols := Len(aCols)
		cItem := aCols[nCols][nPosItem]
	Else
		If Len(aCols) > 0
			cItem := aCols[Len(aCols)][nPosItem]
		Endif
		Aadd(aCols, Array(Len(aHeader) + 1))
		cItem := Soma1(cItem)
	EndIf
	
	For nHeader := 1 To Len(aHeader)
		If Trim(aHeader[nHeader][2]) <> "CH_ALI_WT" .And. Trim(aHeader[nHeader][2]) <> "CH_REC_WT"
			aCols[Len(aCols)][nHeader] := CriaVar(aHeader[nHeader][2])
		EndIf
	Next
	
	aCols[Len(aCols)][nPosItem] := cItem
	
	// Interpreto os campos incluida possibilidade de variaveis de memoria
	If !Empty(CTJ->CTJ_DEBITO)
		aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_DEBITO
	Else
		aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_CREDIT
	Endif
	
	
	If lCusto
		If ! Empty(CTJ->CTJ_CCD)
			aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCD
		Else
			aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCC
		Endif
	EndIf
	
	If lItem
		If ! Empty(CTJ->CTJ_ITEMD)
			aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMD
		Else
			aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMC
		Endif
	EndIf
	
	If lClVl
		If ! Empty(CTJ->CTJ_CLVLDB)
			aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLDB
		Else
			aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLCR
		Endif
	EndIf
	aCols[Len(aCols)][nPosPerc] := CTJ->CTJ_PERCEN
	aCols[Len(aCols)][nPosValor] := M->Z7_VLINI * (CTJ->CTJ_PERCEN / 100)
	aCols[Len(aCols)][Len(aHeader) + 1] := .F.
	
EndIf

Return .T.