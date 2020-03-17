#include 'protheus.ch'
#include 'parmtype.ch'

user function AGCOMA01()

Local nNumPed	:= SC7->C7_NUM //Pedido de Compras posicionado no momento da Alteração
Local aCabec	:= {}
Local aLinha	:= {}
Local aItens	:= {}
Local oDlg
Local oBtn1
Local oSay1
Local oGet1
Local cGet1		:= SC7->C7_DATPRF
Local nOpc 		:= 0
Local cIndexPad	:= IndexKey(IndexOrd()) //indice padrão no momento de acessar tela
Local lAltDtEnt	:= .T.
Local nRecPC	:= Recno() //guarda o registro 

Private lMsErroAuto := .F.

DbSetOrder(1) //Filial + Numero Pedido
DbSeek(xFilial("SC7")+SC7->C7_NUM)
Do While !EOF() .and. nNumPed == SC7->C7_NUM //executa enquanto for o mesmo Pedido de Compras (selecionado)
	If C7_QUJE==0 .And. C7_QTDACLA==0		//-- Pendente
		lAltDtEnt	:= .T.
	ElseIf C7_QUJE<>0.And.C7_QUJE<C7_QUANT	//-- Pedido Parcialmente Atendido
		lAltDtEnt	:= .T.
	Else
		lAltDtEnt	:= .F.
		Exit
	EndIf
	SC7->(dbSkip())
EndDo


If lAltDtEnt
	DbSetOrder(1) //Filial + Numero Pedido
	DbSeek(xFilial("SC7")+nNumPed)

	DEFINE MSDIALOG oDlg TITLE "Alteração da Data de Entrega" FROM 0,0 TO 150,300 COLOR CLR_BLACK,CLR_WHITE PIXEL
	oDlg:lEscClose := .F.
	
	@ 10,05 SAY oSay1 PROMPT "Numero Pedido: " + nNumPed SIZE 60,12 OF oDlg PIXEL
	
	@ 25,05 SAY oSay1 PROMPT "Dt.Entrega" SIZE 60,12 OF oDlg PIXEL
	@ 25,55 GET oGet1 VAR cGet1 SIZE 60,12 OF oDlg PIXEL 
	 
	@ 50,05 BUTTON oBtn1 PROMPT 'OK'   ACTION ( nOpc:=1, oDlg:End() ) SIZE 40, 013 OF oDlg PIXEL
	@ 50,55 BUTTON oBtn1 PROMPT 'Sair' ACTION ( nOpc:=2, oDlg:End() ) SIZE 40, 013 OF oDlg PIXEL
	ACTIVATE DIALOG oDlg CENTER
	
	If nOpc = 2
		Alert("Processo Cancelado!")
		return
	ElseIf nOpc = 0
		Alert("Processo Cancelado!")
		return
	EndIf
	
	aadd(aCabec,{"C7_NUM" 		,SC7->C7_NUM})
	aadd(aCabec,{"C7_EMISSAO" 	,SC7->C7_EMISSAO})
	aadd(aCabec,{"C7_FORNECE" 	,SC7->C7_FORNECE})
	aadd(aCabec,{"C7_LOJA" 		,SC7->C7_LOJA})
	aadd(aCabec,{"C7_COND" 		,SC7->C7_COND})
	aadd(aCabec,{"C7_CONTATO" 	,SC7->C7_CONTATO})
	aadd(aCabec,{"C7_FILENT" 	,SC7->C7_FILENT})
	
	DbSetOrder(1) //Filial + Numero Pedido
	Do While !EOF() .and. nNumPed == SC7->C7_NUM //executa enquanto for o mesmo Pedido de Compras (selecionado)
		aadd(aLinha,{"C7_ITEM" 		,SC7->C7_ITEM	,Nil})
		aadd(aLinha,{"C7_PRODUTO" 	,SC7->C7_PRODUTO,Nil})
		aadd(aLinha,{"C7_QUANT" 	,SC7->C7_QUANT 	,Nil})
		aadd(aLinha,{"C7_PRECO" 	,SC7->C7_PRECO 	,Nil})
		aadd(aLinha,{"C7_TOTAL" 	,SC7->C7_TOTAL 	,Nil})
		aadd(aLinha,{"C7_TES" 		,SC7->C7_TES 	,Nil})
		aadd(aLinha,{"C7_DATPRF" 	,cGet1			,Nil})
		aadd(aItens,aLinha)
		aLinha	:= {}
		SC7->(dbSkip())
	EndDo
	
	FWMsgRun(,{|| MATA120(1,aCabec,aItens,4) },,"Processamento alteração no Pedido de Compras, Aguarde..." )
		
	If !lMsErroAuto
		MsgInfo("Alteracao com sucesso! " + nNumPed) 
	Else
		Alert("Erro na Alteracao!")
		MostraErro()
	EndIf
Else
	Alert("Somente pedidos totalmente em aberto podem ser alterados!")
	return
EndIf

Return