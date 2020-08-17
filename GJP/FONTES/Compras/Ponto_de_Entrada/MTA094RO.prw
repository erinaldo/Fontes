#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA094RO º Autor ³ Carlos A. Queiroz  º Data ³  28/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao de funcionalidade de Rejeicao de Solicitacao de    º±±
±±º          ³ Compras e Pedido de Compras.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resort                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA094RO()

Local aAuxRotina := PARAMIXB[1]

aAdd(aAuxRotina,{OemToAnsi("Rejeitar Solicitacao de Compras"),"U_GJPREJSC",  0 , 6, 0, Nil,Nil,Nil} )
aAdd(aAuxRotina,{OemToAnsi("Rejeitar Pedido de Compras"),"U_GJPREJPC",  0 , 6, 0, Nil,Nil,Nil} )

Return aAuxRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GJPREJSC º Autor ³ Carlos A. Queiroz  º Data ³  28/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao de funcionalidade de Rejeicao de Solicitacao de    º±±
±±º          ³ Compras.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resort                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GJPREJSC()

If SCR->CR_STATUS == '02' .AND. SCR->CR_TIPO == 'SC'
	dbselectarea("SC1")
	dbsetorder(1)
	If dbseek(SCR->CR_FILIAL+alltrim(SCR->CR_NUM))
		U_xA110Aprov("SC1",SC1->(Recno()),2)
	Else
		msginfo("Solicitação de Compras "+alltrim(SCR->CR_NUM)+" não localizada na filial "+SCR->CR_FILIAL+".")
	EndIf
Else
	msginfo("Necessário que esteja com status 'Pendente' e a linha selecionada seja uma Solicitação de Compras (tipo SC) para que esta funcionalidade seja executada.")
EndIF

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³xA110Aprov³ Autor ³  Carlos A. Queiroz   ³ Data ³ 28.10.2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de rejeicao  de solicitacao de compra                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                    ³±±
±±³          ³ ExpN2 = Numero do registro                                  ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo de rejeitar um item 		   ³±±
±±³          ³da solicitação de compra                                     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GJP                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xA110Aprov(cAlias,nReg,nOpcx)

Local lPrjCni := If(FindFunction("ValidaCNI"),ValidaCNI(),.F.)
Local aArea		:= GetArea()
Local aSizeAut	:= MsAdvSize(.F.,.F.)
Local aCpos     := {"C1_FILENT","C1_NUM","C1_EMISSAO","C1_PRODUTO","C1_DESCRI","C1_OBS","C1_QUANT","C1_UM"}
Local aObjects	:= {}
Local aInfo 	:= {}
Local aPosGet	:= {}
Local aPosObj	:= {}
Local aItens 	:= {}
Local aCposNew 	:= {}

Local nOpcA     := 0
Local lRet
Local lContinua := .T.
Local lAProvSI 	:= GetNewPar("MV_APROVSI",.F.)
//Local l110ApvE	:= ExistBlock("MT110APV")
Local l110Apv   := .T.
Local oQual
Local oDlg
Local cCond  	:= "" //IIf(mv_par02==1,".T.","!Eof() .And. C1_FILIAL == xFilial('SC1') .And. SC1->C1_NUM == cNumSc")
Local cAprov    := ""
//-- Variavel usada para verificar se o disparo da funcao IntegDef() pode ser feita manualmente
Local lIntegDef  :=  FWHasEAI("MATA110",.T.,,.T.)
Local lMkPlace	:= .F.

Local cAprovBkp	:= ""
Local lReject 	:= .F.

//Private lShowAprv	:= !ExistSCR('SC',SC1->C1_NUM)

mv_par02 := 2  // 1 - aprovacao por item // 2 - aprovacao por sc
cCond  	:= IIf(mv_par02==1,".T.","SC1->(!Eof()) .And. SC1->C1_FILIAL == xFilial('SC1') .And. SC1->C1_NUM == cNumSc")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PE: MT110APV - Indica se a rotina de aprovação será executada |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If l110ApvE
l110Apv := ExecBlock("MT110APV",.F.,.F.,{cAlias, nReg})
If ValType(l110Apv)<>"L"
l110Apv:=.T.
EndIf
EndIf
*/
If l110Apv //.And. lShowAprv
	/*	If l110Auto
	If ProcH("C1_NUM") > 0
	If ProcH("C1_ITEM") > 0
	dbSelectArea("SC1")
	dbSetOrder(1)
	dbSeek(xFilial("SC1")+aAutoCab[ProcH("C1_NUM"),2]+aAutoCab[ProcH("C1_ITEM"),2])
	nReg:=SC1->(RECNO())
	mv_par02 := 1//Aprovacao por item
	cCond := ".T."
	Else
	dbSelectArea("SC1")
	dbSetOrder(1)
	dbSeek(xFilial("SC1")+aAutoCab[ProcH("C1_NUM"),2])
	nReg:=SC1->(RECNO())
	mv_par02 := 2//Aprovacao por SC
	cCond := "!Eof() .And. C1_FILIAL == xFilial('SC1') .And. SC1->C1_NUM == cNumSc"
	EndIf
	
	If ProcH("C1_APROV") > 0
	cAprov := aAutoCab[ProcH("C1_APROV"),2]
	
	Do Case
	Case cAprov == "L"//Liberado
	nOpcA := 1
	Case cAprov == "R"//Rejeitado
	nOpcA := 2
	Case cAprov == "B"//Bloqueado
	nOpcA := 3
	EndCase
	EndIf
	EndIf
	EndIf
	*/
	If SC1->C1_TIPO == 2
		Help(" ",1,"A113TIPO")
		RestArea(aArea)
		Return
	EndIf
	
	cNumSc := SC1->C1_NUM
	
	If ExistBlock("MT110CPO")
		aCposNew := ExecBlock("MT110CPO",.F.,.F.,{aCpos})
		If ValType(aCposNew) == "A"
			aCpos := aCposNew
		EndIf
	EndIf
	
	If mv_par02 == 1
		If SoftLock("SC1") .And. SC1->C1_APROV $ 'B,R,L, ' .And. SC1->C1_QUJE == 0 .And.;
			IIf( lAProvSI ,(Empty(SC1->C1_COTACAO).Or.C1_COTACAO=="IMPORT"),Empty(SC1->C1_COTACAO)) .And. Empty(SC1->C1_RESIDUO)
			lContinua := .T.
		Else
			lContinua := .F.
		EndIf
	Else
		dbSelectArea("SC1")
		dbSetOrder(1)
		dbSeek(xFilial("SC1")+SC1->C1_NUM)
		While !Eof() .And. C1_FILIAL == xFilial("SC1") .And. SC1->C1_NUM == cNumSc
			If SoftLock("SC1") .And. SC1->C1_APROV $ 'B,R,L, ' .And. SC1->C1_QUJE == 0 .And.;
				IIf( lAProvSI ,(Empty(SC1->C1_COTACAO).Or.C1_COTACAO=="IMPORT"),Empty(SC1->C1_COTACAO)) .And. Empty(SC1->C1_RESIDUO)
				AADD(aItens,{C1_PRODUTO,C1_UM,C1_QUANT,C1_OBS,C1_EMISSAO,C1_DESCRI,C1_FILENT})
			EndIf
			dbSkip()
		EndDo
		dbSeek(xFilial("SC1")+cNumSc) //Volta para o primeiro item da SC
		If Len(aItens) == 0
			lContinua := .F.
		EndIf
	EndIf
EndIf

If lContinua .And. l110Apv //.And. lShowAprv
	//	If !l110Auto
	AAdd( aObjects, { 100, 100, .T., .T. })
	
	if lPrjCni
		AAdd( aObjects, { 0,    55, .T., .F. })
	Else
		AAdd( aObjects, { 0,    25, .T., .F. })
	EndIf
	
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Solicitação de Compras")+" - Aprovar"+IIf(mv_par02==2," - "+cNumSc,"") From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		//"Solicita‡„o de Compras"
	
	If mv_par02 == 1
		EnChoice( cAlias, nReg, nOpcx, , , , aCpos, aPosObj[1], , 3 )
	Else
		@ 1.6,.7 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Produto"),OemToAnsi("Unid.Medida"),OemToAnsi("Quantidade"),OemToAnsi("Observacao"),OemToAnsi("Dt.Emissao"),OemToAnsi("Descricao"),OemToAnsi("Fil.Entrega") SIZE aPosObj[1][4],aPosObj[1][3]-18 //	"Produto"##"Unid.Medida"##"Quantidade"##"Observacao"##"Dt.Emissao"##"Descricao"##"Fil.Entrega"
		oQual:SetArray(aItens)
		oQual:bLine := { || {aItens[oQual:nAT][1],aItens[oQual:nAT][2],aItens[oQual:nAT][3],aItens[oQual:nAT][4],aItens[oQual:nAT][5],aItens[oQual:nAT][6],aItens[oQual:nAT][7]}}
		If ExistBlock("MT110CP2")
			ExecBlock("MT110CP2",.F.,.F.,{aItens,oQual})
		EndIf
	EndIf
	
	//		@ aPosObj[2,1]+008,aPosObj[2,4]-300 BUTTON STR0035 SIZE 60,15 FONT oDlg:oFont ACTION (nOpcA := 3,oDlg:End()) PIXEL
	//		@ aPosObj[2,1]+008,aPosObj[2,4]-220 BUTTON STR0033 SIZE 60,15 FONT oDlg:oFont ACTION (nOpcA := 1,oDlg:End()) PIXEL
	@ aPosObj[2,1]+008,aPosObj[2,4]-140 BUTTON "Rejeitar Solicitação" SIZE 60,15 FONT oDlg:oFont ACTION (nOpcA := 2,oDlg:End()) PIXEL
	@ aPosObj[2,1]+008,aPosObj[2,4]-060 BUTTON "Sair" SIZE 60,15 FONT oDlg:oFont ACTION (nOpcA := 0,oDlg:End()) PIXEL
	ACTIVATE MSDIALOG oDlg
	//	EndIf
	
	If (ExistBlock("MT110BLO"))
		lRet := ExecBlock("MT110BLO",.f.,.f.,{nOpcA})
		If ValType(lRet) <> "L"
			lRet := .T.
		EndIf
	Else
		lRet := .T.
	EndIf
	
	PcoIniLan("000051")
	
	If lRet .And. nOpcA > 0
		While &cCond
			If mv_par02 == 2
				If !(SoftLock("SC1")) .And. !(SC1->C1_APROV $ 'B,R,L, ') .And. SC1->C1_QUJE <> 0 .And.;
					IIf( lAProvSI ,!(Empty(SC1->C1_COTACAO).Or.C1_COTACAO<>"IMPORT"),!Empty(SC1->C1_COTACAO))	.And.!Empty(SC1->C1_RESIDUO)
					dbSkip()
					Loop
				EndIf
			EndIf
			
			Do Case
				Case nOpcA == 1
					If !PcoVldLan('000051','02','MATA110',/*lUsaLote*/,/*lDeleta*/, .F./*lVldLinGrade*/)  // valida bloqueio na aprovacao de SC
						Exit
					Endif
					Begin Transaction
					If RecLock("SC1")
						cAprovBkp := SC1->C1_APROV
						If SC1->C1_APROV $ " ,B,R" .And. SC1->C1_QUJE == 0 .And.;
							IIf( lAProvSI ,(Empty(SC1->C1_COTACAO).Or.C1_COTACAO=="IMPORT"),Empty(SC1->C1_COTACAO)) .And. Empty(SC1->C1_RESIDUO)
							SC1->C1_APROV := "L"
							SC1->C1_NOMAPRO := UsrRetName(RetCodUsr())
						EndIf
						MaAvalSC("SC1",8,,,,,,cAprovBkp)
					EndIf
					End Transaction
				Case nOpcA == 2
					Begin Transaction
					If RecLock("SC1")
						cAprovBkp := SC1->C1_APROV
						If SC1->C1_APROV $"B,L, " .And. SC1->C1_QUJE == 0 .And.;
							IIf( lAProvSI ,(Empty(SC1->C1_COTACAO).Or.C1_COTACAO=="IMPORT"),Empty(SC1->C1_COTACAO)) .And. Empty(SC1->C1_RESIDUO)
							SC1->C1_APROV := "R"
							SC1->C1_NOMAPRO := UsrRetName(RetCodUsr())
						EndIf
						MaAvalSC("SC1",8,,,,,,cAprovBkp)
					EndIf
					
					dbselectarea("DBM")
					dbsetorder(1)
					If dbseek(SCR->CR_FILIAL+"SC"+alltrim(SCR->CR_NUM))
						While DBM->(!EOF()) .and. (SCR->CR_FILIAL+"SC"+alltrim(SCR->CR_NUM)) == (DBM->DBM_FILIAL+DBM->DBM_TIPO+alltrim(DBM->DBM_NUM))
							RecLock("DBM",.F.)
							DBM->(dbdelete())
							DBM->(msunlock())
							DBM->(dbskip())
						EndDo
					EndIf

					lReject := .T.

					RecLock("SCR",.F.)
					SCR->(dbdelete())
					SCR->(msunlock())
					End Transaction
					
//					msginfo("SC "+alltrim(SC1->C1_NUM)+" teve seu status alterado para 'rejeitada'.")
					
				Case nOpcA == 3
					Begin Transaction
					If RecLock("SC1")
						cAprovBkp := SC1->C1_APROV
						If SC1->C1_APROV $ " ,L,R" .And. SC1->C1_QUJE == 0 .And.;
							IIf( lAProvSI ,(Empty(SC1->C1_COTACAO).Or.C1_COTACAO=="IMPORT"),Empty(SC1->C1_COTACAO)) .And. Empty(SC1->C1_RESIDUO)
							SC1->C1_APROV := "B"
							SC1->C1_NOMAPRO := UsrRetName(RetCodUsr())
						EndIf
						MaAvalSC("SC1",9,,,,,,cAprovBkp)
					EndIf
					End Transaction
					//Caio.Santos - 11/01/13 - Req.72
					If lPrjCni
						RSTSCLOG("APR",1,/*cUsrWF*/)
					EndIf
			EndCase
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Executa o PE MT110END apos acionar os botoes Aprovar Bloquear Rejeitar ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MT110END")
				ExecBlock("MT110END",.F.,.F.,{cNumSc,nOpcA})
			EndIf
			
			If mv_par02 == 1
				Exit
			Else
				SC1->(dbSkip())
			EndIf
		EndDo
		
		If lReject
			msginfo("SC "+alltrim(cNumSc)+" teve seu status alterado para 'rejeitada'.")
		EndIf
		
		SC1->(DbSetOrder(1))
		SB5->(DbSetOrder(1))
		
		If SB5->(DbSeek( xFilial("SB5") + SC1->C1_PRODUTO ) )
			If SB5->(FieldPos("B5_ENVMKT")) > 0
				If SB5->B5_ENVMKT <> "1"
					lMkPlace := .F.
				EndIf
			EndIf
		EndIf
		
		If lIntegDef .And. SC1->( DbSeek( xFilial("SC1")+cNumSc ) )
			If SuperGetMV("MV_MKPLACE",.F.,.F.) .And. lMkPlace
				Inclui:=.T.
				FwIntegDef( 'MATA110' )
			ELseIf !(SuperGetMV("MV_MKPLACE",.F.,.F.))
				Inclui:=.T.
				FwIntegDef( 'MATA110' )
			EndIf
		EndIf
		
	EndIf
	PcoFinLan("000051")
	PcoFreeBlq("000051")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa o PE MT110CFM apos acionar os botoes Aprovar Bloquear Rejeitar - para todos os itens da SC ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("MT110CFM")
		ExecBlock("MT110CFM",.F.,.F.,{cNumSc,nOpcA})
	EndIf
Else
	//	If !lShowAprv
	//		Help(" ",1,"EXISTSCR")
	//	Else
	//	If !l110ApvE
	//		Help(" ",1,"MT110APROV")
	
	//	EndIf
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GJPREJPC º Autor ³ Carlos A. Queiroz  º Data ³  28/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criacao de funcionalidade de Rejeicao de Pedido de Compras.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP Hotels & Resort                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GJPREJPC()
If SCR->CR_STATUS == '02' .AND. SCR->CR_TIPO == 'PC'
	dbselectarea("SC7")
	dbsetorder(1)
	If dbseek(SCR->CR_FILIAL+alltrim(SCR->CR_NUM))
		If msgyesno("Deseja rejeitar o Pedido de Compras "+alltrim(SCR->CR_NUM)+" localizado na filial "+SCR->CR_FILIAL+"?")
			Begin Transaction
			While SC7->(!EOF()) .and. (SCR->CR_FILIAL+alltrim(SCR->CR_NUM)) == (SC7->C7_FILIAL+alltrim(SC7->C7_NUM))
				RecLock("SC7",.F.)
				SC7->C7_CONAPRO := "B"
				SC7->C7_APROV   := "XXXXXX"
				SC7->(msunlock())
				SC7->(dbskip())
			EndDo

			SC7->(dbskip(-1))

			RecLock("SCR",.F.)
			SCR->(dbdelete())
			SCR->(msunlock())
			End Transaction
			
			msginfo("PC "+alltrim(SC7->C7_NUM)+" teve seu status alterado para 'rejeitado'.")
			
		Else
			msginfo("Status do Pedido de Compras "+alltrim(SCR->CR_NUM)+" não foi alterado.")
		EndIf
	Else
		msginfo("Pedido de Compras "+alltrim(SCR->CR_NUM)+" não localizada na filial "+SCR->CR_FILIAL+".")
	EndIf
Else
	msginfo("Necessário que esteja com status 'Pendente' e a linha selecionada seja um Pedido de Compras (tipo PC) para que esta funcionalidade seja executada.")
EndIF

Return .T.