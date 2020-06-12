#INCLUDE "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTRB001  ºAutor  ³Claudio Barros      º Data ³  10/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio Razao Financeiro para conciliacao contabil        º±±                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaCTB - Especifico CIEE                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function CCTBR01()

Private oProcess := NIL
Private cPerg := "CCTB01    "
CriaSx1()
//Pergunte(cPerg,.f.)

If !pergunte(cPerg,.T.)
	Return Nil
EndIf

oProcess := MsNewProcess():New({|lEnd| CCTBR00A(lEnd,oProcess)},"Processando","Lendo...",.T.)
oProcess:Activate()

Return Nil


Static Function CCTBR00A(lEnd,oObj)

Local IndOrder
Local _aCampos := {}
Local nOrdem
Local _nContReg := 0
Private cFl := CHR(13)+CHR(10)
//Private cPerg := "CCTB01"
Private _cArqTrab




//nOrdem 	  := aReturn[8]
nOrdem 	  := 1


_aCampos := {;
{"CONTA"      , "C", 20, 0},;
{"DATACON"    , "D", 20, 0},;
{"TIPO"       , "C", 03, 0},;
{"NUMERO"     , "C", 9, 0},;
{"FORNECE"     , "C", 6, 0},;
{"NOMFOR"     , "C", 30, 0},;
{"VALOR"      , "N", 14, 2},;
{"BORDERO"    , "C", 6, 0},;
{"NUMAP"      , "C", 6, 0},;
{"CHEQUE"     , "C", 10, 0},;
{"CREDIT"     , "N", 14, 2},;
{"DEBITO"     , "N", 14, 2},;
{"EMISSAO"    , "D", 8, 0},;
{"VENCREA"    , "D", 8, 0},;
{"BAIXA"      , "D", 8, 0},;
{"CCUSTO"     , "C", 10, 0},;
{"CONCIL"     , "D", 8, 0},; 
{"HIST"       , "C", 40, 0},;
{"USUARIO"    , "C", 15, 0} }

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aCampos, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TRB", .F., .F.)

cIndex := _cArqTrab+"1"

Do Case
	Case nOrdem  == 1
		IndOrder := "CONTA+DTOS(DATACON)+NOMFOR"
	Case nOrdem  == 2
		IndOrder := "VENCREA"
	Case nOrdem  == 4
		IndOrder := ""
	Case nOrdem  == 5
		IndOrder := "NOMFOR"
EndCase


IndRegua("TRB",cIndex,IndOrder,,,"Indexando Registros...")

_Query := " SELECT CT1_RES FROM CT1010 CT1 "+cFl
_Query += " WHERE D_E_L_E_T_ = ' ' "+cFl
_Query += " AND CT1_RES BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "+cFl
_Query += " AND CT1_CLASSE = '2' "+cFl
_Query += " ORDER BY CT1_RES "+cFl
_Query := ChangeQuery(_Query)
MemoWrite("CCTBR01_A.SQL",_Query)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_Query),'TRA',.T.,.T.)
DbSelectArea("TRA")



_nContReg := CCTBRCT1()
oObj:SetRegua1(_nContReg)


While !TRA->(EOF())
	
	oObj:IncRegua1("Lendo Contas Contabeis: "+TRA->CT1_RES)
	
	CCTBR01A(TRA->CT1_RES,lEnd,oObj)
	TRA->(DBSKIP())
End


DBSELECTAREA("TRA")
TRA->(DBGOTOP())
CCTBR01B() // Impressao

DBSELECTAREA("TRB")
//COPY TO "RAZAO.XLS"

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


Static Function CCTBR01A(pConta,lEnd,oObj)


Local _cQuery := ""
Local lTitSE2
Local _nContReg := 0
Local  cTIPO    
Local  cNUMERO  
Local _nTamTit := 9

//Private lEnd
//Private oObj

_cQuery := " SELECT CT2_KEY, CT2_LP, CT2_ITEMD, CT2_ITEMC, CT2_CCC, CT2_CCD, CT2_VALOR, CT2_DC, CT2_DATA,"+cFl
_cQuery += " CT2_HIST "+cFl
_cQuery += " FROM "+RetSqlName("CT2")+" "+cFl
_cQuery += " WHERE D_E_L_E_T_ = ' ' "+cFl
IF MV_PAR17 == 1
	_cQuery += " AND  CT2_ITEMD = '"+pConta+"'
ELSEIF MV_PAR17 == 2
	_cQuery += " AND  CT2_ITEMC = '"+pConta+"' "+cFl
ELSE
	_cQuery += " AND ( CT2_ITEMD = '"+pConta+"' OR CT2_ITEMC = '"+pConta+"') "+cFl
ENDIF
_cQuery += " AND CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+cFl
_cQuery += " AND (CT2_LP IN ('510','511','512','515','530','531','532','566','571','650')) "+cFl
_cQuery := ChangeQuery(_cQuery)
MemoWrite("CCTBR01_B.SQL",_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRT',.T.,.T.)

dbSelectArea("TRT")
dbGoTop()



TcSetField("TRT","CT2_DATA","D",8, 0 )


_nContReg := CCTBRCT2(pConta)
oObj:SetRegua2(_nContReg)

_nTamTit := 9

While !TRT->(EOF())
	
	oObj:IncRegua2("Lendo Movimentos Contabeis: "+DTOC(TRT->CT2_DATA))
	If lEnd
		Exit
	Endif
	
	//	lTitSE2 :={}
	DO CASE
		CASE  ALLTRIM(TRT->CT2_LP) == "650"
			//XFILIAL("SD1")+D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA
			_cFilial 	:= SUBS(TRT->CT2_KEY,01,2)
			_cPrefixo 	:= SUBS(TRT->CT2_KEY,03,3) //Serie
			If Len(Alltrim(TRT->CT2_KEY)) == 19 // Titulos Antigos 6 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,06,6) //Doc
				_cFornece 	:= SUBS(TRT->CT2_KEY,12,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,18,2)
			ElseIf Len(Alltrim(TRT->CT2_KEY)) == 22 // Titulos Novos 9 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,06,9) //Doc
				_cFornece 	:= SUBS(TRT->CT2_KEY,15,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,21,2)
			EndIf
		
//			lTitSE2 := FPESKEY(_cPrefixo,_cNumero+Space(3)," ","NF ",_cFornece,_cLOja,TRT->CT2_LP)
			lTitSE2 := FPESKEY(_cPrefixo,PaD(_cNumero,_nTamTit)," ","NF ",_cFornece,_cLOja,TRT->CT2_LP)
	        cTIPO    := "NF "
	        cNUMERO  := _cNumero

		CASE ALLTRIM(TRT->CT2_LP) $ "532"
			//XFILIAL("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
			_cFilial 	:= SUBS(TRT->CT2_KEY,01,2)
			_cPrefixo 	:= SUBS(TRT->CT2_KEY,03,3)
			If Len(Alltrim(TRT->CT2_KEY)) == 25 // Titulos Antigos 6 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,06,6)
				_cParcela 	:= SUBS(TRT->CT2_KEY,12,1)
				_cTipo 		:= SUBS(TRT->CT2_KEY,13,3)
				_cFornece 	:= SUBS(TRT->CT2_KEY,16,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,22,2)
				_cSeq 		:= SUBS(TRT->CT2_KEY,24,2)
			ElseIf Len(Alltrim(TRT->CT2_KEY)) == 28 // Titulos Novos 9 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,06,9)
				_cParcela 	:= SUBS(TRT->CT2_KEY,15,1)
				_cTipo 		:= SUBS(TRT->CT2_KEY,16,3)
				_cFornece 	:= SUBS(TRT->CT2_KEY,19,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,25,2)
				_cSeq 		:= SUBS(TRT->CT2_KEY,27,2)
			EndIf
//			lTitSE2 := FPESKEY(_cPrefixo,_cNumero+Space(3),_cParcela,_cTipo,_cFornece,_cLOja,TRT->CT2_LP)
			lTitSE2 := FPESKEY(_cPrefixo,PaD(_cNumero,_nTamTit),_cParcela,_cTipo,_cFornece,_cLOja,TRT->CT2_LP)
	        cTIPO    := _cTipo
	        cNUMERO  := _cNumero

		CASE ALLTRIM(TRT->CT2_LP) $ "510/511/512/515/532/566/571"
			//XFILIAL("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
			_cFilial 	:= SUBS(TRT->CT2_KEY,01,2)
			_cPrefixo 	:= SUBS(TRT->CT2_KEY,03,3)
			If Len(Alltrim(TRT->CT2_KEY)) == 23 // Titulos Antigos 6 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,06,6)
				_cParcela 	:= SUBS(TRT->CT2_KEY,12,1)
				_cTipo 		:= SUBS(TRT->CT2_KEY,13,3)
				_cFornece 	:= SUBS(TRT->CT2_KEY,16,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,22,2)
			ElseIf Len(Alltrim(TRT->CT2_KEY)) == 26 // Titulos Novos 9 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,06,9)
				_cParcela 	:= SUBS(TRT->CT2_KEY,15,1)
				_cTipo 		:= SUBS(TRT->CT2_KEY,16,3)
				_cFornece 	:= SUBS(TRT->CT2_KEY,19,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,25,2)
			EndIf
//			lTitSE2 := FPESKEY(_cPrefixo,_cNumero+Space(3),_cParcela,_cTipo,_cFornece,_cLOja,TRT->CT2_LP)
			lTitSE2 := FPESKEY(_cPrefixo,PaD(_cNumero,_nTamTit),_cParcela,_cTipo,_cFornece,_cLOja,TRT->CT2_LP)
	        cTIPO    := _cTipo
	        cNUMERO  := _cNumero

		CASE ALLTRIM(TRT->CT2_LP) $ "530/531"
			//E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
			_cFilial 	:= SUBS(TRT->CT2_KEY,01,2)
			_cTipoDoc	:= SUBS(TRT->CT2_KEY,03,2)
			_cPrefixo 	:= SUBS(TRT->CT2_KEY,05,3)
			If Len(Alltrim(TRT->CT2_KEY)) == 35 // Titulos Antigos 6 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,08,6)
				_cParcela 	:= SUBS(TRT->CT2_KEY,14,1)
				_cTipo 		:= SUBS(TRT->CT2_KEY,15,3)
				_dData		:= SUBS(TRT->CT2_KEY,18,8)
				_cCliFor 	:= SUBS(TRT->CT2_KEY,26,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,32,2)
				_cSeq		:= SUBS(TRT->CT2_KEY,34,2)
			ElseIf Len(Alltrim(TRT->CT2_KEY)) == 38 // Titulos Novos 9 posicoes E2_NUM
				_cNumero 	:= SUBS(TRT->CT2_KEY,08,9)
				_cParcela 	:= SUBS(TRT->CT2_KEY,17,1)
				_cTipo 		:= SUBS(TRT->CT2_KEY,18,3)
				_dData		:= SUBS(TRT->CT2_KEY,21,8)
				_cCliFor 	:= SUBS(TRT->CT2_KEY,29,6)
				_cLOja 		:= SUBS(TRT->CT2_KEY,35,2)
				_cSeq		:= SUBS(TRT->CT2_KEY,37,2)
			EndIf
//			lTitSE2 := FPESKEY(_cPrefixo,_cNumero+Space(3),_cParcela,_cTipo,_cCliFor,_cLOja,TRT->CT2_LP)
			lTitSE2 := FPESKEY(_cPrefixo,PaD(_cNumero,_nTamTit),_cParcela,_cTipo,_cCliFor,_cLOja,TRT->CT2_LP)
	        cTIPO    := _cTipo
	        cNUMERO  := _cNumero
	EndCase
	 
	
	//lTitSE2[1][1] = Emissao
	//lTitSE2[1][2] = Vencimento
	//lTitSE2[1][3] = Nome Fornecedor
	//lTitSE2[1][4] = Valor
	//lTitSE2[1][5] = Numero Bordero
	//lTitSE2[1][6] = Numero Aut. Pagto.
	//lTitSE2[1][7] = Numero Cheque
	//lTitSE2[1][8] = Data Conciliacao
	
	
	//AAdd(alRet{SE2->E2_EMISSAO,SE2->E2_VENCREA,SE2->E2_NOMFOR,SE2->E2_NUMBOR, SE2->E2_NUMAP, SE2->E2_NUMBCO,SE2->E2_BAIXA,dDtConc })
	RecLock("TRB",.T.)
	TRB->CONTA   := pConta //IIF(!EMPTY(TRT->CT2_ITEMD),TRT->CT2_ITEMD,TRT->CT2_ITEMC)
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
//    TRB->HIST    := TRT->CT2_HIST
    TRB->HIST    := lTitSE2[1][11]
	TRB->(MSUNLOCK())
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

Static Function CCTBR01b()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "Razao Contas Contabeis do Financeiro.              "
Private cDesc3 := "Titulos de Contas a Pagar.                          "

Private titulo := "RAZAO ANALITICO EM REAIS DE "+ Dtoc(MV_PAR01)+" ATE "+Dtoc(MV_PAR02)
Private nLin   := 80
Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220//220
Private tamanho      := "G" //"G"
Private nomeprog     := "CCTBR1"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CTBR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "TRB"
Private _nFL         := 0
Private _lPode       := .F.
Private _aAliases    := {}
Private _aMatriz     := {}
Private cabec1       := "Titulo          Emissao   Fornecedor                      CR                   Debito         Credito    Bordero  AP      CHEQUE    Vencto.   Baixa     Conciliado   Historico"
Private cabec2       :=""

wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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
	
	
	
	If TRB->FORNECE < MV_PAR09 .OR. TRB->FORNECE > MV_PAR10
		TRB->(DBSKIP())
		LOOP
	ENDIF
	IF MV_PAR11 <> 3
		If TRB->BAIXA < MV_PAR13 .OR. TRB->BAIXA > MV_PAR14
			TRB->(DBSKIP())
			LOOP
		ENDIF
	ENDIF
	If TRB->VENCREA < MV_PAR03 .OR. TRB->VENCREA > MV_PAR04
		TRB->(DBSKIP())
		LOOP
	ENDIF
	IF MV_PAR12 <> 3
		If TRB->CONCIL < MV_PAR15 .OR. TRB->CONCIL > MV_PAR16
			TRB->(DBSKIP())
			LOOP
		ENDIF
	ENDIF
	IF MV_PAR11 == 1  // Baixado Sim
		IF EMPTY(TRB->BAIXA )
			TRB->(DBSKIP())
			LOOP
		ENDIF
	ELSEIF MV_PAR11 == 2 // Baixado Nao
		IF !EMPTY(TRB->BAIXA)
			TRB->(DBSKIP())
			LOOP
		ENDIF
	ENDIF
	
	IF MV_PAR12 == 1  // Conciliado
		IF EMPTY(TRB->CONCIL )
			TRB->(DBSKIP())
			LOOP
		ENDIF
	ELSEIF MV_PAR12 == 2 // Pedente - Nao Conciliado
		IF !EMPTY(TRB->CONCIL)
			TRB->(DBSKIP())
			LOOP
		ENDIF
	ENDIF
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	DbSelectArea("CT1")
	CT1->(DBSETORDER(2))
	CT1->(DbGotop())
	CT1->(DBSEEK(xFilial("CT1")+TRB->CONTA))
	If _Conta <> TRB->CONTA  // .AND. nLin > 9 .AND. nLin < 55
		nLin:=nLin+1
		@ nLin, 000 PSay SUBS(TRB->CONTA,1,10)
		@ nLin, 020 PSay SUBS(CT1->CT1_DESC01,1,30)
		nLin:=nLin+2
	Endif
	
	_Conta := TRB->CONTA
	nTotDGer:= 0
	nTotCGer:= 0
	
	While TRB->CONTA == _Conta
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		DbSelectArea("CT1")
		CT1->(DBSETORDER(2))
		CT1->(Dbgotop())
		CT1->(DBSEEK(xFilial("CT1")+TRB->CONTA))
		
		//
		
		nTotDeb:= 0
		nTotCre:=0
		_dData := TRB->DATACON
		_cFornece := TRB->FORNECE
		
		While  TRB->DATACON == _dData //.AND. TRB->FORNECE ==  _cFornece
			
			
			If TRB->FORNECE < MV_PAR09 .OR. TRB->FORNECE > MV_PAR10
				TRB->(DBSKIP())
				LOOP
			ENDIF
			If TRB->BAIXA < MV_PAR13 .OR. TRB->BAIXA > MV_PAR14
				TRB->(DBSKIP())
				LOOP
			ENDIF
			If TRB->VENCREA < MV_PAR03 .OR. TRB->VENCREA > MV_PAR04
				TRB->(DBSKIP())
				LOOP
			ENDIF
			
			If TRB->CONCIL < MV_PAR15 .OR. TRB->CONCIL > MV_PAR16
				TRB->(DBSKIP())
				LOOP
			ENDIF
			IF MV_PAR11 == 2
				IF !EMPTY(TRB->BAIXA )
					TRB->(DBSKIP())
					LOOP
				ENDIF
			ELSEIF MV_PAR11 == 1
				IF EMPTY(TRB->BAIXA)
					TRB->(DBSKIP())
					LOOP
				ENDIF
			ENDIF
			
			IF MV_PAR12 == 2
				IF !EMPTY(TRB->CONCIL )
					TRB->(DBSKIP())
					LOOP
				ENDIF
			ELSEIF MV_PAR12 == 1
				IF EMPTY(TRB->CONCIL)
					TRB->(DBSKIP())
					LOOP
				ENDIF
			ENDIF
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				nLin:=nLin+1
				
			DbSelectArea("CT1")
       		CT1->(DBSETORDER(2))
	     	CT1->(Dbgotop())
		    CT1->(DBSEEK(xFilial("CT1")+TRB->CONTA))

				@ nLin, 000 PSay SUBS(TRB->CONTA,1,10)
				@ nLin, 020 PSay SUBS(CT1->CT1_DESC01,1,30)
				nLin:=nLin+1
			Endif
			
			//                                                                                                      1         1         1         1         1         1         1         1         1         1         2
			//            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
			//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			// "Titulo       Emissao   Fornecedor                      CR                   Debito         Credito    Bordero  AP      CHEQUE    Vencto.   Baixa     Conciliado   Historico"
			//  XXX/999999   99/99/99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX     9.999.999,99    9.999.999,99    XXXXXX   XXXXXX  999999    99/99/99  99/99/99  99/99/99     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			
			
			@ nLin, 000 PSay TRB->TIPO+"/" Picture "@!"
			@ nLin, 005 PSay TRB->NUMERO
			@ nLin, 013+3 PSay TRB->DATACON
			@ nLin, 023+3 PSay TRB->NOMFOR
			@ nLin, 055+3 PSay TRB->CCUSTO
			@ nLin, 070+3 PSay TRB->DEBITO  Picture "@E 9,999,999.99"
			@ nLin, 086+3 PSay TRB->CREDIT  Picture "@E 9,999,999.99"
			@ nLin, 102+3 PSay TRB->BORDERO
			@ nLin, 111+3 PSay TRB->NUMAP
			@ nLin, 119+3 PSay TRB->CHEQUE
			@ nLin, 129+3 PSay TRB->VENCREA
			@ nLin, 139+3 PSay TRB->BAIXA
			@ nLin, 149+3 PSay TRB->CONCIL
			@ nLin, 162+3 PSay TRB->HIST
			//		_nSubTot:=_nSubTot+SE2TMP->E2_VALOR
			//		_nTotal :=_nTotal +SE2TMP->E2_VALOR
			
			nLin:=nLin+1
			
			nTotDeb+=TRB->DEBITO
			nTotCre+=TRB->CREDIT
			nTotDGer+=TRB->DEBITO
			nTotCGer+=TRB->CREDIT
			nTotDFin+=TRB->DEBITO
			nTotCFin+=TRB->CREDIT
			
			dbSelectArea("TRB")
			TRB->(DbSkip())
			
		End
		If nTotDeb+nTotCre > 0
			nLin:=nLin+1
			@ nLin, 013 PSay "T o t a l  D i a  ==>"  
			@ nLin, 069+3 PSay nTotDeb  Picture "@E 99,999,999.99"
			@ nLin, 085+3 PSay nTotCre  Picture "@E 99,999,999.99"
			nLin:=nLin+2
		EndIf
		
	End
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If nTotDGer+nTotCGer > 0
		nLin:=nLin+1
		@ nLin, 013 PSay "T o t a l  C o n t a  ==>"  
		@ nLin, 069+3 PSay nTotDGer  Picture "@E 99,999,999.99"
		@ nLin, 085+3 PSay nTotCGer  Picture "@E 99,999,999.99"
		nLin:=nLin+1
	EndIf
	
	nLin:=nLin+1
	
EndDo

//nLin ++
//nLin ++
If nLin > 65
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

//nLin++
@ nLin, 000 PSay Replicate("-", 220)
nLin++
@ nLin, 013 PSay "T O T A L  G E R A L  ==>"  
@ nLin, 069+3 PSay nTotDFin  Picture "@E 99,999,999.99"
@ nLin, 085+3 PSay nTotCFin  Picture "@E 99,999,999.99"
nLin++
@ nLin, 000 PSay Replicate("-", 220)

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


Static Function CriaSx1()

Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

cPerg := PADR(cPerg,10)

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
AADD(aReg,{cPerg,"11","Baixados          ?","","","mv_chb","N",01,0,0,"C","","mv_par11","Sim","","","Nao","","","Ambos","","","","","","","",""})
AADD(aReg,{cPerg,"12","Tipo Mov. Financ. ?","","","mv_chb","N",01,0,0,"C","","mv_par12","Conciliado","","","Pendente","","","Ambos","","","","","","","",""})
AADD(aReg,{cPerg,"13","Baixa De          ?","","","mv_chc","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"14","Baixa Ate         ?","","","mv_chd","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"15","Conciliado De     ?","","","mv_che","D",08,0,0,"G","","mv_par15","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"16","Conciliado Ate    ?","","","mv_chf","D",08,0,0,"G","","mv_par16","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"17","Tipo Lancto Contab?","","","mv_chg","N",01,0,0,"C","","mv_par17","Debito","","","Credito","","","Ambos","","","","","","","",""})
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




Static Function FPESKEY(pPrefixo,pNumero,pParcela,pTipo,pFornece,pLoja,pLP)

Local alRet := {}
Local cAlias := GetArea()
Local dDtConc := Ctod("//")
Local cTipo := "NF "

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


RestArea(cAlias)

Return(alRet)





Static Function CCTBRCT1()


Local _Query := " "
Local _lRetReg

_Query := " SELECT COUNT(CT1_RES) AS NRREG FROM CT1010 CT1 "+cFl
_Query += " WHERE D_E_L_E_T_ = ' ' "+cFl
_Query += " AND CT1_RES BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "+cFl
_Query += " AND CT1_CLASSE = '2' "+cFl
_Query := ChangeQuery(_Query)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_Query),'TRC',.T.,.T.)
DbSelectArea("TRC")

_lRetReg := TRC->NRREG


If Select("TRC") > 0
	TRC->(DbCloseArea())
EndIf


Return(_lRetReg)




Static Function CCTBRCT2(pConta)


Local _Query := " "
Local _lRetReg

_cQuery := " SELECT COUNT(CT2_VALOR) AS NRREG"+cFl
_cQuery += " FROM "+RetSqlName("CT2")+" "+cFl
_cQuery += " WHERE D_E_L_E_T_ = ' ' "+cFl
_cQuery += " AND ( CT2_ITEMD = '"+pConta+"' OR CT2_ITEMC = '"+pConta+"') "+cFl
_cQuery += " AND CT2_DATA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+cFl
_cQuery += " AND (CT2_LP IN ('510','511','512','515','530','531','532','566','571','650')) "+cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRD',.T.,.T.)

dbSelectArea("TRD")
dbGoTop()

_lRetReg := TRD->NRREG


If Select("TRD") > 0
	TRD->(DbCloseArea())
EndIf


Return(_lRetReg)


Static Function cieCabec()

DbSelectArea("CT1")
CT1->(DBSETORDER(2))
CT1->(DBSEEK(xFilial("CT1")+TRB->CONTA))
//@ nLIn, 000 PSay SUBS(_Conta,1,10)
//@ nLin, 020 PSay SUBS(CT1->CT1_DESC01,1,30)

@ 009, 000 PSay SUBS(TRB->CONTA,1,10)
@ 009, 020 PSay SUBS(CT1->CT1_DESC01,1,30)




Return
