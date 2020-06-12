#Include "PROTHEUS.CH"
#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CFATR01  ³ Autor ³ Daniel G.Jr.TI1239       ³ Data ³ Abr/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Notas Fiscais de Saída por C.R. (Centro Referencia)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CFATR01(void)                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CIEE                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFATR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1    := "Este relatorio ira imprimir a relação de Notas Fiscais de "
Local cDesc2    := "Saida por C.R.           "
Local cDesc3    := ""
Local wnrel
Local cString   := "SF2"
Local Tamanho   := "G"
Local aUserX    := {}

Private titulo  := "Relação de Notas Fiscais por C.R."
Private cabec1
Private cabec2
Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
Private nomeprog:= "CFATR01"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "CFATR01"
Private aUserY	:={}
aUserX    		:= AllUsers(.F.,.T.)

// Obter dados dos usuários (nome, departamento)
For _nI:=1 to Len(aUserX)
	aAdd(aUserY, { aUserX[_nI][1][2], aUserX[_nI][1][12] } )
Next _nI
aUserY := aSort( aUserY,,,{ |x,y| x[1] < y[1] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos Cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("Relacao de Notas Fiscais por C.R.")

cabec1 := OemToAnsi("Data Pedido  C.R.       Descrição do C.R.                         Nr.NF.     Qtde.Volume  Peso         Valor            Tipo de Material")
//                   0         10        20        30        40        50        60        70        80        90        100                 120
//                   0123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,1234567
//                   00           13         24                                        66         77           90           103
//                   dd/mm/aaaa   123456789  123456789,123456789,123456789,123456789,  999999999  999,999,999  9999,999.99  9999,999,999.99
cabec2 := " "

ValidPerg(cPerg)
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01			Da Dt.Emissão						  ³
//³ mv_par02			Ate Dt.Emissão						  ³
//³ mv_par03			Da Nota Fiscal						  ³
//³ mv_par04			Ate Nota Fiscal						  ³
//³ mv_par05			Da Serie							  ³
//³ mv_par06			Ate a Serie							  ³
//³ mv_par07			Do C.R.								  ³
//³ mv_par08			Ate o C.R.							  ³
//³ mv_par09			Gera Planilha						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= "CFATR01"            //Nome Default do relatorio em Disco
aOrd := {}
wnrel:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| CFATR01Imp(@lEnd,wnRel,cString)},titulo)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CFATR01IMP³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ Abr/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de NFs por CR                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CFATR01Imp(lEnd,wnRel,cString)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡ao do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem			                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CIEE                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CFATR01Imp(lEnd,wnRel,cString)

Local CbCont,CbTxt
Local tamanho   := "G"
Local limite    := 132
Local nOrdem
Local nTotch:=0,nTotVal:=0,nTotchg:=0,nTotValg:=0,nFirst:=0
Local lContinua := .T.,nTipo
Local cDepto	:= ""
Local nLocal	:= 0

Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPlan		:= ""

nTipo:=Iif(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem   := aReturn[8]

SetRegua(RecCount())

cQuery := "SELECT DISTINCT F2_DOC, F2_SERIE, F2_EMISSAO, F2_PLIQUI, F2_VOLUME1, F2_VALBRUT "
cQuery +=      ", C5_XCR, CTT_DESC01, C5_XUSERLG "
cQuery +=   "FROM " + RetSqlName("SF2") + " SF2 (NOLOCK) "
cQuery +=      ", " + RetSqlName("SD2") + " SD2 (NOLOCK) "
cQuery +=      ", " + RetSqlName("SC5") + " SC5 (NOLOCK) "
cQuery +=      ", " + RetSqlName("CTT") + " CTT (NOLOCK) "
cQuery +=  "WHERE F2_FILIAL = '" + xFilial("SF2") + "' "
cQuery +=    "AND F2_DOC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery +=    "AND F2_SERIE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
cQuery +=    "AND F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery +=    "AND SF2.D_E_L_E_T_='' "
cQuery +=    "AND D2_FILIAL = '" + xFilial("SD2") +"' "
cQuery +=    "AND D2_DOC = F2_DOC "
cQuery +=    "AND D2_SERIE = F2_SERIE "
cQuery +=    "AND D2_CLIENTE = F2_CLIENTE "
cQuery +=    "AND D2_LOJA = F2_LOJA "
cQuery +=    "AND D2_PEDIDO <> '' "
cQuery +=    "AND SD2.D_E_L_E_T_='' "
cQuery +=    "AND C5_FILIAL = '" +xFilial("SC5") + "' "
cQuery +=    "AND C5_NUM = D2_PEDIDO "
cQuery +=    "AND C5_CLIENTE = D2_CLIENTE "
cQuery +=    "AND C5_LOJACLI = D2_LOJA "
cQuery +=    "AND C5_XCR BETWEEN '" + mv_par07 +"' AND '" + mv_par08 + "' "
cQuery +=    "AND SC5.D_E_L_E_T_='' "
cQuery +=    "AND CTT_FILIAL = '" +xFilial("CTT") + "' "
cQuery +=    "AND CTT_CUSTO = C5_XCR "
cQuery +=    "AND CTT.D_E_L_E_T_='' "
cQuery += "ORDER BY F2_EMISSAO, C5_XCR, F2_DOC
cQuery := ChangeQuery(cQuery)

If Select("TRAB")>0
	TRAB->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRAB', .F., .T.)

If TRAB->(Eof().And.Bof())
	MsgAlert("Não há registros a serem processados!","Atenção!")
	TRAB->(dbCloseArea())
	Return
EndIf

TCSetField('TRAB', "F2_EMISSAO"	, "D", 8, 0 )
TCSetField('TRAB', "F2_PLIQUI" 	, "N", TamSX3("F2_PLIQUI")[1] , TamSX3("F2_PLIQUI")[2]  )
TCSetField('TRAB', "F2_VOLUME1" , "N", TamSX3("F2_VOLUME1")[1], TamSX3("F2_VOLUME1")[2] )
TCSetField('TRAB', "F2_VALBRUT" , "N", TamSX3("F2_VALBRUT")[1], TamSX3("F2_VALBRUT")[2] )

// Cria cabecalho html da planilha
If mv_par09==1
	CabPlan()
EndIf

While TRAB->(!Eof())
	
	If lEnd
		@Prow()+1,001 Psay OemToAnsi("Cancelado pelo Operador")
		Exit
	EndIf
	
	IncRegua()
	
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		nFirst:=0
	Endif
	            
	// Traz o departamento do usuário requisitante
	nLocal := aScan( aUserY, {|x| x[1]==AllTrim(TRAB->C5_XUSERLG)} )
	If nLocal>0
		cDepto := aUserY[nLocal][2]
		cDepto := Iif(Upper(cDepto)=="COMPRAS E ESTOQUE","SUPRIMENTOS ALMOXARIFADO",Iif(Upper(cDepto)=="RELACIONAMENTO COM USUARIOS","SUPRIMENTOS INFORMATICA","SEM IDENTIFICAÇÃO"))
	Else
		cDepto := "SEM IDENTIFICAÇÃO"
	EndIf
	
	@li , 000 Psay TRAB->F2_EMISSAO
	@li , 013 Psay TRAB->C5_XCR
	@li , 024 Psay TRAB->CTT_DESC01
	@li , 066 Psay TRAB->F2_DOC
	@li , 077 Psay TRAB->F2_VOLUME1	Picture "@E 999,999,999"
	@li , 090 Psay TRAB->F2_PLIQUI 	Picture "@E 9999,999.99"
	@li , 103 Psay TRAB->F2_VALBRUT Picture "@E 9999,999,999.99"
	@li , 120 Psay cDepto
	
	cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+RetCpo(TRAB->F2_EMISSAO)+"</td>"
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+RetCpo(TRAB->C5_XCR)+"</td>"
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+TRAB->CTT_DESC01+"</td>"
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+RetCpo(TRAB->F2_DOC)+"</td>"
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+TransForm(TRAB->F2_VOLUME1,"@E 999,999,999")+"</td>"
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl69>"+TransForm(TRAB->F2_PLIQUI ,"@E 9999,999.99")+"</td>"
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl69>"+TransForm(TRAB->F2_VALBRUT,"@E 9999,999,999.99")+"</td>"
	cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl69>"+cDepto+"</td>"
	cPlan += '  </TR>'
	
	li++
	
	TRAB->(dbSkip())
	
Enddo


cPlan += '</tr></TBODY></TABLE></BODY></HTML>'

If li != 80
	roda(cbcont,cbtxt,"M")
EndIf

Set Device To Screen
TRAB->(dbCloseArea())

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

If mv_par09==1		// Gera planilha
	GeraPlan()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³GeraPlan  ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ Fev/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³Gera planilha do relatorio                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estapar                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraPlan()

// Grava linha a linha no arquivo XLS
xAddToFile( cPlan, cCmd )

IncProc('Gerando Planilha....')

CpyS2T(cDirDocs+"\"+cArquivo+".xls",cTempPath,.T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".xls")
oExcelApp:SetVisible(.T.)

If MsgYesNo("Deseja fechar a planilha do excel?")
	oExcelApp:Quit()
	oExcelApp:Destroy()
EndIf

Ferase( cDirDocs+"\"+cArquivo+".xls" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabPlan   ºAutor  ³ Daniel G.Jr.TI1239    ³ Data ³ Fev/2013 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria cabecalho da planilha                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estapar                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CabPlan()

cPlan := '<HTML><HEAD><TITLE></TITLE>'
cPlan += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
cPlan += '<META content="text/html; charset=windows-1252" http-equiv=Content-Type>'
cPlan += '<META name=GENERATOR content="MSHTML 9.00.8112.16457"></HEAD>'
cPlan += '<BODY>'
cPlan += '<TABLE style="WIDTH: 871pt; BORDER-COLLAPSE: collapse; TABLE-LAYOUT: fixed" '
cPlan += 'border=1 cellSpacing=0 cellPadding=0 width=1162>'
cPlan += '<TBODY>'
cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'
cPlan += '    <TD style="WIDTH: 871pt; HEIGHT: 15.75pt" class=xl67 height=21 width=1162 colSpan=8>'
cPlan += '      <P align=center>Relação de Notas Fiscais por C.R.</P></TD></TR>'
cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'
cPlan += '    <TD style="HEIGHT: 15.75pt; BORDER-TOP: medium none" class=xl71 height=21>Dt.Emissão</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl71>C.R.</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl71>Descrição C.R.</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl68>Nr.NF</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>Qtde.Volume</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>Peso</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>Valor</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>Tipo Material</TD>'
cPlan += '  </TR>'
//cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'

// Grava linha a linha no arquivo XLS
xAddToFile( cPlan, cCmd )

cPlan := ""

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAddToFileºAutor  ³ Daniel G.Jr.TI1239    ³ Data ³ Fev/2013 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona a linha de log ao fim de um arquivo.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr04.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAddToFile( cLog, cToFile )

Local nHdl  := -1
Local cBuff := cLog

If File( cToFile )
	
	nHdl := FOpen( cToFile, 1 )
	
	If nHdl >= 0
		
		FSeek( nHdl, 0, 2 )
		
	EndIf
	
Else
	
	nHdl := FCreate( cToFile )
	
EndIf

If nHdl >= 0
	
	FWrite( nHdl,  cBuff, Len( cBuff ) )
	
EndIf

FClose( nHdl )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetCpo   ºAutor  ³ Daniel G.Jr.TI1239    ³ Data ³ Fev/2013 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna campo no formato correto para planilha              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr04.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetCpo(cCpo)

If ValType(cCpo)=="D"
	If Empty(cCpo)
		cCpo := ""
	Else
		cCpo := DtoC(cCpo)
	EndIf
Else
	If !Empty(cCpo)
		If !IsAlpha(cCpo)
			cCpo := "'"+cCpo
		EndIf
	EndIf
EndIf

Return(cCpo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ValidPerg ³ Autor ³ Daniel G.Jr.TI1239    ³ Data ³ Fev/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³Gera SX1 da rotina                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estapar                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg( cPerg )
Local aArea := GetArea(),;
aRegs := {},;
i, j

DbSelectArea( "SX1" )
DbSetOrder( 1 )

cPerg := PadR( cPerg,10 )
AAdd( aRegs, { cPerg,"01","Da Dt.Emissão  ?","","","mv_ch1","D",8					  ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AAdd( aRegs, { cPerg,"02","Ate Dt.Emissão ?","","","mv_ch2","D",8                     ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AAdd( aRegs, { cPerg,"03","Da Nota Fiscal ?","","","mv_ch3","C",TamSX3("F2_DOC")[1]	  ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","","","" } )
AAdd( aRegs, { cPerg,"04","Ate Nota Fiscal?","","","mv_ch4","C",TamSX3("F2_DOC")[1]	  ,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","","","" } )
AAdd( aRegs, { cPerg,"05","Da Serie       ?","","","mv_ch5","C",TamSX3("F2_SERIE")[1] ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AAdd( aRegs, { cPerg,"06","Ate a Serie    ?","","","mv_ch6","C",TamSX3("F2_SERIE")[1] ,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AAdd( aRegs, { cPerg,"07","Do C.R.        ?","","","mv_ch7","C",TamSX3("CTT_CUSTO")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","","" } )
AAdd( aRegs, { cPerg,"08","Ate o C.R.     ?","","","mv_ch8","C",TamSX3("CTT_CUSTO")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","","" } )
AAdd( aRegs, { cPerg,"15","Gera Planilha  ?","","","mv_ch9","N",1                     ,0,2,"C","","mv_par09","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","","","" } )

For i := 1 TO Len( aRegs )
	If !DbSeek( cPerg + aRegs[i,2] )
		RecLock( "SX1", .T. )
		For j := 1 TO FCount()
			If j <= Len( aRegs[i] )
				FieldPut( j, aRegs[i,j] )
			EndIf
		Next
		MsUnlock()
	EndIf
Next

RestArea( aArea )

Return
