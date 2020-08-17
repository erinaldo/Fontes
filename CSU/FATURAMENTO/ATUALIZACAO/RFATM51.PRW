#INCLUDE "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE MAXPASSO 4
//Entry Point - Pontos de Entrada
#DEFINE EP_M460MKB	 01
#DEFINE EP_M461IMPF 02
#DEFINE EP_SF2460I	 03
#DEFINE EP_M460IPI	 04
#DEFINE EP_M460ICM	 05
#DEFINE EP_M460SOLI 06
#DEFINE EP_MSD2UM2	 07
#DEFINE EP_MSD2460	 08
#DEFINE EP_MTASF2	 09
#DEFINE EP_F440COM	 10
#DEFINE EP_M460IREN 11
#DEFINE EP_M460ISS	 12
#DEFINE EP_M460VISS 13
#DEFINE EP_M460ATEC 14
#DEFINE EP_M460NITE 15
#DEFINE EP_M460PROC 16
#DEFINE EP_M460QRY  17
#DEFINE EP_M460FIL  18
#DEFINE EP_M460RTPD 19
#DEFINE EP_M460FIM  20
#DEFINE EP_M460COND 21
#DEFINE EP_M460INSS 22
#DEFINE EP_M460ITPD 23
#DEFINE EP_M460ORD  24
#DEFINE EP_M460MOED 25
#DEFINE EP_M460FIT  26
#DEFINE EP_M460IPT	 27
#DEFINE EP_M460QRT  28
#DEFINE EP_M460SOT  29
#DEFINE EP_MSD246T	 30
#DEFINE EP_MSD2UMT	 31
#DEFINE EP_SF2460T	 32
#DEFINE EP_M460RAT  33
#DEFINE EP_M461ACRE 34

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATM51   บ Autor ณPaulo Bindo         บ Data ณ  03/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera Nota fiscal da distribuidora para a matriz e emite     บฑฑ
ฑฑบ          ณnota fiscal para o cliente                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFATM51()
Local oProcess
Private cPerg 	:= "RFAT51"
Private lAuto 	:= .T.
Private nPro    := 1
Private cText   := "Processo "
Private nCount	:= 0
Private  cNewEmp	:= GetJobProfString('cCodEmp', '05')
Private  cNewFil	:= GetJobProfString('cCodFil', '03')
Private nCount      := 0
Private lAuto 	:= .T.

//cria pergunta no sx1
ValidPerg(cPerg)

//verifica se a execucao e pelo menu ou pelo schedule
If Select("SX6") == 0
	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT EMPRESA "05" FILIAL "03" TABLES "SC9", "SC5", "SC6", "SC7", "SZ2" ,"SA1", "SB1","SF4", "SB2"
Else
	lAuto := .F.
	
	If !(cFilAnt =="03" .And. cEmpAnt =="05")
		MsgStop("Esta empresa nใo pode executar esta rotina!","Aten็ใo")
		Return
	EndIf
	
	If Pergunte(cPerg,.T.)
		oProcess := MsNewProcess():New({|lEnd|RFATM51a(oProcess)},"Gera็ใo de Faturamento Manual","",.F.)
		oProcess:Activate()
		MsgInfo("Opera็ใo Realizada com Sucesso.","PROCESSO CONCLUIDO!")
	EndIf
EndIf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATM51a  บAutor  ณPaulo Bindo         บ Data ณ  02/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona os pedidos ja produzidos e os fatura              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RFATM51a(oObj)
Local aTrab := {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria a Estrutura do Arquivo de Trabalho                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aTrab,{ "PEDIDO" ,"C", 06, 0 })	//PEDIDO VENDAS DISTRIBUIDORA
AADD(aTrab,{ "ITEM"   ,"C", 02, 0 })	//ITEM PV DA DISTRIBUIDORA
AADD(aTrab,{ "PRODUTO","C", 25, 0 })	//CODIGO DO PRODUTO
AADD(aTrab,{ "QTDLIB"   ,"N", 14, 0 })	//QUANTIDADE A SER FATURADA


cArqDBF0 := CriaTrab( aTrab, .T. )
cArqNTX0 := CriaTrab( NIL, .F. )
Use &cArqDBF0 Alias "TRBZ" Exclusive New

//monta a regua
If !lAuto
	dbSelectArea("SM0")
	oObj:SetRegua1(MAXPASSO)
	oObj:IncRegua1(cText+AllTrim(Str(nPro))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
	cMensagem := "Selecionando Registros..."
EndIf

//BUSCA OS REGISTROS NO SC9 LIBERADOS PARA SEREM FATURADOS, 
cQuery := " SELECT C9_QTDLIB, C9_PEDIDO,C9_ITEM, C9_PRODUTO, C5_X_RESG FROM "+ RetSqlName("SC9") + " SC9 INNER JOIN "+RetSqlName("SC5") +" SC5 "
cQuery += " ON SC9.C9_PEDIDO = SC5.C5_NUM AND SC9.C9_FILIAL = SC5.C5_FILIAL AND SC5.C5_X_RESG <> '' "
cQuery += " WHERE SC9.C9_NFISCAL = '' "
cQuery += " AND SC9.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' "
If !lAuto
	cQuery += " AND C9_PEDIDO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
EndIf
 cQuery += " GROUP BY C9_PEDIDO, C9_ITEM, C9_PRODUTO, C9_QTDLIB, C5_X_RESG "

MemoWrit("RFATM51.sql",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)

//CASO TENHA DADOS
If !EOF()
	
	If !lAuto
		oObj:SetRegua2(0)
	EndIf
	dbSelectArea("TRB1")
	dbGoTop()
	While !EOF()
		If !lAuto
			oObj:IncRegua2(cMensagem)
		EndIf
		dbSelectArea("TRBZ")
		RecLock("TRBZ",.T.)
		PEDIDO  := TRB1->C9_PEDIDO
		ITEM    := TRB1->C9_ITEM
		PRODUTO := TRB1->C9_PRODUTO
		QTDLIB    := TRB1->C9_QTDLIB

		MsUnlock("TRBZ")
		nCount++
		dbSelectArea("TRB1")
		dbSkip()
	End
////	RFATE51a(oObj) //LIBERA OS PEDIDOS DA FABRICA
	RFATE51b(oObj) //FATURA OS PEDIDOS DA FABRICA
EndIf
TRB1->(dbCloseArea())

TRBZ->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATM51a  บAutor  ณPaulo Bindo         บ Data ณ  12/13/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLibera pedido de venda da distribuidora                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RFATE51a(oObj)
CONOUT("INICIO RFATE51a")
//monta a regua
If !lAuto
	dbSelectArea("SM0")
	oObj:SetRegua1(MAXPASSO)
	oObj:IncRegua1(cText+AllTrim(Str(nPro))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
	cMensagem := "Selecionando Registros..."
EndIf

dbSelectArea("TRBZ")
dbGoTop()

If !lAuto
	oObj:SetRegua2(nCount)
EndIf

While !EOF()
	
	DBSelectArea("SC5")
	DBSetOrder(1)
	MsSeek( xFilial("SC5") + TRBZ->PEDIDO)
	
	dbSelectArea("SC6")
	DBSetOrder(1)
	MsSeek( xFilial("SC6") + TRBZ->PEDIDO+TRBZ->ITEM )
	
	
	If RecLock("SC5",.F.)
		nQtdLib  := TRBZ->QTDLIB
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRecalcula a Quantidade Liberada                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RecLock("SC6",.F.) //Forca a atualizacao do Buffer no Top
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณLibera por Item de Pedido                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Begin Transaction
		/*
		ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
		ฑฑณFuncao    ณMaLibDoFatณ Autor ณEduardo Riera          ณ Data ณ09.03.99  ณฑฑ
		ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
		ฑฑณDescri…o ณLiberacao dos Itens de Pedido de Venda                      ณฑฑ
		ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
		ฑฑณRetorno   ณExpN1: Quantidade Liberada                                  ณฑฑ
		ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
		ฑฑณTransacao ณNao possui controle de Transacao a rotina chamadora deve    ณฑฑ
		ฑฑณ          ณcontrolar a Transacao e os Locks                            ณฑฑ
		ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
		ฑฑณParametrosณExpN1: Registro do SC6                                      ณฑฑ
		ฑฑณ          ณExpN2: Quantidade a Liberar                                 ณฑฑ
		ฑฑณ          ณExpL3: Bloqueio de Credito                                  ณฑฑ
		ฑฑณ          ณExpL4: Bloqueio de Estoque                                  ณฑฑ
		ฑฑณ          ณExpL5: Avaliacao de Credito                                 ณฑฑ
		ฑฑณ          ณExpL6: Avaliacao de Estoque                                 ณฑฑ
		ฑฑณ          ณExpL7: Permite Liberacao Parcial                            ณฑฑ
		ฑฑณ          ณExpL8: Tranfere Locais automaticamente                      ณฑฑ
		ฑฑณ          ณExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ณฑฑ
		ฑฑณ          ณ       apenas avalia ).                                     ณฑฑ
		ฑฑณ          ณExpbA: CodBlock a ser avaliado na gravacao do SC9           ณฑฑ
		ฑฑณ          ณExpAB: Array com Empenhos previamente escolhidos            ณฑฑ
		ฑฑณ          ณ       (impede selecao dos empenhos pelas rotinas)          ณฑฑ
		ฑฑณ          ณExpLC: Indica se apenas esta trocando lotes do SC9          ณฑฑ
		ฑฑณ          ณExpND: Valor a ser adicionado ao limite de credito          ณฑฑ
		ฑฑณ          ณExpNE: Quantidade a Liberar - segunda UM                    ณฑฑ
		*/
		MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.T.,.T.,.F.,.F.)
		End Transaction
	EndIf
	SC6->(MsUnLock())
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza o Flag do Pedido de Venda                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Begin Transaction
	SC6->(MaLiberOk({TRBZ->PEDIDO},.F.))
	End Transaction
	
	SC6->(dbCloseArea())
	
	dbSelectArea("TRBZ")
	dbSkip()
End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATM51b  บAutor  ณPaulo Bindo         บ Data ณ  12/13/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera nota fiscal de saida da fabrica                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RFATE51b(oObj)
Local aPvlNfs := {}
Local nPrcVen := 0
Local cSerie  :=  GetMV("MV_X_SERGO")   ////"UNI"   SERIE PARA GERACAO DA NOTA FISCAL GO IN GO
Local nItemNf := a460NumIt(cSerie)
Local cQuebra := "S"     //////////////////////GetMV("MV_E_NFSF")
Private aNotas := {}
CONOUT("INICIO RFATE51b")
//monta a regua
If !lAuto
	dbSelectArea("SM0")
	oObj:SetRegua1(MAXPASSO)
	oObj:IncRegua1(cText+AllTrim(Str(nPro))+"/"+AllTrim(Str(MAXPASSO))+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL)
	cMensagem := "Selecionando Registros..."
EndIf
If !lAuto
	oObj:SetRegua2(nCount)
EndIf

dbSelectArea("TRBZ")
dbGoTop()
cPedido := TRBZ->PEDIDO
While !EOF()
	If !lAuto
		oObj:IncRegua2(cMensagem)
	EndIf
	
	//CASO O PARAMETRO QUERIA QUE EMITA NOTA POR NOTA
	If cQuebra == "S" .And. TRBZ->PEDIDO # cPedido
		cNota := MaPvlNfs (aPvlNfs,cserie , .F.    , .F.    , .F.     , .T.    , .F.    , 0      , 0          , .F.  ,.F.)
		//cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)
		aPvlNfs := {}
	EndIf

	//abre o cabecalho dos pedidos
	SC5->(DbSetOrder(1))
	SC5->(MsSeek(xFilial("SC5")+TRBZ->PEDIDO))
	//abre os itens dos pedidos
	SC6->(dbSetOrder(1))
	SC6->(MsSeek(xFilial("SC6")+TRBZ->PEDIDO+TRBZ->ITEM))
	
	SC9->(DbSetOrder(1))
	SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))) //FILIAL+NUMERO+ITEM
	
	cPedido := SC9->C9_PEDIDO
	
	SE4->(DbSetOrder(1))
	SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO
	
	SB1->(DbSetOrder(1))
	SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))    //FILIAL+PRODUTO
	
	SB2->(DbSetOrder(1))
	SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL
	
	SF4->(DbSetOrder(1))
	SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES
	
	nPrcVen := SC9->C9_PRCVEN
	If ( SC5->C5_MOEDA <> 1 )
		nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
	EndIf
	
	Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
	SC9->C9_ITEM,;
	SC9->C9_SEQUEN,;
	SC9->C9_QTDLIB,;
	nPrcVen,;
	SC9->C9_PRODUTO,;
	.f.,;
	SC9->(RecNo()),;
	SC5->(RecNo()),;
	SC6->(RecNo()),;
	SE4->(RecNo()),;
	SB1->(RecNo()),;
	SB2->(RecNo()),;
	SF4->(RecNo())})
	
	//QUEBRA A NF
///	If ( Len(aPvlNfs) >= nItemNf )
//		cNota := MaPvlNfs(aPvlNfs,cserie , .F.    , .F.    , .F.     , .T.    , .F.    , 0      , 0          , .F.  ,.F.)
		//cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)
//		aPvlNfs := {}
///	EndIf

	dbSelectArea("TRBZ")
	dbSkip()

End
/*
ฑฑณDescri…o ณInclusao de Nota fiscal de Saida atraves do PV liberado     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpA1: Array com os itens a serem gerados                   ณฑฑ
ฑฑณ          ณExpC2: Serie da Nota Fiscal                                 ณฑฑ
ฑฑณ          ณExpC3: Numero da Nota Fiscal                                ณฑฑ
ฑฑณ          ณExpL4: Lancamento 610                                       ณฑฑ
ฑฑณ          ณExpL5: Lancamento 620                                       ณฑฑ
ฑฑณ          ณExpN6: Controle de contabilizacao                           ณฑฑ
ฑฑณ          ณExpN7: Handle do arquivo de contabilizacao                  ณฑฑ
ฑฑณ          ณExpL8: Reajuste de preco na nota fiscal                     ณฑฑ
ฑฑณ          ณExpN9: Tipo de Acrescimo Financeiro                         ณฑฑ
ฑฑณ          ณExpNA: Tipo de Arredondamento                               ณฑฑ
ฑฑณ          ณExpLB: Atualiza Amarracao Cliente x Produto                 ณฑฑ
ฑฑณ          ณExplC: Cupom Fiscal                                         ณฑฑ
ฑฑณ          ณExpCD: Numero do Embarque de Exportacao                     ณฑฑ
ฑฑณ          ณExpBE: Code block para complemento de atualizacao dos titu- ณฑฑ
ฑฑณ          ณ       los financeiros.                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
*/

cNota := MaPvlNfs(aPvlNfs,cserie, .F.    , .F.    , .F.     , .T.    , .F.    , 0      , 0          , .F.  )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณPaulo Bindo         บ Data ณ  12/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria pergunta no e o help do SX1                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar     ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02  ,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg,"01"   ,"Do Pedido  		   ?",""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "C",""    ,"" ,""         ,""   ,"mv_par01",""			,""      ,""      ,""    ,""	   ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"02"   ,"At้ o Pedido       ?",""                    ,""                    ,"mv_ch2","C"   ,06      ,0       ,0      , "G",""    ,"" ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")



cKey     := "P.RFAT5101."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Digite o n๚mero do pedido de vendas  ")
aAdd(aHelpPor,"inicial.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.RFAT5102."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Digite o n๚mero do pedido de vendas  ")
aAdd(aHelpPor,"final.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return
