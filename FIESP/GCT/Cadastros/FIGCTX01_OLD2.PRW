#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

#Define ENTER Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIGCTX01  �Autor  �Claudinei/Donizeti  � Data �  10/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina especifica para Manutencao na Solicitacao de Contrato���
�������������������������������������������������������������������������͹��
���Uso       �FIESP                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Private aIndex 	   := {}
Private bFiltraBrw := {}
Private cFiltro    := ""
//
dbSelectArea('SZ7')
dbSetOrder(1)

// Inclus�o de Filtro por Usu�rio x Centro de Custo - Donizeti - 16/12/2013

_aArea   := GetArea()
_cCentroC:= ""
SZF->(dbSetOrder(1))
SZF->(MsSeek(xFilial("SZF")+__cUserId))
While SZF->(!Eof()) .and. SZF->(ZF_FILIAL+ZF_USERID) == XFilial("SZF")+(__cUserId)
	_cCentroC+=	alltrim(SZF->ZF_CUSTO) + "|"
	SZF->(DbSkip())
Enddo
RestArea(_aArea)

cFiltro 	:= "SZ7->Z7_USUSOL $ '" + __cUserId + "' .or. ALLTRIM(SZ7->Z7_CUSTO) $ '" + _cCentroC + "'"

bFiltraBrw 	:= {|| FilBrowse("SZ7", @aIndex, @cFiltro)}
Eval(bFiltraBrw)

/////

mBrowse(,,,,"SZ7",,,,,,aCores,,, )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Inc  �Autor  �Microsiga           � Data �  09/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida inclusao da Solicitacao                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Inc()
Local aButtons := {}

Private cAliasTrb  := GetNextAlias()

xRateio(3)

aAdd(aButtons, {"Filtro", {|| GCT01Rat(3)}, "Rateio"})

AxInclui("SZ7", , , , , ,"U_GCTE01TOK(3)", , , aButtons, , ,.T.)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIGCTX01  �Autor  �Felipe Alves        � Data �  27/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Alt  �Autor  �Microsiga           � Data �  09/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida altera��o da Solicitacao                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Alt()
Local aButtons := {}

Private cAliasTrb  := GetNextAlias()

xRateio(4)

aAdd(aButtons, {"Filtro", {|| GCT01Rat(4)}, "Rateio"})

IF SZ7->Z7_STATUS == "1" // Em Elaboracao
	AxAltera('SZ7',SZ7->(Recno()),4,,,,,"U_GCTE01TOK(4)", , , aButtons, , ,.T.)
ELSE
	Aviso(cCadastro, "Somente solicita��es em elabora��o podem ser alteradas!", {"Sair"} )
ENDIF

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Del �Autor  �Microsiga           � Data � 10/09/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida exclusao da Solicitacao                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Del(nReg,nOpc)

IF SZ7->Z7_STATUS == "1" // Em Elaboracao
	AxDeleta('SZ7',SZ7->(Recno()),5)
ELSE
	Aviso(cCadastro, "Somente solicita��es em elabora��o podem ser exclu�das!", {"Sair"} )
ENDIF

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Efet�Autor  �Claudinei Ferreira  � Data �  24/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Avalia Aprovacao da Solicitacao e consulta saldo do PCO     ���
�������������������������������������������������������������������������͹��
���Uso       � GCT                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Efet()
Local nRecnoSZ7 	:= SZ7->(Recno())
Local _cWfDir   	:= Alltrim(GetNewPar("MV_WFDIRWF","\workflow") )
Local lGeraCont		:= .F.
Local lSldOrc		:= .F.
Local _lContinua 	:= .F.
Local lRet          := .T.

IF SZ7->Z7_STATUS <> "1" // Em Elaboracao
	Aviso(cCadastro, "Somente solicita��es em elabora��o podem ser efetivadas!", {"Sair"} )
	Return()
ENDIF

IF Aviso(cCadastro,"Confirma efetiva��o da Solicita��o "+SZ7->Z7_NUM, {"Sim","N�o"} ) <> 1
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
	// Gera Al�ada
	MsgRun("Gerando Al�ada. Aguarde... ","",{|| U_GCTE01Scr() })
Endif

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Scr �Autor  �TOTVS               � Data �  24/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera controle de alcada                                    ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Scr()
//Local _cAreaCTT := CTT->(GetArea())

SCR->(dbSetOrder(1))

CTT->(dbSetOrder(1))
CTT->(dbSeek(XFilial("CTT")+SZ7->Z7_CUSTO))

IF !Empty(CTT->CTT_XAPROV)
	// Gravar Alcada SCR
	IF !SCR->(dbSeek(xFilial("SCR")+"GC"+SZ7->Z7_NUM))
		MaAlcDoc({SZ7->Z7_NUM,"GC",SZ7->Z7_VLINI,,,CTT->CTT_XAPROV,,1,1,SZ7->Z7_DTSOL},,1)
	Endif
	
	// Verifica se nao entrou em nenhum al�ada, e altera status para Pendente
	IF !SCR->(dbSeek(xFilial("SCR")+"GC"+SZ7->Z7_NUM))
		RecLock("SZ7",.F.)
		SZ7->Z7_STATUS := '6' // Pendente
		SZ7->(MsUnlock())
		Aviso("Aten��o", "Libera��o direta por falta de aprovadores (valores)!", {"Ok"} )
	Endif
	
ELSE
	RecLock("SZ7",.F.)
	SZ7->Z7_STATUS := '6' // Pendente
	SZ7->(MsUnlock())
ENDIF

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Can �Autor  �Microsiga           � Data � 10/09/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida cancelamento da SOlicitacao                        ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Can()

IF SZ7->Z7_STATUS$("5/6") // Aguardando Aprova��o e Pendentes
	
	IF Aviso(cCadastro,"Confirma cancelamento da Solicita��o "+SZ7->Z7_NUM, {"Sim","N�o"} ) <> 1
		Return()
	ENDIF
	
	MsgRun("Estornando Movimentos da Solicita��o","",{|| PcoIniLan('900001'), PcoDetLan('900001','01','FIGCTX01',.T.), PcoFinLan('900001') })
	MsgRun("Estornando Empenhos da Solicita��o","",{|| PcoIniLan("000356"), PcoDetLan("000356",'02',"PCOA530",.T.), PcoFinLan("000356") })
	
	// Altera status para
	RecLock("SZ7",.F.)
	SZ7->Z7_STATUS := '8' // Cancelado
	SZ7->(MsUnlock())
ELSE
	Aviso(cCadastro, "Somente solicita��es pendentes de contrato e/ou reprovadas na al�ada podem ser canceladas!", {"Sair"} )
ENDIF

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Ctr �Autor  �Microsiga           � Data � 10/09/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Valida geracao de contrato                                ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Ctr()

IF SZ7->Z7_STATUS <> "6" // Pendente
	Aviso(cCadastro, "Somente solicita��es pendentes podem gerar contrato!", {"Sair"} )
	Return()
ENDIF

IF Aviso(cCadastro,"Confirma gera��o de contrato da Solicita��o "+SZ7->Z7_NUM, {"Sim","N�o"} ) <> 1
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

//Grava CN9 - Cabe�alho Contrato
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

Aviso( "Gera��o de Contrato", "Contrato n�mero: " + cContrato + " gerado com sucesso.", {"Ok"} )

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Res �Autor  �Microsiga           � Data � 10/09/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �  Gera revisao do contrato                                  ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Res()

IF SZ7->Z7_STATUS <> "7" // Pendente
	Aviso(cCadastro, "Somente solicita��es com contrato gerado podem ser revisadas!", {"Sair"} )
	Return()
ENDIF

IF Empty(SZ7->Z7_CONTRAT)
	Aviso(cCadastro, "Campo de contrato n�o informado. Verifique!", {"Sair"} )
	Return()
ENDIF

IF !Empty(SZ7->Z7_REVISAO) .and. Aviso(cCadastro,"Este contrato j� possui revis�o. Deseja incluir/alterar revis�o ?", {"Sim","N�o"} ) <> 1
	Return()
ENDIF

IF Empty(SZ7->Z7_REVISAO) .and. Aviso(cCadastro,"Confirma revis�o do contrato "+Alltrim(SZ7->Z7_CONTRAT)+" ?", {"Sim","N�o"} ) <> 1
	Return()
ENDIF

CN9->(dbSetOrder(1))
IF CN9->(dbSeek(XFilial("CN9")+SZ7->(Z7_CONTRAT+Z7_REVISAO)))
	CN140Manut("CN9",CN9->(Recno()),3)
ENDIF

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01TOK  �Autor  �Microsiga           � Data �  09/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao TudoOK                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01TOK(_nOpc)
Local _aArea    := {GetArea(), SZ8->(GetArea()), CTT->(GetArea())}
Local _lRet     := .T.
Local lAchou    := .F.

IF _nOpc == 3 .or. _nOpc == 4 // Inclusao ou Alteracao
	CTT->(dbSetOrder(1))
	IF CTT->(dbSeek(XFilial("CTT")+M->Z7_CUSTO))
		IF Empty(CTT->CTT_XAPROV)
			Aviso(cCadastro, "O centro de custo informado n�o possui Grupo de Aprova��o!", {"Sair"} )
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Mnu �Autor  �Microsiga           � Data �  09/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Criacao de Menu                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GCTE01Mnu()
Local _aRet := {}

aAdd( _aRet ,{"Pesquisar" 			,'AxPesqui'  	,0,1})
aAdd( _aRet ,{"Visualizar"			,'u_GCTE01Vis'	,0,2})
aAdd( _aRet ,{"Incluir"   			,'U_GCTE01Inc'  ,0,3})
aAdd( _aRet ,{"Alterar"   			,'U_GCTE01Alt'	,0,4})
aAdd( _aRet, {"Excluir"   			,'U_GCTE01Del'	,0,5})
aAdd( _aRet ,{"Efetivar Solicita��o",'U_GCTE01Efet'	,0,4})
aAdd( _aRet ,{"Cancelar Solicita��o",'U_GCTE01Can'	,0,4})
aAdd( _aRet ,{"Consultar Aprova��o" ,'U_FIGCTA01(4)',0,4})
aAdd( _aRet ,{"Gerar Contrato"		,'U_GCTE01Ctr'	,0,4})
aAdd( _aRet ,{"Revisar Contrato"	,'U_GCTE01Res'	,0,4})
aAdd( _aRet ,{"Legenda"   			,'U_GCTE01Leg'	,0,6})

Return(_aRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTE01Leg   �Autor  �Totvs               � Data �  10/08/13 ���
�������������������������������������������������������������������������͹��
���Desc.     �Visualizacao da legenda (Solicitacao de Contrato            ���
�������������������������������������������������������������������������͹��
���Uso       �FIESP                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCTE01Leg()
Local aCor := {}

aAdd(aCor,{"BR_AMARELO"		,"Em Elabora��o"           })
aAdd(aCor,{"PMSEDT3"		,"Aguardando Conting�ncia" })
aAdd(aCor,{"BR_CANCEL"		,"Or�amento Reprovado"     })
aAdd(aCor,{"BR_AZUL"		,"Aguardando Aprova��o"    })
aAdd(aCor,{"BR_MARROM"		,"Solicita��o Reprovada"   })
aAdd(aCor,{"BR_VERDE" 		,"Solicita��o Pendente"    })
aAdd(aCor,{"BR_VERMELHO"	,"Solicita��o Atendida"    })
aAdd(aCor,{"BR_PRETO"		,"Solicita��o Cancelada"   })

BrwLegenda(cCadastro,OemToAnsi("Solicita��o"),aCor)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIGCTX01  �Autor  �Felipe Alves        � Data �  26/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIGCTX01  �Autor  �Felipe Alves        � Data �  26/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

aButtons := {{'AUTOM', {|| AdmRatExt(aHeader,oRateio:aCols,{ |x,y,z,w| X01CarCC(x,y,@z,w) }) }, "Rateio pr�-configurado"}}

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

// Altera��o Donizeti para validar os percentais de rateio

/*oRateio  := MsNewGetDados():New(0, 0, 140, 302, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue()", "AllwaysTrue()", ;  
"+Z8_ITEM", , , 999, "AllwaysTrue()", , , oDlg, aHeader, aCols) */

oRateio  := MsNewGetDados():New(0, 0, 140, 302, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue()", "RatTudOk()", ; 
"+Z8_ITEM", , , 999, "AllwaysTrue()", , , oDlg, aHeader, aCols)

If (nOpc == 2)
	oRateio:Disable()
Endif

//Altera��o Donizeti para validar os percentais de rateio
//Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg,{ || IIf(oRateio:TudoOk() .and. FIGCTRat(oRateio:aCols), oDlg:End()}, {|| oDlg:End() }, , @aButtons))

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg,  { || IIf(RatTudOk(oRateio:aCols) .and. FIGCTRat(oRateio:aCols), (nOpc:=1,oDlg:End()),nOpc := 0 )  },;
								   						  { || (nOpc:=2,oDlg:End())  },, aButtons )

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIGCTX01  �Autor  �Felipe Alves        � Data �  27/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FIGCTRat(oRat)
Local aArea := {GetArea()}
Local lRet 	:= .T.
Local nI 	:= 0      

IF lRet
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
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIGCTX01  �Autor  �Felipe Alves        � Data �  27/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RatTudOk �Autor  � Donizeti Lopes      � Data �  17/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao de todas as linhas da getdados                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function RatTudOk(oRat)
Local _lRet := .T.
Local _nAtu	:= oRateio:nAt
Local _nTotal:= 0
Local nI

For nI	:= 1 To Len(oRat)
	If !oRat[nI][Len(oRat[nI])]
		_nTotal += oRat[nI][6]
	EndIf
Next

If _nTotal > 0 .And. _nTotal <> 100
	Help(" ",1,"A103TOTRAT")
	_lRet := .F.
EndIf

oRateio:nAt := _nAtu
Return _lRet

