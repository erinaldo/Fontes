#INCLUDE "RWMAKE.CH" "
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMAAPR        ºAutor  ³Felipe Santos  º Data ³  06/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIO DE E-MAIL                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EMAAPR(cFil,cDoc,cSer,cFor,cLoj,cCod,cItem,cEmissao,cPrazo,cApr,cObs, cTo)

Local cConta 		:= GETMV('MV_EMCONTA')
Local cSenha 		:= GETMV('MV_EMSENHA')
Local cServer		:= GETMV('MV_RELSERV')
Local cFrom		:= GETMV('MV_RELFROM')
Local lReturn 	:= .F.
Local cMensagem 	:= ""
Local aArquivos 	:= {}
Local lResulConn 

//cApr = 1 -SIM
//cApr = 2 - NÃO
cApr := IIF(cApr=="1","Aprovado","Rejeitado")

cMensagem += GeraXml2(cFil, cDoc, cSer, cFor, cLoj, cCod, cItem, cEmissao, cPrazo, cApr, cObs)

//Envia E-mail
lRet:= U_EnviaEmail(cConta,  cSenha, cServer, cFrom, cTo,"Aviso de Resposta de WorkFlow - Análise de Amostra",cMensagem,"")
   


Return


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
Static Function GeraXml2(cFil,cDoc,cSer,cFor,cLoj,cCod,cItem,cEmissao,cPrazo,cApr,cObs)

Local cAr := GetArea()
Local cMensagem := ""
Local cQuery	:= ""
Local nCont		:= 0
Local cNFor		:= GetAdvFVal("SA2",'A2_NOME',xFilial("SA2")+cFor+cLoj,1)

cMensagem :=' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cMensagem +=' <html xmlns="http://www.w3.org/1999/xhtml"> '
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
cMensagem +=' 			<table width="100%"> '
cMensagem +=' 				<tbody> '
cMensagem +=' 					<tr> '
cMensagem +=' 					</tr> '
cMensagem +=' 					<tr> '
cMensagem +=' 						<td align="center" bgcolor="White" colspan="2"> '
cMensagem +=' 							<font face="verdana" size="1"><font color="#6495ED" size="3"><b>WorkFlow - Analise de amostra</b></font> </font></td> '
cMensagem +=' 					</tr> '
cMensagem +=' 					<tr> '
cMensagem +=' 						<td width="20%"> '
cMensagem +=' 							<font face="verdana" size="1"><b>Numero do Doc./Serie</b></font></td> '
cMensagem +=' 						<td> '
cMensagem +=' 							<font face="verdana" size="1"><input id="numeroCotacao" type="hidden" value="!numeroCotacao!" /> '+cDoc +'/'+ cSer +' </font></td> '
cMensagem +=' 					</tr> '
cMensagem +=' 					<tr> '
cMensagem +=' 						<td width="20%"> '
cMensagem +=' 							<font face="verdana" size="1"><b>Data de Emiss&atilde;o</b> </font></td> '
cMensagem +=' 						<td> '
cMensagem +=' 							<font face="verdana" size="1">'+DTOC(cEmissao)+'</font></td> '
cMensagem +=' 					</tr> '
cMensagem +=' 					<tr> '
cMensagem +=' 						<td width="20%"> '
cMensagem +=' 							<font face="verdana" size="1"><b>Prazo para Retorno</b> </font></td> '
cMensagem +=' 						<td> '
cMensagem +=' 							<font face="verdana" size="1"><font color="red"><b>'+DTOC(cPrazo)+'</b></font> </font></td> '
cMensagem +=' 					</tr> '
cMensagem +=' 					<tr> '
cMensagem +=' 						<td width="20%"> '
cMensagem +=' 							<font face="verdana" size="1"><b>Resposta</b> </font></td> '
cMensagem +=' 						<td> '
cMensagem +=' 							<font face="verdana" size="1">'+cApr+'</font></td> '
cMensagem +=' 					</tr> '
cMensagem +=' 					<tr> '
cMensagem +=' 						<td width="20%"> '
cMensagem +=' 							<font face="verdana" size="1"><b>Motivo Rejei&ccedil;&atilde;o</b></font></td> '
cMensagem +=' 						<td> '
cMensagem +=' 							<font face="verdana" size="1">'+cObs+'</font></td> '
cMensagem +=' 					</tr> '
cMensagem +=' 				</tbody> '
cMensagem +=' 			</table> '
cMensagem +=' 			<font face="verdana" size="1"><!-- Itens --></font> '
cMensagem +=' 			<table width="100%"> '
cMensagem +=' 				<tbody> '
cMensagem +=' 					<tr bgcolor="Black"> '
cMensagem +=' 						<td width="2%"> '
cMensagem +=' 							<font face="verdana" size="1"><font color="White"><b>Item</b></font> </font></td> '
cMensagem +=' 						<td width="12%"> '
cMensagem +=' 							<font face="verdana" size="1"><font color="white"><b>Produto</b></font> </font></td> '
cMensagem +=' 						<td width="18%"> '
cMensagem +=' 							<font face="verdana" size="1"><font color="white"><b>Descri&ccedil;&atilde;o</b></font> </font></td> '
cMensagem +=' 					</tr> '
cMensagem += 					PopItens(cFil,cDoc,cSer,cFor,cLoj,cCod,cItem)
cMensagem +=' 					<tr> '
cMensagem +=' 						<td align="center" bgcolor="Black" colspan="10"> '
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


RestArea(cAr)

Return(cMensagem)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PopItens      ºAutor  ³Felipe Santos  º Data ³  06/07/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIO DE E-MAIL                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PopItens(cFil,cDoc,cSer,cFor,cLoj,cCod,cItem)

local cAAnt:= GetArea()
local cAlias := GetNextAlias()
local cRHtml := ""
local cCont := ""
local cDPr	:= ""

	BeginSQL Alias cAlias
	    
  	%noparser% 
 
	SELECT D1_ITEM,D1_COD,D1_UM,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_TES
	FROM %Table:SD1% SD1 
	   WHERE SD1.%notDel%
	   AND D1_FILIAL = %Exp:cFil%
	   AND D1_DOC = %Exp:cDoc%
	   AND D1_SERIE = %Exp:cSer%
	   AND D1_FORNECE = %Exp:cFor%
	   AND D1_LOJA = %Exp:cLoj%
	   AND D1_COD = %Exp:cCod%
	   AND D1_ITEM = %Exp:cItem%
	   ORDER BY D1_FILIAL,D1_ITEM

	EndSQL

While (cAlias)->(!EOF())
	
	cDPr := GetAdvFVal("SB1",'B1_DESC',xFilial("SB1")+(cAlias)->D1_COD,1)
	
	cRHtml +='	<tr> <td> '
	cRHtml +='	<font face="verdana" size="1">'+ (cAlias)->D1_ITEM +'</font></td> '
	cRHtml +='	<td> '
	cRHtml +='	<font face="verdana" size="1">'+ (cAlias)->D1_COD +'</font></td> '
	cRHtml +='	<td> '
	cRHtml +='	<font face="verdana" size="1">'+ Posicione("SB1", 1, xFilial("SB1") + (cAlias)->D1_COD, "B1_DESC") +'</font></td></tr>  '	
	
	(cAlias)->(dbSkip())

EndDo
RestArea(cAAnt)

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
User Function EnviaEmail(cAccount    ,cPassword    ,cServer    ,cFrom,;
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