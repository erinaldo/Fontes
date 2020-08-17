#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSATFR02   บAutor  ณ Renato Carlos    บ Data ณ  Jun/2009    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo xls com dados de ativo fixo                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU - Ativo                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CSATFR02()

Private nOpca       := 0
Private cCadastro   := "Geracao de Planilha com Rela็ใo de Ativos"
Private aRegs := {}, aSays := {}, aButtons := {}
Private oExcelApp, cLin
Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPerg       := PADR("CSAFR1",LEN(SX1->X1_GRUPO))
Private cFuncao     := " Processa( { || Rctbr02a() }, 'Processando o Verificacao....' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private lSair       := .f.
Private oExcelApp

aAdd(aRegs,{cPerg,"01","Filial de        ","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial ate       ","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"03","Conta de         ","","","mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
aAdd(aRegs,{cPerg,"04","Conta ate        ","","","mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
aAdd(aRegs,{cPerg,"05","Fornecedor de    ","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
aAdd(aRegs,{cPerg,"06","Fornecedor ate   ","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
aAdd(aRegs,{cPerg,"07","Aquisi็ใo de     ","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","","",""})
aAdd(aRegs,{cPerg,"08","Aquisi็ใo ate    ","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","","",""})
aAdd(aRegs,{cPerg,"09","Centro Custo de  ","","","mv_ch9","C",20,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})
aAdd(aRegs,{cPerg,"10","Centro Custo ate ","","","mv_ch10","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})


nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")

U_ValidPerg(cPerg,aRegs)

Pergunte(cPerg,.f.)

If nHdl = -1
	Aviso("EXCEL","Nao esta sendo possivel acessar o diretorio de arquivos temporarios de sua estacao.",;
	{"&Fechar"},3,"Geracao de Arquivo Excel",,;
	"PCOLOCK")
	Return
Endif

Define MsDialog MkwDlg Title "Rela็ใo de Ativos" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Listagem de ativos conforme os parโmetros do usuแrio" Size 141,8
//@ 045,015 Say "binadas de forma incorreta. "                         Size 142,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rctbr02a บAutor  ณ Sergio Oliveira    บ Data ณ  Fev/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento do relatorio.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rctbr02.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rctbr02a()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local _cSelect    := ""
//Local _aCabecalho := {"FILIAL","CODIGO","DAT_AQUISIC","CHAPA","CENTRO_CUSTO","OPERACAO","CONTA","DESCRICAO","VALOR","TX_DEPRECI","DPR_ACUM","FIM_DEPR","FORNECE","LOJA","NFISCAL","RAZAO"}



_cSelect  +=    "SELECT         "
_cSelect  +=	"N1_FILIAL AS FILIAL,  "
_cSelect  +=	"N1_CBASE AS CODIGO,   "
//_cSelect  +=	"N1.N1_ITEM,    "
_cSelect  +=	"N1_AQUISIC AS AQUISICAO, "
_cSelect  +=	"N1_CHAPA AS CHAPA,   "
//_cSelect  +=	"N1.N1_FORNEC AS FORCECEDOR,  "
//_cSelect  +=	"N1.N1_LOJA AS LOJA,    "
//_cSelect  +=	"N1.N1_BAIXA AS DT_BAIXA,   "
//_cSelect  +=	"N3.N3_CCUSTO AS CENTRO_CUSTO,  "
//_cSelect  +=	"N3.N3_DTBAIXA AS , "
//_cSelect  +=	"N3.N3_BAIXA,   "
//_cSelect  +=	"N3.N3_FILIAL,  "
//_cSelect  +=	"N3.N3_CBASE,   "
//_cSelect  +=	"N3.N3_ITEM,
_cSelect  +=	"N3_CUSTBEM AS CCUSTO, "
//_cSelect  +=	"N3.N3_SUBCTA,  "
_cSelect  +=	"N3_CLVL AS OPERACAO,    "
_cSelect  +=	"N3_CCONTAB AS CONTA, "
_cSelect  +=	"N1_DESCRIC AS DESCRICAO, "
_cSelect  +=	"N3_VORIG1 AS VALOR,  "
_cSelect  +=	"N3_TXDEPR1 AS TXDEPRE, "
_cSelect  +=	"N3_VRDACM1 AS ACUMUL, "
_cSelect  +=	"N3_FIMDEPR AS FIMDEPR, "
_cSelect  +=	"A2_COD AS CODIGO,     "
_cSelect  +=	"A2_LOJA AS LOJA,    "
_cSelect  +=	"N1_NFISCAL AS NFISCAL, "
_cSelect  +=	"A2_NOME AS RAZAO,     "
_cSelect  +=	"N3_X_PRJ AS PROJETO "
_cSelect  +=	"FROM "+RetSqlName("SN1")+" AS N1 "
  
_cSelect  += 	"INNER JOIN "+RetSqlName("SN3")+" AS N3 ON N1.N1_FILIAL = N3.N3_FILIAL "
_cSelect  +=					   " AND N1.N1_CBASE = N3.N3_CBASE "
_cSelect  +=					   " AND N1.N1_ITEM = N3.N3_ITEM   "
_cSelect  +=				" INNER JOIN "+RetSqlName("SA2")+" AS A2 ON N1.N1_FORNEC = A2.A2_COD "
_cSelect  +=					   " AND N1.N1_FORNEC = A2.A2_COD  "
_cSelect  +=					   " AND N1.N1_LOJA = A2.A2_LOJA	"
_cSelect  +=				" WHERE N1.N1_FILIAL BETWEEN '" +MV_PAR01+"' AND '"+MV_PAR02+"' "
_cSelect  +=				" AND N1.N1_AQUISIC BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
_cSelect  +=				" AND N3.N3_CCONTAB BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cSelect  +=				" AND N1.N1_FORNEC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cSelect  +=				" AND N3.N3_BAIXA <> '1' "
_cSelect  +=				" AND N3.N3_CCUSTO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cSelect  +=				" AND N1.D_E_L_E_T_ = '' "
_cSelect  +=				" AND N3.D_E_L_E_T_ = '' "
_cSelect  +=				" AND A2.D_E_L_E_T_ = '' "

_cSelect  +=				" ORDER BY N1.N1_CHAPA "



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha alias caso esteja aberto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TRBATF") > 0
	DBSelectArea("TRBATF")
	DBCloseArea()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TCQUERY _cSelect NEW ALIAS "TRBATF"
IncProc("Selecionando Registros...")

DBSelectArea("TRBATF")

TCSetField("TRBATF","FILIAL",     	"C", TamSX3("N1_FILIAL")[1],TamSX3("N1_FILIAL")[2])
TCSetField("TRBATF","CODIGO",    		"C", TamSX3("N1_CBASE")[1],TamSX3("N1_CBASE")[2])
TCSetField("TRBATF","AQUISICAO",   		"C", TamSX3("N1_AQUISIC")[1],TamSX3("N1_AQUISIC")[2])
TCSetField("TRBATF","CHAPA",    		"C", TamSX3("N1_CHAPA")[1],TamSX3("N1_CHAPA")[2])
TCSetField("TRBATF","CCUSTO",   		"C", TamSX3("N3_CUSTBEM")[1],TamSX3("N3_CUSTBEM")[2])
TCSetField("TRBATF","OPERACAO",   		"C", TamSX3("N3_CLVL")[1],TamSX3("N3_CLVL")[2])
TCSetField("TRBATF","CONTA",   		"C", TamSX3("N3_CCONTAB")[1],TamSX3("N3_CCONTAB")[2])
TCSetField("TRBATF","DESCRICAO",   		"C", TamSX3("N1_DESCRIC")[1],TamSX3("N1_DESCRIC")[2])
TCSetField("TRBATF","VALOR",   		"N", TamSX3("N3_VORIG1")[1],2)
TCSetField("TRBATF","TXDEPRE",   		"N", TamSX3("N3_TXDEPR1")[1],2)
TCSetField("TRBATF","ACUMUL",   		"N", TamSX3("N3_VRDACM1")[1],TamSX3("N3_VRDACM1")[2])
TCSetField("TRBATF","FIMDEPR",   		"C", TamSX3("N3_FIMDEPR")[1],TamSX3("N3_FIMDEPR")[2])
TCSetField("TRBATF","CODIGO",     		"C", TamSX3("A2_COD")[1],TamSX3("A2_COD")[2])
TCSetField("TRBATF","LOJA",   		"C", TamSX3("A2_LOJA")[1],TamSX3("A2_LOJA")[2])
TCSetField("TRBATF","NFISCAL",   		"C", TamSX3("N1_NFISCAL")[1],TamSX3("N1_NFISCAL")[2])
TCSetField("TRBATF","RAZAO",   		"C", TamSX3("A2_NOME")[1],TamSX3("A2_NOME")[2]) 
TCSetField("TRBATF","PROJETO",   		"C", TamSX3("N3_X_PRJ")[1],TamSX3("N3_X_PRJ")[2]) 

If TRBATF->(Eof().And.Bof())
	Aviso("A T E N C A O","Nao hแ dados a serem processados",{'Ok'})
	Return()
	TRBATF->(dbCloseArea())
EndIf
/*
aCampos := {}
AADD(aCampos,{"N1_FILIAL",     	"C", TamSX3("N1_FILIAL")[1],TamSX3("N1_FILIAL")[2]})
AADD(aCampos,{"N1_CBASE",   	"C", TamSX3("N1_CBASE")[1],TamSX3("N1_CBASE")[2]})
AADD(aCampos,{"N1_AQUISIC",   	"C", TamSX3("N1_AQUISIC")[1],TamSX3("N1_AQUISIC")[2]})
AADD(aCampos,{"N1_CHAPA",   	"C", TamSX3("N1_CHAPA")[1],TamSX3("N1_CHAPA")[2]})
AADD(aCampos,{"N3_CUSTBEM",   	"C", TamSX3("N3_CUSTBEM")[1],TamSX3("N3_CUSTBEM")[2]})
AADD(aCampos,{"N3_CLVL",   		"C", TamSX3("N3_CLVL")[1],TamSX3("N3_CLVL")[2]})
AADD(aCampos,{"N3_CCONTAB",   	"C", TamSX3("N3_CCONTAB")[1],TamSX3("N3_CCONTAB")[2]})
AADD(aCampos,{"N1_DESCRIC",   	"C", TamSX3("N1_DESCRIC")[1],TamSX3("N1_DESCRIC")[2]})
AADD(aCampos,{"N3_VORIG1",   	"N", TamSX3("N3_VORIG1")[1],2})
AADD(aCampos,{"N3_TXDEPR1",   	"N", TamSX3("N3_TXDEPR1")[1],TamSX3("N3_TXDEPR1")[2]})
AADD(aCampos,{"N3_VRDACM1",   	"N", TamSX3("N3_VRDACM1")[1],TamSX3("N3_VRDACM1")[2]})
AADD(aCampos,{"N3_FIMDEPR",   	"C", TamSX3("N3_FIMDEPR")[1],TamSX3("N3_FIMDEPR")[2]})
AADD(aCampos,{"A2_COD",     	"C", TamSX3("A2_COD")[1],TamSX3("A2_COD")[2]})
AADD(aCampos,{"A2_LOJA",   		"C", TamSX3("A2_LOJA")[1],TamSX3("A2_LOJA")[2]})
AADD(aCampos,{"N1_NFISCAL",   	"C", TamSX3("N1_NFISCAL")[1],TamSX3("N1_NFISCAL")[2]})
AADD(aCampos,{"A2_NOME",   		"C", TamSX3("A2_NOME")[1],TamSX3("A2_NOME")[2]})
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCopia alias para DBF ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//_cNomeArq := CriaTrab(Nil,.F.)

DbSelectArea("TRBATF")

copy to &(cCmd)
//Dbusearea(.T.,,_cNomeArq,"TRBEXL",.F.,.F.)

//DbSelectArea("TRBEXL")

//DBGOTOP()

//TRBEXL->(dbCloseArea())

CpyS2T(cCmd,cTempPath,.T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".xls")
oExcelApp:SetVisible(.T.)

Ferase( cCmd )

Return