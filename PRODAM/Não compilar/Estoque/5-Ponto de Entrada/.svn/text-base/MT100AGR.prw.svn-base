#Include 'Protheus.ch'
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"

#IFNDEF CRLF
	#DEFINE CRLF (Chr(13)+ Chr(10))
#ENDIF

User Function MT100AGR()
Local lEnvMail	:= .F.
Local aSC7		:= GetArea()
Local aCN9		:= GetArea()


//Adicionar Tx. Permanência e Juros no Título do contas a pagar se o contrato o tiver.
//Tiago Prata - 27/01/2014


IF INCLUI .OR. ALTERA
	DbSelectArea("SC7")	
	SC7->(DbSetOrder(1))
	If DbSeek(xfilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
		DbSelectArea("CN9")	
		CN9->(DbSetOrder(1))
		If DbSeek(xfilial("CN9")+SC7->C7_CONTRA+SC7->C7_CONTREV)
			RecLock("SE2",.F.)
			SE2->E2_PORCJUR := CN9->CN9_PERJU
			SE2->E2_VALJUR 	:= CN9->CN9_TAXJ
			SE2->(MsUnLock())
		Endif
	Endif
Endif

RestArea(aSC7)
RestArea(aCN9)

IF INCLUI .OR. ALTERA
	IF ALLTRIM(SF1->F1_STATUS) = 'B'
		lEnvMail:= .T.
	ENDIF
ENDIF       

IF  lEnvMail //Envia o email para o grupo de aprovadores
	u_UmEmail(SF1->F1_DOC,SF1->F1_SERIE)
ENDIF

Return

User Function UmEmail(cDoc,cSerie)                            

Local cConta 	:= GETMV('MV_EMCONTA')
Local cSenha 	:= GETMV('MV_EMSENHA')
Local cServer	:= GETMV('MV_RELSERV')
Local cTo		:= GETMV('MV_RELFROM')
Local lReturn 	:= .F.
Local cMensagem := ""

cMensagem += GeraXml(cDoc,cSerie)

If !Empty(cMensagem)
	lReturn := TkSendMail(cConta,+;
	cSenha,+;
	cServer,+;
	cConta,+;
	cTo,+;
	"Divergências ",+;
	cMensagem,+;
	"")
Endif
	
Return

Static Function GeraXml(cDoc,cSerie)

Local cMensagem := ""
Local cQuery	:= ""
Local nQtdTol   := 0
Local nVlrTol   := 0

If SELECT("TMP") <> 0
	TMP->(DbCloseArea())
EndIF

cQuery:= " SELECT D1_FILIAL,D1_PEDIDO,D1_GRUPO,D1_LOJA,D1_ITEMPC,D1_FORNECE,D1_COD,D1_DOC,D1_SERIE,D1_QUANT,D1_VUNIT,B1_FILIAL,B1_COD,B1_DESC,C7_FILIAL,C7_PRODUTO,C7_FORNECE,C7_ITEM,C7_LOJA,C7_NUM,C7_QUANT,C7_PRECO,AIC_FILIAL,AIC_FORNEC,AIC_LOJA,AIC_PRODUT,AIC_GRUPO,AIC_PQTDE,AIC_PPRECO "+CRLF
cQuery+= " FROM "+RetSqlName("SD1")+" SD1 "+CRLF
cQuery+= " INNER JOIN "+RetSqlName("SB1")+" SB1 ON  SB1.B1_COD = SD1.D1_COD "+CRLF
cQuery+= " INNER JOIN "+RetSqlName("SC7")+" SC7 ON SC7.C7_PRODUTO = SD1.D1_COD AND SC7.C7_FORNECE = SD1.D1_FORNECE AND SC7.C7_LOJA = SD1.D1_LOJA AND SC7.C7_NUM = SD1.D1_PEDIDO AND SD1.D1_ITEMPC = SC7.C7_ITEM"+CRLF 
cQuery+= " INNER JOIN "+RetSqlName("AIC")+" AIC ON AIC.AIC_FORNEC = SD1.D1_FORNECE AND AIC.AIC_LOJA = SD1.D1_LOJA AND AIC.AIC_PRODUT = SD1.D1_COD "+CRLF
cQuery+= " WHERE SD1.D1_DOC = '"+cDoc+"' AND SD1.D1_SERIE = '"+cSerie+"' "+CRLF
cQuery+= " AND SD1.D_E_L_E_T_ = '' "+CRLF
cQuery+= " AND SB1.D_E_L_E_T_ = '' "+CRLF
cQuery+= " AND SC7.D_E_L_E_T_ = '' "+CRLF
cQuery+= " AND AIC.D_E_L_E_T_ = '' "
TCQUERY cQuery ALIAS TRB NEW

cMensagem := '<html>'

cMensagem += '<head>'
cMensagem += ' <title>Tolerância de Recebimento</title>'
cMensagem += '<style type="text/css">'
cMensagem += '<!--'
cMensagem += '.style4 {font-size: 10px; font-weight: bold; }'
cMensagem += '.style6 {font-size: 10px;'
cMensagem += 'font-family:Verdana, Arial, Helvetica, sans-serif;}'
cMensagem += '.style9 {font-size: 12px;'
cMensagem += 'font-family:Verdana, Arial, Helvetica, sans-serif;'
cMensagem += 'color:#FF0000}'
cMensagem += 'body,td,th {'
cMensagem += '	font-family: Verdana, Arial, Helvetica, sans-serif;'
cMensagem += '	font-size: 10px;'
cMensagem += '}'
cMensagem += 'body {'
cMensagem += '	margin-left: 0px;'
cMensagem += '	margin-top: 0px;'
cMensagem += '	margin-right: 0px;'
cMensagem += '	margin-bottom: 0px;'
cMensagem += '}'
cMensagem += '.style8 {'
cMensagem += '	font-size: 12px;'
cMensagem += '	font-weight: bold;'
cMensagem += '	font-family: Verdana, Arial, Helvetica, sans-serif;'
cMensagem += '}'
cMensagem += '.style10 {'
cMensagem += '	color: #FF0000;'
cMensagem += '	font-weight: bold;'
cMensagem += '}'
cMensagem += '.style11 {'
cMensagem += '	color: #009900;'
cMensagem += '	font-weight: bold;'
cMensagem += '}'
cMensagem += '.style12 {font-size: 9px}'
cMensagem += '.style13 {color: #FFFFFF}'
cMensagem += '-->'
cMensagem += '</style>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>'

cMensagem += '<body bgproperties="fixed">'

cMensagem += '<form action="mailto:%WFMailTo%" method="POST"'
cMensagem += 'name="Form1">'
cMensagem += '<table border="0" width="950">'
cMensagem += '        <tr>'
cMensagem += '          <td width="757" valign="top"><table border="0" width="950"'
cMensagem += '            height="68">'

cMensagem += '<tr>'
cMensagem += '<td height="24" colspan="2" align="center" valign="middle" style="background-color: rgb(137, 175, 198);">'
cMensagem += ' <h2 align="center">'
cMensagem += '   <font color="white" size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>Tolerância de Recebimento</strong></font></h2></td>'
cMensagem += '</tr>'

cMensagem += '            </table>'
cMensagem += '<table border="1" width="950" height="45">'
cMensagem += '                <tr>'
cMensagem += '                    <td width="300" height="0" align="center" valign="middle" style="background-color: rgb(137, 175, 198);"><span class="style4"><font'
cMensagem += '                    face="Verdana, Arial, Helvetica, sans-serif">Cdigo Doc</font></span></td>'

cMensagem += '		    <td width="300" height="0" align="center" valign="middle" style="background-color: rgb(137, 175, 198);"><span class="style4"><font'
cMensagem += '           	    face="Verdana, Arial, Helvetica, sans-serif">Descrio Doc</font></span></td>'

dbSelectArea("TRB")
TRB->(dbGoTop())
While !TRB->(EOF())

nQtdTol := (TRB->C7_PRECO * TRB->AIC_PQTDE) / 100
nVlrTol := (TRB->C7_QUANT * TRB->AIC_PPRECO)/ 100
nQtd := (TRB->D1_QUANT-TRB->C7_QUANT)
nVlr := (TRB->D1_VUNIT-TRB->C7_PRECO)

//Alert(cValToChar(nQtdTol))
//Alert(cValToChar(nVlrTol))
//Alert(cValToChar(nQtd))
//Alert(cValToChar(nVlr))


If ((nQtd > nQtdTol) .AND. (nVlr > nVlrTol))
	cMensagem += '<tr>'	
	cMensagem += '<td width="300" height="0" align="center" valign="middle" nowrap><span class="style6"><font'
	cMensagem += 'face="Verdana, Arial, Helvetica, sans-serif">'+'DOCUMENTO: '+TRB->D1_DOC+' SERIE: '+TRB->D1_SERIE+'</font></span></td>'
	cMensagem += '<td width="300" height="0" align="center" valign="middle" nowrap><span class="style6"><font'
	cMensagem += 'face="Verdana, Arial, Helvetica, sans-serif">'+'Produto: '+TRB->D1_COD+' - '+TRB->B1_DESC+' está com o valor divergênte e a quantidade divergente </font></span></td>'
	cMensagem += '</tr>'
ElseIf (nVlr > nVlrTol)
	cMensagem += '<tr>'	
	cMensagem += '<td width="300" height="0" align="center" valign="middle" nowrap><span class="style6"><font'
	cMensagem += 'face="Verdana, Arial, Helvetica, sans-serif">'+'DOCUMENTO: '+TRB->D1_DOC+' SERIE: '+TRB->D1_SERIE+'</font></span></td>'
	cMensagem += '<td width="300" height="0" align="center" valign="middle" nowrap><span class="style6"><font'
	cMensagem += 'face="Verdana, Arial, Helvetica, sans-serif">'+'Produto: '+TRB->D1_COD+' - '+TRB->B1_DESC+' está com o valor divergênte </font></span></td>'
	cMensagem += '</tr>'
ElseIf (nQtd > nQtdTol)
	cMensagem += '<tr>'	
	cMensagem += '<td width="300" height="0" align="center" valign="middle" nowrap><span class="style6"><font'
	cMensagem += 'face="Verdana, Arial, Helvetica, sans-serif">'+'DOCUMENTO: '+TRB->D1_DOC+' SERIE: '+TRB->D1_SERIE+'</font></span></td>'
	cMensagem += '<td width="300" height="0" align="center" valign="middle" nowrap><span class="style6"><font'
	cMensagem += 'face="Verdana, Arial, Helvetica, sans-serif">'+'Produto: '+TRB->D1_COD+' - '+TRB->B1_DESC+' está com a quantidade divergênte </font></span></td>'
	cMensagem += '</tr>'
Endif
	TRB->(dbSkip())
EndDo

TRB->(dBCloseArea())

cMensagem += '            </table>'
cMensagem += '            <br>'
cMensagem += '            <table width="950" border="0" cellspacing="0" cellpadding="0">'
cMensagem += '</form>'
cMensagem += '</body>'
cMensagem += '</html>'

Return(cMensagem)
