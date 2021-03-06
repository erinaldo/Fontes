#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun??o    �PROEA010  � Autor � Felipe Santos          � Data � 26/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri??o � Rotina de alerta do prazo de resposta do WF de an. amostra ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PROEA010()
Local cConta 	:= ""
Local cSenha 	:= ""
Local cServer	:= ""
Local cFrom		:= ""
Local lReturn 	:= .F.
Local cMensagem := ""
Local aArquivos := {}
Local lResulConn 
Local cMailEst  := ""

PREPARE ENVIRONMENT Empresa "01" Filial "01" 

conout("entrou")

cConta 	:= GETMV('MV_EMCONTA')
cSenha 	:= GETMV('MV_EMSENHA')
cServer	:= GETMV('MV_RELSERV')
cFrom	:= GETMV('MV_RELFROM')
cMailEst  := U_UsrRetMail(GETMV("ES_EMLESTO"))//GRUPO DE USUARIOS DO ESTOQUE QUE RECEBER� UMA NOTIFICA��O CASO O USU�RIO N�O RESPONDA O FLUXO NO PRAZO


conout("entrou1")
cMensagem := GeraHtmlJOB()
conout("entrou2")
If !Empty(cMensagem)
conout("entrou3")
	U_EnviaEmail(cConta,  cSenha, cServer, cFrom, cMailEst,"Alerta - Prazo para an�lise de Amostra",cMensagem,"")
conout("entrou4")
EndIf

RESET ENVIRONMENT

Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun??o    �GeraHtmlJOB    Autor � Felipe Santos      � Data � 26/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri??o � GERA HTML PARA ENVIAR ALERTA PARA O ESTOQUE                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraHtmlJOB()
Local cAr := GetArea()
Local cMensagem := ""
Local cQuery	:= ""
Local nCont		:= 0
Local lContinua := .F.
Local cHtmlDoc  := BuscaPrazo()
conout("entrouA2")
If !Empty(cHtmlDoc)
  conout("entrouB2")
	cMensagem := ' <html xmlns="http://www.w3.org/1999/xhtml"> '
	cMensagem +=' 	<head> '
	cMensagem +=' 		<title>Alerta - Analise de Amostra</title> '
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
	cMensagem +=' 				<b style="color: rgb(100, 149, 237); font-family: verdana; background-color: rgb(255, 255, 255);">Alerta - Retorno da an�lise de amostra expirado</b></div> '
	cMensagem +=' 			<h3 style="color: red;"> '
	cMensagem +=' 				<span style="font-family: arial, helvetica, sans-cMensagem +=" serif;">Aten��o, o(s) seguinte(s) documento(s) esta(�o) com data de retorno da an�lise de amostra expirada. </span></h3> '
	cMensagem +=' 			<br /> '
	cMensagem +=' 			<font face="verdana" size="1"><!-- Itens --></font> '
	cMensagem +=' 			<table width="100%"> '
	cMensagem +=' 				<tbody> '
	cMensagem +=' 					<tr bgcolor="Black"> '
	cMensagem +=' 						<td width="2%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="White"><b>Doc./NF</b></font> </font></td> '
	cMensagem +=' 						<td width="12%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>S�rie</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Data Documento</b></font> </font></td> '
	 cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Data Expira��o</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Dias Expirado</b></font> </font></td> ' 
	cMensagem +=' 					</tr> '
	cMensagem +=' 					<tr> '
	cMensagem += 					cHtmlDoc
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
conout("entrouC2")
EndIf
conout("entrouB2")
Return(cMensagem)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun??o    �BuscaPrazo Autor � Felipe Santos          � Data � 26/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri??o � Rotina de alerta do prazo de resposta do WF de an. amostra ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function BuscaPrazo()
Local cAlias := GetNextAlias()
Local cRHtml := ""
Local cFil   := cFilAnt
Local nDifData := 0

	BeginSQL Alias cAlias
	    
  	%noparser% 
 
	SELECT F1_DOC, F1_SERIE, F1_EMISSAO, F1_XANAPRZ
	FROM %Table:SF1% SF1 
	   WHERE SF1.%notDel%
	   AND F1_FILIAL  = %Exp:cFil%
	   AND F1_XANAPRZ <> ''

	EndSQL

While (cAlias)->(!EOF())
	
	If !EMPTY((cAlias)->F1_XANAPRZ)
		
		nDifData := (DDATABASE+1) - STOD((cAlias)->F1_XANAPRZ)
		
		If nDifData >0
		
			cRHtml +='	<tr><td> '
			cRHtml +='	<font face="verdana" size="1">'+ (cAlias)->F1_DOC +'</font></td> '
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ (cAlias)->F1_SERIE +'</font></td> '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ DTOC(STOD((cAlias)->F1_EMISSAO)) +'</font></td>  '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ DTOC(STOD((cAlias)->F1_XANAPRZ)) +'</font></td> '
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ STR(nDifData) +'</font></td></tr>  '
		
		EndIf
		
		
	EndIf		
	(cAlias)->(dbSkip())

EndDo


Return cRHtml
