#Include 'Protheus.ch'
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ MMENSZ10 ºAutor ³ Marcos Candido º Data ³ 18/09/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Rotina para adequar a mensagem que o usuario ira receber º±±
±±º ³ sobre evento pre cadastrado. º±±
±±º ³ º±±
±±º ³ Z10 ==> Inclusao/Alteracao/Exclusao de TES º±±
±±º ³ º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MMENSZ10(cFil, aProds, cProd)
Local cConta 	:= GETMV('MV_EMCONTA')
Local cSenha 	:= GETMV('MV_EMSENHA')
Local cServer	:= GETMV('MV_RELSERV')
Local cFrom		:= GETMV('MV_RELFROM')
Local lReturn 	:= .F.
Local cMensagem := ""
Local aArquivos := {}
Local lResulConn 
Local cEmails := ""

cMensagem := GeraHtmlMM(cFil, aProds, cProd)

If !Empty(cMensagem)

	cEmails   := FindTo(xFilial("SAN"), "Z10")
	conout("MMENSZ10 2 " + cEmails)
	U_EnviaEmail(cConta,  cSenha, cServer, cFrom, cEmails,"Diferença entre Estoque do Produto",cMensagem,"")
	conout("MMENSZ10 3 " + cEmails)
EndIf

Return(cMensagem)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraXml2      ºAutor  ³Felipe Santos  º Data ³  06/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIO DE E-MAIL                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraHtmlMM(cFil, aProds, cProd)

Local cAr := GetArea()
Local cMensagem := ""
Local cQuery	:= ""
Local nCont		:= 0
Local lContinua := .F.
Local nEstSeg
Local nEstSB2

If LEN(aProds) = 0 
conout("MMENSZ10 1 " + cProd)
	nEstSB2 := Posicione("SB2", 1, xFilial("SB2") + cProd, "B2_QATU")
	nEstSeg := Posicione("SB1", 1, xFilial("SB1") + cProd, "B1_ESTSEG")	
conout("MMENSZ10 4 " + STR(nEstSB2))	
	//If nEstSeg <  nEstSB2
	If nEstSeg >  nEstSB2 //Alterado dia 07/01/16
		lContinua := .T.
	EndIf


Else

	//VERIFICA SE EXISTE A NECESSIDADE DE ENVIA EMAIL
	For nY:=1 to len(aProds)
	
		nEstSB2 := Posicione("SB2", 1, xFilial("SB2") + aProds[nY][1], "B2_QATU")
		nEstSeg := Posicione("SB1", 1, xFilial("SB1") + aProds[nY][1], "B1_ESTSEG")	
		
		//If nEstSeg <  nEstSB2
		If nEstSeg >  nEstSB2 //Alterado dia 08/01/16
			lContinua := .T.
		EndIf
	
	Next nY
	
EndIf

If lContinua
conout("MMENSZ10 5 ")	
	cMensagem :=' <html xmlns="http://www.w3.org/1999/xhtml"> '
	cMensagem +=' 	<head> '
	cMensagem +=' 		<title>WorkFlow - An&aacute;lise de Amostra</title> '
	cMensagem +=' 	</head> '
	cMensagem +=' 	<body> '
	cMensagem +=' 		<p> '
	cMensagem +=' 			&nbsp;</p> '
	cMensagem +=' 		<p> '
	cMensagem +=' 			<font face="verdana" size="1"><img src="" /></font></p> '
	cMensagem +=' 		<p> '
	cMensagem +=' 			&nbsp;</p> '
	cMensagem +=' 		<form action="mailto:%WFMailTo%" method="post" name="form1"> '
	cMensagem +=' 			<div style="text-align: center;"> '	
	cMensagem +=' 				<font face="verdana" size="1"><img alt="" src="http://www.prefeitura.sp.gov.br/cidade/secretarias/upload/logo_prodam_1256829644.jpg" style="width: 195px; height: 96px;" /></font></div> '	
	cMensagem +=' 			<div style="text-align: center;"> '
	cMensagem +=' 				&nbsp;</div> '
	cMensagem +=' 			<div style="text-align: center;"> '
	cMensagem +=' 				<b style="color: rgb(100, 149, 237); font-family: verdana; background-color: rgb(255, 255, 255);">Alerta - Estoque de Seguran&ccedil;a</b></div> '
	cMensagem +=' 			<h3 style="color: red;"> '
	cMensagem +=' 				<span style="font-family: arial, helvetica, sans-cMensagem +=" serif;">Aten&ccedil;&atilde;o, estoque de seguran&ccedil;a do(s) produto(s) abaixo cMensagem +=" est&atilde;o abaixo da quantidade em estoque.</span></h3> '
	cMensagem +=' 			<br /> '
	cMensagem +=' 			<font face="verdana" size="1"><!-- Itens --></font> '
	cMensagem +=' 			<table width="100%"> '
	cMensagem +=' 				<tbody> '
	cMensagem +=' 					<tr bgcolor="Black"> '
	cMensagem +=' 						<td width="2%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="White"><b>Cod. Produto</b></font> </font></td> '
	cMensagem +=' 						<td width="12%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Nome Produto</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Qtd. Estoque Seg.</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Qtd. Estoque</b></font> </font></td> '
	cMensagem +=' 					</tr> '
	cMensagem +=' 					<tr> '
	cMensagem += 					FindItens(cFil, aProds, cProd)
	cMensagem +=' 					</tr> '
	cMensagem +=' 					<tr> '
	cMensagem +=' 						<td align="center" bgcolor="Black" colspan="10">  '
	cMensagem +=' 							&nbsp;</td> '
	cMensagem +=' 					</tr> '
	cMensagem +=' 				</tbody> '
	cMensagem +=' 			</table> '
	cMensagem +=' 			<br /> '
	cMensagem +=' 			&nbsp;</form> '
	cMensagem +=' 		<p> '
	cMensagem +=' 			&nbsp;</p> '
	cMensagem +=' 	</body> '
	cMensagem +=' </html> '

EndIf

RestArea(cAr)
conout("MMENSZ10 6 " + cMensagem)	
Return(cMensagem)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FindItens     ºAutor  ³Felipe Santos  º Data ³  06/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIO DE E-MAIL                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FindItens(cFil, aProds, cProd)
local cRHtml := ""
Local nEstSb2 := 0
Local nEstSeg := 0

If LEN(aProds) = 0 

		nEstSb2 := Posicione("SB2", 1, xFilial("SB2") + cProd, "B2_QATU")
		nEstSeg := Posicione("SB1", 1, xFilial("SB1") + cProd, "B1_ESTSEG")	
		
		If nEstSeg < nEstSb2
		
			cRHtml +='	<tr><td> '
			cRHtml +='	<font face="verdana" size="1">'+ cProd +'</font></td> '
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ Posicione("SB1", 1, xFilial("SB1") + cProd, "B1_DESC") +'</font></td> '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ STR(nEstSeg) +'</font></td>  '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ STR(nEstSb2) +'</font></td></tr>  '	
			
		EndIf	

Else

	For nX:=1 to len(aProds)
	
		nEstSb2 := Posicione("SB2", 1, xFilial("SB2") + aProds[nX][1], "B2_QATU")
		nEstSeg := Posicione("SB1", 1, xFilial("SB1") + aProds[nX][1], "B1_ESTSEG")	
		
		If nEstSeg < nEstSb2
		
			cRHtml +='	<tr><td> '
			cRHtml +='	<font face="verdana" size="1">'+ aProds[nX][1] +'</font></td> '
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ Posicione("SB1", 1, xFilial("SB1") + aProds[nX][1], "B1_DESC") +'</font></td> '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ STR(nEstSeg) +'</font></td>  '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ STR(nEstSb2) +'</font></td></tr>  '	
			
		EndIf	
	
	Next nX
EndIf

Return cRHtml



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³EnviaEmail³ Autor ³ Vendas e CRM          ³ Data ³ 26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina para o envio de emails                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMK                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EnviaEmailMessenger(cAccount    ,cPassword    ,cServer    ,cFrom,;
                    cEmail        ,cAssunto    ,cMensagem    ,cAttach)

Local cEmailTo := ""                            // E-mail de destino
Local cEmailBcc:= ""                            // E-mail de copia
Local lResult  := .F.                            // Se a conexao com o SMPT esta ok
Local cError   := ""                            // String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")        // Parametro que indica se existe autenticacao no e-mail
Local lRet       := .F.                            // Se tem autorizacao para o envio de e-mail
Local cConta   := ALLTRIM(cAccount)                // Conta de acesso 
Local cSenha   := ALLTRIM(cPassword)            // Senha de acesso

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cEmailTo := cEmail
If At(";",cEmail) > 0 // existe um segundo e-mail.
    cEmailBcc:= SubStr(cEmail,At(";",cEmail)+1,Len(cEmail))
Endif    

CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenha RESULT lResult

// Se a conexao com o SMPT esta ok
If lResult

    // Se existe autenticacao para envio valida pela funcao MAILAUTH
    If lRelauth
        lRet := Mailauth(cConta,cSenha)    
    Else
        lRet := .T.    
    Endif    

    If lRet
        SEND MAIL FROM cFrom ;
        TO          cEmailTo;
        BCC         cEmailBcc;
        SUBJECT     cAssunto;
        BODY        cMensagem;
        ATTACHMENT  cAttach  ;
        RESULT lResult
        
        If !lResult
            //Erro no envio do email
            GET MAIL ERROR cError
            Help(" ",1,"Atencao",,cError+ " " + cEmailTo,4,5)    //Atenção
        Endif

    Else
        GET MAIL ERROR cError
        Help(" ",1,"Autenticacao",,cError,4,5)  //"Autenticacao"
        MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")          //"Erro de autenticação","Verifique a conta e a senha para envio"
    Endif
        
    DISCONNECT SMTP SERVER
Else
    //Erro na conexao com o SMTP Server
    GET MAIL ERROR cError
    Help(" ",1,"Atencao",,cError,4,5)      //Atencao
Endif

Return(lResult)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³FindTo    ³ Autor ³ Vendas e CRM          ³ Data ³ 26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Busca emails na tabela de eventos MMESSENGER               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMK                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FindTo(cFil, cEvent)
local cEmails:= ""
local cAlias := GetNextAlias()
local cCont := ""
local cDPr	:= ""

	BeginSQL Alias cAlias
	    
  	%noparser% 
 
	SELECT AN_FILIAL,AN_USER, AN_EMAIL, AN_EVENTO
	FROM %Table:SAN% SAN 
	   WHERE SAN.%notDel%
	   AND AN_FILIAL = %Exp:cFil%
	   AND AN_EVENTO = %Exp:cEvent%

	EndSQL

While (cAlias)->(!EOF())
	
	If !EMPTY((cAlias)->AN_USER) .and. EMPTY((cAlias)->AN_EMAIL)
		cEmails += UsrRetMail((cAlias)->AN_USER) + " , "
	ElseIf EMPTY((cAlias)->AN_USER) .and. !EMPTY((cAlias)->AN_EMAIL)
		cEmails += (cAlias)->AN_EMAIL + " , "
	EndIf
	(cAlias)->(dbSkip())

EndDo

cEmails:= SubStr(cEmails, 0, Len(cEmails)-1)

Return cEmails
