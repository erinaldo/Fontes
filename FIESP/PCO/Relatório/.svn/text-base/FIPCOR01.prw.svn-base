#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SHELL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FIPCOR01  ³ Autor ³ Ligia Sarnauskas		³ Data ³ 07.08.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Relatório Conferencia de registros PCO              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FICDVR01      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FIESP     												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FIPCOR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de Conferencia lanctos PCO"
Local   cDesc3      := ""
Local   cPict       := ""
Local   aOrd        := {}
Local 	aRegs		:= {}
Local   titulo      := "Conferência Lanctos PCO"
Local   nLin        := 80
Local   Cabec1      := ""
Local   Cabec2      := ""
Local   lImprime    := .T.
Private cString     := ""
Private CbTxt       := ""
Private cPerg       := "FIPCOR01"
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "FIPCOR01"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 2, "Administracao", 2, 2, 2, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private nCONTFL     := 01
Private m_pag       := 01
Private wnrel       := "FIPCOR01"
Private cString     := "AKD"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria perguntas utilizada no relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


AADD(aRegs,{cPerg,"01","Dt Lancto de     :","","","mv_ch1","D",08,0,0,"G","","mv_par01",""         ,"","","","",""         ,"","","","",""           ,"","","","",""      ,"","","","",""      ,"","","",""   ,"","","","",""})
AADD(aRegs,{cPerg,"02","Dt Lancto ate    :","","","mv_ch2","D",08,0,0,"G","","mv_par02",""         ,"","","","",""         ,"","","","",""           ,"","","","",""      ,"","","","",""      ,"","","",""   ,"","","","",""})
AADD(aRegs,{cPerg,"03","Tipo de Saldo    :","","","mv_ch3","C",02,0,0,"G","","mv_par03",""         ,"","","","",""         ,"","","","",""           ,"","","","",""      ,"","","","",""      ,"","","","AL2","","","","",""})
AADD(aRegs,{cPerg,"04","Operação         :","","","mv_ch4","N",01,0,0,"G","","mv_par04","Credito"  ,"","","","","Debito"   ,"","","","",""           ,"","","","",""      ,"","","","",""      ,"","","",""   ,"","","","",""})
AADD(aRegs,{cPerg,"05","Gera Planilha    :","","","mv_ch5","N",01,0,0,"G","","mv_par05","Sim"      ,"","","","","Nao"      ,"","","","",""           ,"","","","",""      ,"","","","",""      ,"","","",""   ,"","","","",""})
AADD(aRegs,{cPerg,"06","Diretorio        :","","","mv_ch6","C",20,0,0,"G","","mv_par06",""         ,"","","","",""         ,"","","","",""           ,"","","","",""      ,"","","","",""      ,"","","",""   ,"","","","",""})
AADD(aRegs,{cPerg,"07","Arquivo          :","","","mv_ch7","C",20,0,0,"G","","mv_par07",""         ,"","","","",""         ,"","","","",""           ,"","","","",""      ,"","","","",""      ,"","","",""   ,"","","","",""})

U_ValidPerg(cPerg,aRegs)    //--> Cria as perguntas. Funcao na Biblioteca

IF !Pergunte(cPerg,.t.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If MV_PAR05 = 1 // Gera Planilha
	CriaPlan()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	RptStatus({|lEnd| R10RunReport(Cabec1,Cabec2,Titulo,nLin,@lEnd) },Titulo)
	//alert("Esse relatório só pode ser gerado em Excel. Reconfigure a parametrização.")
Endif


Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 05.12.06 ³ Modelagem de Dados                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpA1 = array com o conteúdo do grupo de perguntas (SX1)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ABREHTML  ºAutor  ³TOTVS               º Data ³  26/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes para Integracao com o Excel                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AbreHtml()
Local cCabHtml 		:= ""
Local cFileCont 	:= ""
//monta cabeçalho de pagina HTML para posterior utilização
cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml += "<html>" + CRLF
cCabHtml += "<head>" + CRLF
cCabHtml += "  <title>teste</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF
cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF
cCabHtml += "" + CRLF
cFileCont := cCabHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif
Return nil

Static Function fecHtml()
Local cRodHtml 	:= ""
Local cFileCont	:= ""
// Monta Rodape Html para posterior utilizaçao
cRodHtml := "</body>" + CRLF
cRodHtml += "</html>" + CRLF
cFileCont := cRodHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif

Return nil

Static Function PutHtml(aConteudo, nTipo, nBold)
Local cLinFile 	:= ""
Local cFileCont := ""
Local nXb 		:= 0
Default nBold 	:= 0
Default nTipo	:= 2

//Aqui começa a montagem da pagina html propriamente dita
// acrescenta o cabeçalho
If nTipo == 1
	cLinFile += "<Table style='background: #ZZZZZZ; width: 100%;' border='1' cellpadding='2' cellspacing='2'>"
EndIf

cLinFile += "<TR>"

For nXb := 1 to Len(aConteudo)
	cLinFile += "<TD style='Background: #ZZZZZZ; font-style: Bold;'>"
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += Alltrim(aConteudo[nXb])
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += "</TD>"
next nXb
cLinFile += "</TR>" + CRLF

If nTipo == 3
	cLinFile += "</Table>"
EndIf

cFileCont := cLinFile

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaPlan  ºAutor  ³                    º Data ³  27/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria Planilha Excel com Base na Query                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaPlan()

Local _i
Local cPasta	:= AllTrim(MV_PAR06)
Local cArq		:= AllTrim(Mv_PAR07)
Private nHdl1    := 0
_lRetorno:=.F.
_cFilial:=""

If Empty(MV_PAR06) .OR. Empty(MV_PAR07)
	ApMsgAlert("O arquivo nao pode ser executado! Verifique os parametros.","Atencao!")
	Return NIL
Else
	MakeDir( AllTrim(MV_PAR06) )
	nhdl1 := fCreate( cPasta + "\" + cArq + ".xls",0)
Endif
If nHdl1 == -1
	ApMsgAlert("O arquivo nao pode ser executado! Verifique os parametros.","Atencao!")
	Return NIL
Endif

AbreHtml()

PutHtml({"TIPO","FILIAL","DATA","NUMERO", "ITEM","CONTRATO","MEDICAO","VALOR","CONTA","C.CUSTO", "ITEM","LOTE","STATUS","DATA","HISTORICO","CONTA ORC","C.CUSTO ORC","ITEM ORC","VALOR ORC"},1,1)


If MV_PAR03 == "SC" .AND. MV_PAR04 = 1
	MontaTMPSC1()
	dbSelectArea("TMPSC1")
	While !TMPSC1->(EOF())
		_cTipo:="Solic.Contrato"
		_cChave:="SZ7"+ALLTRIM(TMPSC1->FILIAL)+ALLTRIM(TMPSC1->NUM)
		Dbselectarea("AKD")
		Dbsetorder(3)
		If Dbseek(SUBSTR(TMPSC1->FILIAL,1,4)+"    "+"900001"+"01"+_cChave)
			PutHtml({_cTipo,TMPSC1->FILIAL,(TMPSC1->DTSOL),TMPSC1->NUM,"",TMPSC1->CONTRATO,"",Transform(((TMPSC1->VLINI/100)*TMPSC1->PERC),'@E 999,999,999.99'),TMPSC1->CONTA,TMPSC1->CUSTO,TMPSC1->ITEMCTB,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
		eLSE
			PutHtml({_cTipo,TMPSC1->FILIAL,(TMPSC1->DTSOL),TMPSC1->NUM,"",TMPSC1->CONTRATO,"",Transform(((TMPSC1->VLINI/100)*TMPSC1->PERC),'@E 999,999,999.99'),TMPSC1->CONTA,TMPSC1->CUSTO,TMPSC1->ITEMCTB,"","","","","","","",""},1,0)
		Endif
		dbSelectArea("TMPSC1")
		Dbskip()
	Enddo
ElseIf MV_PAR03 == "SC" .AND. MV_PAR04 = 2
	MontaSC2()
	dbSelectArea("TMPSC2")
	While !TMPSC2->(EOF())
		_cTipo:="Solic.Contrato"
		_cChave:="CNB"+ALLTRIM(TMPSC2->FILIAL)+ALLTRIM(TMPSC2->CONTRATO)+(TMPSC2->REVISAO)+ALLTRIM(TMPSC2->PLANILHA)+ALLTRIM(TMPSC2->ITEM)
		Dbselectarea("AKD")
		Dbsetorder(3)
		If Dbseek(SUBSTR(TMPSC2->FILIAL,1,4)+"    "+"000354"+"02"+_cChave)
			While !EOF() .and. alltrim(AKD->AKD_FILIAL) == SUBSTR(TMPSC2->FILIAL,1,4) .AND. AKD->AKD_PROCESS == "000354" .AND. AKD->AKD_ITEM == "02" .AND. ALLTRIM(AKD->AKD_CHAVE) == ALLTRIM(_cChave)
				If AKD->AKD_SEQ == "01"
					PutHtml({_cTipo,TMPSC2->FILIAL,(TMPSC2->DTCAD),"",TMPSC2->ITEM,TMPSC2->CONTRATO,"",Transform(TMPSC2->VLTOT,'@E 999,999,999.99'),TMPSC2->CONTA,TMPSC2->CC,TMPSC2->ITEMCT,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
				Endif
				Dbselectarea("AKD")
				Dbskip()
			Enddo
		eLSE
			PutHtml({_cTipo,TMPSC2->FILIAL,(TMPSC2->DTCAD),"",TMPSC2->ITEM,TMPSC2->CONTRATO,"",Transform(TMPSC2->VLTOT,'@E 999,999,999.99'),TMPSC2->CONTA,TMPSC2->CC,TMPSC2->ITEMCT,"","","","","","","",""},1,0)
		Endif
		dbSelectArea("TMPSC2")
		Dbskip()
	Enddo
ElseIf MV_PAR03 == "CO" .AND. MV_PAR04 = 1
	MontaCO1()
	dbSelectArea("TMPCO1")
	While !TMPCO1->(EOF())
		_cTipo:="Contrato"
		_cChave:="CNB"+ALLTRIM(TMPCO1->FILIAL)+ALLTRIM(TMPCO1->CONTRATO)+(TMPCO1->REVISAO)+ALLTRIM(TMPCO1->PLANILHA)+ALLTRIM(TMPCO1->ITEM)
		Dbselectarea("AKD")
		Dbsetorder(3)
		If Dbseek(SUBSTR(TMPCO1->FILIAL,1,4)+"    "+"000354"+"02"+_cChave)
			While !EOF() .and. alltrim(AKD->AKD_FILIAL) == SUBSTR(TMPCO1->FILIAL,1,4) .AND. AKD->AKD_PROCESS == "000354" .AND. AKD->AKD_ITEM == "02" .AND. ALLTRIM(AKD->AKD_CHAVE) == ALLTRIM(_cChave)
				If AKD->AKD_SEQ == "02"
					PutHtml({_cTipo,TMPCO1->FILIAL,(TMPCO1->DTCAD),"",TMPCO1->ITEM,TMPCO1->CONTRATO,"",Transform(TMPCO1->VLTOT,'@E 999,999,999.99'),TMPCO1->CONTA,TMPCO1->CC,TMPCO1->ITEMCT,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
				Endif
				Dbselectarea("AKD")
				Dbskip()
			Enddo
		eLSE
			PutHtml({_cTipo,TMPCO1->FILIAL,(TMPCO1->DTCAD),"",TMPCO1->ITEM,TMPCO1->CONTRATO,"",Transform(TMPCO1->VLTOT,'@E 999,999,999.99'),TMPCO1->CONTA,TMPCO1->CC,TMPCO1->ITEMCT,"","","","","","","",""},1,0)
		Endif
		dbSelectArea("TMPCO1")
		Dbskip()
	Enddo
ElseIf MV_PAR03 == "CO" .AND. MV_PAR04 = 2
	MontaTMP4()
	dbSelectArea("TMP4")
	While !TMP4->(EOF())
		If TMP4->RATEIO == "2"
			Dbselectarea("CNE")
			Dbsetorder(4)
			If Dbseek(TMP4->FILIAL+ALLTRIM(TMP4->MEDICAO))
				_cChave:="CNE"+ALLTRIM(TMP4->FILIAL)+ALLTRIM(TMP4->CONTRA)+CNE->CNE_REVISA+CNE->CNE_NUMERO+ALLTRIM(TMP4->MEDICAO)+CNE->CNE_ITEM
				Dbselectarea("AKD")
				Dbsetorder(3)
				If Dbseek(SUBSTR(TMP4->FILIAL,1,4)+"    "+"000355"+"02"+_cChave)
					While !EOF() .and. alltrim(AKD->AKD_FILIAL) == SUBSTR(TMP4->FILIAL,1,4) .AND. AKD->AKD_PROCESS == "000355" .AND. AKD->AKD_ITEM == "02" .AND. ALLTRIM(AKD->AKD_CHAVE) == ALLTRIM(_cChave)
						If AKD->AKD_SEQ == "01"
							PutHtml({"Contratos",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(TMP4->TOTAL,'@E 999,999,999.99'),TMP4->CONTA,TMP4->CC,TMP4->ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
						Endif
						Dbselectarea("AKD")
						Dbskip()
					Enddo
				eLSE
					PutHtml({"Contratos",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(TMP4->TOTAL,'@E 999,999,999.99'),TMP4->CONTA,TMP4->CC,TMP4->ITEMCTA,"","","","","","","",""},1,0)
				Endif
			Endif
		Else
			Dbselectarea("SCH")
			Dbsetorder(2)
			If Dbseek(ALLTRIM(TMP4->FILIAL)+ALLTRIM(TMP4->NUM)+ALLTRIM(TMP4->ITEM))
				While !EOF() .and. ALLTRIM(TMP4->NUM)==ALLTRIM(SCH->CH_PEDIDO) .AND. ALLTRIM(TMP4->ITEM)==ALLTRIM(SCH->CH_ITEMPD)
					_cChave:="CNZ"+ALLTRIM(TMP4->FILIAL)+ALLTRIM(TMP4->CONTRA)+TMP4->CONTREV+ALLTRIM(TMP4->MEDICAO)+ALLTRIM(TMP4->ITEMED)+SCH->CH_ITEM
					Dbselectarea("AKD")
					Dbsetorder(3)
					If Dbseek(SUBSTR(TMP4->FILIAL,1,4)+"    "+"000355"+"05"+_cChave)
						While !EOF() .and. alltrim(AKD->AKD_FILIAL) == SUBSTR(TMP4->FILIAL,1,4) .AND. AKD->AKD_PROCESS == "000355" .AND. AKD->AKD_ITEM == "05" .AND. ALLTRIM(AKD->AKD_CHAVE) == ALLTRIM(_cChave)
							If AKD->AKD_SEQ == "04"
								PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
							Endif
							Dbselectarea("AKD")
							Dbskip()
						Enddo
					Else
						If Dbseek(SUBSTR(TMP4->FILIAL,1,4)+"    "+"000355"+"06"+_cChave)
							While !EOF() .and. alltrim(AKD->AKD_FILIAL) == SUBSTR(TMP4->FILIAL,1,4) .AND. AKD->AKD_PROCESS == "000355" .AND. AKD->AKD_ITEM == "06" .AND. ALLTRIM(AKD->AKD_CHAVE) == ALLTRIM(_cChave)
								If AKD->AKD_SEQ == "06"
									PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
								Endif
								Dbselectarea("AKD")
								Dbskip()
							Enddo
						Else
							PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,"","","","","","","",""},1,0)
						Endif
					Endif
					Dbselectarea("SCH")
					Dbskip()
				Enddo
			Else
				PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),"Não encontrado rateio"},1,0)
			Endif
		Endif
		dbSelectArea("TMP4")
		Dbskip()
	Enddo
	
ElseIf MV_PAR03 == "EM" .AND. MV_PAR04 = 1
	MontaTMP1()
	dbSelectArea("TMP1")
	While !TMP1->(EOF())
		If TMP1->RATEIO =="2"
			_cTipo:="Pedido"
			_cChave:="SC7"+ALLTRIM(TMP1->FILIAL)+ALLTRIM(TMP1->NUM)+ALLTRIM(TMP1->ITEM)
			Dbselectarea("AKD")
			Dbsetorder(3)
			If Dbseek(SUBSTR(TMP1->FILIAL,1,4)+"    "+"000052"+"01"+_cChave)
				PutHtml({_cTipo,TMP1->FILIAL,(TMP1->EMISSAO),TMP1->NUM,TMP1->ITEM,"","",Transform(TMP1->TOTAL,'@E 999,999,999.99'),TMP1->CONTA,TMP1->CC,TMP1->ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
			Else
				PutHtml({_cTipo,TMP1->FILIAL,(TMP1->EMISSAO),TMP1->NUM,TMP1->ITEM,"","",Transform(TMP1->TOTAL,'@E 999,999,999.99'),TMP1->CONTA,TMP1->CC,TMP1->ITEMCTA,"","","","","","","",""},1,0)
			Endif
		Else
			_cTipo:="Pedido/Rateio"
			Dbselectarea("SCH")
			Dbsetorder(2)
			If Dbseek(ALLTRIM(TMP1->FILIAL)+ALLTRIM(TMP1->NUM)+ALLTRIM(TMP1->ITEM))
				While !EOF() .and. ALLTRIM(TMP1->NUM)==ALLTRIM(SCH->CH_PEDIDO) .AND. ALLTRIM(TMP1->ITEM)==ALLTRIM(SCH->CH_ITEMPD)
					_cChave:="SCH"+ALLTRIM(TMP1->FILIAL)+ALLTRIM(TMP1->NUM)+(TMP1->FORNECE)+(TMP1->LOJA)+ALLTRIM(TMP1->ITEM)+SCH->CH_ITEM
					Dbselectarea("AKD")
					Dbsetorder(3)
					If Dbseek(SUBSTR(TMP1->FILIAL,1,4)+"    "+"000376"+"01"+_cChave)
						PutHtml({_cTipo,TMP1->FILIAL,(TMP1->EMISSAO),TMP1->NUM,TMP1->ITEM,"","",Transform(((TMP1->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
					Else
						PutHtml({_cTipo,TMP1->FILIAL,(TMP1->EMISSAO),TMP1->NUM,TMP1->ITEM,"","",Transform(((TMP1->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,"","","","","","","",""},1,0)
					Endif
					Dbselectarea("SCH")
					Dbskip()
				Enddo
			Else
				PutHtml({_cTipo,TMP1->FILIAL,(TMP1->EMISSAO),TMP1->NUM,TMP1->ITEM,"","",Transform(((TMP1->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),"Não encontrado rateio"},1,0)
			Endif
		Endif
		TMP1->(dbSkip())
	Enddo
	MontaTMP2()
	dbSelectArea("TMP2")
	While !TMP2->(EOF())
		_cChave:="SCP"+ALLTRIM(TMP2->FILIAL)+ALLTRIM(TMP2->NUM)+ALLTRIM(TMP2->ITEM)+ALLTRIM(TMP2->EMISSAO)
		Dbselectarea("AKD")
		Dbsetorder(3)
		If Dbseek(SUBSTR(TMP2->FILIAL,1,4)+"    "+"000150"+"01"+_cChave)
			PutHtml({"Req.Armazem",TMP2->FILIAL,(TMP2->EMISSAO),TMP2->NUM,TMP2->ITEM,"","",Transform(TMP2->XVLRTOT,'@E 999,999,999.99'),TMP2->CONTA,TMP2->CC,TMP2->ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
		eLSE
			PutHtml({"Req.Armazem",TMP2->FILIAL,(TMP2->EMISSAO),TMP2->NUM,TMP2->ITEM,"","",Transform(TMP2->XVLRTOT,'@E 999,999,999.99'),TMP2->CONTA,TMP2->CC,TMP2->ITEMCTA,"","","","","","","",""},1,0)
		Endif
		dbSelectArea("TMP2")
		Dbskip()
	Enddo
	MontaTMP3()
	dbSelectArea("TMP3")
	While !TMP3->(EOF())
		_cChave:="SZ0"+ALLTRIM(TMP3->FILIAL)+ALLTRIM(TMP3->NUMSV)+ALLTRIM(TMP3->ITEMSV)
		If TMP3->TOTAL > 0
			Dbselectarea("AKD")
			Dbsetorder(3)
			If Dbseek(SUBSTR(TMP3->FILIAL,1,4)+"    "+"900002"+"01"+_cChave)
				PutHtml({"Sol.Viagens",TMP3->FILIAL,(TMP3->DATAVI),TMP3->NUMSV,TMP3->ITEMSV,"","",Transform(((TMP3->TOTAL/100)*TMP3->PERC),'@E 999,999,999.99'),TMP3->CONTA,TMP3->CC,TMP3->ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
			eLSE
				PutHtml({"Sol.Viagens",TMP3->FILIAL,(TMP3->DATAVI),TMP3->NUMSV,TMP3->ITEMSV,"","",Transform(((TMP3->TOTAL/100)*TMP3->PERC),'@E 999,999,999.99'),TMP3->CONTA,TMP3->CC,TMP3->ITEMCTA,"","","","","","","",""},1,0)
			Endif
		Endif
		dbSelectArea("TMP3")
		Dbskip()
	Enddo
	MontaTMP4()
	dbSelectArea("TMP4")
	While !TMP4->(EOF())
		If TMP4->RATEIO == "2"
			Dbselectarea("CNE")
			Dbsetorder(4)
			If Dbseek(TMP4->FILIAL+ALLTRIM(TMP4->MEDICAO))
				_cChave:="CNE"+ALLTRIM(TMP4->FILIAL)+ALLTRIM(TMP4->CONTRA)+CNE->CNE_REVISA+CNE->CNE_NUMERO+ALLTRIM(TMP4->MEDICAO)+CNE->CNE_ITEM
				Dbselectarea("AKD")
				Dbsetorder(3)
				If Dbseek(SUBSTR(TMP4->FILIAL,1,4)+"    "+"000355"+"02"+_cChave)
					PutHtml({"Contratos",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(TMP4->TOTAL,'@E 999,999,999.99'),TMP4->CONTA,TMP4->CC,TMP4->ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
				eLSE
					PutHtml({"Contratos",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(TMP4->TOTAL,'@E 999,999,999.99'),TMP4->CONTA,TMP4->CC,TMP4->ITEMCTA,"","","","","","","",""},1,0)
				Endif
			Endif
		Else
			Dbselectarea("SCH")
			Dbsetorder(2)
			If Dbseek(ALLTRIM(TMP4->FILIAL)+ALLTRIM(TMP4->NUM)+ALLTRIM(TMP4->ITEM))
				While !EOF() .and. ALLTRIM(TMP4->NUM)==ALLTRIM(SCH->CH_PEDIDO) .AND. ALLTRIM(TMP4->ITEM)==ALLTRIM(SCH->CH_ITEMPD)
					
					_cChave:="CNZ"+ALLTRIM(TMP4->FILIAL)+ALLTRIM(TMP4->CONTRA)+TMP4->CONTREV+ALLTRIM(TMP4->MEDICAO)+ALLTRIM(TMP4->ITEMED)+SCH->CH_ITEM
					Dbselectarea("AKD")
					Dbsetorder(3)
					If Dbseek(SUBSTR(TMP4->FILIAL,1,4)+"    "+"000355"+"05"+_cChave)
						PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
					Else
						If Dbseek(SUBSTR(TMP4->FILIAL,1,4)+"    "+"000355"+"06"+_cChave)
							PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
						Else
							PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),SCH->CH_CONTA,SCH->CH_CC,SCH->CH_ITEMCTA,"","","","","","","",""},1,0)
						Endif
					Endif
					Dbselectarea("SCH")
					Dbskip()
				Enddo
			Else
				PutHtml({"Contratos/Rateio",TMP4->FILIAL,(TMP4->EMISSAO),TMP4->NUM,TMP4->ITEM,TMP4->CONTRA,TMP4->MEDICAO,Transform(((TMP4->TOTAL/100)*SCH->CH_PERC),'@E 999,999,999.99'),"Não encontrado rateio"},1,0)
			Endif
		Endif
		dbSelectArea("TMP4")
		Dbskip()
	Enddo
	//PutHtml({"","","","","","","","","","","",""},1,0)
	TMP1->(dbCloseArea()) //fecha o TMP da query
	TMP2->(dbCloseArea()) //fecha o TMP da query
	TMP3->(dbCloseArea()) //fecha o TMP da query
	TMP4->(dbCloseArea()) //fecha o TMP da query
ElseIf MV_PAR03 == "EM" .AND. MV_PAR04 = 2
	MontaTMP5()
	dbSelectArea("TMP5")
	While !TMP5->(EOF())
		If TMP5->RATEIO =="2"
			_cTipo:="Nota"
			_cChave:="SD1"+ALLTRIM(TMP5->FILIAL)+(TMP5->DOC)+(TMP5->SERIE)+(TMP5->FORNECE)+(TMP5->LOJA)+(TMP5->COD)+(TMP5->ITEM)
			
			Dbselectarea("AKD")
			Dbsetorder(3)
			If Dbseek(SUBSTR(TMP5->FILIAL,1,4)+"    "+"000054"+"01"+_cChave)
				PutHtml({_cTipo,TMP5->FILIAL,(TMP5->DTDIGIT),TMP5->DOC+"/"+TMP5->SERIE,TMP5->ITEM,"","",Transform(TMP5->TOTAL,'@E 999,999,999.99'),TMP5->CONTA,TMP5->CC,TMP5->ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
			Else
				PutHtml({_cTipo,TMP5->FILIAL,(TMP5->DTDIGIT),TMP5->DOC+"/"+TMP5->SERIE,TMP5->ITEM,"","",Transform(TMP5->TOTAL,'@E 999,999,999.99'),TMP5->CONTA,TMP5->CC,TMP5->ITEMCTA,"","","","","","","",""},1,0)
			Endif
		Else
			_cTipo:="Nota/Rateio"
			Dbselectarea("SDE")
			Dbsetorder(1)
			If Dbseek(ALLTRIM(TMP5->FILIAL)+(TMP5->DOC)+(TMP5->SERIE)+(TMP5->FORNECE)+(TMP5->LOJA)+(TMP5->ITEM))
				While !EOF() .and. ALLTRIM(TMP5->FILIAL)==ALLTRIM(SDE->DE_FILIAL) .and. ALLTRIM(TMP5->DOC)==ALLTRIM(SDE->DE_DOC) .AND. ALLTRIM(TMP5->SERIE)==ALLTRIM(SDE->DE_SERIE) .AND. ALLTRIM(TMP5->FORNECE)==ALLTRIM(SDE->DE_FORNECE) .AND. ALLTRIM(TMP5->LOJA)==ALLTRIM(SDE->DE_LOJA) .AND. ALLTRIM(TMP5->ITEM)==ALLTRIM(SDE->DE_ITEMNF)
					_cChave:="SDE"+ALLTRIM(TMP5->FILIAL)+(TMP5->DOC)+(TMP5->SERIE)+(TMP5->FORNECE)+(TMP5->LOJA)+ALLTRIM(TMP5->ITEM)+SDE->DE_ITEM
					Dbselectarea("AKD")
					Dbsetorder(3)
					If Dbseek(SUBSTR(TMP5->FILIAL,1,4)+"    "+"000054"+"09"+_cChave)
						PutHtml({_cTipo,TMP5->FILIAL,(TMP5->DTDIGIT),TMP5->DOC+"/"+TMP5->SERIE,TMP5->ITEM,"","",Transform(((TMP5->TOTAL/100)*SDE->DE_PERC),'@E 999,999,999.99'),SDE->DE_CONTA,SDE->DE_CC,SDE->DE_ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
					Else
						PutHtml({_cTipo,TMP5->FILIAL,(TMP5->DTDIGIT),TMP5->DOC+"/"+TMP5->SERIE,TMP5->ITEM,"","",Transform(((TMP5->TOTAL/100)*SDE->DE_PERC),'@E 999,999,999.99'),SDE->DE_CONTA,SDE->DE_CC,SDE->DE_ITEMCTA,"","","","","","","",""},1,0)
					Endif
					Dbselectarea("SDE")
					Dbskip()
				Enddo
			Else
				PutHtml({_cTipo,TMP5->FILIAL,(TMP5->DTDIGIT),TMP5->DOC+"/"+TMP5->SERIE,TMP5->ITEM,"","",Transform(((TMP5->TOTAL/100)*SDE->DE_PERC),'@E 999,999,999.99'),"Não encontrado rateio"},1,0)
			Endif
		Endif
		TMP5->(dbSkip())
	Enddo
	MontaTMP6()
	dbSelectArea("TMP6")
	While !TMP6->(EOF())
		_cChave:="SD3"+ALLTRIM(TMP6->FILIAL)+(TMP6->COD)+(TMP6->LOCAL)+(TMP6->NUMSEQ)+(TMP6->CF)
		Dbselectarea("AKD")
		Dbsetorder(3)
		If Dbseek(SUBSTR(TMP6->FILIAL,1,4)+"    "+"000151"+"02"+_cChave)
			PutHtml({"Bx.Req.Armazem",TMP6->FILIAL,(TMP6->EMISSAO),TMP6->NUMSEQ,TMP6->COD,"","",Transform(TMP6->CUSTO1,'@E 999,999,999.99'),TMP6->CONTA,TMP6->CC,TMP6->ITEMCTA,AKD->AKD_LOTE,AKD->AKD_STATUS,AKD->AKD_DATA,AKD->AKD_HIST,AKD->AKD_CO,AKD->AKD_CC,AKD->AKD_ITCTB,Transform(AKD->AKD_VALOR1,'@E 999,999,999.99')},1,0)
		eLSE
			PutHtml({"Bx.Req.Armazem",TMP6->FILIAL,(TMP6->EMISSAO),TMP6->NUMSEQ,TMP6->COD,"","",Transform(TMP6->CUSTO1,'@E 999,999,999.99'),TMP6->CONTA,TMP6->CC,TMP6->ITEMCTA,"","","","","","","",""},1,0)
		Endif
		dbSelectArea("TMP6")
		Dbskip()
	Enddo
	TMP5->(dbCloseArea()) //fecha o TMP da query
	TMP6->(dbCloseArea()) //fecha o TMP da query
ElseIf MV_PAR03 == "RE" .AND. (MV_PAR04 = 1 .OR. MV_PAR04 = 2)
	ALERT("A conferência do saldo realizado deve ser feita com os relatórios da contabilidade. (Balancete e Razão)")
Endif
FecHtml()
fClose(nHdl1)
ShellExecute('open', cPasta + "\" + cArq + ".xls",'','',SW_SHOWMAXIMIZED)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMP1  º Autor ³                   º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao PEDIDOS DE COMPRA (EM - CREDITO)          º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTMP1()
Local cQuery
Local cEnter := Chr(13)

If Select("TMP1") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP1")
	dbCloseArea()
EndIf

cQuery := " SELECT               " + CRLF
cQuery += " C7_FILIAL   FILIAL   " + CRLF
cQuery += ",C7_TOTAL    TOTAL    " + CRLF
cQuery += ",C7_ITEM     ITEM     " + CRLF
cQuery += ",C7_CC       CC       " + CRLF
cQuery += ",C7_ITEMCTA  ITEMCTA  " + CRLF
cQuery += ",C7_CONTA    CONTA    " + CRLF
cQuery += ",C7_EMISSAO  EMISSAO  " + CRLF
cQuery += ",C7_NUM      NUM      " + CRLF
cQuery += ",C7_RATEIO   RATEIO   " + CRLF
cQuery += ",C7_FORNECE  FORNECE  " + CRLF
cQuery += ",C7_LOJA     LOJA     " + CRLF
cQuery += " FROM " + RetSqlName("SC7") + " SC7 "  + CRLF
cQuery += " WHERE SC7.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND SC7.C7_XNUMSV = ' '                                " + CRLF
cQuery += " AND SC7.C7_EMISSAO >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND SC7.C7_EMISSAO <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " AND SC7.C7_CONTRA = ' '                                " + CRLF
cQuery += " ORDER BY C7_EMISSAO                                    " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP1", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMP2 º Autor ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao REQUISIÇÕES ARMAZEM (EM - CREDITO)        º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTMP2()
Local cQuery
Local cEnter := Chr(13)

If Select("TMP2") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP2")
	dbCloseArea()
EndIf

cQuery := " SELECT               " + CRLF
cQuery += " CP_FILIAL   FILIAL   " + CRLF
cQuery += ",CP_NUM      NUM      " + CRLF
cQuery += ",CP_XVLRTOT  XVLRTOT  " + CRLF
cQuery += ",CP_CC       CC       " + CRLF
cQuery += ",CP_ITEMCTA  ITEMCTA  " + CRLF
cQuery += ",CP_CONTA    CONTAP   " + CRLF
cQuery += ",CP_EMISSAO  EMISSAO  " + CRLF
cQuery += ",CP_ITEM     ITEM     " + CRLF
cQuery += ",B1_XCONTA1  CONTA    " + CRLF
cQuery += " FROM " + RetSqlName("SCP") + " SCP,  "  + CRLF
cQuery += "      " + RetSqlName("SB1") + " SB1   "  + CRLF
cQuery += " WHERE SCP.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND SCP.CP_EMISSAO >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND SCP.CP_EMISSAO <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " AND SB1.B1_FILIAL = '"+SUBSTR(XFILIAL("SCP"),1,4)+"'   " + CRLF
cQuery += " AND SB1.B1_COD    = SCP.CP_PRODUTO                     " + CRLF
cQuery += " ORDER BY CP_EMISSAO                                    " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP2", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMP3 º Autor ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao VIAGENS             (EM - CREDITO)        º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTMP3()
Local cQuery
Local cEnter := Chr(13)

If Select("TMP3") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP3")
	dbCloseArea()
EndIf

cQuery := " SELECT               " + CRLF
cQuery += " Z0_FILIAL   FILIAL   " + CRLF
cQuery += ",Z0_NUMSV    NUMSV    " + CRLF
cQuery += ",Z0_ITEM     ITEMSV   " + CRLF
cQuery += ",Z0_CCUSTO   CC       " + CRLF
cQuery += ",Z0_ITEMCTA  ITEMCTA  " + CRLF
cQuery += ",Z0_CONTA    CONTA    " + CRLF
cQuery += ",Z0_PERC     PERC     " + CRLF
cQuery += ",Z1_TOTAL    TOTAL    " + CRLF
cQuery += ",Z1_DATA     DATAVI   " + CRLF
cQuery += " FROM " + RetSqlName("SZ0") + " SZ0, " + RetSqlName("SZ1") + " SZ1  "  + CRLF
cQuery += " WHERE SZ0.D_E_L_E_T_ = ' '                          " + CRLF
cQuery += " AND SZ0.Z0_FILIAL = SZ1.Z1_FILIAL                   " + CRLF
cQuery += " AND SZ0.Z0_NUMSV  = SZ1.Z1_NUM                      " + CRLF
cQuery += " AND SZ1.D_E_L_E_T_ = ' '                            " + CRLF
cQuery += " AND SZ1.Z1_DATA >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND SZ1.Z1_DATA <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " AND SZ1.Z1_STATUS <> 'W'                            " + CRLF
cQuery += " ORDER BY Z1_DATA                                    " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP3", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMP4 º Autor ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao CONTRATOS           (EM - CREDITO)        º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTMP4()
Local cQuery
Local cEnter := Chr(13)

If Select("TMP4") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP4")
	dbCloseArea()
EndIf

If Select("TMP4") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP4")
	dbCloseArea()
EndIf

cQuery := " SELECT               " + CRLF
cQuery += " C7_FILIAL   FILIAL   " + CRLF
cQuery += ",C7_TOTAL    TOTAL    " + CRLF
cQuery += ",C7_ITEM     ITEM     " + CRLF
cQuery += ",C7_CC       CC       " + CRLF
cQuery += ",C7_ITEMCTA  ITEMCTA  " + CRLF
cQuery += ",C7_CONTA    CONTA    " + CRLF
cQuery += ",C7_EMISSAO  EMISSAO  " + CRLF
cQuery += ",C7_NUM      NUM      " + CRLF
cQuery += ",C7_RATEIO   RATEIO   " + CRLF
cQuery += ",C7_FORNECE  FORNECE  " + CRLF
cQuery += ",C7_LOJA     LOJA     "¦ + CRLF
cQuery += ",C7_CONTRA   CONTRA   " + CRLF
cQuery += ",C7_MEDICAO  MEDICAO  " + CRLF
cQuery += ",C7_CONTREV  CONTREV  " + CRLF
cQuery += ",C7_PLANILH  PLANILH  " + CRLF
cQuery += ",C7_ITEMED   ITEMED   " + CRLF
cQuery += " FROM " + RetSqlName("SC7") + " SC7 "  + CRLF
cQuery += " WHERE SC7.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND SC7.C7_XNUMSV = ' '                                " + CRLF
cQuery += " AND SC7.C7_EMISSAO >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND SC7.C7_EMISSAO <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " AND SC7.C7_CONTRA <> ' '                               " + CRLF
cQuery += " ORDER BY C7_EMISSAO                                    " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP4", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMP5  º Autor ³                   º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao NOTAS DE COMPRAS (EM - DEBITO)            º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTMP5()
Local cQuery
Local cEnter := Chr(13)

If Select("TMP5") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP5")
	dbCloseArea()
EndIf

cQuery := " SELECT               " + CRLF
cQuery += " D1_FILIAL   FILIAL   " + CRLF
cQuery += ",D1_TOTAL    TOTAL    " + CRLF
cQuery += ",D1_ITEM     ITEM     " + CRLF
cQuery += ",D1_CC       CC       " + CRLF
cQuery += ",D1_ITEMCTA  ITEMCTA  " + CRLF
cQuery += ",D1_CONTA    CONTA    " + CRLF
cQuery += ",D1_DTDIGIT  DTDIGIT  " + CRLF
cQuery += ",D1_DOC      DOC      " + CRLF
cQuery += ",D1_SERIE    SERIE    " + CRLF
cQuery += ",D1_RATEIO   RATEIO   " + CRLF
cQuery += ",D1_FORNECE  FORNECE  " + CRLF
cQuery += ",D1_LOJA     LOJA     " + CRLF
cQuery += ",D1_COD      COD      " + CRLF
cQuery += " FROM " + RetSqlName("SD1") + " SD1 "  + CRLF
cQuery += " WHERE SD1.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND SD1.D1_DTDIGIT >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND SD1.D1_DTDIGIT <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " ORDER BY D1_DTDIGIT                                    " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP5", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMP6  º Autor ³                   º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao BAIXA ESTOQUE (EM - DEBITO)               º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTMP6()
Local cQuery
Local cEnter := Chr(13)

If Select("TMP6") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP6")
	dbCloseArea()
EndIf

cQuery := " SELECT               " + CRLF
cQuery += " D3_FILIAL   FILIAL   " + CRLF
cQuery += ",D3_CUSTO1   CUSTO1   " + CRLF
cQuery += ",D3_COD      COD      " + CRLF
cQuery += ",D3_CC       CC       " + CRLF
cQuery += ",D3_ITEMCTA  ITEMCTA  " + CRLF
cQuery += ",D3_CONTA    CONTA    " + CRLF
cQuery += ",D3_EMISSAO  EMISSAO  " + CRLF
cQuery += ",D3_LOCAL    LOCAL    " + CRLF
cQuery += ",D3_NUMSEQ   NUMSEQ   " + CRLF
cQuery += ",D3_CF       CF       " + CRLF
cQuery += " FROM " + RetSqlName("SD3") + " SD3 "  + CRLF
cQuery += " WHERE SD3.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND SD3.D3_EMISSAO >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND SD3.D3_EMISSAO <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " ORDER BY D3_EMISSAO                                    " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP6", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMPSC1  º Autor ³                 º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao SOLICITAÇÕES DE CONTRATOS (SC - CREDITO)  º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTMPSC1()
Local cQuery
Local cEnter := Chr(13)

If Select("TMPSC1") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMPSC1")
	dbCloseArea()
EndIf

cQuery := " SELECT               " + CRLF
cQuery += " Z7_FILIAL   FILIAL   " + CRLF
cQuery += ",Z7_NUM      NUM      " + CRLF
cQuery += ",Z7_DTSOL    DTSOL    " + CRLF
cQuery += ",Z8_ITEMCTB  ITEMCTB  " + CRLF
cQuery += ",Z8_CONTA    CONTA    " + CRLF
cQuery += ",Z8_CUSTO    CUSTO    " + CRLF
cQuery += ",Z7_VLINI    VLINI    " + CRLF
cQuery += ",Z7_CONTRAT  CONTRATO " + CRLF
cQuery += ",Z7_STATUS   STATUS   " + CRLF
cQuery += ",Z8_PERC     PERC     " + CRLF
cQuery += ",Z8_ITEM     ITEM     " + CRLF
cQuery += " FROM " + RetSqlName("SZ7") + " SZ7, "  + CRLF
cQuery += " " + RetSqlName("SZ8") + " SZ8 "  + CRLF
cQuery += " WHERE SZ7.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND SZ7.Z7_DTSOL   >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND SZ7.Z7_DTSOL   <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " AND SZ8.Z8_FILIAL = SZ7.Z7_FILIAL                      " + CRLF
cQuery += " AND SZ8.Z8_NUMSC   = SZ7.Z7_NUM                        " + CRLF
cQuery += " AND SZ8.D_E_L_E_T_ = ' '                               " + CRLF
cQuery += " ORDER BY Z7_DTSOL                                      " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPSC1", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaTMPSC2  º Autor ³                 º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao GERAÇÃO DE CONTRATOS (SC - DEBITO)        º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaSC2()
Local cQuery
Local cEnter := Chr(13)

If Select("TMPSC2") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMPSC2")
	dbCloseArea()
EndIf

cQuery := " SELECT                 " + CRLF
cQuery += " CNB_FILIAL   FILIAL    " + CRLF
cQuery += ",CNB_NUMERO   PLANILHA  " + CRLF
cQuery += ",CNB_REVISA   REVISAO   " + CRLF
cQuery += ",CNB_DTCAD    DTCAD     " + CRLF
cQuery += ",CNB_ITEM     ITEM      " + CRLF
cQuery += ",CNB_VLTOT    VLTOT     " + CRLF
cQuery += ",CNB_CONTRA   CONTRATO  " + CRLF
cQuery += ",CNB_ITEMCT   ITEMCT    " + CRLF
cQuery += ",CNB_CONTA    CONTA     " + CRLF
cQuery += ",CNB_CC       CC        " + CRLF
cQuery += " FROM " + RetSqlName("CNB") + " CNB "  + CRLF
cQuery += " WHERE CNB.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND CNB.CNB_DTCAD  >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND CNB.CNB_DTCAD  <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " ORDER BY CNB_DTCAD                                     " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPSC2", .F., .T.)
dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MontaCO1  º Autor ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Query de selecao GERAÇÃO DE CONTRATOS (CO - CREDITO)       º±±
±±º          ³ 													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaCO1()
Local cQuery
Local cEnter := Chr(13)

If Select("TMPCO1") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMPCO1")
	dbCloseArea()
EndIf

cQuery := " SELECT                 " + CRLF
cQuery += " CNB_FILIAL   FILIAL    " + CRLF
cQuery += ",CNB_NUMERO   PLANILHA  " + CRLF
cQuery += ",CNB_REVISA   REVISAO   " + CRLF
cQuery += ",CNB_DTCAD    DTCAD     " + CRLF
cQuery += ",CNB_ITEM     ITEM      " + CRLF
cQuery += ",CNB_VLTOT    VLTOT     " + CRLF
cQuery += ",CNB_CONTRA   CONTRATO  " + CRLF
cQuery += ",CNB_ITEMCT   ITEMCT    " + CRLF
cQuery += ",CNB_CONTA    CONTA     " + CRLF
cQuery += ",CNB_CC       CC        " + CRLF
cQuery += " FROM " + RetSqlName("CNB") + " CNB "  + CRLF
cQuery += " WHERE CNB.D_E_L_E_T_ = ' '                             " + CRLF
cQuery += " AND CNB.CNB_DTCAD  >= '"+DTOS(MV_PAR01)+"'             " + CRLF
cQuery += " AND CNB.CNB_DTCAD  <= '"+DTOS(MV_PAR02)+"'             " + CRLF
cQuery += " ORDER BY CNB_DTCAD                                     " + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMPCO1", .F., .T.)
dbGotop()

Return Nil

