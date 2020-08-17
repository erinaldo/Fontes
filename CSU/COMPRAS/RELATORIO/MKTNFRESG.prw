#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ MKTNFRESG³ Autor ³     Eduardo Dias      ³ Data ³  06/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Relatorio  notas fiscais da MarketSystem                   ³±±
±±³			 ³ (Centro de Custo 0701020000) - O.S. 1366/16                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteração ³ OS 1947/16 INSERÇÃO DE NOVOS CAMPOS NO REL DE NF OPT+   	  ³±±
±±³			 ³ 27/07/2016 - Douglas Coelho							      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MKTNFRESG()

Private nOpca       := 0
Private cCadastro   := "Relatorio Notas Fiscais MarketSystem"
Private aMkt := {}, aSays := {}, aButtons := {}
Private oExcelApp, cLin
Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPerg 		:= PADR("MKTNF",LEN(SX1->X1_GRUPO)) //PADR("CSRESG",LEN(SX1->X1_GRUPO))
Private cFuncao     := " Processa( { || MKTPRESG() }, 'Processando os Dados.....' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private lSair       := .f.
Private oExcelApp

AjustaX1(cPerg)


nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")

Pergunte(cPerg,.f.)

If nHdl = -1
	Aviso("EXCEL","Nao esta sendo possivel acessar o diretorio de arquivos temporarios de sua estacao.",;
	{"&Fechar"},3,"Geracao de Arquivo Excel",,;
	"PCOLOCK")
	Return
Endif

Define MsDialog MkwDlg Title "Relação de Notas Fiscais - MarketSystem" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "	 Notas Fiscais da MarketSystem " Size 141,8
@ 050,015 Say "	 Centro de Custo = 0701020000" Size 141,8
@ 020,173 Button "_Parametro" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ MKTPRESG ³ Autor ³     Eduardo Dias      ³ Data ³  06/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função de processamento do relatorio                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MKTPRESG()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cSelect    := ""

_cSelect +="SELECT DISTINCT A2.A2_COD, A2.A2_NOME, D1.D1_DOC, D1.D1_SERIE, D1.D1_EMISSAO, D1.D1_XDTAQUI, E2.E2_VENCTO, D1.D1_COD, D1.D1_ITEM," 
_cSelect +="D1.D1_QUANT, D1.D1_PEDIDO, F1.F1_FRETE, D1.D1_TOTAL,  F1.F1_VALMERC, F1.F1_VALBRUT, F1.F1_DESCONT, F1.F1_BASEICM, F1.F1_VALICM,  "
_cSelect +="F1.F1_BASEIPI, F1.F1_VALIPI, F1.F1_TIPO, E2.E2_HIST, D1.D1_CC, D1.D1_ITEMCTA,  D1.D1_CLVL, F1.F1_DTDIGIT, D1.D1_X_RESG, "
_cSelect +="C7.C7_X_NFGP, D1.D1_X_RESGP, A1.A1_COD, A1.A1_NOME, A1.A1_CGC, B1.B1_DESC "
_cSelect +="FROM  SD1050 D1 (NOLOCK) "
_cSelect +="LEFT JOIN SF1050 F1 (NOLOCK) ON F1.F1_FILIAL = D1.D1_FILIAL AND F1.F1_DOC = D1.D1_DOC AND F1.F1_SERIE = D1.D1_SERIE AND F1.D_E_L_E_T_ = '' "
_cSelect +="LEFT JOIN SC7050 C7 (NOLOCK) ON C7.C7_X_RESG = D1.D1_X_RESG AND C7.C7_PRODUTO = D1.D1_COD AND C7.C7_NUM = D1.D1_PEDIDO AND C7.D_E_L_E_T_ = '' "
_cSelect +="LEFT JOIN SC6050 C6 (NOLOCK) ON C6.C6_FILIAL = D1.D1_FILIAL AND C6.C6_X_RESG = D1.D1_X_RESG AND C6.C6_PRODUTO = D1.D1_COD AND C6.D_E_L_E_T_ = '' "
_cSelect +="LEFT JOIN SB1050 B1 (NOLOCK) ON B1.B1_COD = D1.D1_COD AND B1.D_E_L_E_T_ = '' "
_cSelect +="LEFT JOIN SA2050 A2 (NOLOCK) ON A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA AND A2.D_E_L_E_T_ = '' "
_cSelect +="LEFT JOIN SA1050 A1 (NOLOCK) ON A1.A1_COD = C6.C6_CLI AND A1.D_E_L_E_T_ = '' "
_cSelect +="LEFT JOIN SE2050 E2 (NOLOCK) ON E2.E2_NUM = F1.F1_DOC AND E2.D_E_L_E_T_ = '' "
_cSelect +="WHERE D1_CC = '0701020000' "
_cSelect +="AND D1.D1_X_RESG <> '' "
_cSelect +="AND D1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
_cSelect +="AND D1.D1_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
_cSelect +="AND D1.D1_X_RESG BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cSelect +="AND D1.D_E_L_E_T_ = '' "
_cSelect +="ORDER BY D1.D1_X_RESG, D1.D1_DOC , F1.F1_DTDIGIT "


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha alias caso esteja aberto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TRBATF") > 0
	DBSelectArea("TRBATF")
	DBCloseArea()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a Query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TCQUERY _cSelect NEW ALIAS "TRBATF"
IncProc("Selecionando Registros...")

DBSelectArea("TRBATF")

TCSetField("TRBATF","CODFOR", 			"C", TamSX3("A2_COD")[1],TamSX3("A2_COD")[2])
TCSetField("TRBATF","RAZAOSOCIAL",     	"C", TamSX3("A2_NOME")[1],TamSX3("A2_NOME")[2])
TCSetField("TRBATF","DOC",      		"C", TamSX3("D1_DOC")[1],TamSX3("D1_DOC")[2])
TCSetField("TRBATF","SERIE",    		"C", TamSX3("D1_SERIE")[1],TamSX3("D1_SERIE")[2])
TCSetField("TRBATF","EMISSAO",    		"D", TamSX3("D1_EMISSAO")[1],TamSX3("D1_EMISSAO")[2])
TCSetField("TRBATF","COMPETENCIA",  	"C", TamSX3("D1_XDTAQUI")[1],TamSX3("D1_XDTAQUI")[2])
TCSetField("TRBATF","VENCIMENT",      	"D", TamSX3("E2_VENCTO")[1],TamSX3("E2_VENCTO")[2])
TCSetField("TRBATF","CODPRO",   		"C", TamSX3("D1_COD")[1],TamSX3("D1_COD")[2])
TCSetField("TRBATF","ITEM", 	  		"C", TamSX3("D1_ITEM")[1],TamSX3("D1_ITEM")[2])
TCSetField("TRBATF","QUANT",   	 		"N", TamSX3("D1_QUANT")[1],2)
TCSetField("TRBATF","PEDIDO",   	 	"C", TamSX3("D1_PEDIDO")[1],TamSX3("D1_PEDIDO")[2])
TCSetField("TRBATF","F1_FRETE",   		"N", TamSX3("F1_FRETE")[1],2)
TCSetField("TRBATF","TOTAL",   	 		"N", TamSX3("D1_TOTAL")[1],2)
TCSetField("TRBATF","F1_VALMERC",  		"N", TamSX3("F1_VALMERC")[1],2)
TCSetField("TRBATF","F1_VALBRUT",  		"N", TamSX3("F1_VALBRUT")[1],2)
TCSetField("TRBATF","F1_DESCONT",  		"N", TamSX3("F1_DESCONT")[1],2)
TCSetField("TRBATF","F1_BASEICM",  		"N", TamSX3("F1_BASEICM")[1],2)
TCSetField("TRBATF","F1_VALICM",  		"N", TamSX3("F1_VALICM")[1],2)
TCSetField("TRBATF","F1_BASEIPI",  		"N", TamSX3("F1_BASEIPI")[1],2)
TCSetField("TRBATF","F1_VALIPI",  		"N", TamSX3("F1_VALIPI")[1],2)
TCSetField("TRBATF","F1_TIPO",     		"C", TamSX3("F1_TIPO")[1],TamSX3("F1_TIPO")[2])
TCSetField("TRBATF","E2_HIST",     		"C", TamSX3("E2_HIST")[1],TamSX3("E2_HIST")[2])
TCSetField("TRBATF","CC",      			"C", TamSX3("D1_CC")[1],TamSX3("D1_CC")[2])
TCSetField("TRBATF","UNIDNEGOCIO",		"C", TamSX3("D1_ITEMCTA")[1],TamSX3("D1_ITEMCTA")[2])
TCSetField("TRBATF","CLVL", 		   	"C", TamSX3("D1_CLVL")[1],TamSX3("D1_CLVL")[2])
TCSetField("TRBATF","F1_DTDIGIT",    	"D", TamSX3("F1_DTDIGIT")[1],TamSX3("F1_DTDIGIT")[2])
TCSetField("TRBATF","D1_X_RESG", 	   	"C", TamSX3("D1_X_RESG")[1],TamSX3("D1_X_RESG")[2])
TCSetField("TRBATF","NUMNFGP", 	  		"C", TamSX3("C7_X_NFGP")[1],TamSX3("C7_X_NFGP")[2])
TCSetField("TRBATF","D1_X_RESGP", 	   	"C", TamSX3("D1_X_RESGP")[1],TamSX3("D1_X_RESGP")[2])
TCSetField("TRBATF","A1_COD",     		"C", TamSX3("A1_COD")[1],TamSX3("A1_COD")[2])
TCSetField("TRBATF","A1_NOME",     		"C", TamSX3("A1_NOME")[1],TamSX3("A1_NOME")[2])
TCSetField("TRBATF","A1_CGC",     		"C", TamSX3("A1_CGC")[1],TamSX3("A1_CGC")[2])
TCSetField("TRBATF","PRODUTO",   		"C", TamSX3("B1_DESC")[1],TamSX3("B1_DESC")[2])


If TRBATF->(Eof().And.Bof())
	Aviso("A T E N C A O","Nao há dados a serem processados",{'Ok'})
	Return()
	TRBATF->(dbCloseArea())
EndIf

DbSelectArea("TRBATF")

copy to &(cCmd)

CpyS2T(cCmd,cTempPath,.T.)

__CopyFile(cTempPath+cArquivo+".xls", AllTrim(MV_PAR07)+".xls")

Ferase( cCmd )
Alert("Relatório gerado com sucesso! Verifique no diretório: "+AllTrim(MV_PAR07))

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VALIDPERG ³ Autor ³ Marcio Costa          ³ Data ³ 01/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Criacao das perguntas do relatorio no arquivo SX1           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaX1(cPerg)

Private aRegs := {}

_sAlias := Alias()

DBSelectArea("SX1")
DBSetOrder(1)

aAdd(aRegs,{cPerg,"01","Digitação Entrada de:    ","","","mv_ch1","D",08,0,0,"G","        	","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Digitação Entrada Ate:   ","","","mv_ch2","D",08,0,0,"G","        	","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Emissão Entrada de:      ","","","mv_ch3","D",08,0,0,"G","        	","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Emissão Entrada Ate:     ","","","mv_ch4","D",08,0,0,"G","        	","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Resgate  de:             ","","","mv_ch5","C",30,0,0,"G","        	","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Resgate ate:             ","","","mv_ch6","C",30,0,0,"G","        	","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Salvar em:        		 ","","","mv_ch7","C",40,0,0,"G","NaoVazio()","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","DIR","S","","","",""})


For i:=1 to Len(aRegs)
	If ! DBSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

DBSkip()

DBSelectArea(_sAlias)

Return
