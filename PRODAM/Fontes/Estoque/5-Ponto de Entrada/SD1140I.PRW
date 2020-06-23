#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
                                    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD1140I  ºAutor  ³Felipe Santos        º Data ³  11/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Function Ma140Grava() - Responsável por atualizar            ±±
±±º          ³um pre-documento de entrada e seus anexos.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 							                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SD1140I

Local aItens := {}
Local cSolicit := ""

//Grava o usuário que está incluindo a pré-nota no campo
RecLock("SF1",.F.)
SF1->F1_XNOMUSR := USRRETNAME(RETCODUSR())
SF1->(MsUnLock())

//Monta Array com dados dos itens 	
FOR nX:=1 to Len(aCols)
	AADD(aItens, {aCols[nX][1], aCols[nX][2], Posicione("SB1", 1, xFilial("SB1") + aCols[nX][2], "B1_DESC")})
Next nX

//Verifica se Pré-NF de entrada possui solicitação de compras atrelado - Email
//D1_PEDIDO + D1_ITEMPC = C7_NUM + C7_ITEM
//C7_NUMSC + C7_ITEMSC = C1_NUM + C1_ITEM
cSolicit := FindMailAmostra(SD1->D1_DOC, SD1->D1_SERIE)

If !Empty(cSolicit)
  TelaAmostra(SD1->D1_DOC, SD1->D1_SERIE, aItens, cSolicit)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TelaAmostra ºAutor  ³Felipe Santos     º Data ³  11/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 							                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TelaAmostra(cDoc, cSerie, aItens, cSolicit)

Local oDlg
Local nPrazoRetorno := "2 "
Local cAnalise
Local oGet1 

DEFINE MSDIALOG oDlg FROM  64,33 TO 235,435 TITLE "WorkFlow - Análise de Amostra" PIXEL
@ 00,000 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 35,oDlg:nBottom / 2.4 NOBORDER WHEN .F. PIXEL

@ 06,050 SAY "Análise de Amostra para a Pré-Nota/ Série :"+ cDoc +" / " + cSerie  SIZE 255, 7 OF oDlg PIXEL

@ 20,040 SAY "Análise de Amostra ?" SIZE 245, 7 OF oDlg PIXEL
@ 22,120 MSCOMBOBOX oGet1 VAR cAnalise ITEMS{"1-Sim","2-Não"}  SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 35,040 SAY "Prazo para Retorno" SIZE 245, 7 OF oDlg PIXEL
@ 37,120 MSGET nPrazoRetorno OF oDlg PIXEL 

DEFINE SBUTTON FROM 67, 140 TYPE 1 ENABLE OF oDlg ACTION EnviaWF(cAnalise, nPrazoRetorno, cDoc, cSerie, oDlg, aItens, cSolicit)
DEFINE SBUTTON FROM 67, 170 TYPE 2 ENABLE OF oDlg ACTION ( nOpca:=0,oDlg:End() )
ACTIVATE MSDIALOG oDlg CENTERED

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaWF     ºAutor  ³Felipe Santos     º Data ³  11/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 							                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnviaWF(cAnalise, nPrazoRetorno, cDoc, cSerie,  oDlg, aItens, cSolicit)

//ENVIA WORKFLOW PARA ANÁLISE DE AMOSTRA
U_WfPreNF001(SUBSTR(cAnalise,1,1), cDoc, cSerie, DDataBase, DAYSUM(DDataBase,VAL(nPrazoRetorno)), aItens, cSolicit)
oDlg:End()
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WfPreNF001  ºAutor  ³Felipe Santos     º Data ³  06/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para enviar a cotacao via HTTPRET                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow enviado na criação da Pré-NF de entrada           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WfPreNF001(cAnalise, cDoc, cSerie, cEmissao, dDiasAnalise, aItens, cEmailTo)
Local oProcess
Local cCodProcesso
Local cHtmlModelo
Local cMailID
Local cTexto
Local cAssunto    
Local cUsuarioProtheus 
Local aAreaSB1
Local cUrlWF := ""
Local cDirHTTP	:= Alltrim(GetMv('MV_WFDHTTP',.F.,'\workflow\'))
Local nX
Local aAprovado := {}
//Local cEmailTo  := FindMailAmostra(cDoc, aItens)

If cAnalise = "1"
    
    //ALTERA CAMPO COM A DATA LIMITE DIGITADA PELO USUÁRIO
    //DbSelectArea("SF1")
	SF1->( dbSetOrder(1) ) 

	If SF1->( dbSeek( xFilial("SF1") + cDoc ) )
		RECLOCK("SF1",.F.)
		SF1->F1_XANAPRZ := dDiasAnalise
		MSUNLOCK()
	EndIf	
    
	AADD( aAprovado, "1 - Sim ")
	AADD( aAprovado, "2 - Não ")
	
	cDirHTTP := Iif( Right( cDirHTTP, 1) != "\",cDirHTTP + "\",cDirHTTP )  
	
	cDirHTTP := cDirHTTP + "messenger\emp"+Alltrim(cEmpAnt)+"\WfProdam\"   
	
	MakeDir(cDirHTTP)
	
	//obtem o url que vai no link via e-mail
	cUrlWF := SuperGetMV("ES_WFURL",,"http://localhost:8081/") // [10.42.92.53:8089/wf0100]
	
	If Right( cUrlWF, 1) != "/"
		cUrlWF += "/"
	EndIF 
	
	//codigo extraido do cadastro de processos wf (configurador)
	cCodProcesso := "WFPRODAM"
	
	//template a partir do rootPath que contem o conteudo do workflow
	cHtmlModelo := "\workflow\modelos\WfPreNF_AnaliseAmostra.htm"
	
	//assunto da mensagem                                                            
	cAssunto := "[Workflow PRODAM] - Análise de Amostra"
	
	//usuario do protheus
	cUsuarioProtheus := SubStr(cUsuario, 07, 15)
	
	//inicia a classe TWFProcess e assinala a variável objeto oProcess
	oProcess := TWFProcess():New(cCodProcesso, cAssunto)

	//cria uma tarefa.
	oProcess:NewTask(cAssunto, cHtmlModelo)
	
	oHtml := oProcess:oHTML

	
	//assinalar valores às macros existentes no html	
	oProcess:oHtml:ValByName("cDoc", cDoc)
	oProcess:oHtml:ValByName("cSerie", cSerie)
	oProcess:oHtml:ValByName("cEmissao", cEmissao)
	oProcess:oHtml:ValByName("dDiasAnalise", dDiasAnalise)
	oProcess:oHtml:ValByName("condPagto", aAprovado )

	For nX := 1 to Len ( aItens )
		AADD( oProcess:oHtml:ValByName("a.it_produto") 	, aItens[nX][01] ) 
		AADD( oProcess:oHtml:ValByName("a.cod_produto")	, aItens[nX][02] )
		AADD( oProcess:oHtml:ValByName("a.ds_produto")	, aItens[nX][03] )
	Next nX	
	
	//assunto do processo/e-mail
	oProcess:cSubject := cAssunto
	
	//informa a pasta que vai criar o htm para cada destinatario
	oProcess:cTo := "WFPRODAM"
	
	//funcao de retorno do wf
	oProcess:bReturn := "U_WfPreNFRet001"
	
	//inicia o processo
	cMailID := oProcess:Start(cDirHTTP) 
	oProcess:Free()
	
	//comeca agora a montar a mensagem que vai no e-mail dos destinatarios
	cHtmlModelo := "\workflow\modelos\WfLinkAnaliseAmostra.htm"
	
	oProcess:NewTask(cAssunto, cHtmlModelo)  

	oProcess:cSubject := cAssunto
	
	//agora sim informa o endereço eletrônico do destinatário
	oProcess:cTo := cEmailTo
	
	//assinalar valores das macros do html
	oProcess:ohtml:ValByName("cDoc", cDoc)	
	oProcess:ohtml:ValByName("cSerie", cSerie)	
	oProcess:ohtml:ValByName("proc_link", cUrlWF+"messenger/emp"+Alltrim(cEmpAnt)+"/WfProdam/" + cMailID + ".htm")	
	oProcess:Start()
	
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WfPreNFRet001 ºAutor  ³Jose Carlos    º Data ³  06/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamento do retorno da cotacao                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow Cotacao                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WfPreNFRet001(oProcess) 
Local cDoc, cMotivoRej, CondPagto
Local condPag	:= ""
Local aAreaSF1 	:= SF1->( GetArea() )
Local cLog		:= "" 
Local nPreco	:= 0
Local nTotal	:= 0
Local nPrazo	:= 0
Local cCodProd	:= ""
Local cMailRet  := U_UsrRetMail(GETMV("ES_EMLRAMO"))//GRUPO DE USUARIOS QUE RECEBERÁ O RETORNO/RESPOSTA DO WF  

	DbSelectArea("SF1")
	SF1->( dbSetOrder(1) )
	
	//conOut("Passo dbselectarea SF1")
	
	cDoc 	:= oProcess:oHtml:RetByName("cDoc")
	cDoc 	:= PadR(cDoc, TamSX3("F1_DOC")[1])
	
	cSerie 	:= oProcess:oHtml:RetByName("cSerie")
	cSerie 	:= PadR(cDoc, TamSX3("F1_SERIE")[1])	
	
	cMotivoRej  := oProcess:oHtml:RetByName("motivo")
	cMotivoRej	:= PadR(cMotivoRej, TamSX3("F1_XMOTREJ")[1]) 
	
	cEmissao  := oProcess:oHtml:RetByName("cEmissao")
	
	cEmissao  := oProcess:oHtml:RetByName("cEmissao")
	
	cPrazo := oProcess:oHtml:RetByName("dDiasAnalise")
	
	//1-Aprovado 2-Rejeitado
	cAprovRej 	:= oProcess:oHtml:RetByName("CondPagto") 
	cAprovRej   := SUBSTR(cAprovRej,1,1)                                            
	
	If SF1->( dbSeek( xFilial("SF1") + cDoc ) )
		RECLOCK("SF1",.F.)
		SF1->F1_XMOTREJ := cMotivoRej
		SF1->F1_XANARES := cAprovRej
		MSUNLOCK()
	Else
		conOut("ATENCAO: NAO CONSEGUIU POSICIONAR SF1, NAO RODOU EXECAUTO, WF CANCELADO")
	EndIf
	
	//Envia resposta do WF para o grupo de usuários do parametro ES_EMLRAMO
	U_EMAAPR("01", SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, cEmissao, cPrazo, cAprovRej, cMotivoRej, cMailRet)
	
	oProcess:Finish()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UsrRetMail    ºAutor  ³Jose Carlos    º Data ³  06/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamento do retorno do email do user protheus            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UsrRetMail(cUserID) 

	Local aUsrMail
	Local cUsrMail	:= ""

	Local nBL
	Local nEL

	//DEFAULT cUserID	:= RetCodUsr()

	PswOrder(2)
	IF (;
			!Empty( cUserID );
			.and.;
			PswSeek(cUserID,.T.);
		)
		cUsrMail 	:= PswRet(1)[1][14]
		cUsrMail	:= STRTRAN( cUsrMail , ";","," )
	EndIF

Return( cUsrMail )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FindMailAmostra ºAutor  ³Felipe Sant  º Data ³  18/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamento do retorno do email do solicitante da           º±±
±±º          ³ solicitação de compras                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FindMailAmostra(cDoc, cSerie)
Local cRetEmails := ""//"felipe.csantos@totvs.com.br;neofelipe@gmail.com"
Local _cQry 	 := ""					//Monta a QUERY
Local _aArea	 := GetArea()			//Salva a Area atual
Local _cAlias	 := GetNextAlias()		//Busca o proximo Alias disponivel
Local _aCat		 := {}					//Array contendo os recnos das tabelas DC3, DC2 e DC8

DbSelectArea("SD1")
DbSetOrder(1)

_cQry := " SELECT SC1.C1_SOLICIT FROM " + RetSqlName("SD1") + " SD1"
_cQry += " INNER JOIN "+ RetSqlName("SC7") + " SC7 ON SD1.D1_PEDIDO=SC7.C7_NUM AND SD1.D1_ITEMPC = SC7.C7_ITEM "
_cQry += " INNER JOIN "+ RetSqlName("SC1") + " SC1 ON SC1.C1_NUM=SC7.C7_NUMSC AND SC1.C1_ITEM = SC7.C7_ITEMSC "
_cQry += " WHERE SD1.D1_FILIAL     = '" + xFilial("SD1") + "'"
_cQry += " AND SC7.C7_FILIAL       = '" + xFilial("SC7") + "'"
_cQry += " AND SC1.C1_FILIAL       = '" + xFilial("SC1") + "'"
_cQry += " AND SD1.D1_DOC          = '" + cDoc + "'"
_cQry += " AND SD1.D1_SERIE        = '" + cSerie + "'"
_cQry += " AND SD1.D_E_L_E_T_ = ' '"
_cQry += " AND SC7.D_E_L_E_T_ = ' '"
_cQry += " AND SC1.D_E_L_E_T_ = ' '"
_cQry += " AND SC1.C1_XANAMOS = '1' " //VERIFICA SE O SOLICITANTE SOLICITOU ANALISE DE AMOSTRA.  
_cQry += " GROUP BY SC1.C1_SOLICIT "


TcQuery _cQry New Alias (_cAlias)    

While !(_cAlias)->( Eof() )
	If !Empty(AllTrim((_cAlias)->C1_SOLICIT)) 		
		cRetEmails += U_UsrRetMail(AllTrim((_cAlias)->C1_SOLICIT)) + ","
	EndIf

	(_cAlias)->( dbSkip() )
EndDo


(_cAlias)->( dbCloseArea() )

RestArea(_aArea)

If !Empty(cRetEmails)
	cRetEmails := SUBSTR(cRetEmails,1,LEN(cRetEmails)-1)
EndIf

Return cRetEmails