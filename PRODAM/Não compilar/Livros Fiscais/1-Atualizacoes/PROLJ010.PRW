#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"



//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun??o    ³PROLJ010  ³ Autor ³ Felipe Santos          ³ Data ³ 26/11/00³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri??o ³ Rotina de atualização do campo A2_RECISS	                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ SIGAFIN                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function PROLJ010()
Local cConta 	:= ""
Local cSenha 	:= ""
Local cServer	:= ""
Local cFrom		:= ""
Local lReturn 	:= .F.
Local cMensagem := ""
Local aArquivos := {}
Local lResulConn 
Local cMailTitl  := ""

PREPARE ENVIRONMENT Empresa "99" Filial "01" 

cConta 	  := GETMV('MV_EMCONTA')
cSenha 	  := GETMV('MV_EMSENHA')
cServer	  := GETMV('MV_RELSERV')
cFrom	  := GETMV('MV_RELFROM')
cMailIss  := U_UsrRetMail(GETMV("ES_EMLCISS"))//GRUPO DE USUARIOS QUE RECEBERÃO ALERTA

//EFETUA ANALISE DO ARQUIVO E ATUALIZA CAMPO A2_RECISS 
ProcRecIss()

cMensagem := GeraHtmlJOB()

If !Empty(cMensagem)

	U_EnviaEmail(cConta,  cSenha, cServer, cFrom, cMailIss,"Alerta - Atualização de arquivo da prefeitura - ISS ",cMensagem,"")

EndIf

RESET ENVIRONMENT

Return 


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun??o    ³GeraHtmlJOB    Autor ³ Felipe Santos      ³ Data ³ 26/07/00 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri??o ³ GERA HTML PARA ENVIAR POR E-MAIL				              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ SIGAFIN                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function GeraHtmlJOB()
Local cAr := GetArea()
Local cMensagem := ""
Local cQuery	:= ""
Local nCont		:= 0
Local lContinua := .F.


cMensagem += ' <html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += ' 	<head>'
cMensagem += ' 		<title>Alerta - Atualiza&ccedil;&atilde;o de Arquivo da Prefeitura - ISS</title>'
cMensagem += ' 	</head>'
cMensagem += ' 	<body>'
cMensagem += ' 		<p>'
cMensagem += ' 			&nbsp;</p>'
cMensagem += ' 		<p>'
cMensagem += ' 			<font face="verdana" size="1"><img src="" /></font></p>'
cMensagem += ' 		<p>'
cMensagem += ' 			&nbsp;</p>'
cMensagem += ' 		<form action="mailto:%WFMailTo%" method="post" name="form1">'
cMensagem += ' 			<div style="text-align: center;">'
cMensagem += ' 				<font face="verdana" size="1"><img alt="" src="http://www.prefeitura.sp.gov.br/cidade/secretarias/upload/logo_prodam_1256829644.jpg" style="width: 195px; height: 96px;" /></font></div>'
cMensagem += ' 			<div style="text-align: center;">'
cMensagem += ' 				&nbsp;</div>'
cMensagem += ' 			<div style="text-align: center;">'
cMensagem += ' 				<b style="color: rgb(100, 149, 237); font-family: verdana; background-color: rgb(255, 255, 255);">Alerta para efetuar atualiza&ccedil;&atilde;o de arquivo de fornecedores que recolhem ISS</b></div>'
cMensagem += ' 				<h3 style="color: red;"><center>PASTA: &nbsp;\PRODAM_DATA\ISS</center></h3>'
cMensagem += ' 			<br />'
cMensagem += ' 			<p>'
cMensagem += ' 				<span style="font-family:lucida sans unicode,lucida grande,sans-serif;"><span local+="" span="" style="font-family:lucida sans unicode,lucida grande,sans-serif;"><center> Site:&nbsp;</span><a href="https://www3.prefeitura.sp.gov.br/cpom2/Consulta_Tomador.aspx">https://www3.prefeitura.sp.gov.br/cpom2/Consulta_Tomador.aspx</a></center></span></p>'
cMensagem += ' 			<p>'
cMensagem += ' 				<span style=&quot;font-family: arial, helvetica, sans-cMensagem +=&quot; serif;&quot;=&quot;&quot;&gt;</p>'
cMensagem += ' 			<br />'
cMensagem += ' 			<font face="verdana" size="1"><!-- Itens --></font><br />'
cMensagem += ' 			&nbsp;</form>'
cMensagem += ' 		<p>'
cMensagem += ' 			&nbsp;</p>'
cMensagem += ' 	</body>'
cMensagem += ' </html>'



Return(cMensagem)


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun??o    ³ATURECISS      Autor ³ Felipe Santos      ³ Data ³ 26/07/00 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri??o ³ GERA HTML PARA ENVIAR POR E-MAIL				              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ SIGAFIN                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//
Static Function ATURECISS()
Local nTamFile   := 0
Local nTamLin    := 680
Local nBtLidos   := 0
Local cBuffer   := ""
Local cFileOpen := ""
Local cTitulo1 := "Selecione o arquivo"
Local cExtens       := "Arquivo TXT | *.txt"
Local nTam
Local nItem       := 0   
Local aCNPJ       := {}
Local cIdReg 	  := ""
lOCAL cQueryTcSql := ""

cDir  := curdir()
cFileOpen := "c:\totvs 12.3\microsiga\protheus_data\iss\prs.txt"

If !File(cFileOpen)
     MsgAlert("Arquivo texto: "+cFileOpen+" não localizado",oLeArqTxt)
     Return
Endif

FT_FUSE(cFileOpen)                //ABRIR
FT_FGOTOP()                        //PONTO NO TOPO
ProcRegua(FT_FLASTREC())   //QTOS REGISTROS LER

//DELETA TODOS OS DADOS DA TABELA
cQueryDel := "DELETE FROM "+RetSqlName("SZ1")
If TCSQLEXEC(cQueryDel) < 0
	MsgInfo("Erro ao remover dados da tabela SZ1, verifique com o administrador do sistema e refaça o processo")
EndIf
	
While !FT_FEOF()
     IncProc()
     cBuffer 	:= FT_FREADLN()
     cIdReg     := SubStr(cBuffer,01,14) 
    
    //INSERE VALORES NOVAMENTE NA TABELA
    DBSELECTAREA("SZ1") 
    RECLOCK("SZ1",.T.)
    SZ1->Z1_FILIAL := xFilial("SZ1")
    SZ1->Z1_CNPJ   := Alltrim(cIdReg)
    MSUNLOCK("SZ1")
     	
     cIdReg := ""
    FT_FSKIP()
endDo 
FT_FUSE()



Return 


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun??o    ³ProcRecIss      Autor ³ Felipe Santos      ³ Data ³ 26/07/00 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri??o ³ GERA HTML PARA ENVIAR POR E-MAIL				              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ SIGAFIN                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function ProcRecIss()
Local lRet := .T.

dbSelectarea("SA2")	
SA2->( dbSetOrder(3) )
SA2->( dbGoTop() )

//ATUALIZA TABELA SZ1
ATURECISS()

While !SA2->( Eof() )
	
	cCNPJ:= POSICIONE("SZ1",1,xFilial("SZ1")+SA2->A2_CGC,"Z1_CNPJ")
	
	IF !Empty(cCNPJ)
		RECLOCK("SA2",.F.)
		SA2->A2_RECISS = "1" //SIM				
		MSUNLOCK("SA2")		
	ELSE
		RECLOCK("SA2",.F.)
		SA2->A2_RECISS = "2" //NÃO			
		MSUNLOCK("SA2")		
	ENDIF
dbSkip()	
EndDo

Return 
