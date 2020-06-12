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
{ 'Z7_STATUS == "8"'  , "BR_PRETO"},;
{ 'Z7_STATUS == "9"'  , "BR_PINK"}}

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

AxInclui("SZ7", , , , , ,"U_GCTE01TOK(3)")

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

IF SZ7->Z7_STATUS == "1" // Em Elaboracao
	AxAltera('SZ7',SZ7->(Recno()),4,,,,,"U_GCTE01TOK(4)")
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

IF SZ7->Z7_STATUS <> "1" // Em Elaboracao
	Aviso(cCadastro, "Somente solicita็๕es em elabora็ใo podem ser efetivadas!", {"Sair"} )
	Return()
ENDIF

IF Aviso(cCadastro,"Confirma efetiva็ใo da Solicita็ใo "+SZ7->Z7_NUM, {"Sim","Nใo"} ) <> 1
	Return()
ENDIF

_lSaldoOK := PcoVldLan('900001','01','FIGCTX01',,, .T.)

IF _lSaldoOK // Orcamento OK - Envia para Aprova็ใo
	
	PcoIniLan('000051')
	MsgRun("Gerando Movimentos. Aguarde... ","",{|| PcoDetLan('900001','01','FIGCTX01') })
	PcoFinLan('000051')
	
	RecLock("SZ7",.F.)
	SZ7->Z7_STATUS := '4' // Em Aprova็ใo
	SZ7->(MsUnlock())
	
	// Gera Al็ada
	MsgRun("Gerando Al็ada. Aguarde... ","",{|| GCTE01Scr() })
	
ELSE
	IF !Empty(SZ7->Z7_XCDCNTG)
		RecLock("SZ7",.F.)
		SZ7->Z7_STATUS := '2' // Em Contingencia
		SZ7->(MsUnlock())
	ENDIF
ENDIF

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

Static Function GCTE01Scr()
Local _cAreaCTT := CTT->(GetArea())

SCR->(dbSetOrder(1))

CTT->(dbSetOrder(1))
CTT->(dbSeek(XFilial("CTT")+SZ7->Z7_CUSTO))

IF !Empty(CTT->CTT_XAPROV)
	// Gravar Alcada SCR
	IF !SCR->(dbSeek(xFilial("SCR")+"GC"+SZ7->Z7_NUM))
		MaAlcDoc({SZ7->Z7_NUM,"GC",SZ7->Z7_VLINI,,,CTT->CTT_XAPROV,,1,1,SZ7->Z7_DTSOL},,1)
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

//Reserva o numero da planilha
cPlanilha := GetSxENum("CNA","CNA_NUMERO")
cPlanilha := StrZero( 1, Len(cPlanilha))

Begin Transaction

cContrato := GetSXENum("CN9","CN9_NUMERO")
While CN9->(dbSeek(xFilial("CN9")+cContrato))
	CN9->(ConfirmSX8())
	cContrato := GetSXENum("CN9","CN9_NUMERO")
EndDo
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
CNB->CNB_CC     := SZ7->Z7_CONTA
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

IF Aviso(cCadastro,"Confirma revisใo do contrato "+Alltrim(SZ7->Z7_CONTRAT)+" ?", {"Sim","Nใo"} ) <> 1
	Return()
ENDIF

CN9->(dbSetOrder(1))
IF CN9->(dbSeek(XFilial("CN9")+SZ7->(Z7_CONTRAT+Z7_REVISAO)))
	CN140Manut("CN9",CN9->(Recno()),3)
ENDIF

a:= ""

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
Local _lRet     := .T.
Local _cAreaCTT := CTT->(GetArea())

IF _nOpc == 3 .or. _nOpc == 4 // Inclusao ou Alteracao
	CTT->(dbSetOrder(1))
	IF CTT->(dbSeek(XFilial("CTT")+M->Z7_CUSTO))
		IF Empty(CTT->CTT_XAPROV)
			Aviso(cCadastro, "O centro de custo informado nใo possui Grupo de Aprova็ใo!", {"Sair"} )
			_lRet := .F.
		ENDIF
	ENDIF
ENDIF

RestArea(_cAreaCTT)
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
aAdd( _aRet ,{"Visualizar"			,'AxVisual'		,0,2})
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
aAdd(aCor,{"BR_PINK"		,"Revisใo Gerada"   })

BrwLegenda(cCadastro,OemToAnsi("Solicita็ใo"),aCor)

Return
