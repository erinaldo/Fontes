#include "Protheus.ch"
#Include "Topconn.ch"
#include "rwmake.ch"
#Include "tbiconn.ch"
#Include "AP5MAIL.CH" 
#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"
#Include "PARMTYPE.ch"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO8     ºAutor  ³ Carlos A. Queiroz  º Data ³  25/04/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTALCFIM()
Local uRet := .T.
//C1_APROV c7_conapro
uRet := U_GJPAlcFim()

Return uRet     





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTALCFIM  ºAutor  ³Microsiga           º Data ³  04/29/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION GJPAlcFim()
If !IsInCallStacks("a110altera") .and. !IsInCallStacks("MATA120")
//if MsgYesNo("Deseja enviar email?!")
	SCR->(dbskip(-1))
	If Select("SC1") > 0 
		If alltrim(SCR->CR_NUM) == alltrim(SC1->C1_NUM) .and. SCR->CR_TIPO == "SC"
			If SC1->C1_APROV == "L" //.and. !IsInCallStacks("a110altera")
				GJPMail (UsrRetMail(SC1->C1_USER), Alltrim(SM0->M0_NOME) + " - Solicitação de Compras "+alltrim(SC1->C1_NUM)+" da Filial "+alltrim(SC1->C1_FILIAL)+"- LIBERADA","",  , 0, "")
			EndIf
		EndIf
	EndIf
	
	If Select("SC7") > 0
		If alltrim(SCR->CR_NUM) == alltrim(SC7->C7_NUM) .and. SCR->CR_TIPO == "PC"
		    If SC7->C7_CONAPRO == "L" 
				GJPMail (UsrRetMail(SC7->C7_USER), Alltrim(SM0->M0_NOME) + " - Pedido de Compras "+alltrim(SC7->C7_NUM)+" da Filial "+alltrim(SC7->C7_FILIAL)+"- LIBERADO","",  , 0, "")
			EndIf
		EndIf
	EndIf
//endif
EndIf
RETURN NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTALCFIM  ºAutor  ³Microsiga           º Data ³  04/29/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GJPMail(cEmailTo , cAssunto, cfile, dVencto, nValor, cCliente)//(cEmailTo , cAssunto,cfile)

Local lOk		:= .F.		// Variavel que verifica se foi conectado OK
Local lSendOk	:= .F.		// Variavel que verifica se foi enviado OK
Local cError	:= ""
Local cEmailBcc	:= ""
Local lMailAuth	:= .T. //SuperGetMv("MV_RELAUTH",,.T.)
Local cMailAuth := ""
Local lResult	:= .F.                                                       
local cMensagem	:= Nil
local cCC			:= ""
local lDNSAuth	:= .F.

Private cMailConta	:= Nil
Private cMailServer	:= Nil
Private cMailSenha	:= Nil

If SCR->CR_TIPO == "SC"
cMensagem   := "Prezado solicitante, " + CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= "A Solicitação de Compras "+alltrim(SC1->C1_NUM)+" da Filial "+alltrim(SM0->M0_NOME)+" foi liberada pelo aprovador.
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= "Acesse a interface de Solicitação de Compras para dar prosseguimento. " + CRLF
cMensagem	+= ""+ CRLF
ElseIf SCR->CR_TIPO == "PC"
cMensagem   := "Prezado comprador, " + CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= "O Pedido de Compras "+alltrim(SC7->C7_NUM)+" do Fornecedor "+alltrim(POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA ,"A2_NOME"))+ " da Filial "+alltrim(SM0->M0_NOME)+" foi liberado pelo aprovador."
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= "Acesse a interface de Pedido de Compras para dar prosseguimento. " + CRLF
cMensagem	+= ""+ CRLF
EndIf
//cMensagem   += " https://nfe.prefeitura.sp.gov.br/contribuinte/notaprint.aspx?ccm=36011100&nf"+ CRLF
//cMensagem	+= ""+ CRLF
//cMensagem	+= ""+ CRLF
//cMensagem	+= "“Após o vencimento, acesse para atualizar seu boleto”"+ CRLF
//cMensagem	+= ""+ CRLF
//cMensagem	+= ""+ CRLF


cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF

cMensagem	+= " Atenciosamente, " + CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
//cMensagem	+= " Departamento Financeiro " + CRLF
cMensagem	+= substr(SM0->M0_NOMECOM,1,50)+ CRLF
  

cMailConta	:= If( cMailConta	== NIL, GetMV( "MV_RELACNT" ), cMailConta  )
//cMailConta	:= If( cMailConta	== NIL, GetMV( "MV_EMCONTA" ), cMailConta  )
cMailServer	:= If( cMailServer	== NIL, GetMV( "MV_RELSERV" ), cMailServer )
cMailSenha	:= If( cMailSenha	== NIL, GetMV( "MV_RELPSW" ), cMailSenha  )
//cMailSenha	:= If( cMailSenha	== NIL, GetMV( "MV_EMSENHA" ), cMailSenha  )


//Verifica se existe o SMTP Server
If 	Empty(cMailServer)
	Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf

//Verifica se existe a CONTA
If 	Empty(cMailConta)
	Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf

//Verifica se existe a Senha
If 	Empty(cMailSenha)
	Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf


cEmailBcc:= "" //"carlos.queiroz@totvspartners.com.br"


// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a autenticacao no servidor SMTP                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMailAuth
/*		If ( "@" $ cMailConta ) .AND. !lDNSAuth
			cMailAuth := Subs(cMailConta,1,At("@",cMailConta)-1)
		Else
			cMailAuth := cMailConta
		EndIf
		
		lResult := MailAuth(cMailAuth,cMailSenha)
	Else
*/		lResult := .T. //Envia E-mail
	Endif
	
	If 	lOk .And. lResult
//		ConfirmMailRead(.T.)
		
//		SEND MAIL 	FROM cMailConta	TO cEmailTo	BCC cEmailBcc SUBJECT cAssunto	BODY cMensagem  Attachment cFile RESULT lSendOk
		SEND MAIL 	FROM cMailConta	TO cEmailTo	BCC cEmailBcc SUBJECT cAssunto	BODY cMensagem RESULT lSendOk
		If !lSendOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError
			MsgInfo( cError, OemToAnsi( "Erro no envio de Email" ) ) //"Erro no envio de Email"
		EndIf
		
		DISCONNECT SMTP SERVER
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgInfo( cError, OemToAnsi( "Erro no envio de Email") ) // "Erro no envio de Email"
	EndIf
EndIf


Return lSendOk
