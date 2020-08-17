#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CSFISRESG³ Autor ³ Douglas David       ³ Data ³ Abril/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Relatorio  pedidos de venda MKT			                  ³±±
±±³			 ³ Com o objetivo de atender a O.S. 0009/16                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Alteracoes³ 23/05/16  OS 1418/16 Inclusão dos campos Cod.e razão social ±±
±±           ³            do Fornecedor - Douglas David	                   ±±
±±			 ³ 04/11/16  OS 3076/16 Inclusão do campo Filial. - Douglas    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSFISRESG()

Private nOpca       := 0
Private cCadastro   := "Relatorio Notas Fiscais MarketSystem"
Private aRegs := {}, aSays := {}, aButtons := {}
Private oExcelApp, cLin
Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPerg       := PADR("CSRESG",LEN(SX1->X1_GRUPO))
Private cFuncao     := " Processa( { || CSUPRESG() }, 'Processando os Dados.....' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private lSair       := .f.
Private oExcelApp

aAdd(aRegs,{cPerg,"01","Filial de:  		     ","","","mv_ch1","C",02,0,0,"G","			","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial ate:    			 ","","","mv_ch2","C",02,0,0,"G","			","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"03","Digitação Entrada de:    ","","","mv_ch3","D",08,0,0,"G","        	","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Digitação Entrada ate:   ","","","mv_ch4","D",08,0,0,"G","        	","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Emissão Entrada de:      ","","","mv_ch5","D",08,0,0,"G","        	","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Emissão Entrada ate:     ","","","mv_ch6","D",08,0,0,"G","        	","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Emissão Saída de:        ","","","mv_ch7","D",08,0,0,"G","        	","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Emissão Saída ate:       ","","","mv_ch8","D",08,0,0,"G","        	","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Resgate  de:             ","","","mv_ch9","C",30,0,0,"G","        	","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Resgate ate:             ","","","mv_cha","C",30,0,0,"G","        	","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Status:                  ","","","mv_chb","N",01,0,0,"C","        	","mv_par11","Falta Pedido","","","","","Falta NF","","","","","PV/Sem NF","","","","","Todos","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Salvar em:        		 ","","","mv_chc","C",40,0,0,"G","NaoVazio()","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","DIR","S","","","",""})
                                                                                                                                                                                                                                                                                                                   

nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")

U_ValidPerg(cPerg,aRegs)

Pergunte(cPerg,.f.)

If nHdl = -1
	Aviso("EXCEL","Nao esta sendo possivel acessar o diretorio de arquivos temporarios de sua estacao.",;
	{"&Fechar"},3,"Geracao de Arquivo Excel",,;
	"PCOLOCK")
	Return
Endif

Define MsDialog MkwDlg Title "Relotorio Notas Fiscais - MarketSystem" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Entradas vs Saídas MarketSystem" Size 141,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSUPRESG	³ Autor ³ Douglas David         ³ Data ³ Dez/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função de processamento do relatorio                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CSUPRESG()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cSelect    := ""

_cSelect +="SELECT DISTINCT D1.D1_FILIAL, D1.D1_DTDIGIT, D1.D1_EMISSAO, D1.D1_FORNECE, A2.A2_NOME, D1.D1_DOC, D1.D1_SERIE, D1.D1_CF, D1.D1_ITEMCTA,  D1.D1_COD, D1.D1_QUANT,  "
_cSelect +="D1.D1_VUNIT, D1.D1_TOTAL, D1.D1_PICM, D1.D1_BASEICM, D1.D1_VALICM, D1.D1_X_RESGP, D1.D1_X_RESG, D2.D2_X_RESG,C6.C6_NUM,  "
_cSelect +="C6.C6_PRODUTO, D2.D2_EMISSAO, D2.D2_DOC, D2.D2_SERIE, D2.D2_PICM, D2.D2_BASEICM, D2.D2_VALICM, F2.F2_EST, D2.D2_TOTAL 	  "
_cSelect +="FROM  "+RetSqlName('SD1')+" D1 (NOLOCK)"
_cSelect +="LEFT JOIN SA2050 A2 (NOLOCK) ON A2.A2_COD = D1.D1_FORNECE AND A2.D_E_L_E_T_ = ''	"
_cSelect +="LEFT JOIN SD2050 D2 (NOLOCK) ON D2.D2_FILIAL = D1.D1_FILIAL AND D2.D2_X_RESG = D1.D1_X_RESG AND D2.D2_COD = D1.D1_COD AND D2.D_E_L_E_T_ = ''	"
_cSelect +="LEFT JOIN SF2050 F2 (NOLOCK) ON F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND F2.D_E_L_E_T_ = ''		"
_cSelect +="LEFT JOIN SC6050 C6 (NOLOCK) ON C6.C6_FILIAL = D1.D1_FILIAL AND C6.C6_X_RESG = D1.D1_X_RESG AND C6.C6_PRODUTO = D1.D1_COD AND C6.D_E_L_E_T_ = '' "
_cSelect +="WHERE D1.D1_X_RESG <> '' "
_cSelect +="AND   D1.D1_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cSelect +="AND   D1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
_cSelect +="AND   D1.D1_EMISSAO BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"' "
If MV_PAR11 == 1
	_cSelect +="AND   C6.C6_NUM IS NULL "
ElseIf MV_PAR11 == 2
	_cSelect +="AND   D2.D2_EMISSAO IS NULL "
ElseIf MV_PAR11 == 3
	_cSelect +="AND D2.D2_DOC IS NULL  " 
	_cSelect +="AND C6.C6_NUM IS NOT NULL "
Endif
If !Empty (MV_PAR07)
	_cSelect +="AND   D2.D2_EMISSAO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"' "
    Endif
_cSelect +="AND   D1.D1_X_RESG  BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cSelect +="AND   D1.D_E_L_E_T_='' "
_cSelect +="ORDER BY D1.D1_X_RESG, D1.D1_DOC , D1.D1_DTDIGIT"

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

TCSetField("TRBATF","FILIAL",	      	"C", TamSX3("D1_FILIAL")[1],TamSX3("D1_FILIAL")[2])
TCSetField("TRBATF","DTDIGIT",      	"D", TamSX3("D1_DTDIGIT")[1],TamSX3("D1_DTDIGIT")[2])
TCSetField("TRBATF","EMISSAO",    		"D", TamSX3("D1_EMISSAO")[1],TamSX3("D1_EMISSAO")[2])
TCSetField("TRBATF","CODFOR",  	  		"C", TamSX3("D1_FORNECE")[1],TamSX3("D1_FORNECE")[2])
TCSetField("TRBATF","FORNECEDOR", 		"C", TamSX3("A2_NOME")[1],TamSX3("A2_NOME")[2])
TCSetField("TRBATF","DOC",      		"C", TamSX3("D1_DOC")[1],TamSX3("D1_DOC")[2])
TCSetField("TRBATF","SERIE",    		"C", TamSX3("D1_SERIE")[1],TamSX3("D1_SERIE")[2])
TCSetField("TRBATF","CFOP", 	 		"C", TamSX3("D1_CF")[1],TamSX3("D1_CF")[2])
TCSetField("TRBATF","UNIDNEGOCIO",		"C", TamSX3("D1_ITEMCTA")[1],TamSX3("D1_ITEMCTA")[2])
TCSetField("TRBATF","PRODUTO",   		"C", TamSX3("D1_COD")[1],TamSX3("D1_COD")[2])
TCSetField("TRBATF","QTD",  	 		"C", TamSX3("D1_QUANT")[1],TamSX3("D1_QUANT")[2])
TCSetField("TRBATF","VALOR",   			"N", TamSX3("D1_VUNIT")[1],2)
TCSetField("TRBATF","TOTAL",   			"N", TamSX3("D1_TOTAL")[1],2)
TCSetField("TRBATF","ALIQICM", 			"N", TamSX3("D1_PICM")[1],2)
TCSetField("TRBATF","BASEICM", 			"N", TamSX3("D1_BASEICM")[1],2)
TCSetField("TRBATF","VALICM", 			"N", TamSX3("D1_VALICM")[1],2)
TCSetField("TRBATF","RESGGP",  			"C", TamSX3("D1_X_RESGP")[1],TamSX3("D1_X_RESGP")[2]) 
TCSetField("TRBATF","RESGATE",   		"C", TamSX3("D2_X_RESG")[1],TamSX3("D2_X_RESG")[2]) 
TCSetField("TRBATF","PEDIDO",   		"C", TamSX3("C6_NUM")[1],TamSX3("C6_NUM")[2]) 
TCSetField("TRBATF","PRODUTO",   		"C", TamSX3("C6_PRODUTO")[1],TamSX3("C6_PRODUTO")[2]) 
TCSetField("TRBATF","EMISSAOSAIDA", 	"C", TamSX3("D2_EMISSAO")[1],TamSX3("D2_EMISSAO")[2]) 
TCSetField("TRBATF","DOCSAIDA",   		"C", TamSX3("D2_DOC")[1],TamSX3("D2_DOC")[2]) 
TCSetField("TRBATF","SERIESAIDA",  		"C", TamSX3("D2_SERIE")[1],TamSX3("D2_SERIE")[2]) 
TCSetField("TRBATF","ESTSAIDA",   		"C", TamSX3("F2_EST")[1],TamSX3("F2_EST")[2]) 
TCSetField("TRBATF","ALIQICM", 			"N", TamSX3("D2_PICM")[1],2)
TCSetField("TRBATF","BASEICM", 			"N", TamSX3("D2_BASEICM")[1],2)
TCSetField("TRBATF","VALICM", 			"N", TamSX3("D2_VALICM")[1],2)
TCSetField("TRBATF","VALOR",   			"N", TamSX3("D2_TOTAL")[1],2)


If TRBATF->(Eof().And.Bof())
	Aviso("A T E N C A O","Nao há dados a serem processados",{'Ok'})
	Return()
	TRBATF->(dbCloseArea())
EndIf

DbSelectArea("TRBATF")

copy to &(cCmd)

CpyS2T(cCmd,cTempPath,.T.)

__CopyFile(cTempPath+cArquivo+".xls", AllTrim(MV_PAR12)+".xls")

Ferase( cCmd ) 
Alert("Relatório gerado com sucesso! Verifique no diretório: "+AllTrim(MV_PAR12))

Return