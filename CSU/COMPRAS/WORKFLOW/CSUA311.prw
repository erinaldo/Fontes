#include "Protheus.ch"
#Include "TopConn.ch"  
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ CSUA311  ³ Autor ³ Microsiga               ³ Data ³ 02/10/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de email de aviso de atraso na classificacao de NF.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ nenhum                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nenhum                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ Compras/recebimento - CSU                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CSU                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.  ³  Data  ³ Bops ³ Manutencao Efetuada                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                ³  /  /  ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSUA311(aList)         

Local aArea		:= GetArea()									
Local cTime1	:= ''
Local dData1	:= Ctod('  /  /  ')
Local cTime2	:= Time()
Local dData2	:= dDataBase
Local cTmp      := GetNextAlias()
Local nHrDeco   := 0
Local cQuery	:= ''
Local nQtdReg	:= 0 
Local nHrPrazo	:= SuperGetMV('FS_HRPRAZO',,1)
Local lEnviou   := .F.

//-----------------------------------
//monta query principal
//-----------------------------------
cQuery	:= ''
cQuery += "SELECT PB1_PEDIDO,PB1_NOTA,PB1_SERIE,PB1_FORNEC,PB1_LOJA,PB1_DTDEVO,PB1_ENVEMA,PB1_DTRECE,PB1_HRRECE,C7_NUMSC,C1_SOLICIT,PB1.R_E_C_N_O_ PB1RECNO "
cQuery += "FROM " + RetSQLName( 'PB1' ) + " PB1 "
	cQuery += "INNER JOIN " + RetSQLName( 'SC7' ) + " SC7 ON "
	cQuery += "C7_FILIAL = '" + xFilial( 'SC7' ) + "' "
	cQuery += "AND C7_NUM = PB1_PEDIDO "
	cQuery += "AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += "INNER JOIN " + RetSQLName( 'SC1' ) + " SC1 ON "
	cQuery += "C1_FILIAL = '" + xFilial( 'SC1' ) + "' "
	cQuery += "AND C1_NUM = C7_NUMSC "
	cQuery += "AND SC1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE PB1.D_E_L_E_T_ = ' ' "
	cQuery += "AND PB1_FILIAL = '" + xFilial( 'PB1' ) + "' "
	cQuery += "AND PB1_DTDEVO = ' ' "
	cQuery += "AND PB1_ENVEMA = ' ' "
cQuery += "ORDER BY PB1_PEDIDO,PB1_NOTA,PB1_SERIE,PB1_FORNEC,PB1_LOJA " 

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .T., .T. )

// Verifica se existe registro para devolucao
nQtdReg := 0
(cTmp)->( dbGoTop() )
(cTmp)->( dbEval( { || nQtdReg++ },, { || !EOF() } ) )
(cTmp)->( dbGoTop() )
	
If nQtdReg = 0
	ConOut("CSUA311 - Nao ha E-MAIL de aviso para enviar na EMPRESA :" +cEmpAnt+ " - FILIAL: "+cFilAnt)
	RestArea(aArea)
	Return Nil
EndIf

While !(cTmp)->( EOF() )
	
	cTime1	:= (cTmp)->PB1_HRRECE + ':00' //hora de recebimento - hora1
	dData1	:= StoD( (cTmp)->PB1_DTRECE ) //data de recebimento - data1
	
	//---------------------------------------
	//calcula o tempo em horas decorrido da
	//data1, hora1 ate data2, hora2
	//---------------------------------------
	nHrDeco := fCalHoras(	dData1 , SecsToHrs( TimeToSecs( cTime1 ) ), dData2 , SecsToHrs( TimeToSecs( cTime2 ) )   )
	
	//---------------------------------------
	//Se tempo decorrido para classificacao
	//ultrapassar o prazo limite, envia e-mail
	//---------------------------------------
	If nHrDeco >= nHrPrazo
		lEnviou := EnvAviso(  (cTmp)->PB1_PEDIDO,(cTmp)->PB1_NOTA,(cTmp)->PB1_SERIE,(cTmp)->PB1_FORNEC,(cTmp)->PB1_LOJA,(cTmp)->C1_SOLICIT,nHrPrazo,aList  )
		If lEnviou 
			//----------------------------------------
			//grava fleg para controle de envio 
			//do aviso. nao repete o envio
			//----------------------------------------
			Begin Transaction
				PB1->( DbGoTo( (cTmp)->PB1RECNO ) )
				RecLock( 'PB1' , .F. )
					PB1->PB1_ENVEMA := 'S'
				MsUnLock()
			End Transaction
		EndIf
	EndIf

	(cTmp)->( dbSkip() )
EndDo

RestArea( aArea )
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ EnvAviso º Autor ³ Microsiga          º Data ³  03/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia email de aviso de atraso de classificacao da NF.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvAviso(cPed,cNf,cSerie,cFor,cLj,cNomUsr,nPrz,aList)

Local lRet      := .T.
Local lOk       := .F.  
Local cMsg      := ''                                         // Mensagem do e-mail
Local cEmDest   := UsrInf( cNomUsr,aList )                   // e-mail do destinatario             
Local cServer   := Trim( SuperGetMV( 'MV_RElSERV',, '' ) )  // Nome do servidor de e-mail           
Local cConta    := Trim( SuperGetMV( 'MV_RELACNT',, '' ) )  // Nome da conta a ser usada no e-mail  
Local cPaswd    := Trim( SuperGetMV( 'MV_RELPSW' ,, '' ) )  // Senha                                
Local cEmRem    := Trim( SuperGetMV( 'MV_RELFROM',, '' ) )  // E-mail do remetente                  
Local lAuth     :=       SuperGetMV( 'MV_RELAUTH',, .F.  )  // Tem Autenticacao ?
Local cAssun    := 'Prazo de classificação expirado pedido/NF: ' + cPed + '/' + cNf

//cEmDest   := 'darlan.maciel@totvs.com.br' 

//----------------------------
//Monta html do email de aviso
//----------------------------
MontaHtml(cPed,cNf,cSerie,cFor,cLj,nPrz,@cMsg)

//----------------------------
//Envia email de aviso
//----------------------------
If !Empty(cServer) .And. !Empty(cConta) .And. !Empty(cPaswd) .And. !Empty(cEmDest) .And. !Empty(cMsg)
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPaswd RESULT lOk
	If lOk
		If lAuth 
			MailAuth( cConta, cPaswd ) //realiza a autenticacao no servidor de e-mail.
		EndIf
		SEND MAIL FROM cEmRem to cEmDest SUBJECT cAssun BODY cMsg RESULT lSendOk FORMAT TEXT
		//SEND MAIL FROM cEmRem TO cEmDest SUBJECT cAssun BODY cMsg ATTACHMENT cAnexo RESULT lSendOk FORMAT TEXT   // exemplo de envio de anexo
		
		If !lSendOk
			GET MAIL ERROR cError
			lRet := .F.     
			ConOut("EnvAviso - Erro ao enviar e-mail de aviso para pedido/NF: " + cPed + "/" + cNf )
			//Aviso("Erro no envio do e-Mail",cError,{"Fechar"},2)
		EndIf
	Else
		GET MAIL ERROR cError
		lRet := .F. 
		ConOut("EnvAviso - Erro ao conectar o servidor: " + cServer + " conta: " + cConta )
		//Aviso("Erro no envio do e-Mail",cError,{"Fechar"},2)
	EndIf
	If lOk
		DISCONNECT SMTP SERVER
	EndIf

EndIf

Return lRet      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ UsrInf   º Autor ³ Microsiga          º Data ³  03/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Busca email do usuario a partir do nome do login           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UsrInf( cNomUsr,aList )

Local cEmail := ''
Local nI       := 0
Local nPos     := 0

ConOut("Pesquisando e-mail do usuario: " + cNomUsr )

nPos := aScan(aList,{|x|AllTrim(Upper(x[1])) == alltrim(Upper(cNomUsr))})

If nPos <= 0
	ConOut("E-mail nao encontrado para o usuario: " + cNomUsr )
	Return cEmail
Endif

ConOut("E-mail do usuario encontrado.")

cEmail := AllTrim( aList[nPos][2] )

Return cEmail

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ MontaHtmlº Autor ³ Microsiga          º Data ³  03/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta email em html para enviar no aviso.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaHtml(cPed,cNf,cSerie,cFor,cLj,nPrz,cMsg)

cMsg := ''
cMsg += '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
cMsg += '<html>'
cMsg += '<head>'
cMsg += '  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">'
cMsg += '  <title>Prazo para classificacao de nf expirado</title>'
cMsg += '</head>'
cMsg += '<body>'
cMsg += '<table style="width: 100%; text-align: left; margin-left: auto; margin-right: auto;" border="0" cellpadding="0" cellspacing="2">'
cMsg += '  <tbody>'
cMsg += '    <tr>'
cMsg += '      <td style="text-align: center;"><big><span style="font-weight: bold; font-family: Arial;">Prazo para classifica&ccedil;&atilde;o de nota fiscal expirado.</span></big></td>'
cMsg += '    </tr>'
cMsg += '  </tbody>'
cMsg += '</table>'
cMsg += '<br>'
cMsg += '<table style="text-align: left; width: 100%; font-family: Arial;" border="0" cellpadding="0" cellspacing="2">'
cMsg += '  <tbody>'
cMsg += '    <tr>'
cMsg += '      <td style="text-align: justify;">Informamos que o '
cMsg += 'per&iacute;odo de <span style="font-weight: bold;">"' + AllTrim(Str(nPrz)) + '"</span>'
cMsg += ' hora(s) para inclus&atilde;o da NF <span'
cMsg += ' style="font-weight: bold;">"' + cNf + '"</span>'
cMsg += ' referente ao pedido de compra <span style="font-weight: bold;">"' + cPed + '"</span>,'
cMsg += ' fornecedor <span style="font-weight: bold;">"' + AllTrim(   GetAdvFVal( 'SA2' , 'A2_NOME' , xFilial( 'SA2' ) + cFor + cLj , 1 , ' ' )   ) + '"</span>'
cMsg += ' est&aacute;'
cMsg += ' expirado.<br>'
cMsg += '      <br>'
cMsg += 'Solicitamos assim, que voc&ecirc; colaborador, analise e '
cMsg += 'valide este documento impreterivelmente at&eacute; &agrave;s <span'
cMsg += ' style="font-weight: bold;">15h00min de hoje '
cMsg += '"' + DtoC( dDataBase ) + '"</span>, devolvendo este em seguida aos cuidados da '
cMsg += '&Aacute;rea de '
cMsg += 'Recebimento de Documentos e Materiais.<br>'
cMsg += '      <br>'
cMsg += 'A nota fiscal dever&aacute; ser '
cMsg += 'enviada em tempo h&aacute;bil atrav&eacute;s da &Aacute;rea '
cMsg += 'de Recebimento aos cuidados do '
cMsg += 'Contas a Pagar, &nbsp;de forma a n&atilde;o comprometer a CSU '
cMsg += 'pela falta de '
cMsg += 'pagamento no vencimento.<br>'
cMsg += '      <br>'
cMsg += 'Observa&ccedil;&atilde;o:<br>'
cMsg += 'Eventuais problemas ou danos que sejam decorrentes da '
cMsg += 'inobserv&acirc;ncia deste procedimento poder&atilde;o ser '
cMsg += 'imputados a quem der causa.<br>'
cMsg += '      <br>'
cMsg += 'Atenciosamente.<br>'
cMsg += 'Recebimento de Documentos e Materiais<br>'
cMsg += '      <br>'
cMsg += '      <br>'
cMsg += '      <small style="font-weight: bold;">"Aten&ccedil;&atilde;o - Processo automatizado queira, por favor, n&atilde;o responder esta mensagem."</small></td>'
cMsg += '    </tr>'
cMsg += '  </tbody>'
cMsg += '</table>'
cMsg += '<br>'
cMsg += '</body>'
cMsg += '</html>'

Return cMsg