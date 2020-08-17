#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT120BRW ³ Autor ³  Sergio Oliveira      ³ Data ³ Set/2007  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada na montagem do Browse de Pedidos de Compras³±±
±±³          ³ Inclusao do botao para informar o Base Line de Compras.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120BRW()
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Sergio em Mai/2010: Controle de data de entrega de acordo com as opcoes pre-cadastradas - OS 0248/10  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

If SY1->( DbSetOrder(3), DbSeek( xFilial('SY1')+__cUserId ) )
	aAdd(aRotina, { "Entrega","U_InfEntre()"	, 0 , 1})
EndIf
aAdd(aRotina, { "Base Line","U_BaseLine()"	, 0 , 1})
aAdd(aRotina, { OemToAnsi('Recebimento') , 'u_RecebeNF()' , 0 , 2})   // fsw - projeto FS08500301
aAdd(aRotina, { "Qualificação","U_MTA097(2)"	, 0 , 1})
aAdd(aRotina, { "Volta Pedido","U_RetResiduo()"	, 0 , 1})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ BaseLine ºAutor  ³ Sergio Oliveira    º Data ³  Set/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a chamada da funcao que processa a informacao.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mt120Brw.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BaseLine()

Local nBaseLine := 0, nRacional := 0
Local cJustific := "", cMaxSeq := "00", cQry := '', cNxtAlias := CriaTrab(Nil,.f.), cCombo := ""
Local oMens1, oMens2, oMens3, oMens4
Local oFont   := TFont():New("Tahoma",11,,,.T.,,,,,.F.) // Com Negrito
Local aCampos := {}, aStru := {}, aListBox := {}
//Local aClassif := {"ECONOMIA SOBRE MENOR VALOR APRESENTADO","ECONOMIA SOBRE CAPEX APROVADO","ECONOMIA SOBRE VALOR ATUAL PAGO","SEM ECONOMIA"}  //OS 3015-09
//Local aClassif := {"CONTRATO - REDUÇÃO SOBRE O VALOR ATUAL","CONTRATO - REPRESAMENTO DE REAJUSTE","SPOT - REDUÇÃO SOBRE O VALOR ATUAL / ÚLT. COMPRA","SPOT - REDUÇÃO SOBRE MENOR VALOR APRESENTADO","CAPEX - REDUÇÃO SOBRE O VALOR APROVADO","SPOT - SEM ECONOMIA"}  //OS 0403-10
//Local aClassif := {"CONTRATO - REDUCAO SOBRE O VALOR ATUAL","CONTRATO - REPRESAMENTO DE REAJUSTE","SPOT - REDUCAO SOBRE O VALOR ATUAL / ULT. COMPRA","SPOT - REDUCAO SOBRE MENOR VALOR APRESENTADO","NEGOCIADO PELA AREA DEMANDANTE","SPOT - SEM ECONOMIA"}  //OS 2866-10
Local aClassif := {"CAPEX - REDUÇÃO SOBRE O MENOR VALOR APRESENTADO",;
						"CAPEX - REDUÇÃO SOBRE O VALOR ATUAL",;
						"CAPEX - SEM ECONOMIA",;
						"CONTRATO - REDUÇÃO SOBRE O MENOR VALOR APRESENTADO",;
						"CONTRATO - REDUCAO SOBRE O VALOR ATUAL",;						
						"CONTRATO - REPRESAMENTO DE REAJUSTE",;
						"CONTRATO - SEM ECONOMIA",;
						"NEGOCIADO PELA AREA DEMANDANTE",;
						"PROJETO - REDUÇÃO SOBRE O MENOR VALOR APRESENTADO",;
						"PROJETO - REDUÇÃO SOBRE O VALOR ATUAL",;
						"PROJETO - SEM ECONOMIA",;
						"SPOT - REDUCAO SOBRE MENOR VALOR APRESENTADO",;
						"SPOT - REDUCAO SOBRE O VALOR ATUAL / ULT. COMPRA",;												
						"SPOT - SEM ECONOMIA"}  //OS 2675-17 Alexandre Avelino
Local l_Cancel := .F. , l_Ok := .F., lSair := .F.
Private  oBrolseS


If Select('ZA7') == 0
	ChkFile('ZA7')
EndIf

cQry := " SELECT R_E_C_N_O_ AS REGS "
cQry += " FROM "+RetSqlName('ZA7')

If Alltrim(Upper(FunName())) == "MATA097"// OS 3015/09
	cQry += " WHERE ZA7_PEDIDO = '"+Alltrim(SCR->CR_NUM)+"' "
Else
	cQry += " WHERE ZA7_PEDIDO = '"+Alltrim(SC7->C7_NUM)+"' "
EndIf
cQry += " AND   ZA7_FILIAL = '"+xFilial('ZA7')+"' "
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNxtAlias )

(cNxtAlias)->( DbGoTop() )

While !(cNxtAlias)->( Eof() )
	
	ZA7->( DbGoTo((cNxtAlias)->REGS) )
	
	AADD(aListBox,{ZA7->ZA7_PEDIDO,ZA7->ZA7_DESCRI,ZA7->ZA7_BASELI,ZA7->ZA7_SEQ,ZA7->ZA7_USUARI,ZA7->ZA7_DATA,ZA7->ZA7_COMPUT,ZA7->ZA7_LOGIN,ZA7->ZA7_HORA,ZA7->ZA7_RACION,ZA7->ZA7_CLASSI } )
	
	cMaxSeq := ZA7->ZA7_SEQ
	
	(cNxtAlias)->( DbSkip() )
	
EndDo
// OS 3015/09
If Alltrim(Upper(FunName())) == "MATA097"
	If Len( aListBox ) <> 0
		Return
	EndIf
EndIf

If Len( aListBox ) == 0
	Aadd( aListBox, { '','',0,'','','','','','',0,'' } )
EndIf

cMaxSeq := Soma1( cMaxSeq )

Define MsDialog MkwDlg Title "Base Line" From 128,059 To 559,787 Of oMainWnd Pixel

@ 004,001 To 212,293
@ 148,001 LISTBOX oListBox VAR cVar FIELDS HEADER "Pedido"  ,;
"Justificativa",;
"Base Line"  	,;
"Seq"  	,;
"Usuario"  	,;
"Data"  	,;
"Terminal" ,;
"Login"    ,;
"Hora",;
"Racional",;
"Classificacao" SIZE 292,065 PIXEL of mkwdlg   //OS 3015-09
oListBox:SetArray(aListBox)
oListBox:bLine:={ || { aListBox[oListBox:nAt,1],;
aListBox[oListBox:nAt,2],;
Transform(aListBox[oListBox:nAt,3],"@E 999,999,999.99"),;
aListBox[oListBox:nAt,4],;
aListBox[oListBox:nAt,5],;
aListBox[oListBox:nAt,6],;
aListBox[oListBox:nAt,7],;
aListBox[oListBox:nAt,8],;
aListBox[oListBox:nAt,9],;
Transform(aListBox[oListBox:nAt,10],"@E 999,999,999.99"),;
aListBox[oListBox:nAt,11] }}
@ 027,297 To 184,355
@ 010,008 To 124,124
@ 010,128 To 124,291
@ 035,018 Say "Valor do Base Line" Color 8388608 Object oMens1 Size 96,19
@ 079,040 Say "Racional"           Color 8388608 Object oMens4 Size 96,19
@ 020,173 Say "Justificativa"      Color 8388608 Object oMens2 Size 96,19
@ 128,059 Say "Valores de Base Line Já Digitados para este Pedido" Color 8388608 Object oMens3 Size 179,19
@ 059,028 Get nBaseLine Picture "@E 999,999,999.99" Size 76,12
@ 099,028 Get nRacional Picture "@E 999,999,999.99" Size 76,12
@ 044,132 Get cJustific Memo Size 154,77
@ 030,132 ComboBox cCombo Items aClassif Size 154,150  // OS 3015-09
@ 050,308 Button "_Vis. Just." Size 41,19 Action( MostraMemo(oListBox, aListBox) )
@ 080,308 Button "_Atualizar"  Size 41,19 Action( BaseLineGr(@nBaseLine, @cJustific, @cMaxSeq, @aListBox, @nRacional,@cCombo), l_Ok := .T. )
@ 110,308 Button "_Abandonar"  Size 41,16 Action( ( (cNxtAlias)->( DbCloseArea() ),lSair := .T., Close( MkwDlg ), l_Cancel := .T. ) )

oMens1:ofont:=ofont
oMens2:ofont:=ofont
oMens3:ofont:=ofont
oMens4:ofont:=ofont

Activate MsDialog mkwdlg Centered Valid ( lSair )

If l_Cancel .And. !l_Ok
	If Alltrim(Upper(FunName())) == "MATA097"
		Aviso("BASELINE","Caro comprador, favor preencher o Base Line antes da liberação!",;
		{"&Fechar"},3,"Base Line",,;
		"PCOLOCK")
		U_BaseLine()
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³BaseLineGRºAutor  ³ Sergio Oliveira    º Data ³  Set/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a Gravacao do base line + motivo.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mt120Brw.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BaseLineGr(pnBaseLine, pcJustific, pcMaxSeq, aListBox, pnRacional,pcCombo)

If !Empty( pnBaseLine ) //.And. !Empty( pcJustific ) - OS 3015/09 - TIRAR A OBRIGATORIEDADE DA JUSTIFICATIVA
	
	If Aviso("BASELINE","Confirma a gravacao destas informações?",;
		{"&Fechar", "&Confirmar"},3,"Justificativa do Base Line",,;
		"PCOLOCK") == 2
		
		ZA7->(RecLock('ZA7',.t.))
		ZA7->ZA7_FILIAL := xFilial( 'ZA7' )
		If Alltrim(Upper(FunName())) == "MATA097"  //OS 3015-09
			ZA7->ZA7_PEDIDO := SCR->CR_NUM
		Else
			ZA7->ZA7_PEDIDO := SC7->C7_NUM
		EndIf
		ZA7->ZA7_DESCRI := pcJustific
		ZA7->ZA7_BASELI := pnBaseLine
		ZA7->ZA7_SEQ    := pcMaxSeq
		ZA7->ZA7_USUARI := UsrFullName( __cUserID )
		ZA7->ZA7_DATA   := Date()
		ZA7->ZA7_COMPUT := GetComputerName()
		ZA7->ZA7_LOGIN  := cUserName
		ZA7->ZA7_HORA   := Time()
		ZA7->ZA7_RACION := pnRacional
		ZA7->ZA7_CLASSI := pcCombo //OS 3015-09
		ZA7->( MsUnLock() )
		
		pcJustific := ""
		pnBaseLine := 0
		pnRacional := 0
		
		pcMaxSeq := Soma1( pcMaxSeq )
		
		If Empty(aListBox[1][1])
			aListBox := {}
		EndIf
		
		AADD(aListBox,{ZA7->ZA7_PEDIDO,ZA7->ZA7_DESCRI,ZA7->ZA7_BASELI,ZA7->ZA7_SEQ,ZA7->ZA7_USUARI,ZA7->ZA7_DATA,ZA7->ZA7_COMPUT,ZA7->ZA7_LOGIN,ZA7->ZA7_HORA,ZA7->ZA7_RACION,ZA7->ZA7_CLASSI } )
		
		oListBox:SetArray(aListBox)
		oListBox:bLine:={ || { aListBox[oListBox:nAt,1],;
		aListBox[oListBox:nAt,2],;
		Transform(aListBox[oListBox:nAt,3],"@E 999,999,999.99"),;
		aListBox[oListBox:nAt,4],;
		aListBox[oListBox:nAt,5],;
		aListBox[oListBox:nAt,6],;
		aListBox[oListBox:nAt,7],;
		aListBox[oListBox:nAt,8],;
		aListBox[oListBox:nAt,9],;
		Transform(aListBox[oListBox:nAt,10],"@E 999,999,999.99"),;
		aListBox[oListBox:nAt,11] }}
		
		oListBox:Refresh()
		
		ZA7->( DbGoTop() )
		
	EndIf
	
Else
	
	Aviso("BASELINE","Preencha todos os campos!",;
	{"&Fechar"},3,"Justificativa do Base Line",,;
	"PCOLOCK")
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MostraMemoºAutor  ³ Sergio Oliveira    º Data ³  Set/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe a justificativa gravada.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mt120Brw.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MostraMemo(oListBox, aListBox)

If Len( aListBox ) > 0
	
	Aviso("JUSTIFICATIVA - SEQ "+aListBox[oListBox:nat][4],aListBox[oListBox:nat][2],;
	{"&Fechar"},3,"Justificativa do Base Line",,;
	"PMSAPONT")
	
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RecebeNF ³ Rev.  ³ Microsiga - FS08500301³ Data ³ 23/09/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cadastro de informacoes de recebimento de NF.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RecebeNF

Local aArea	   := GetArea()
Local aCpos    := {'PB1_PEDIDO','PB1_NOTA','PB1_SERIE','PB1_FORNEC','PB1_LOJA','PB1_TIPONF','PB1_DTRECE','PB1_HRRECE','PB1_USRREC','PB1_NOMREC'}
Local aAltCpos := {'PB1_NOTA','PB1_SERIE','PB1_FORNEC','PB1_LOJA','PB1_TIPONF','PB1_DTRECE','PB1_HRRECE','PB1_USRREC','PB1_NOMREC'}
Local lSvInc   := INCLUI

//----------------------
//Pedido Bloqueado
//----------------------
If SC7->C7_CONAPRO=="B" .And. SC7->C7_QUJE < SC7->C7_QUANT
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

//----------------------
//Pedido Eliminado por residuo
//----------------------
If !Empty(SC7->C7_RESIDUO)
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

//----------------------
//Pedido atendido
//----------------------
If SC7->C7_QUJE>=SC7->C7_QUANT
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

//----------------------
//Pedido usado em pre-nota
//----------------------
If SC7->C7_QTDACLA >0
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

//----------------------------------------
//Pedido pendente ou atendido parcialmente
//----------------------------------------
If ( SC7->C7_QUJE==0 .And. SC7->C7_QTDACLA==0 ) .Or. ( SC7->C7_QUJE<>0 .And. SC7->C7_QUJE<SC7->C7_QUANT )
	
	DbSelectArea('PB1')
	DbSetOrder(1)
	If DbSeek( xFilial('PB1')+SC7->C7_NUM )
		If !MsgNoYes('Já existe cadastro de recebimento de NF para este pedido. Deseja cadastrar outro recebimento de NF para este pedido?')
			RestArea(aArea)
			Return Nil
		EndIf
	EndIf
	
	INCLUI := .T.
	
	AxInclui('PB1',/*nReg*/,3,aCpos,/*cFunc*/,aAltCpos,/*cTudoOk*/,/*lF3*/,/*cTransact*/,/*aButtons*/,/*aParam*/,/*aAuto*/,/*lVirtual*/,.T.)
	
	INCLUI := lSvInc
	RestArea(aArea)
	Return Nil
	
Else
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DevolvNF ³ Rev.  ³Microsiga - FS08500301 ³ Data ³ 23/09/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cadastro de informacoes de recebimento de NF.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DevolvNF

Local aArea	   := GetArea()
Local aAreaPB1 := PB1->(GetArea())
Local aCpos    := {'PB1_PEDIDO','PB1_NOTA','PB1_SERIE','PB1_FORNEC','PB1_LOJA','PB1_TIPONF','PB1_DTRECE','PB1_HRRECE','PB1_USRREC','PB1_NOMREC','PB1_DTDEVO','PB1_HRDEVO','PB1_USRDEV','PB1_NOMDEV','PB1_DTCPAG','PB1_USRCP','PB1_NOMCP'}
Local aAltCpos := {'PB1_DTDEVO','PB1_HRDEVO','PB1_USRDEV','PB1_NOMDEV','PB1_DTCPAG','PB1_USRCP','PB1_NOMCP'}
Local lSvAlt   := ALTERA
Local cQuery   := ''
Local nQtdReg  := 0
Local nPos     := 0
Local aVetor   := {}
Local oDlg     := Nil
Local oLbx     := Nil
Local cTitulo  := "Devolução de NF de entrada."

//----------------------
//Pedido Bloqueado
//----------------------
If SC7->C7_CONAPRO=="B" .And. SC7->C7_QUJE < SC7->C7_QUANT
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

//----------------------
//Pedido usado em pre-nota
//----------------------
If SC7->C7_QTDACLA >0
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

//----------------------
//Pedido PENDENTE
//----------------------
If SC7->C7_QUJE==0 .And. SC7->C7_QTDACLA==0
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

//---------------------------------
//Pedido atendido total ou parcial
//---------------------------------
If (SC7->C7_QUJE>=SC7->C7_QUANT) .Or. (SC7->C7_QUJE<>0 .And. SC7->C7_QUJE<SC7->C7_QUANT)
	
	cQuery := ""
	cQuery += "SELECT PB1_PEDIDO,PB1_NOTA,PB1_SERIE,PB1_FORNEC,PB1_LOJA,PB1_TIPONF,D1_EMISSAO,D1_DTDIGIT "
	cQuery += "FROM " + RetSqlName('PB1') + " PB1 "
	cQuery += "INNER JOIN " + RetSqlName('SD1') + " SD1 ON "
	cQuery += "D1_FILIAL = '" + xFilial('SD1') + "' "
	cQuery += "AND PB1_NOTA = D1_DOC "
	cQuery += "AND PB1_SERIE = D1_SERIE "
	cQuery += "AND PB1_FORNEC = D1_FORNECE "
	cQuery += "AND PB1_LOJA = D1_LOJA "
	cQuery += "AND PB1_PEDIDO = D1_PEDIDO "
	cQuery += "AND PB1.D_E_L_E_T_ = SD1.D_E_L_E_T_ "
	cQuery += "WHERE PB1.D_E_L_E_T_ = ' ' "
	cQuery += "AND PB1_FILIAL = '" + xFilial('PB1') + "' "
	cQuery += "AND PB1_PEDIDO = '" + SC7->C7_NUM + "' "
	cQuery += "AND PB1_DTDEVO = '' "
	cQuery += "GROUP BY PB1_PEDIDO,PB1_NOTA,PB1_SERIE,PB1_FORNEC,PB1_LOJA,PB1_TIPONF,D1_EMISSAO,D1_DTDIGIT "
	cQuery += "ORDER BY PB1_PEDIDO,PB1_NOTA,PB1_SERIE,PB1_FORNEC,PB1_LOJA,PB1_TIPONF,D1_EMISSAO,D1_DTDIGIT "
	
	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	endif
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
	
	TCSetField( "TRB", 'D1_EMISSAO', "D", 8, 0 )
	TCSetField( "TRB", 'D1_DTDIGIT', "D", 8, 0 )
	
	// Verifica se existe registro para devolucao
	nQtdReg := 0
	TRB->( dbGoTop() )
	TRB->( dbEval( { || nQtdReg++ },, { || !EOF() } ) )
	TRB->( dbGoTop() )
	
	If nQtdReg = 0
		MsgAlert('Não foi encontrada NF para devolução.')
		RestArea(aArea)
		Return Nil
	EndIf
	
	While TRB->( !EOF() )
		aAdd( aVetor, { TRB->PB1_PEDIDO,TRB->PB1_NOTA,TRB->PB1_SERIE,TRB->PB1_FORNEC,TRB->PB1_LOJA,TRB->PB1_TIPONF,TRB->D1_EMISSAO,TRB->D1_DTDIGIT } )
		TRB->( DbSkip() )
	EndDo
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	
	@ 10,10 LISTBOX oLbx FIELDS HEADER ;
	"Nota" , "Serie" , "Fornecedor" , "Loja" , "Tipo Nota" , "Emissao" , "Digitacao" ;
	SIZE 230,95 OF oDlg PIXEL
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5],;
	aVetor[oLbx:nAt,6],;
	aVetor[oLbx:nAt,7],;
	aVetor[oLbx:nAt,8]}}
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (nPos:=oLbx:nAt,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	DbSelectArea('PB1')
	DbSetOrder(1) //filial   +    pedido      +     nota       +    serie      +   fornecedor  +    loja
	If DbSeek( xFilial('PB1')+aVetor[nPos][1]+aVetor[nPos][2]+aVetor[nPos][3]+aVetor[nPos][4]+aVetor[nPos][5] )
		ALTERA := .T.
		AxAltera('PB1',PB1->(Recno()),4,aCpos,aAltCpos,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,/*cTransact*/,/*cFunc*/,/*aButtons*/,/*aParam*/,/*aAuto*/,/*lVirtual*/,.T.)
	Else
		MsgAlert( 'Registro não encontrado (PB1) - Pedido: '+aVetor[nPos][1]+' NF/Série: '+aVetor[nPos][2]+'/'+aVetor[nPos][3] )
		RestArea(aAreaPB1)
		RestArea(aArea)
		Return Nil
	EndIf
	
	ALTERA := lSvAlt
	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	endif
	RestArea(aAreaPB1)
	RestArea(aArea)
	Return Nil
Else
	MsgAlert('Opção inválida para este pedido. Verifique a situação do Pedido de Compra.')
	RestArea(aArea)
	Return Nil
EndIf

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Infentre ³ Autor ³ Sergio Oliveira       ³ Data ³ Mai/2010  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Abre a tela para informar o tipo de entrega previamente ca- ³±±
±±³          ³ dastrado.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function InfEntre()

Local oMensg1
Local oFont2    := TFont():New("Tahoma",8,,,.T.,,,,,.F.) // Com Negrito
Private cEntreg := CriaVar("ZA9_CODIGO"), cDescEnt := CriaVar("ZA9_DESCRI")

DEFINE MSDIALOG oDlgItens TITLE "	" FROM 287,348 To 438,653 PIXEL OF oMainWnd

@ 000,001 To 040,154 // "Moldura Principal"
@ 041,001 To 068,154 Title "Opções"
@ 009,015 Say "Entrega Para o Pedido "+SC7->C7_NUM Color 8388608 Object oMensg1 Size 120,08
@ 020,004 Get cEntreg F3 "ZA9" Valid( ( Vazio().Or.ExistCpo("ZA9", cEntreg) ).And.DescZA9() ) Size 27,10
@ 020,034 Get cDescEnt When .f. Size 117,10
@ 048,010 Button "Confirmar" Size 36,16 Action( GrvEnt(), oDlgItens:End() )
@ 048,055 Button "Cancelar"  Size 36,16 Action oDlgItens:End()
@ 048,095 Button "Ajuda"     Size 36,16 Action( MostraHelp() )

oMensg1:ofont:=ofont2

Activate MsDialog oDlgItens Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DescZA9  ³ Autor ³ Sergio Oliviera       ³ Data ³ Mai/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Preencher a descricao da opcao de entrega apos a escolha.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DescZA9()

Local lRet := .t.

If !Empty( cEntreg )
	If !ZA9->( DbSetOrder(1), DbSeek( xFilial('ZA9')+cEntreg ) )
		lRet := .f.
	Else
		cDescEnt := ZA9->ZA9_DESCRI
	EndIf
EndIf

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GrvEnt   ³ Autor ³ Sergio Oliviera       ³ Data ³ Mai/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a gravacao da entrega nos itens do Pedido de Compra ³±±
±±³          ³ posicionado.                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GrvEnt()

Local cExec, cTxtBlq, cVerifik, nCntView
Local cEol     := Chr(13)+Chr(10)
Local cNxtWork := GetNextAlias()
Local cMens    := "Atualização da Forma de Entrega"
Local cPriLin  := "Se deseja realmente efetuar esta operação, "

If Empty(cEntreg)
	Aviso("Gravacao do Tipo de Entrega","Informe a opção de entrega.",{"Voltar"},3,"Tipo de Entrega",,"PCOLOCK") == 1
	Return
EndIf
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Primeiramente verificar se ha mais de uma forma de entrega para o mesmo pedido antes de sobrescrever  ³
³ os dados para que o usuario possa confirmar a operacao:                                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cVerifik := " SELECT DISTINCT C7_X_TENT "
cVerifik += " FROM "+RetSqlName('SC7')
cVerifik += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
cVerifik += " AND   C7_NUM     = '"+SC7->C7_NUM+"' "
cVerifik += " AND   D_E_L_E_T_ = ' ' "

nCntView := U_MontaView( cVerifik, cNxtWork )

(cNxtWork)->( DbGoTop() )

If nCntView > 1
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ O sistema detectou que ha mais de uma forma de entrega para o pedido posicionado. Devera ser solicitada ³
	³ a digitacao do codigo de seguranca para que o comprador faca a alteracao de forma consciente:           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cTxtBlq := "Para este pedido ["+SC7->C7_NUM+"] há mais de um tipo de entrega. "
	cTxtBlq += "Se você prosseguir, somente poderá ser gravada o tipo de entega ["+Trim( Posicione('ZA9',1,xFilial('ZA9')+cEntreg,'ZA9_DESCRI') )+"] "
	cTxtBlq += "para todo o Pedido."
	
	If Aviso("Gravacao do Tipo de Entrega",cTxtBlq,{"&DESISTIR","Continuar"},3,"Tipo de Entrega",,"PCOLOCK") == 1
		Aviso(cTxtBlq,"Operação nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
		Return
	EndIf
	
	If !U_CodSegur(cMens, cPriLin)
		Aviso(cMens,"Operação nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
		Return
	EndIf
Else
	cTxtBlq := "Se você confirmar esta transação, somente poderá ser gravada um tipo de entega "
	cTxtBlq += "para todo o Pedido. Deseja realmente confirmar?"
	
	If Aviso("Gravacao do Tipo de Entrega",cTxtBlq,{"&DESISTIR","Continuar"},3,"Tipo de Entrega",,"PCOLOCK") == 1
		Aviso(cTxtBlq,"Operação nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
		Return
	EndIf
EndIf

cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_X_TENT = '"+cEntreg+"' "
cExec += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
cExec += " AND   C7_NUM     = '"+SC7->C7_NUM+"' "
cExec += " AND   D_E_L_E_T_ = ' ' "

If TcSqlExec( cExec ) # 0
	
	cTxtBlq := "Ocorreu um problema no momento da gravacao do campo referente ao tipo de entrega. "
	cTxtBlq += "Entre em contato com a area de Sistemas ERP informando a mensagem "
	cTxtBlq += "a seguir: "+cEol+cEol+TcSqlError()
	
	Aviso("Gravacao do Tipo de Entrega",cTxtBlq,{"&Fechar"},3,"Tipo de Entrega",,"PCOLOCK")
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MostraHelpºAutor  ³ Sergio Oliveira     ºData ³ Mai/2010    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exibir o help da rotina.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MT120Brw.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MostraHelp()

Local cDescHlp  := "Esta opção serve para definir a estratégia de entrega sem que haja necessidade de alterar "
cDescHlp  += "o Pedido e perder o processo de aprovação atual. A diferença desta rotina é que poderá "
cDescHlp  += "ser definida somente uma estratégia de entrega para todos os itens. "
Private cTitulo := "Descricao da Rotina"

DEFINE MSDIALOG oDlgRelp TITLE cTitulo FROM 065,025 To 516,691 PIXEL OF oMainWnd

@ 007,008 To 207,272 Title "Funcionamento Desta Opcao"
@ 023,019 Get cDescHlp MEMO Size 242,177 When .f.
@ 072,280 Button "_Sair"    Size 043,016 Action( oDlgRelp:End() )

Activate MsDialog oDlgRelp Centered

Return

User Function RetResiduo()

_cPedido :=SPACE(6)
_dData   :=CTOD('  /  /  ')
_cUsuario:=SPACE(15)
_cArea1  :=SPACE(25)
_cResp   :=SPACE(25)
_cMotivo :=SPACE(250)
_cItem   :=""
_cProduto:=""

IF SC7->C7_RESIDUO<>'S'
	_cMens:='Opcao disponivel apenas para pedido eliminado por residuo !!!! '+CHR(10)+CHR(13)
	_cMens+='Posicione sobre um pedido eliminado por residuo Cor < Cinza > '+CHR(10)+CHR(13)
	MsgBox(_cMens,'Atencao','Info')
ELSE
	_cPedido  :=SC7->C7_NUM
	_dData    :=DDATABASE
	_cUsuario :=Substr(cUsuario,7,15)
	_cItem    :=SC7->C7_ITEM
	_cProduto :=SC7->C7_PRODUTO
	_cDesc    :=""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao da Interface                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 150,271 To 501,1009 Dialog Residuo Title OemToAnsi("Retorno Pedido de Compra Eliminado Por residuo")
	@ 8,11 To 141,343 Title OemToAnsi("")
	@ 25,023 Say OemToAnsi("Pedido") Size 28,8
	@ 25,123 Say OemToAnsi("Data") Size 16,8
	@ 25,204 Say OemToAnsi("Usuario") Size 27,8
	
	@ 25,060 Get _cPedido  Size 42,10 when .f.
	@ 25,151 Get _dData    Size 45,10 when .f.
	@ 25,244 Get _cUsuario Size 83,10 when .f.
	
	@ 40,023 Say OemToAnsi("Item") Size 28,8
	@ 40,060 Get _cItem  Size 42,10 when .f.
	@ 40,123 Say OemToAnsi("Produto") Size 28,8
	@ 40,150 Get _cProduto  Size 45,10 when .f.
	
	SB1->(DBSETORDER(1))
	IF SB1->(DBSEEK(XFILIAL()+_cProduto))
		_cDesc:=SB1->B1_DESC
		@ 40,244 Get _cDesc  Size 91,10 when .f.
	ENDIF
	
	@ 55,024 Say OemToAnsi("Area Demandante") Size 44,8
	@ 55,169 Say OemToAnsi("Autorizado Por") Size 43,8
	@ 55,076 Get _cArea1 Size 91,10
	@ 55,215 Get _cResp Size 113,10
	
	@ 70,027 Say OemToAnsi("Motivo") Size 23,8
	@ 78,027 Get _cMotivo Size 300,10 Picture "@S100"
	
	//@ 78,027 Get cVar Size 300,54
	
	@ 148,307 Button OemToAnsi("_Ok") Size 36,16 Action GravaRet()
	@ 148,261 Button OemToAnsi("_Cancela") Size 36,16 Action Close(Residuo)
	Activate Dialog Residuo
	
	Return
ENDIF

Return

Static Function GravaRet()
_cArea:=GetArea()

DBSELECTAREA('SC7')
RECLOCK('SC7')
SC7->C7_RESIDUO:=" "
MSUNLOCK('SC7')

// OS 0135/12 - RENATO CARLOS - 01/2012

cExec := " UPDATE "+RetSqlName("SCR")+" SET CR_X_RES  = '' "
cExec += " WHERE CR_FILIAL  = '"+SC7->C7_FILIAL+"' "
cExec += " AND   CR_NUM     = '"+SC7->C7_NUM+"' "
cExec += " AND   CR_TIPO    = 'PC' "
cExec += " AND   D_E_L_E_T_ = '' "

TcSqlExec( cExec )

// FIM - OS 0135/12

DBSELECTAREA('ZB5')
RECLOCK('ZB5',.T.)
ZB5->ZB5_FILIAL := XFILIAL('ZB5')
ZB5->ZB5_PEDIDO := SC7->C7_NUM
ZB5->ZB5_ITEMPC := SC7->C7_ITEM
ZB5->ZB5_USUARI := _cUsuario
ZB5->ZB5_DATA   := _dData
ZB5->ZB5_MOTIVO := _cMotivo
ZB5->ZB5_AREA   := _cArea1
ZB5->ZB5_RESP   := _cResp
ZB5->ZB5_TIPO   := 'R'
ZB5->ZB5_HORA   := Time()
ZB5->ZB5_DTELI  := SC7->C7_X_DTELI
MSUNLOCK('ZB5')
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 0585/10: Se existir provisao para o pedido de compra, gerar o log de rastreamento (nem todos os PC possuem provisao) ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If ZB2->( DbSetOrder(4), DbSeek( xFilial( 'ZB2' )+SC7->( C7_NUM+C7_FORNECE+C7_LOJA ) ) )
	
	cOrigem := "Rollback de Residuo"
	cHist   := "Residuo do PC "+SC7->C7_NUM+" Restaurado!"
	cNomUsu := Left( UsrFullName( __cUserId ), TamSX3("ZB3_USUARI")[1] )
	
	U_GrvOcorPrv(ZB2->ZB2_PROVIS,"4",Date(),(SC7->C7_QUANT - SC7->C7_QUJE)*SC7->C7_PRECO,cOrigem,cHist,cNomUsu)
	
EndIf

MsgBox('Pedido Restaurado','Atencao','Info')
close(Residuo)

RestArea(_cArea)

Return