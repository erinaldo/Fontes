#Include "PROTHEUS.CH"
#Include "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOVLBLQ  ºAutor  ³Microsiga           º Data ³  03/23/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PcoVlBLQ()
Local aEmail1 := GETMV("MV_PCOMAP")
Local cOBS := ""
Local aEnvmail1 := ""
Local aEnvmail2 := ""

lRet	:= .T.
__aDadosBlq :=  aClone(ParamIXB)
cConta 		:= SUBSTR(__aDadosBlq[4],1,12)
//aLERT(CCONTA)
cCusto		:= SUBSTR(__aDadosBlq[4],13,20)
//aLERT(CCUSTO)
//__aDadosBlq	:=	{nMoedaCfg,nValReal,nValPrv,cChaveR,cProcesso,cItem,cPrograma,cChaveRD,aDataIniFim,aAuxFil}



IF ZU6->(DbSeek(xFilial("ZU6")+cConta+cCusto)) //validação da amarração Conta e CCusto
	
	If __aDadosBlq[2] <= __aDadosBlq[3]
		lRet	:=	.T.
	Else
		While .T.
			
			aArea	:= GetArea()
			
			cDesccta    := ""
			cDesccusto	:= ""
			
			DbSelectArea("CTT")
			DbSetOrder(1)
			DbSeek(xFilial("CTT")+cCusto)
			
			cDesccusto 	= CTT->CTT_DESC01
			
			DbSelectArea("AK5")
			DbSetOrder(1)
			DbSeek(xFilial("AK5")+cConta)
			
			cDesccta	= ALLTRIM(AK5->AK5_DESCRI)
			
			RestArea (aArea)
			
			cTxtBlq	:=	"Os saldos atuais do Planejamento e Controle Orçamentário são insuficientes para completar esta operação no periodo de "+;
			DTOC(__aDadosBlq[9,1])+" - "+DTOC(__aDadosBlq[9,2])+"."+CHR(13)+CHR(10)+; //###
			"Tipo de Bloqueio : "+AllTrim(AKJ->AKJ_DESCRI)+CHR(13)+CHR(10)+; //"Tipo de Bloqueio : "
			"Cubo : "+AllTrim(__aDadosBlq[8])+CHR(13)+CHR(10)+;
			"Chave : "+AllTrim(__aDadosBlq[4])+CHR(13)+CHR(10)+;
			"Conta  :"+AllTrim(cDesccta)+CHR(13)+CHR(10)+;
			"Custo  :"+AllTrim(cDesccusto)+CHR(13)+CHR(10)+;
			"Saldo Previsto : "+Str(__aDadosBlq[3],14,2)+ " Vs Saldo Realizado : " +Str(__aDadosBlq[2],14,2)+CHR(13)+CHR(10)
			If __aDadosBlq[5] =="000055"
				nDet := Aviso("Planejamento e Controle Orçamentário",cTxtBlq,;
				{"&Fechar", "&Solic. lib.","&Detalhes"},3,"Saldo Insuficiente",,;
				"PCOLOCK")
			Else
				nDet := Aviso("Planejamento e Controle Orçamentário",cTxtBlq,;
				{"&Fechar", "&Detalhes"},3,"Saldo Insuficiente",,;
				"PCOLOCK")
			Endif
			If nDet <= 2
				Exit
			Else
				cCodCuboPrv  := Posicione("AL4", 1, xFilial("AL4")+AKJ->AKJ_PRVCFG, "AL4_CONFIG")
				cCodCuboReal := Posicione("AL4", 1, xFilial("AL4")+AKJ->AKJ_REACFG, "AL4_CONFIG")
				PcoDetBlq(cCodCuboPrv, cCodCuboReal, __aDadosBlq[9,1], __aDadosBlq[9,2], __aDadosBlq[4], __aDadosBlq[3], __aDadosBlq[2], __aDadosBlq[10])
			EndIf
		EndDo
		If nDet	==	2
			U_GrvContPCO(AKD->(Recno()),ParamIXB,cTxtBlq)
		Endif
	Endif
	
	If __aDadosBlq[2] <= __aDadosBlq[3]
		lRet	:=		.T.
	Else
		lRet	:= 	.F.
	Endif
	
Endif

aEnvmail1 := GETMV("MV_PCOM1")

If aEnvmail1 == "S"
	
	//cMensagem	:=	"Cod. Bloqueio: "+__aDadosBlq[5]+ "."
	//MsgInfo(cMensagem,"Atenção")
	
	//-------------------------------------------------------------------------------
	//Envio de e-mail na Solicitação de Compras
	// Incluído em 30/01/2007 para envio de e- mail
	//-------------------------------------------------------------------------------
	
	cDesccta    := ""
	cDesccusto	:= ""
	
	DbSelectArea("CTT")
	DbSetOrder(1)
	DbSeek(xFilial("CTT")+cCusto)
	
	cDesccusto 	= CTT->CTT_DESC01
	
	DbSelectArea("AK5")
	DbSetOrder(1)
	DbSeek(xFilial("AK5")+cConta)
	
	cDesccta	= ALLTRIM(AK5->AK5_DESCRI)
	
	cOBS	:=			'<p class="titulo"><font size="3"> Tipo de Bloqueio : '+AllTrim(AKJ->AKJ_DESCRI)+'</p>' //"Tipo de Bloqueio : "
	cOBS	+=			'<p class="titulo"><font size="3"> Cubo : '+AllTrim(__aDadosBlq[8])+'</p>'
	cOBS	+=			'<p class="titulo"><font size="3"> Chave : '+AllTrim(__aDadosBlq[4])+'</p>'
	cOBS	+=			'<p class="titulo"><font size="3"> Conta  :'+AllTrim(cDesccta)+'</p>'
	cOBS	+=			'<p class="titulo"><font size="3"> Custo  :'+AllTrim(cDesccusto)+'</p>'
	cOBS	+=			'<p class="titulo"><font size="3"> Saldo Previsto : '+Str(__aDadosBlq[3],14,2)+'</p>'
	cOBS	+=			'<p class="titulo"><font size="3"> Vs Saldo Realizado : ' +Str(__aDadosBlq[2],14,2)+'</p>'
	
	If __aDadosBlq[5] == "000051" // somente irá gerar valores de contigência para a rotina de Liberação de Pedido de Compras
		//	aEmail1:= IIf(Empty(UsrRetMail(aEmail1)),aEmail1,UsrRetMail(SC1->C1_SOLICIT))
		cMensagem:= '<p class="titulo"><font size="3"> A solicitação abaixo demandará aprovação orçamentária complementar ' +'</p>'
		cMensagem+= '<p class="titulo"><font size="3">  Atenciosamente,' +'</p>'
		cMensagem+= '<p class="titulo"><font size="3">         '+UsrRetName() +'</p>'
		cMensagem+= '<p class="titulo"><font size="3">         '+UsrRetMail(__cUserID) +'</p>'
		
		EmailBlq(aEmail1,.T.,cOBS,cMensagem)
		
	Endif
	
Endif

//-------------------------------------------------------------------------------

If __aDadosBlq[5] <>"000055"
	lRet	:=		.T.
Endif

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PcoGravaCont   ºAutor  ³Bruno Sobieski   º Data ³ 05/03/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geracao de registro para solicitacao de contingencia        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GrvContPCO(nRecAKD,aDadosBlq,cObs)

Local nX
Local lRetorno	:=.F.
Local lContinua:= .T.
Local cChave	:=	''
Local aEmail1 := GETMV("MV_PCOMAP")
DEFAULT cObs	:=	""


If aDadosBlq[5] =="000055" // Somente irá gerar valores de contigência para Liberação de Pedido de Compras
	
	//Se o processo for de liberacao de pedido, pode que ja exista uma solicitacao gravada
	If aDadosBlq[5] =="000055"
		
		cQuery	:=	" SELECT *  FROM  "+RetSqlName("ZU1")
		cQuery	+=	" WHERE ZU1_FILIAL = '"+xFilial('ZU1')+"' AND "
		cQuery	+=	" ZU1_PEDIDO = '"+SCR->CR_NUM+"' AND "
		cQuery	+=	" D_E_L_E_T_<> '*' "
		cQuery	:=	ChangeQuery(cQuery)
		
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),"QRYZU1", .F., .F. )
		
		While !Eof()
			If QRYZU1->ZU1_STATUS == "02"
				cMsg	:= "A contingencia aguarda liberacao do usuario :"+UsrRetName(QRYZU1->ZU1_USER)
				Aviso("Solicitacao ja existe",'Ja existe solicitacao de contingencia para este pedido e item (Solicitacao '+ZU2->ZU2_CDCNTG+')'+CRLF+cMsg,{"Fechar"},3)
				lContinua := .F.
				Exit
			ElseIf QRYZU1->ZU1_STATUS == "04"
				cMsg	:= "A contingencia foi cancelada pelo usuario :"+UsrRetName(QRYZU1->ZU1_USER)
				Aviso("Solicitacao ja existe",'Ja existe solicitacao de contingencia para este pedido e item (Solicitacao '+ZU2->ZU2_CDCNTG+')'+CRLF+cMsg,{"Fechar"},3)
				lContinua := .F.
				Exit
			Endif
			QRYZU1->(DbSkip())
		Enddo
		DbCloseArea()
	Endif
	If lContinua
		
		lRetorno	:=	U_MaAlcPco(1,AKJ->AKJ_COD,{aDadosBlq[5],aDadosBlq[2],aDadosBlq[3],aDadosBlq[1],aDadosBlq[4],AKD->(AKD_LOTE+AKD_ID),cObs})
		
		
		If lRetorno
			RecLock('ZU2',.T.)
			For nX := 1 To (AKD->(FCount()))
				nPosCpo := ZU2->(FieldPos("ZU2_"+Substr(AKD->(FieldName(nX)),5)))
				If nPosCpo > 0
					ZU2->(FieldPut(nPosCpo,AKD->(FieldGet(nX))) )
				Endif
			Next nX
			ZU2_FILIAL 	:= xFilial('ZU2')
			ZU2_ID		:=	StrZero(1,TamSX3('ZU2_ITEM' )[1])
			ZU2_CDCNTG	:=	ZU1->ZU1_CDCNTG
			ZU2_VALOR1	:=	aDadosBlq[2]-aDadosBlq[3]
			ZU2_LOTEID  :=  ZU1->ZU1_LOTEID
			MsUnLock()
		Else
			Aviso("Atencao","Nao existe aprovador cadastrado para liberacao para este bloqueio (tipo de bloqueio, chave e valores).",{"Ok"})
		Endif
		
	Endif
	
Endif

//Envio de e-mail na liberação do pedido
/*
If aDadosBlq[5] == "000055" // somente irá gerar valores de contigência para a rotina de Liberação de Pedido de Compras
aEmail1:= IIf(Empty(UsrRetMail(SC1->C1_SOLICIT)),aEmail1,UsrRetMail(SC1->C1_SOLICIT))
cMensagem:= "A solicitação abaixo demandará aprovação orçamentária complementar " +CRLF+CRLF
cMensagem+= " Atenciosamente," +CRLF+CRLF
cMensagem+= "        "+UsrRetName() +CRLF
cMensagem+= "        "+UsrRetMail(__cUserID) +CRLF

EmailBlq(aEmail1,.T.,cOBS,cMensagem)

Endif
*/

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MaAlcPco ³ Autor ³ Bruno Sobieski        ³ Data ³05.03.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controla a Alcada dos bloqueios  no PCO.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MaAlcPco(ExpN1,EXPC1,ExpA1      )                       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ ExpN1 = Operacao a ser executada                           ³±±
±±³          ³       1 = Inclusao do documento                            ³±±
±±³          ³       2 = Transferencia para Superior                      ³±±
±±³          ³       3 = Exclusao do documento                            ³±±
±±³          ³       4 = Aprovacao do documento                           ³±±
±±³          ³       5 = Estorno da Aprovacao                             ³±±
±±³          ³       6 = Bloqueio Manual da Aprovacao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MaAlcPco(nOper,cCodBlq,aDados)

Local lFirstNiv:= .T.
Local cAuxNivel:= ""
Local cNextNiv	:= ""
Local cNivIgual:= ""
Local lRetorno	:= .F.
Local lAchou	:= .F.
Local	cCodCntg	:=	""
Local cProcesso
Local nValVerba
Local nValReal
Local nValOrc
Local nMoeda
Local cChaveBlq
Local cLoteID
Local cObs
Local cStatusAnt:= ""
Local aRecZU1	:=	{}
Local aEmail	:=	{}
Local cMensagem:=""
Local nX

If nOper == 1  //Inclusao do Documento
	cProcesso	:=	aDados[1]
	nValReal	:=	aDados[2]
	nValOrc		:=	aDados[3]
	nMoeda		:=	aDados[4]
	cChaveBlq	:=	aDados[5]
	cLoteID		:=	aDados[6]
	cObs		:=	aDados[7]
	
	If cProcesso =="000055" // somente irá gerar valores de contigência para a rotina de Liberação de Pedido de Compras
		
		dbSelectArea("ZU5")
		dbSetOrder(1)
		
		If !Empty(cCodBlq) .And. dbSeek(xFilial("ZU5")+cCodBlq)
			ZU1->(dbSetOrder(2))
			If ZU1->(MsSeek(xFilial()+cLoteID))
				cCodCntg	:=	ZU1->ZU1_CDCNTG
			Endif
			
			//cMensagem	:=	"Cod. Bloqueio: "+xFilial("ZU5")+cCodBlq+ "."
			//MsgInfo(cMensagem,"Atenção")
			
			While !Eof() .And. xFilial("ZU5")+cCodBlq == ZU5_FILIAL+alltrim(ZU5_COD) //.And. ZU5_ATIVO == "1"
				
				nValVerba	:=	nValReal-nValOrc
				nPercVerba	:=	((nValReal-nValOrc)/nValOrc)  * 100
				
				//----------------------
				//Busca o Número do Pedido
				DBSELECTAREA("AKD")
				DBSETORDER(1)
				DBSEEK(XFILIAL("AKD")+cLoteID)
				_cPedido := SUBSTR(AKD->AKD_CHAVE,14,6)
				
				//----------------------
				//Busca no Pedido o Comprador
				DbSelectArea("SC7")
				DbSetOrder(1)
				DbSeek(xFilial("SC7")+_cPedido)
				_cComp	:=SC7->C7_USER
				
				//----------------------
				//Busca no Pedido E-mail do Comprador
				DbSelectArea("SY1")
				DbSetOrder(3)
				DbSeek(xFilial("SY1")+_cComp)
				_cemail	:=Alltrim(SY1->Y1_EMAIL)
				
				//----------------------
				//Busca no Pedido a solicicacao
				DbSelectArea("SC1")
				DbSetOrder(6)
				DbSeek(xfilial("SC1")+SC7->(C7_NUM+C7_ITEM) )
				_cEmail += ";"+ USRRETMAIL(SC1->C1_USER)
				
				
				If !MaAlcPcoLim(nValVerba,nPercVerba,nMoeda,cCodBlq,cChaveBlq,ZU5->ZU5_USER)
					dbSelectArea("ZU5")
					dbSkip()
					Loop
				EndIf
				If lFirstNiv
					cAuxNivel := ZU5->ZU5_NIVEL
					lFirstNiv := .F.
				EndIf
				ZU1->(DbSetOrder(2))
				If ZU1->(MsSeek(xFilial()+cLoteID+ZU5->ZU5_USER))
					Reclock("ZU1",.F.)
				Else
					If Empty(cCodCntg)
						cCodCntg	:=	GetSXENum('ZU1','ZU1_CDCNTG')
						ConFirmSX8()
					Endif
					Reclock("ZU1",.T.)
				Endif
				ZU1->ZU1_FILIAL		:=	xFilial("ZU1")
				ZU1->ZU1_CDCNTG		:=	cCodCntg
				ZU1->ZU1_CODBLQ		:=	cCodBlq
				ZU1->ZU1_PROCES		:=	cProcesso
				ZU1->ZU1_LOTEID		:=	cLoteID
				ZU1->ZU1_MEMO  		:=	cOBS
				ZU1->ZU1_NIVEL		:=	ZU5->ZU5_NIVEL
				ZU1->ZU1_USER		:=	ZU5->ZU5_USER
				ZU1->ZU1_STATUS		:=	IIF(ZU5->ZU5_NIVEL == cAuxNivel,"02","01")
				ZU1->ZU1_DTVALI		:=	dDataBase+1
				ZU1->ZU1_DTSOLI		:=	MsDate()
				ZU1->ZU1_HORA		:=	Time()
				ZU1->ZU1_SOLIC		:=	__cUserID
				ZU1->ZU1_NOMSOL		:=	UsrRetName(__cUserID)
				ZU1->ZU1_PEDIDO		:= _cPedido
				
				MsUnlock()
				
				AAdd(aRecZU1,ZU1->(Recno()))
				If ZU1_STATUS == "02"
					//		AAdd(aEmail,UsrRetMail(ZU5->ZU5_USER))  //RETIRADO PARA CORRECAO DO USUARIO - ENVIO DE E-MAIL
					
					AAdd(aEmail,_cemail)			//Inserido em 02/01/2006
					
				Endif
				dbSelectArea("ZU5")
				dbSkip()
				lRetorno	:=	.T.
			EndDo
			cMensagem:= '<p class="titulo"><font size="3"> Necessidade de liberacao de verba orcamentaria complementar para os dados abaixo. ' +'</p>'
			cMensagem+= '<p class="titulo"><font size="3">  Atenciosamente,' +'</p>'
			cMensagem+= '<p class="titulo"><font size="3">         '+UsrRetName() +'</p>'
			cMensagem+= '<p class="titulo"><font size="3">         '+UsrRetMail(__cUserID) +'</p>'
			
		EndIf
		
		ZU1->(DbSetOrder(2))
		ZU1->(MsSeek(xFilial()+cLoteID))
		While !ZU1->(EOF()) .And. xFilial('ZU1')+cLoteID == ZU1->(ZU1_FILIAL+ZU1_LOTEID)
			If Ascan(aRecZU1,ZU1->(Recno())) == 0
				RecLock("ZU1",.F.)
				DbDelete()
				MsUnlock()
			Endif
			ZU1->(DbSkip())
		Enddo
		ZU2->(DbSetOrder(2))
		ZU2->(MsSeek(xFilial()+cLoteID))
		While xFilial('ZU2')+cLoteID == ZU2->(ZU2_FILIAL+ZU2_LOTEID)
			RecLock("ZU2",.F.)
			DbDelete()
			MsUnlock()
			DbSkip()
		Enddo
		ZU1->(MsSeek(xFilial()+cLoteID))
	Endif
ElseIf nOper	==	 4 //Liberacao
	dbSelectArea("ZU5")
	dbSetOrder(2)
	dbSeek(xFilial()+ZU1->ZU1_CODBLQ+ZU1->ZU1_USER)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera a verba pelo aprovador.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("ZU1")
	cAuxNivel:=	ZU1_NIVEL
	cCodCntg	:=	ZU1_CDCNTG
	Reclock("ZU1",.F.)
	ZU1_STATUS := "03"  // Liberado
	ZU1_DTLIB	:= MsDate()
	ZU1_HORAL	:= Time()
	ZU1_USRLIB	:= __cUserID
	ZU1_NOMLIB	:=	UsrRetName(__cUserID)
	MsUnlock()
	nRec := Recno()
	
	dbSelectArea("ZU1")
	DbSetOrder(1)
	dbSeek(xFilial("ZU1")+cCodCntg)
	While !Eof() .And. xFilial("ZU1")+cCodCntg == ZU1_FILIAL+ZU1_CDCNTG
		If nRec == Recno()
			DbSkip()
			Loop
		Endif
		If cAuxNivel == ZU1_NIVEL .And. ZU1_STATUS != "03" .And. ZU5->ZU5_TPLIB$"U "//Usuario
			Exit
		EndIf
		If cAuxNivel == ZU1_NIVEL .And. ZU1_STATUS != "03" .And. ZU5->ZU5_TPLIB$"N" //Nivel
			Reclock("ZU1",.F.)
			ZU1_STATUS	:= "05"
			ZU1_DTLIB	:= MsDate()
			ZU1_HORAL	:= Time()
			ZU1_USRLIB	:= __cUserID
			ZU1_NOMLIB	:=	UsrRetName(__cUserID)
			MsUnlock()
		EndIf
		If ZU1_NIVEL > cAuxNivel .And. ZU1_STATUS != "03" .And. !lAchou
			lAchou := .T.
			cNextNiv := ZU1_NIVEL
		EndIf
		If lAchou .And. ZU1_NIVEL == cNextNiv .And. ZU1_STATUS != "03"
			Reclock("ZU1",.F.)
			ZU1_STATUS :=	If(( Empty(cNivIgual) .Or. cNivIgual == ZU1_NIVEL ) .And. cStatusAnt <> "01" ,"02",ZU1_STATUS)
			If ZU1_STATUS == "05"
				ZU1_DTLIB	:= MsDate()
				ZU1_HORAL	:= Time()
				ZU1_USRLIB	:= __cUserID
				ZU1_NOMLIB	:=	UsrRetName(__cUserID)
			EndIf
			MsUnlock()
			If ZU1_STATUS == "02"
				AAdd(aEmail,UsrRetMail(ZU1->ZU1_USER))
			Endif
			cNivIgual := ZU1_NIVEL
			lAchou    := .F.
		Endif
		cStatusAnt := ZU1->ZU1_STATUS
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reposiciona e verifica se ja esta totalmente liberado.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRetorno	:=	.T.
	dbSeek(xFilial("ZU1")+cCodCntg)
	While !Eof() .And. xFilial("ZU1")+cCodCntg == ZU1_FILIAL+ZU1_CDCNTG
		If ZU1_STATUS != "03" .And. ZU1_STATUS != "05"
			lRetorno := .F.
		EndIf
		//----------------------
		//Busca no Pedido o Comprador
		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+ZU1->ZU1_PEDIDO)
		_cComp	:=SC7->C7_USER
		
		//----------------------
		//Busca no Pedido E-mail do Comprador
		DbSelectArea("SY1")
		DbSetOrder(3)
		DbSeek(xFilial("SY1")+_cComp)
		_cemail	:=Alltrim(SY1->Y1_EMAIL)
		
		//----------------------
		//Busca no Pedido a solicicacao
		DbSelectArea("SC1")
		DbSetOrder(6)
		DbSeek(xfilial("SC1")+SC7->(C7_NUM+C7_ITEM) )
		_cEmail += ";"+ USRRETMAIL(SC1->C1_USER)
		DbselectArea("ZU1")
		dbSkip()
	EndDo
	If lRetorno
		AAdd(aEmail,_cEmail)
		cObs	:=	""
		cMensagem	:=	"Solicitacao de liberacao orcamentaria "+cCodCntg+" aprovada."
	Endif
ElseIf nOper == 5  //Encerramento
	Reclock("ZU1",.F.)
	ZU1_STATUS 	:= "06"
	ZU1_DATAF 	:= Date()
	ZU1_USRFEC	:= __cUserID
	ZU1_NOMFEC	:=	UsrRetName(__cUserID)
	MsUnlock()
ElseIf nOper == 6  //Cancelamento
	Reclock("ZU1",.F.)
	ZU1_STATUS := "04"
	ZU1_DTLIB	:= MsDate()
	ZU1_HORAL	:= Time()
	ZU1_USRLIB	:= __cUserID
	ZU1_NOMLIB	:=	UsrRetName(__cUserID)
	
	MsUnlock()
	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7")+ZU1->ZU1_PEDIDO)
	_cComp	:=SC7->C7_USER
	DbSelectArea("SY1")
	DbSetOrder(3)
	DbSeek(xFilial("SY1")+_cComp)
	_cemail	:=Alltrim(SY1->Y1_EMAIL)
	DbSelectArea("SC1")
	DbSetOrder(6)
	DbSeek(xfilial("SC1")+SC7->(C7_NUM+C7_ITEM) )
	if !empty (_cEmail)
		_cEmail += ";"+ USRRETMAIL(SC1->C1_USER)
	else
		_cEmail += USRRETMAIL(SC1->C1_USER)
	endif
	DbselectArea("ZU1")
	AAdd(aEmail,_cEmail)
	cObs			:=	""
	cMensagem	:=	"Solicitacao de liberacao orcamentaria "+cCodCntg+" rejeitada pelo usuario "+ ZU1_NOMLIB+ "."
	lRetorno := .F.
EndIf

For nX := 1 To Len(aEmail)
	
	aEnvmail2 := GETMV("MV_PCOM2")
	
	If aEnvmail2 == "S"
		EmailBlq(aEmail[nX],.T.,cOBS,cMensagem)
	Endif
	
Next

dbSelectArea("ZU1")

//Endif

Return lRetorno


Static Function MaAlcPcoLim(nValVerba,nPercVerba,nMoeda,cCodBlq,cChaveBlq,cUser)
Local lRet		:=	.F.
Local cQuery	:=	""

cQuery	:=	" SELECT ZU3_USER FROM "+RetSqlName("ZU4")+ " ZU4, "+RetSqlName("ZU3")+" ZU3"
cQuery	+=	" WHERE ZU3_FILIAL = '"+xFilial('ZU3')+"' AND "
cQuery	+=	" ZU4_FILIAL = '"+xFilial('ZU3')+"' AND  "
cQuery	+=	" ZU3_STATUS = '1' AND "
cQuery	+=	" ZU4_CODBLQ='"+cCodBlq+"' AND "
cQuery	+=	" ZU4_USER=ZU3_USER AND  "
cQuery	+=	" ZU4_USER='"+cUser+"' AND "
cQuery	+=	" ZU4_MOEDA = "+Str(nMoeda)+ " AND "
cQuery	+=	" '"+cChaveBlq+"' BETWEEN ZU4_CODINI AND ZU4_CODFIM  AND "
cQuery	+=	" (( ZU4_TPMIN = '1' AND "+Str(nValVerba)+ " BETWEEN ZU4_MINIMO AND ZU4_MAXIMO)    OR "
cQuery	+=	"  ( ZU4_TPMIN = '2' AND "+Str(nPercVerba)+ " BETWEEN ZU4_MINIMO AND ZU4_MAXIMO) ) AND "
cQuery	+=	" ZU4.D_E_L_E_T_<> '*' AND "
cQuery	+=	" ZU3.D_E_L_E_T_<> '*' "
cQuery	:=	ChangeQuery(cQuery)

dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),"QRYTRB", .F., .F. )
If !Eof()
	lRet	:=	.T.
Endif
DbCloseArea()

Return lRet

Static Function EMAILBLQ(cMail,lEditaTxt,cTxtBlq,cMensagem)

Local cTO	:= Padr(cMail,200)
Local cCC	:= SPACE(200)
Local cAssunto	:=	Padr("Solicitacao de liberacao orcamentaria",200)
Local cTitulo := 'Solicitacao de Liberacao Orcamentaria'
Local oDLg

DEFAULT cTxtBLQ	:=	""
Private cError    := ""
Private lOk    	:=	.T.
Private lSendOk	:=	.T.

lMudaEmail 	:=	Empty(cMail)

If !EMPTY(cTxtBlq)
	cMensagem	+=	'<p class="titulo"><font size="3"> _Dados do bloqueio____________________</p>'
	cMensagem	+=	cTxtBlq
Endif

If lEditaTXT
	DEFINE MSDIALOG oDLg from 110,013 To 539,696 Title OemToAnsi("Envio de email") PIXEL of oMainWnd
	@ 002,002 To 50,334 PIXEL of oDlg
	@ 009,006 Say OemToAnsi("Para") 			Size 32,8 PIXEL of oDlg
	@ 022,006 Say OemToAnsi("Com copia") 	Size 29,8 PIXEL of oDlg
	@ 035,006 Say OemToAnsi("Assunto") 		Size 33,8 PIXEL of oDlg
	@ 009,039 MSGet cTo 		Size 294,10 PIXEL of oDlg
	@ 022,039 MSGet cCC 		Size 294,10 PIXEL of oDlg
	@ 035,039 MSGet cAssunto 	Size 294,10 PIXEL of oDlg
	@ 052,003 Get cMensagem MEMO Size 332,142 PIXEL of oDlg
	@ 196,299 Button OemToAnsi("&Enviar") Size 36,16 Action( EnvEmail(cAssunto, cTitulo ,cMensagem, cTo ), oDlg:End()) PIXEL of oDlg
	Activate Dialog oDlg
	cMensagem+=	"______________________________________"+CRLF
Endif

Return .T.

Static Function EnvEmail(pcAssunto, pcTitulo , pcMensagem, pcTo)

U_Rcomw06( pcAssunto, pcTitulo, pcMensagem, pcTo )

Return 
