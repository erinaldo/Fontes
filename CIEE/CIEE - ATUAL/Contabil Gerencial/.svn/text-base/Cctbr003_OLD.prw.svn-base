#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTRB003  ºAutor  ³Claudio Barros      º Data ³  30/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Razao Analitico Fornecedor                                 º±±                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaCTB - Especifico CIEE                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCTBR003()

Private oProcess := NIL
Private cPerg := "CCTB03"
CriaSx1()

If !pergunte(cPerg,.T.)
	Return Nil
EndIf

oProcess := MsNewProcess():New({|lEnd| CCTBR03A(lEnd,oProcess)},"Processando","Lendo...",.T.)
oProcess:Activate()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBR003  ºAutor  ³Microsiga           º Data ³  05/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CCTBR03A(lEnd,oObj)

Local IndOrder
Local _aCampos 	:= {}
Local nOrdem
Local _nContReg := 0

Private _cArqTrab
nOrdem 	  := 1

_aCampos :=	{{"CONTA"      , "C", 20, 0},;
			 {"DATACON"    , "D", 20, 0},;
			 {"TIPO"       , "C", 03, 0},;
			 {"NUMERO"     , "C", 06, 0},;
			 {"FORNECE"    , "C", 06, 0},;
			 {"NOMFOR"     , "C", 30, 0},;
			 {"VALOR"      , "N", 14, 2},;
			 {"BORDERO"    , "C", 06, 0},;
			 {"NUMAP"      , "C", 06, 0},;
			 {"CHEQUE"     , "C", 10, 0},;
			 {"CREDIT"     , "N", 14, 2},;
			 {"DEBITO"     , "N", 14, 2},;
			 {"EMISSAO"    , "D", 08, 0},;
			 {"VENCREA"    , "D", 08, 0},;
			 {"BAIXA"      , "D", 08, 0},;
			 {"CCUSTO"     , "C", 10, 0},;
			 {"CONCIL"     , "D", 08, 0},;
			 {"HIST"       , "C", 40, 0},;
			 {"USUARIO"    , "C", 15, 0}}

// Cria o arquivo de trabalho.
_cArqTrab 	:= CriaTrab(_aCampos, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TRB", .F., .F.)
cIndex 		:= _cArqTrab+"1"

Do Case
	Case nOrdem  == 1
//		IndOrder := "CONTA+NOMFOR"
		IndOrder := "CONTA+NOMFOR+DTOS(DATACON)"
	Case nOrdem  == 2
		IndOrder := "VENCREA"
	Case nOrdem  == 4
		IndOrder := ""
	Case nOrdem  == 5
		IndOrder := "NOMFOR"
EndCase

IndRegua("TRB",cIndex,IndOrder,,,"Indexando Registros...")

_cQuery := " SELECT CT1_RES "
_cQuery += " FROM "+RetSQLname('CT1')+" CT1 "
_cQuery += " WHERE D_E_L_E_T_ = ' ' "
_cQuery += " AND CT1_RES BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
_cQuery += " AND CT1_CLASSE = '2' "
_cQuery += " ORDER BY CT1_RES "
TcQuery _cQuery New Alias "TRA"
DbSelectArea("TRA")

_nContReg := CCTBRCT1() //Realiza Contagem de Numero de Registros atraves da Conta REDUZIDA
oObj:SetRegua1(_nContReg)

While !TRA->(EOF())
	oObj:IncRegua1("Lendo Contas Contabeis: "+TRA->CT1_RES)
	CCTBR003A(TRA->CT1_RES,lEnd,oObj) // Monta arquivo Temporario com os Movimentos das Contas
	TRA->(DBSKIP())
End

DBSELECTAREA("TRA")
TRA->(DBGOTOP())
Cctbr003B() // Impressao

If Select('TRA') > 0
	TRA->(DbCloseArea())
EndIf
If Select('TRB') > 0
	TRB->(DbCloseArea())
EndIf
If File(_cArqTrab+".DBF")
	Ferase(_cArqTrab+".DBF")
Endif
If File(_cArqTrab+"1.CDX")
	Ferase(_cArqTrab+"1.CDX")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBR003  ºAutor  ³Microsiga           º Data ³  05/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CCTBR003A(pConta,lEnd,oObj)

Local _cQuery := ""
Local lTitSE2
Local _nContReg := 0
Local  cTIPO
Local  cNUMERO

_cQuery := " SELECT CT2_KEY, SUBSTRING(CT2_KEY,16,6) AS FORNECE, "
_cQuery += " CT2_LP, CT2_ITEMD, CT2_ITEMC, CT2_CCC, CT2_CCD, CT2_VALOR, CT2_DC, CT2_DATA, "
_cQuery += " CT2_HIST "
_cQuery += " FROM "+RetSqlName("CT2")+" "
_cQuery += " WHERE D_E_L_E_T_ = ' ' "
IF MV_PAR11 == 1 // Tipo de lancamento (1-Debito/ 2-Credito/ 3-Ambos)
	_cQuery += " AND CT2_ITEMD = '"+pConta+"' "
	_cQuery += " AND CT2_CCD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
ELSEIF MV_PAR11 == 2
	_cQuery += " AND CT2_ITEMC = '"+pConta+"' "
	_cQuery += " AND CT2_CCC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
ELSE
	_cQuery += " AND ( CT2_ITEMD = '"+pConta+"' OR CT2_ITEMC = '"+pConta+"') "
	_cQuery += " AND (CT2_CCD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery += "      OR CT2_CCC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
ENDIF
_cQuery += " AND CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
_cQuery += " AND (CT2_LP IN ('510','511','512','515','530','531','532','566','571','650')) "
_cQuery += " AND SUBSTRING(CT2_KEY,16,6) BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "

TcQuery _cQuery New Alias "TRT"
dbSelectArea("TRT")
dbGoTop()

TcSetField("TRT","CT2_DATA","D",8, 0 )

_nContReg := CCTBRCT2(pConta)  //Realiza Contagem de Numero de Registros atraves da Conta REDUZIDA nos Lancamentos
oObj:SetRegua2(_nContReg)

While !TRT->(EOF())
	
	oObj:IncRegua2("Lendo Movimentos Contabeis: "+DTOC(TRT->CT2_DATA))
	If lEnd
		Exit
	Endif
	
	DO CASE
		CASE  ALLTRIM(TRT->CT2_LP) == "650"
			lTitSE2  := FPESKEY(SUBS(TRT->CT2_KEY,3,3),SUBS(TRT->CT2_KEY,6,6)," ","NF ",SUBS(TRT->CT2_KEY,12,6),SUBS(TRT->CT2_KEY,18,2),TRT->CT2_LP)
			cTIPO    := "NF "
			cNUMERO  := SUBS(TRT->CT2_KEY,6,6)
		CASE ALLTRIM(TRT->CT2_LP) $ "510/511/512/515/532/566/571"
			lTitSE2  := FPESKEY(SUBS(TRT->CT2_KEY,3,3),SUBS(TRT->CT2_KEY,6,6),SUBS(TRT->CT2_KEY,12,1),SUBS(TRT->CT2_KEY,13,3),SUBS(TRT->CT2_KEY,16,6),SUBS(TRT->CT2_KEY,22,2),TRT->CT2_LP)
			cTIPO    := SUBS(TRT->CT2_KEY,13,3)
			cNUMERO  := SUBS(TRT->CT2_KEY,6,6)
		CASE ALLTRIM(TRT->CT2_LP) $ "530/531"
			lTitSE2  := FPESKEY(SUBS(TRT->CT2_KEY,5,3),SUBS(TRT->CT2_KEY,8,6),SUBS(TRT->CT2_KEY,14,1),SUBS(TRT->CT2_KEY,15,3),SUBS(TRT->CT2_KEY,26,6),SUBS(TRT->CT2_KEY,32,2),TRT->CT2_LP)
			cTIPO    := SUBS(TRT->CT2_KEY,15,3)
			cNUMERO  := SUBS(TRT->CT2_KEY,8,6)
	EndCase
	
	//lTitSE2[1][1] = Emissao
	//lTitSE2[1][2] = Vencimento
	//lTitSE2[1][3] = Nome Fornecedor
	//lTitSE2[1][4] = Valor
	//lTitSE2[1][5] = Numero Bordero
	//lTitSE2[1][6] = Numero Aut. Pagto.
	//lTitSE2[1][7] = Numero Cheque
	//lTitSE2[1][8] = Data Conciliacao
	
	If !Empty(lTitSE2[1][2])
		RecLock("TRB",.T.)
		TRB->CONTA   := pConta
		TRB->CCUSTO  := IIF(!EMPTY(TRT->CT2_CCD),TRT->CT2_CCD,TRT->CT2_CCC)
		TRB->TIPO    :=  cTIPO
		TRB->NUMERO  :=  cNUMERO
		TRB->FORNECE := lTitSE2[1][9]
		TRB->NOMFOR  := lTitSE2[1][3]
		TRB->VALOR   := TRT->CT2_VALOR
		TRB->BORDERO := lTitSE2[1][4]
		TRB->NUMAP   := lTitSE2[1][5]
		TRB->CHEQUE  := lTitSE2[1][6]
		
		IF ALLTRIM(TRT->CT2_DC) $ "2"
			TRB->CREDIT  := TRT->CT2_VALOR
		ELSEIF ALLTRIM(TRT->CT2_DC) $ "1"
			TRB->DEBITO  := TRT->CT2_VALOR
		ELSEIF ALLTRIM(TRT->CT2_DC) $ "3"
			IF ALLTRIM(TRT->CT2_ITEMC) == ALLTRIM(pConta)
				TRB->CREDIT  := TRT->CT2_VALOR
			ENDIF
			IF ALLTRIM(TRT->CT2_ITEMD) == ALLTRIM(pConta)
				TRB->DEBITO  := TRT->CT2_VALOR
			ENDIF
		ENDIF
		TRB->DATACON := TRT->CT2_DATA
		TRB->EMISSAO := lTitSE2[1][1]
		TRB->VENCREA := lTitSE2[1][2]
		TRB->BAIXA   := lTitSE2[1][7]
		TRB->CONCIL  := lTitSE2[1][8]
//		TRB->HIST    := TRT->CT2_HIST
		TRB->HIST    := lTitSE2[1][11] //Alterado dia 22/01/08 pelo analista Emerson. Colocado Historico do Titulo SE2.
		TRB->(MSUNLOCK())
	EndIf
	TRT->(DBSKIP())

End

If Select("TRT") > 0
	TRT->(DBCLOSEAREA())
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINR015 º Autor ³ AP6 IDE            º Data ³  10/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Consulta de Previsao Pagamento SE2            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico Ativado pelo CFINC02                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Cctbr003b()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 		:= "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 		:= "Razao Contas Contabeis do Financeiro.              "
Private cDesc3 		:= "Titulos de Contas a Pagar.                          "
Private titulo 		:= "RAZAO ANALITICO FORNECEDORES "+ Dtoc(MV_PAR01)+" ATE "+Dtoc(MV_PAR02)
Private nLin   		:= 80
Private lAbortPrint := .F.
Private limite      := 220  //132
Private tamanho     := 	"G" //"M"
Private nomeprog    := "CCTBR3"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "CTBR03"
Private cString     := "TRB"
Private cabec1      := "Titulo       Emissao   Fornecedor                      CR              Debito         Credito    Bordero   AP          Vencto.    Historico"
Private cabec2      := ""

wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho,,.F.)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local _nSubTot := 0
Local _nTotal  := 0
Local nTotDeb  := 0
Local nTotCre  := 0
Local nTotDGer := 0
Local nTotCGer := 0
Local nTotDFin := 0
Local nTotCFin := 0

Private _Conta := SPACE(10)

dbSelectArea("TRB")
TRB->(dbGoTop())

SetRegua(RecCount())

While !TRB->(Eof())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	DbSelectArea("CT1")
	CT1->(DBSETORDER(2))
	CT1->(DbGotop())
	CT1->(DBSEEK(xFilial("CT1")+TRB->CONTA))
	If _Conta <> TRB->CONTA
		nLin:=nLin+1
		@ nLin, 000 PSay SUBS(TRB->CONTA,1,10)
		@ nLin, 020 PSay SUBS(CT1->CT1_DESC01,1,30)
		nLin:=nLin+2
		_Conta 		:= TRB->CONTA
		nTotDGer	:= 0
		nTotCGer	:= 0
		nTotDeb		:= 0
		nTotCre		:=0
		_cFornece 	:= TRB->FORNECE
	Endif
	
	//                                                                                                      1         1         1         1         1         1         1         1         1         1         2
	//            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
	//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	// "Titulo       Emissao   Fornecedor                      CR                   Debito         Credito    Bordero  AP      CHEQUE    Vencto.   Baixa     Conciliado   Historico"
	//  XXX/999999   99/99/99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX     9.999.999,99    9.999.999,99    XXXXXX   XXXXXX  999999    99/99/99  99/99/99  99/99/99     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

	//            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
	//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //  Titulo       Emissao   Fornecedor                      CR              Debito         Credito    Bordero   AP          Vencto.    Historico
	//  XXX/999999   99/99/99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXX       9.999.999,99    9.999.999,99    XXXXXX    XXXXXX      99/99/99   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	

	@ nLin, 000 PSay TRB->TIPO+"/" Picture "@!"
	@ nLin, 005 PSay TRB->NUMERO
	@ nLin, 013 PSay TRB->DATACON
	@ nLin, 023 PSay TRB->NOMFOR
	@ nLin, 055 PSay TRB->CCUSTO
	@ nLin, 065 PSay TRB->DEBITO  Picture "@E 9,999,999.99"
	@ nLin, 081 PSay TRB->CREDIT  Picture "@E 9,999,999.99"
	@ nLin, 097 PSay TRB->BORDERO
	@ nLin, 107 PSay TRB->NUMAP
	@ nLin, 119 PSay TRB->VENCREA
	@ nLin, 130 PSay TRB->HIST
	
	nLin:=nLin+1
	
	nTotDeb+=TRB->DEBITO
	nTotCre+=TRB->CREDIT
	nTotDGer+=TRB->DEBITO
	nTotCGer+=TRB->CREDIT
	nTotDFin+=TRB->DEBITO
	nTotCFin+=TRB->CREDIT
	
	dbSelectArea("TRB")
	TRB->(DbSkip())
	
	If _Conta <> TRB->CONTA
		If nTotDGer+nTotCGer > 0
			nLin:=nLin+1
			@ nLin, 000 PSay  Alltrim(_Conta)
			@ nLin, 013 PSay  "T o t a l  C o n t a  ==>"
			@ nLin, 064 PSay nTotDGer  Picture "@E 99,999,999.99"
			@ nLin, 080 PSay nTotCGer  Picture "@E 99,999,999.99"
			nLin:=nLin+1
		EndIf
	EndIf
	
EndDo

If nLin > 65
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

nLin++
@ nLin, 000 PSay Replicate("-", 132)
nLin++
@ nLin, 013 PSay "T O T A L  G E R A L  ==>"
@ nLin, 064 PSay nTotDFin  Picture "@E 99,999,999.99"
@ nLin, 080 PSay nTotCFin  Picture "@E 99,999,999.99"
nLin++
@ nLin, 000 PSay Replicate("-", 132)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBR003  ºAutor  ³Microsiga           º Data ³  05/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSx1()

Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

cPerg := PADR(cPerg,6)

AADD(aReg,{cPerg,"01","Data Contabil De  ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"02","Data Contabil Ate ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"03","Vencimento De     ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"04","Vencimento Ate    ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"05","Conta De          ?","","","mv_ch5","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"06","Conta Ate         ?","","","mv_ch6","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"07","CR De             ?","","","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"08","CR Ate            ?","","","mv_ch8","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"09","Fornecedor De     ?","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"10","Fornecedor Ate    ?","","","mv_cha","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"11","Tipo Lancto Contab?","","","mv_chb","N",01,0,0,"C","","mv_par11","Debito","","","Credito","","","Ambos","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBR003  ºAutor  ³Microsiga           º Data ³  05/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FPESKEY(pPrefixo,pNumero,pParcela,pTipo,pFornece,pLoja,pLP)

Local alRet 	:= {}
Local cAlias 	:= GetArea()
Local dDtConc 	:= Ctod("//")
Local cTipo 	:= "NF "

//lTitSE2[1][1] = Emissao
//lTitSE2[1][2] = Vencimento
//lTitSE2[1][3] = Nome Fornecedor
//lTitSE2[1][4] = Valor
//lTitSE2[1][5] = Numero Bordero
//lTitSE2[1][6] = Numero Aut. Pagto.
//lTitSE2[1][7] = Numero Cheque
//lTitSE2[1][8] = Data Conciliacao
//lTitSE2[1][9] = Fornece
//lTitSE2[1][10] = Loja

IF Alltrim(pLp) == "650"
	pTipo := "NF "
ENDIF

IF Alltrim(pLp) == "650"
	DBSELECTAREA("SD1")
	SD1->(DBSETORDER(1))
	SD1->(DBGOTOP())
	IF SD1->(DBSEEK(xFilial("SD1")+pNUMERO+pPREFIXO+pFORNECE+pLOJA))
		DBSELECTAREA("SF4")
		SF4->(DBSETORDER(1))
		SF4->(DBGOTOP())
		IF SF4->(DBSEEK(xFilial("SF4")+SD1->D1_TES))
			IF ALLTRIM(SF4->F4_DUPLIC) == "N"
				DBSELECTAREA("SA2")
				SA2->(DBSETORDER(1))
				SA2->(DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
				AAdd(alRet,{SD1->D1_EMISSAO,SD1->D1_EMISSAO,SA2->A2_NREDUZ," "," "," ",CTOD("//"),CTOD("//"),SD1->D1_FORNECE,SD1->D1_LOJA,})
				RestArea(cAlias)
				Return(alRet)
			ENDIF
		ENDIF
	ENDIF
ENDIF

DBSELECTAREA("SE2")
SE2->(DBSETORDER(1))
SE2->(DBGOTOP())
IF SE2->(DBSEEK(XFILIAL("SE2")+pPREFIXO+pNUMERO+pPARCELA+pTipo+pFORNECE+pLOJA)) .AND. ALLTRIM(pLP) $ "510/511/512/515/530/531/532/566/571/650"
	If SE2->E2_VENCREA >= MV_PAR03 .AND. SE2->E2_VENCREA <= MV_PAR04
		IF ALLTRIM(pLP) $ "566/571"
			DBSELECTAREA("SEF")
			SEF->(DBSETORDER(3))
			SEF->(DBGOTOP())
			SEF->(DBSEEK(xFilial("SEF")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_NUMBCO))
			
			DBSELECTAREA("SE5")
			SE5->(DBSETORDER(1))
			SE5->(DBGOTOP())
			IF SE5->(DBSEEK(XFILIAL("SE5")+DTOS(SE2->E2_BAIXA)+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM))
				IF !EMPTY(SE5->E5_RECONC)
					dDtConc := SE5->E5_DTDISPO
				ENDIF
			ENDIF
			DBSELECTAREA("SE2")
			AAdd(alRet,{SE2->E2_EMISSAO,SE2->E2_VENCREA,SE2->E2_NOMFOR,SE2->E2_NUMBOR, SE2->E2_NUMAP, SE2->E2_NUMBCO,SE2->E2_BAIXA,dDtConc,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_HIST})
		ELSE
			DBSELECTAREA("SE5")
			SE5->(DBSETORDER(7))
			SE5->(DBGOTOP())
			
			IF SE5->(DBSEEK(XFILIAL("SE5")+pPREFIXO+pNUMERO+pPARCELA+pTipo+pFORNECE+pLOJA,.T.))
				IF !EMPTY(SE5->E5_RECONC)
					dDtConc := SE5->E5_DTDISPO
				ENDIF
			ENDIF
			DBSELECTAREA("SE2")
			AAdd(alRet,{SE2->E2_EMISSAO,SE2->E2_VENCREA,SE2->E2_NOMFOR,SE2->E2_NUMBOR, SE2->E2_NUMAP, SE2->E2_NUMBCO,SE2->E2_BAIXA,dDtConc,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_HIST})
		ENDIF
	ELSE
		AAdd(alRet,{CTOD("//"),CTOD("//")," "," ", " "," ",CTOD("//"),CTOD("//"), "","","" })		
	ENDIF
ELSE
	AAdd(alRet,{CTOD("//"),CTOD("//")," "," ", " "," ",CTOD("//"),CTOD("//"), "","","" })
ENDIF

RestArea(cAlias)

Return(alRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBR003  ºAutor  ³Microsiga           º Data ³  05/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza uma contagem de quantas Contas Contabeis foram     º±±
±±º          ³ selecionadas atraves da CONTA REDUZIDA                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CCTBRCT1()

Local _cQuery := " "
Local _lRetReg

_cQuery := " SELECT COUNT(CT1_RES) AS NRREG "
_cQuery += " FROM "+RetSQLname('CT1')+" CT1 "
_cQuery += " WHERE D_E_L_E_T_ = ' ' "
_cQuery += " AND CT1_RES BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQuery += " AND CT1_CLASSE = '2' "
TcQuery _cQuery New Alias "TRC"
DbSelectArea("TRC")

_lRetReg := TRC->NRREG

If Select("TRC") > 0
	TRC->(DbCloseArea())
EndIf

Return(_lRetReg)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBR003  ºAutor  ³Microsiga           º Data ³  05/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza uma contagem de quantas Contas Contabeis foram     º±±
±±º          ³ selecionadas atraves da CONTA REDUZIDA                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CCTBRCT2(pConta)

Local _cQuery := " "
Local _lRetReg

_cQuery := " SELECT COUNT(CT2_VALOR) AS NRREG"
_cQuery += " FROM "+RetSqlName("CT2")+" "
_cQuery += " WHERE D_E_L_E_T_ = ' ' "
IF MV_PAR11 == 1 // Tipo de lancamento (1-Debito/ 2-Credito/ 3-Ambos)
	_cQuery += " AND CT2_ITEMD = '"+pConta+"' "
	_cQuery += " AND CT2_CCD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
ELSEIF MV_PAR11 == 2
	_cQuery += " AND CT2_ITEMC = '"+pConta+"' "
	_cQuery += " AND CT2_CCC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
ELSE
	_cQuery += " AND ( CT2_ITEMD = '"+pConta+"' OR CT2_ITEMC = '"+pConta+"') "
	_cQuery += " AND (CT2_CCD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery += "      OR CT2_CCC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
ENDIF
_cQuery += " AND CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
_cQuery += " AND (CT2_LP IN ('510','511','512','515','530','531','532','566','571','650')) "
_cQuery += " AND SUBSTRING(CT2_KEY,16,6) BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
TcQuery _cQuery New Alias "TRD"
dbSelectArea("TRD")
dbGoTop()

_lRetReg := TRD->NRREG

If Select("TRD") > 0
	TRD->(DbCloseArea())
EndIf

Return(_lRetReg)