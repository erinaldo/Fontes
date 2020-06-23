#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PROFJ010  ³ Autor ³ Felipe Santos          ³ Data ³ 26/07/00³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina de alerta de titulos vencidos						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROFJ010()
Local cConta 	:= ""
Local cSenha 	:= ""
Local cServer	:= ""
Local cFrom		:= ""
Local lReturn 	:= .F.
Local cMensagem := ""
Local aArquivos := {}
Local lResulConn 
Local cMailTitl  := ""

PREPARE ENVIRONMENT Empresa "01" Filial "01" 

conout("["+LEFT(DTOC(Date()),5)+"] ["+LEFT(Time(),5)+"] [PROFJ010] - Processo Iniciado")

cConta 	  := GETMV('MV_EMCONTA')
cSenha 	  := GETMV('MV_EMSENHA')
cServer	  := GETMV('MV_RELSERV')
cFrom	  := GETMV('MV_RELFROM')
cMailTitl  := U_UsrRetMail(GETMV("ES_EMLTITL"))//GRUPO DE USUARIOS QUE RECEBERÃO 


cMensagem := GeraHtmlJOB()

If !Empty(cMensagem)
	U_EnviaEmail(cConta,  cSenha, cServer, cFrom, cMailTitl,"Alerta - Titulos a Pagar não liberados",cMensagem,"")
EndIf


conout("["+LEFT(DTOC(Date()),5)+"] ["+LEFT(Time(),5)+"] [PROFJ010] - Processo Finalizado")

RESET ENVIRONMENT

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³GeraHtmlJOB    Autor ³ Felipe Santos      ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ GERA HTML PARA ENVIAR POR E-MAIL				              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraHtmlJOB()
Local cAr := GetArea()
Local cMensagem := ""
Local cQuery	:= ""
Local nCont		:= 0
Local lContinua := .F.
Local cHtmlTitl  := BuscaTitulo()


If !Empty(cHtmlTitl)
	cMensagem := ' <html xmlns="http://www.w3.org/1999/xhtml"> '
	cMensagem +=' 	<head> '
	cMensagem +=' 		<title>Alerta - Titulos a Pagar não liberados</title> '
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
	cMensagem +=' 				<b style="color: rgb(100, 149, 237); font-family: verdana; background-color: rgb(255, 255, 255);">Alerta - Titulos a Pagar não liberados</b></div> '
	cMensagem +=' 			<h3 style="color: red;"> '
	cMensagem +=' 				<span style="font-family: arial, helvetica, sans-cMensagem +=" serif;">Atenção, o(s) seguinte(s) titulo(s) esta(ão) pendentes de liberação. </span></h3> '
	cMensagem +=' 			<br /> '
	cMensagem +=' 			<font face="verdana" size="1"><!-- Itens --></font> '
	cMensagem +=' 			<table width="100%"> '
	cMensagem +=' 				<tbody> '
	cMensagem +=' 					<tr bgcolor="Black"> '
	cMensagem +=' 						<td width="2%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="White"><b>Num. Titulo</b></font> </font></td> '
	cMensagem +=' 						<td width="12%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Vencimento</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Valor</b></font> </font></td> '
	 cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Nome</b></font> </font></td> '
	cMensagem +=' 					</tr> '
	//cMensagem +=' 					<tr> '
	cMensagem += 					cHtmlTitl
	//cMensagem +=' 					</tr> '
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
Return(cMensagem)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³BuscaPrazo Autor ³ Felipe Santos          ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina que busca os titulos								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BuscaTitulo()
Local cAlias := GetNextAlias()
Local cRHtml := ""
Local cFil   := cFilAnt
Local nDifData := 0
Local cQuery     := ""

cQuery += " SELECT SE2.E2_NUM, SE2.E2_VENCREA "
cQuery += " ,CONVERT(varchar, CAST(SE2.E2_VALOR AS money), 0) as E2_VALOR, SA2.A2_NOME, SA2.A2_COD, SA2.A2_LOJA, SA2.A2_COD+SA2.A2_LOJA, SE2.E2_FORNECE+SE2.E2_LOJA "
cQuery += " FROM "+RetSqlName("SE2")+" SE2  "
cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON (SA2.A2_COD+SA2.A2_LOJA) = (SE2.E2_FORNECE+SE2.E2_LOJA) "
cQuery += " WHERE SE2.D_E_L_E_T_ = '' "
cQuery += " AND   SA2.D_E_L_E_T_ = '' "
cQuery += " AND SE2.E2_FILIAL  = '"+XFILIAL("SE2")+"'"
cQuery += " AND SA2.A2_FILIAL  = '"+XFILIAL("SA2")+"'"
cQuery += " AND SE2.E2_DATALIB = '' "
cQuery += " AND SE2.E2_VENCREA BETWEEN '"+DTOS(DDATABASE)+"' AND '"+DTOS(DDATABASE+7)+"' "
cQuery += " ORDER BY SA2.A2_NOME, SE2.E2_NUM "

cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
    Dbselectarea("QRY")
    QRY->(DbClosearea())
EndIf
 
TcQuery cQuery New Alias "QRY"
	
While !EOF()
			cRHtml +='	<tr><td> '
			cRHtml +='	<font face="verdana" size="1">'+ QRY->E2_NUM +'</font></td> '
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ DTOC(STOD(QRY->E2_VENCREA)) +'</font></td> '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">R$'+ CVALTOCHAR(QRY->E2_VALOR) +'</font></td>  '	
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ QRY->A2_NOME +'</font></td>
			cRHtml +='	<td> '
			cRHtml +='	<font face="verdana" size="1">'+ QRY->A2_COD + " - " + QRY->A2_LOJA +'</font></td></tr> '		
	dbSkip()
EndDo


Return cRHtml
