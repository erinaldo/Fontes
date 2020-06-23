#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M460FIM ()  ³Autor³ Felipe Santos ³ Data ³ 03/08/2015      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Este P.E. e' chamado apos a Gravacao da                    ³±±
±±³  NF de Saida, e fora da transação.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³ PE MVC              		                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

User Function M460FIM ()
Local nRecno := PARAMIXB //RECNO DO PEDIDO DE VENDAS SC5

IF !EMPTY(SC5->C5_NOTA) .AND. !EMPTY(SC5->C5_SERIE) //PEDIDO APTO A GERAR NF DE SAIDA

	IF EMPTY(SC5->C5_CONTRA)
		Alert("Pedido de venda não é vinculado a contrato, não irá gerar alerta")
	ELSE
		cMensagem := GeraHtmlFat(SC5->C5_NOTA, SC5->C5_SERIE, SC5->C5_CONTRA, SC5->C5_CLIENTE, SC5->C5_LOJACLI)
		
		BuscaEmailContrato(SC5->C5_CONTRA, cMensagem) 
					
	ENDIF

ENDIF

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³GeraHtmlFat    Autor ³ Felipe Santos      ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ GERA HTML PARA ENVIAR POR E-MAIL				              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraHtmlFat(cNota, cSerie, cContrato, cCliente, cLoja)
Local cAr := GetArea()
Local cMensagem := ""
Local cQuery	:= ""
Local nCont		:= 0
Local lContinua := .F.
Local cNomeCliente := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME") 

	cMensagem := ' <html xmlns="http://www.w3.org/1999/xhtml"> '
	cMensagem +=' 	<head> '
	cMensagem +=' 		<title>Alerta - Emissão de NF de saída</title> '
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
	cMensagem +=' 				<b style="color: rgb(100, 149, 237); font-family: verdana; background-color: rgb(255, 255, 255);">Alerta - Emissão de NF de saída após encerramento de medição do contrato </b></div> '
	cMensagem +=' 			<font face="verdana" size="1"><!-- Itens --></font> '
	cMensagem +=' 			<table width="100%"> '
	cMensagem +=' 				<tbody> '
	cMensagem +=' 					<tr bgcolor="Black"> '
	cMensagem +=' 						<td width="10%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="White"><b>Num. Nota Fiscal</b></font> </font></td> '
	cMensagem +=' 						<td width="4%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Série</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Contrato</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Cliente</b></font> </font></td>'
	cMensagem +=' 					</tr> '
	
	cMensagem +='	<tr><td> '
	cMensagem +='	<font face="verdana" size="1">'+ cNota +'</font></td> '
	cMensagem +='	<td> '
	cMensagem +='	<font face="verdana" size="1">'+ cSerie +'</font></td> '		
	cMensagem +='	<td> '
	cMensagem +='	<font face="verdana" size="1">'+ cContrato +'</font></td> '	
	cMensagem +='	<td> '
	cMensagem +='	<font face="verdana" size="1">'+ cCliente + " - "+cNomeCliente +'</font></td> </tr> '	
	
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

Return(cMensagem)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o ³BuscaEmailContrato -  Felipe Santos          ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina que busca os contratos vencidos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGCT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BuscaEmailContrato(cContrato, cMensagem)
Local cRHtml    := ""
Local nDifData  := 0
Local cQuery    := ""
Local lReturn 	:= .F.
Local aArquivos := {}
Local cMailGCT  := ""
Local cConta 	:= ""
Local cSenha 	:= ""
Local cServer	:= ""
Local cFrom		:= ""
Local lReturn 	:= .F.
Local aArquivos := {}
Local lResulConn 

cConta 	  := GETMV('MV_EMCONTA')
cSenha 	  := GETMV('MV_EMSENHA')
cServer	  := GETMV('MV_RELSERV')
cFrom	  := GETMV('MV_RELFROM')


cQuery += " SELECT CN9.CN9_NUMERO AS CONTRATO, CN9_XEMLGC, CN9_XEMLFC, CN9_XEMLOU FROM "+RetSqlName("CN9")+" CN9 "
cQuery += " 	WHERE CN9.CN9_FILIAL = '"+XFILIAL("CN9")+"' "				
cQuery += " 	AND CN9.D_E_L_E_T_   = ''	 "			
cQuery += " 	AND CN9.CN9_NUMERO   = '"+cContrato+"'	 "


cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
    Dbselectarea("QRY")
    QRY->(DbClosearea())
EndIf
 
TcQuery cQuery New Alias "QRY"
	
While !EOF()	
	cEmailGestor := U_UsrRetMail(QRY->CN9_XEMLGC)
	cEmailFiscal := U_UsrRetMail(QRY->CN9_XEMLFC)
	cEmailOutros := U_UsrRetMail(QRY->CN9_XEMLOU)
	
	cMailGCT  := IIF(EMPTY(cEmailGestor),"", cEmailGestor) + IIF(EMPTY(cEmailFiscal),"", ", "+cEmailFiscal)+ IIF(EMPTY(cEmailOutros),"", ", "+cEmailOutros)   //"felipe.csantos@totvs.com.br" //BUSCA DOS CAMPOS CN9_EMLGES, CN9_EMLFIS, CN9_EMLOUT

	If !Empty(cMensagem)
		U_EnviaEmail(cConta,  cSenha, cServer, cFrom, cMailGCT,"Alerta - Emissão de NF de saída ",cMensagem,"")
	EndIf
	
	dbSkip()
EndDo


Return cRHtml