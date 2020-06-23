#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    PROGJ010³ Autor ³ Felipe Santos          ³ Data ³ 26/07/00³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina de alerta de dias a vencer de documentos de contratos±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGCT                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROGJ010()


PREPARE ENVIRONMENT Empresa "01" Filial "01" 

AlertaMsg()

RESET ENVIRONMENT

Return 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³AlertaMsg  Autor ³ Felipe Santos          ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina que busca os contratos vencidos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGCT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AlertaMsg()
Local cAlias 	:= GetNextAlias()
Local cRHtml    := ""
Local nDifData  := 0
Local cQuery    := ""
Local cConta 	:= ""
Local cSenha 	:= ""
Local cServer	:= ""
Local cFrom		:= ""
Local lReturn 	:= .F.
Local cMensagem := ""
Local aArquivos := {}
Local cMailGCT  := ""


cConta 	  := GETMV('MV_EMCONTA')
cSenha 	  := GETMV('MV_EMSENHA')
cServer	  := GETMV('MV_RELSERV')
cFrom	  := GETMV('MV_RELFROM')

cQuery += " SELECT CN9.CN9_NUMERO AS CONTRATO, CN9_XEMLGC, CN9_XEMLFC, CN9_XEMLOU FROM "+RetSqlName("CN9")+" CN9 "
cQuery += " 	INNER JOIN "+RetSqlName("CNK")+" CNK ON CNK.CNK_CONTRA = CN9.CN9_NUMERO "
cQuery += " 	WHERE CN9.CN9_FILIAL = '"+XFILIAL("CN9")+"' "			
cQuery += " 	AND CNK.CNK_FILIAL   = '"+XFILIAL("CNK")+"'	 "		
cQuery += " 	AND CN9.D_E_L_E_T_   = ''	 "			
cQuery += " 	AND CNK.D_E_L_E_T_   = ''	 "
cQuery += " 	AND CN9.CN9_REVISA = (SELECT MAX(CN9_1.CN9_REVISA) FROM "+RetSqlName("CN9")+" CN9_1 WHERE CN9_1.CN9_FILIAL = CN9.CN9_FILIAL AND CN9_1.D_E_L_E_T_ = '' AND CN9_1.CN9_NUMERO = CN9.CN9_NUMERO ) "

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
	cMensagem := GeraHtmlJOB(QRY->CONTRATO)

	If !Empty(cMensagem)
		U_EnviaEmail(cConta,  cSenha, cServer, cFrom, cMailGCT,"Alerta - Vencimento de Doc de contrato",cMensagem,"")
	EndIf
	
	dbSkip()
EndDo


Return cRHtml

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
Static Function GeraHtmlJOB(cContrato)
Local cAr 		:= GetArea()
Local cMensagem := ""
Local cQuery	:= ""
Local nCont		:= 0
Local lContinua := .F.
Local cHtmlCnt  := BuscaContratos(cContrato)

If !Empty(cHtmlCnt)
  
	cMensagem := ' <html xmlns="http://www.w3.org/1999/xhtml"> '
	cMensagem +=' 	<head> '
	cMensagem +=' 		<title>Alerta - Data de Vencimento de Documentos de contratos</title> '
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
	cMensagem +=' 				<b style="color: rgb(100, 149, 237); font-family: verdana; background-color: rgb(255, 255, 255);">Alerta - Prazo para vencimento de Documentos de Contratos </b></div> '
	cMensagem +=' 			<h3 style="color: red;"> '
	cMensagem +=' 				<span style="font-family: arial, helvetica, sans-cMensagem +=" serif;">Atenção, o(s) seguinte(s) contrato(s) tem documentos com prazo para vencimento </span></h3> '
	cMensagem +=' 			<br /> '
	cMensagem +=' 			<font face="verdana" size="1"><!-- Itens --></font> '
	cMensagem +=' 			<table width="100%"> '
	cMensagem +=' 				<tbody> '
	cMensagem +=' 					<tr bgcolor="Black"> '
	cMensagem +=' 						<td width="11%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="White"><b>Contrato/ Cod. Documento</b></font> </font></td> '
	cMensagem +=' 						<td width="11%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="White"><b>Contrato Prodam</b></font> </font></td> '	
	cMensagem +=' 						<td width="3%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Emissão</b></font> </font></td> '
	cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Vencimento</b></font> </font></td> '
	 cMensagem +=' 						<td width="18%"> '
	cMensagem +=' 							<font face="verdana" size="1"><font cMensagem +=" color="white"><b>Dias para Vencimento</b></font> </font></td> '
	cMensagem +=' 					</tr> '
	//cMensagem +=' 					<tr> '
	cMensagem += 					cHtmlCnt
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
±±³Descri??o ³ Rotina que busca os contratos vencidos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGCT                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BuscaContratos(cContrato)
Local cAlias 	:= GetNextAlias()
Local cRHtml 	:= ""
Local nDifData  := 0
Local cQuery    := ""
Local aDias     := {}
Local lShow     := .F.

cQuery += " SELECT CNK.CNK_CONTRA, CN9.CN9_XCODPR, CNK.CNK_CODIGO, CONVERT(VARCHAR(10),CAST(CNK.CNK_DTEMIS AS DATE), 103)AS CNK_DTEMIS, CONVERT(VARCHAR(10), CAST(CNK.CNK_DTVALI AS DATE), 103) as CNK_DTVALI, CNK.CNK_XDALERT, DATEDIFF(DAY, GETDATE(),CNK_DTVALI) AS  DIFDIAS "
cQuery += " FROM "+RetSqlName("CNK")+" CNK INNER JOIN "+RetSqlName("CN9")+" CN9 ON CNK.CNK_CONTRA = CN9.CN9_NUMERO "		
cQuery += " 	WHERE CNK.CNK_FILIAL   = '"+XFILIAL("CNK")+"'"		
cQuery += " 	WHERE CN9.CN9_FILIAL   = '"+XFILIAL("CN9")+"'"					
cQuery += " 	AND CNK.D_E_L_E_T_     = ''	"
cQuery += " 	AND CN9.D_E_L_E_T_     = ''	"
cQuery += " 	AND CNK.CNK_CONTRA     = '"+cContrato+"'	 "
	

cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
    Dbselectarea("QRY")
    QRY->(DbClosearea())
EndIf
 
TcQuery cQuery New Alias "QRY"

aDias := StrTokArr(QRY->CNK_XDALERT,",")

While !EOF()
	
	//Verifica se a diferenca de dias bate com o campo CNK_DALERT
	For nX:=1 TO LEN(aDias)
		If VAL(aDias[nX]) = QRY->DIFDIAS
			lShow:= .T.
		EndIf
	Next nX
	
	If lShow
	
		cRHtml +='	<tr><td> '
		cRHtml +='	<font face="verdana" size="1">'+ QRY->CNK_CONTRA +" / "+ QRY->CNK_CODIGO +'</font></td> '
		cRHtml +='	<tr><td> '
		cRHtml +='	<font face="verdana" size="1">'+ QRY->CN9_XCODPR +'</font></td> '		
		cRHtml +='	<td> '
		cRHtml +='	<font face="verdana" size="1">'+ QRY->CNK_DTEMIS +'</font></td> '	
		cRHtml +='	<td> '
		cRHtml +='	<font face="verdana" size="1">'+ QRY->CNK_DTVALI +'</font></td>  '	
		cRHtml +='	<td> '
		cRHtml +='	<font face="verdana" size="1">'+ STR(QRY->DIFDIAS) +'</font></td></tr> '
		
	EndIf
			
	dbSkip()
EndDo

Return cRHtml



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³BuscaEmailGCT or ³ Felipe Santos          ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina que busca os contratos vencidos					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGCT                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BuscaEmailGCT(cContrato)
Local cAlias 	:= GetNextAlias()
Local cRHtml 	:= ""
Local nDifData  := 0
Local cQuery    := ""
Local aDias     := {}
Local lShow     := .F.

cQuery += " SELECT CNK.CNK_CONTRA, CNK.CNK_CODIGO, CONVERT(VARCHAR(10),CAST(CNK.CNK_DTEMIS AS DATE), 103)AS CNK_DTEMIS, CONVERT(VARCHAR(10), CAST(CNK.CNK_DTVALI AS DATE), 103) as CNK_DTVALI, CNK.CNK_XDALERT, DATEDIFF(DAY, GETDATE(),CNK_DTVALI) AS  DIFDIAS FROM "+RetSqlName("CNK")+" CNK  "		
cQuery += " 	WHERE CNK.CNK_FILIAL   = '"+XFILIAL("CNK")+"'"					
cQuery += " 	AND CNK.D_E_L_E_T_     = ''	"
cQuery += " 	AND CNK.CNK_CONTRA     = '"+cContrato+"'	 "
	

cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
    Dbselectarea("QRY")
    QRY->(DbClosearea())
EndIf
 
TcQuery cQuery New Alias "QRY"

aDias := StrTokArr(QRY->CNK_XDALERT,",")

While !EOF()
	
	//Verifica se a diferenca de dias bate com o campo CNK_DALERT
	For nX:=1 TO LEN(aDias)
		If VAL(aDias[nX]) = QRY->DIFDIAS
			lShow:= .T.
		EndIf
	Next nX
	
	If lShow
	
		cRHtml +='	<tr><td> '
		cRHtml +='	<font face="verdana" size="1">'+ QRY->CNK_CONTRA +" / "+ QRY->CNK_CODIGO +'</font></td> '
		cRHtml +='	<td> '
		cRHtml +='	<font face="verdana" size="1">'+ QRY->CNK_DTEMIS +'</font></td> '	
		cRHtml +='	<td> '
		cRHtml +='	<font face="verdana" size="1">'+ QRY->CNK_DTVALI +'</font></td>  '	
		cRHtml +='	<td> '
		cRHtml +='	<font face="verdana" size="1">'+ STR(QRY->DIFDIAS) +'</font></td></tr> '
		
	EndIf
			
	dbSkip()
EndDo

Return cRHtml

