#include "Topconn.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CPRJA02  º Autor ³ Fabio Zanchim      º Data ³  10/2013    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Controle das SSi - Envia WF de controle conforme status.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus11                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CPRJA02()

Local dDtJob:=''

RpcSetType(3)
RpcSetEnv('01','01')

dDtJob:=GetMV('CI_DATAJOB')

If Date()>dDtJob
	
	//--------------------
	// SSIs não alocadas
	Conout('Job SSI CPRJA02() - Iniciando SSIs não alocadas...')
	CPrjNAloc()
	
	//-----------------------------------------
	//Controle da Data de Previsao de Termino
	Conout('Job SSI CPRJA02() - Iniciando Controle da Data de Previsao de Termino...')
	CPrjPTer()
	
	//------------------------------------------------------------
	//SSIs Oficializados (Concluidos) e sem Aceite do Solicitante
	Conout('Job SSI CPRJA02() - Iniciando SSIs Oficializados (Concluidos) e sem Aceite do Solicitante...')
	CPrjNAce()
EndIf

PutMV('CI_DATAJOB',Date())

RpcClearEnv()

Return


/*--------------------------------------------------------------------
*
* Função: CPrjNAloc()
* Descrição: Envia WF referente SSIs incluídas e não alocadas
*            a mais de 5 dias da inclusao.
--------------------------------------------------------------------*/
Static Function CPrjNAloc()

Local cQuery:=''
Local cAlias:=''

cQuery:=" Select ZP_EMISSAO, R_E_C_N_O_ From "+RetSqlName('SZP')
cQuery+=" Where ZP_FILIAL='"+xFilial('SZP')+"'"
cQuery+=" And ZP_CONCLUS=' ' And ZP_CANCEL='2'"
cQuery+=" And ZP_ACEITE=' ' And ZP_APROV = 'S'"
cQuery+=" And ZP_ALOC='N'"
cQuery+=" And ZP_EMISSAO>='20130101'"//FABIO
cQuery+=" And D_E_L_E_T_=' '"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

dbSelectArea(cAlias)
While (cAlias)->(!Eof())
	If (Val(Dtos(Date())) - Val((cAlias)->ZP_EMISSAO)) > 5//Passou 5 dias
		
		EnvWFJob(1,(cAlias)->R_E_C_N_O_)
		
	EndIf
	(cAlias)->(dbSkip())
end
(cAlias)->(dbClosearea())
Return

/*------------------------------------------------------------------------
*
* Função: CPrjPTer()
* Descrição: Envia WF das SSIs alocadas e nao concuídas (status PENDENTE)
*            5 dias antes da Data de Previsao de Termino
*
------------------------------------------------------------------------*/
Static Function CPrjPTer()

Local cQuery:=''
Local cAlias:=''

cQuery:=" Select ZP_DTPREV, R_E_C_N_O_ From "+RetSqlName('SZP')
cQuery+=" Where ZP_FILIAL='"+xFilial('SZP')+"'"
cQuery+=" And ZP_CONCLUS=' ' And ZP_CANCEL='2'"
cQuery+=" And ZP_ACEITE=' ' And ZP_APROV = 'S'"
cQuery+=" And ZP_ALOC='S'"
cQuery+=" And ZP_EMISSAO>='20130101'"
cQuery+=" And D_E_L_E_T_=' '"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())
TcSetField((cAlias),"ZP_DTPREV","D",8, 0 )

dbSelectArea(cAlias)
dbGoTop()
While (cAlias)->(!Eof())
	If Date()> (cAlias)->ZP_DTPREV //Vencido, passou a previsao do termino
		
		EnvWFJob(2,(cAlias)->R_E_C_N_O_)
		
	Else//Nao venceu ainda
		If  Date()+5 == (cAlias)->ZP_DTPREV//Esta a 5 dias do vencimento
			
			EnvWFJob(3,(cAlias)->R_E_C_N_O_)
			
		EndIf
	EndIf
	(cAlias)->(dbSkip())
End
(cAlias)->(dbClosearea())

Return

/*--------------------------------------------------------------------
*
* Função: CPrjNAce()
* Descrição: Envia WF das SSIs Oficializados (Concluidas) e
*            sem o Aceite do Solicitante
*
--------------------------------------------------------------------*/
Static Function CPrjNAce()

Local nX:=0
Local cQuery:=''
Local cAlias:=''
Local cMailSPInt:=''
Local aItens:={}
Local aSuperIntend:={}
Local lNaoEnviou:=!GetMV('CI_MESJOB')==StrZero(Month(Date()),2)

cQuery:=" Select ZP_CONCLUS,ZP_EMAIL4, R_E_C_N_O_ From "+RetSqlName('SZP')
cQuery+=" Where ZP_FILIAL='"+xFilial('SZP')+"'"
cQuery+=" And ZP_CONCLUS<>' '"
cQuery+=" And ZP_ACEITE=' '"
cQuery+=" And ZP_EMISSAO>='20130101'"//FABIO
cQuery+=" And D_E_L_E_T_=' '"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

TcSetField((cAlias),"ZP_CONCLUS","D",8, 0 )

dbSelectArea(cAlias)
dbGoTop()
While (cAlias)->(!Eof())
	dDtRef03:=(cAlias)->ZP_CONCLUS
	dDtRef08:=(cAlias)->ZP_CONCLUS
	dDtRef15:=(cAlias)->ZP_CONCLUS
	nCont:=0
	While nCont<=3
		dDtRef03++//Soma Data
		If dDtRef03==DataValida(dDtRef03)//Acha 3 datas validas acima da data de referencia
			nCont++
		EndIF
	End
	nCont:=0
	While nCont<=8
		dDtRef08++
		If dDtRef08==DataValida(dDtRef08)
			nCont++
		EndIF
	End
	nCont:=0
	While nCont<=15
		dDtRef15++
		If dDtRef15==DataValida(dDtRef15)
			nCont++
		EndIF
	End
	
	If Date()>=dDtRef15
		If Day(Date())>15 .And. lNaoEnviou//Só envia a partir do dia 15 do mes e somente 1 vez por mes
			Env2WFJob((cAlias)->R_E_C_N_O_,15)
			
			//Casos que o superintendente precisa ser notificado: será enviado somente um email com a listagem das SSIs
			cMailSPInt:=UPPER(Alltrim((cAlias)->ZP_EMAIL4))
			Aadd(aSuperIntend,{cMailSPInt,(cAlias)->R_E_C_N_O_})
		EndIf
	ElseIf Date()>=dDtRef08//8 oprque é 5 dias a partir do ultimo envio (com 3 dias)
		Env2WFJob((cAlias)->R_E_C_N_O_,8)
	ElseIF Date()>=dDtRef03//3 dias em diante
		Env2WFJob((cAlias)->R_E_C_N_O_,3)
	EndIf
	
	(cAlias)->(dbSkip())
End
(cAlias)->(dbClosearea())

//Envia lista para o superintendente
aSort(aSuperIntend,,,{ |x,y| x[1]<y[1] })
If Len(aSuperIntend)>0
	cMailAnt:=aSuperIntend[1,1]
EndIF
For nX:=1 to Len(aSuperIntend)
	If cMailAnt<>aSuperIntend[nX,1]
		//Envia
		oProcess:= TWFProcess():New("000003", "Workflow Controle SSI")
		oProcess:NewTask( "Workflow Controle SSI", "\workflow\WFSSIOficList.htm")
		oProcess:NewVersion(.T.)
		oProcess:cSubject	:= OemToAnsi("SSIs concluídas sem Aceite!")
		oProcess:cTo  		:= cMailant+"; sistemas@cieesp.org.br; mauricio@cieesp.org.br"
		oProcess:cCc  		:= ''
		oProcess:bReturn	:= Nil
		oProcess:cBody  	:= ''
		oProcess:cBody		+= OemToAnsi("Esta é uma mensagem automática. Por favor, não responda!")
		oHtml  := oProcess:oHTML
		
		For nY:=1 to Len(aItens)
			dbSelectArea('SZP')
			dbGoTo(aItens[nY])
			
			AAdd( (oHtml:ValByName( "t.1" )), SZP->ZP_NRSSI)
			AAdd( (oHtml:ValByName( "t.2" )), Dtoc(SZP->ZP_CONCLUS))
			AAdd( (oHtml:ValByName( "t.3" )), ALLTRIM(SZP->ZP_DESCSIS))
			AAdd( (oHtml:ValByName( "t.4" )), SZP->ZP_SOLICIT)
			AAdd( (oHtml:ValByName( "t.5" )), SZP->ZP_SERVICO)
		Next nY
		
		oProcess:Start()
		oProcess:Free()
		
		aItens:={}
		cMailant:=aSuperIntend[nX,1]
	EndIf
	Aadd(aItens,aSuperIntend[nX,2])//Recno SZP
Next nX
If Len(aSuperIntend)>0
	//Envia o ultimo
	oProcess:= TWFProcess():New("000003", "Workflow Controle SSI")
	oProcess:NewTask( "Workflow Controle SSI", "\workflow\WFSSIOficList.htm")
	oProcess:NewVersion(.T.)
	oProcess:cSubject	:= OemToAnsi("SSIs concluídas sem Aceite!")
	oProcess:cTo  		:= cMailant+"; sistemas@cieesp.org.br; mauricio@cieesp.org.br"
	oProcess:cCc  		:= ''
	oProcess:bReturn	:= Nil
	oProcess:cBody  	:= ''
	oProcess:cBody		+= OemToAnsi("Esta é uma mensagem automática. Por favor, não responda!")
	oHtml  := oProcess:oHTML
	For nY:=1 to Len(aItens)
		dbSelectArea('SZP')
		dbGoTo(aItens[nY])
		
		AAdd( (oHtml:ValByName( "t.1" )), SZP->ZP_NRSSI)
		AAdd( (oHtml:ValByName( "t.2" )), Dtoc(SZP->ZP_CONCLUS))
		AAdd( (oHtml:ValByName( "t.3" )), ALLTRIM(SZP->ZP_DESCSIS))
		AAdd( (oHtml:ValByName( "t.4" )), SZP->ZP_SOLICIT)
		AAdd( (oHtml:ValByName( "t.5" )), SZP->ZP_SERVICO)
	Next nY
	
	oProcess:Start()
	oProcess:Free()
	
	//Atualiza o processamento do Job quinzenal - Somente roda uma vez por mes e após dia 15
	PutMV('CI_MESJOB',StrZero(Month(Date()),2))
EndIF

Return

/*----------------------------------------------------------------------
*
* EnvWFJob()
* Envia e-mail de controle dos status das SSIs
*
----------------------------------------------------------------------*/
Static Function EnvWFJob(_cId,_nRec,nQtdDias)
Local oProcess,oHtml
Local _cAssunto := ''
Local _cHtml	:=''
Local _cBody	:=''
Local _cCodProc:="000002"
Local _cTo		:=""
Local _cCC		:=""

dbSelectArea('SZP')
dbGoTo(_nRec)

If _cId==1//SSIs incluídas e não alocadas
	_cTo:="joaquim@cieesp.org.br"
	_cCC:="mauricio@cieesp.org.br"
	_cAssunto:= OemToAnsi("Pendente de alocação a SSI número "+SZP->ZP_NRSSI+" !")
	_cHtml	 := "\workflow\WFSSINAloc.htm"
	_cBody	 := OemToAnsi("Solicitação "+SZP->ZP_NRSSI+" não alocada.")+CRLF
ElseIf _cId==2//SSI Pendente e passou a previsao do termino
	_cTo:="joaquim@cieesp.org.br"
	_cCC:="sistemas@cieesp.org.br"
	_cAssunto:= OemToAnsi("Prazo vencido da SSI número "+SZP->ZP_NRSSI+" !")
	_cHtml	 := "\workflow\WFSSIVencPos.htm"
	_cBody	 := OemToAnsi("Solicitação "+SZP->ZP_NRSSI+" - Vencida.")+CRLF
ElseIf _cId==3//SSI Pendente e esta a 5 dias do vencimento
	_cTo:="joaquim@cieesp.org.br"
	_cCC:="sistemas@cieesp.org.br"
	_cAssunto:= OemToAnsi("Prazo a vencer da SSI número "+SZP->ZP_NRSSI+" !")
	_cHtml	 := "\workflow\WFSSIVencPre.htm"
	_cBody	 := OemToAnsi("Solicitação "+SZP->ZP_NRSSI+" - Alerta de vencimento.")+CRLF
EndIf

oProcess:= TWFProcess():New(_cCodProc, "Workflow Controle SSI")
oProcess:NewTask( "Workflow Controle SSI", _cHtml)
oProcess:NewVersion(.T.)
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cTo
oProcess:cCc  		:= _cCC
oProcess:bReturn	:= Nil
oProcess:cBody  	:= _cBody
oProcess:cBody		+= OemToAnsi("Esta é uma mensagem automática. Por favor, não responda!")
oHtml  := oProcess:oHTML
If _cId==1
	oHtml:ValByName("numssi", SZP->ZP_NRSSI	)
	oHtml:ValByName("cr"	, SZP->ZP_CR	)
	oHtml:ValByName("data"	, DtoC(SZP->ZP_EMISSAO)	)
ElseIf _cId==2 .Or. _cId==3
	oHtml:ValByName("numssi", SZP->ZP_NRSSI	)
	oHtml:ValByName("cr"	, SZP->ZP_CR	)
	oHtml:ValByName("analist", Alltrim(SZP->ZP_ANALIST)	)
	oHtml:ValByName("venc"	, DtoC(SZP->ZP_DTPREV))
EndIf

AAdd( (oHtml:ValByName( "t.1" )), ALLTRIM(SZP->ZP_DESCSIS))
_cTpIdent	:= "Em Branco"
Do Case
	Case SZP->ZP_TPIDENT == "1"
		_cTpIdent	:= "Alteracao"
	Case SZP->ZP_TPIDENT == "2"
		_cTpIdent	:= "Desenvolvimento"
	Case SZP->ZP_TPIDENT == "3"
		_cTpIdent	:= "Emergencial"
EndCase
AAdd( (oHtml:ValByName( "t.2" )), ALLTRIM(_cTpIdent))
AAdd( (oHtml:ValByName( "t.3" )), ALLTRIM(SZP->ZP_SERVICO))


oProcess:Start()
oProcess:Free()

Return


/*----------------------------------------------------------------------
*
* Env2WFJob()
* Envia e-mail de controle dos status das SSIs CONCLUIDAS sem ACEITE
*
----------------------------------------------------------------------*/
Static Function Env2WFJob(_nRec,nQtdDias)

Local oProcess,oHtml
Local _cAssunto := ''
Local _cBody	:=''
Local _cCodProc	:="000003"
Local _cTo		:=""
Local _cCC		:=""
Local nContFor	:=2

dbSelectArea('SZP')
dbGoTo(_nRec)

_cCC:=""
nContFor:=2
If nQtdDias==8
	nContFor:=3
EndIF
_cAssunto:= OemToAnsi("Falta homologação da SSI número "+SZP->ZP_NRSSI+" !")
_cBody	 := OemToAnsi("Solicitação "+SZP->ZP_NRSSI+" - Aceite pendente.")+CRLF

For nW:=1 to nContFor
	
	If nW==1
		_cCpo:='ZP_EMAIL1'
		_cTo:=Alltrim(SZP->ZP_EMAIL1)
	ElseIf nW==2
		_cCpo:='ZP_EMAIL2'
		_cTo:=Alltrim(SZP->ZP_EMAIL2)
	Else
		_cCpo:='ZP_EMAIL3'
		_cTo:=Alltrim(SZP->ZP_EMAIL3)
	EndIF
	
	oProcess:= TWFProcess():New(_cCodProc, "Workflow Controle SSI")
	oProcess:NewTask( "Workflow Controle SSI", "\workflow\WFSSIOfic.htm")
	oProcess:NewVersion(.T.)
	oProcess:cSubject	:= _cAssunto
	oProcess:cTo  		:= "000016"
	oProcess:cCc  		:= _cCC
	oProcess:bReturn	:= "u_CPRJW01b(1,'"+_cAssunto+"','"+SZP->ZP_NRSSI+"','"+_cCpo+"')"
	oProcess:UserSiga	:= "000016"
	oProcess:cBody  	:= _cBody
	oProcess:cBody		+= OemToAnsi("Esta é uma mensagem automática. Por favor, não responda!")
	
	oHtml  := oProcess:oHTML
	oHtml:ValByName("numssi" , SZP->ZP_NRSSI	)
	oHtml:ValByName("cr"	 , SZP->ZP_CR	)
	oHtml:ValByName("dtconcl", Dtoc(SZP->ZP_CONCLUS))
	oHtml:ValByName("solic"	 , SZP->ZP_SOLICIT)
	
	AAdd( (oHtml:ValByName( "t.1" )), ALLTRIM(SZP->ZP_DESCSIS))
	_cTpIdent	:= "Em Branco"
	Do Case
		Case SZP->ZP_TPIDENT == "1"
			_cTpIdent	:= "Alteracao"
		Case SZP->ZP_TPIDENT == "2"
			_cTpIdent	:= "Desenvolvimento"
		Case SZP->ZP_TPIDENT == "3"
			_cTpIdent	:= "Emergencial"
	EndCase
	AAdd( (oHtml:ValByName( "t.2" )), ALLTRIM(_cTpIdent))
	AAdd( (oHtml:ValByName( "t.3" )), ALLTRIM(SZP->ZP_SERVICO))
	
	cProcess   := oProcess:Start()
	cHtmlFile  := cProcess + ".htm"
	cHtmlTexto := wfloadfile("\workflow\messenger\emp"+cEmpAnt+"\"+"000016"+"\"+cHtmlFile)
	cHtmlTexto := Strtran(cHtmlTexto,"WFHTTPRET.APW","WFHTTPRET.APL")
	wfsavefile("\workflow\messenger\emp"+cEmpAnt+"\"+"000016"+"\"+cHtmlFile+"l",cHtmlTexto)
	
	aMsg := {}
	aaDD(aMsg, "Segue Conclusão da SSI "+SZP->ZP_NRSSI+" para aprovação.")
	AADD(aMsg, " ")
	aAdd(aMsg, '<p><a href="'+'http://187.94.62.86:8282/workflow/messenger/emp' +cEmpAnt  + '/' + "000016" + '/' + alltrim(cProcess) + '.html">clique aqui</a> para Aprovação/Rejeição.</p>')
	AADD(aMsg, " ")
	AADD(aMsg, " ")
	
	U_fEnviaLink(_cTo, oProcess:cSubject , aMsg , 3, {})
Next nW

//Envia somente o informativo , nao o form de aceite.
oProcess:= TWFProcess():New(_cCodProc, "Workflow Controle SSI")
oProcess:NewTask( "Workflow Controle SSI", "\workflow\WFSSIOficForm.htm")
oProcess:NewVersion(.T.)
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= "sistemas@cieesp.org.br; mauricio@cieesp.org.br"
oProcess:cCc  		:= ""
oProcess:bReturn	:= Nil
oProcess:cBody  	:= _cBody
oProcess:cBody		+= OemToAnsi("Esta é uma mensagem automática. Por favor, não responda!")

oHtml  := oProcess:oHTML
oHtml:ValByName("numssi" , SZP->ZP_NRSSI	)
oHtml:ValByName("cr"	 , SZP->ZP_CR	)
oHtml:ValByName("dtconcl", Dtoc(SZP->ZP_CONCLUS))
oHtml:ValByName("solic"	 , SZP->ZP_SOLICIT)

AAdd( (oHtml:ValByName( "t.1" )), ALLTRIM(SZP->ZP_DESCSIS))
_cTpIdent	:= "Em Branco"
Do Case
	Case SZP->ZP_TPIDENT == "1"
		_cTpIdent	:= "Alteracao"
	Case SZP->ZP_TPIDENT == "2"
		_cTpIdent	:= "Desenvolvimento"
	Case SZP->ZP_TPIDENT == "3"
		_cTpIdent	:= "Emergencial"
EndCase
AAdd( (oHtml:ValByName( "t.2" )), ALLTRIM(_cTpIdent))
AAdd( (oHtml:ValByName( "t.3" )), ALLTRIM(SZP->ZP_SERVICO))

oProcess:Start()

Return