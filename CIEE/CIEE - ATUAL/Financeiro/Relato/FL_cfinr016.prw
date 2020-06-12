#DEFINE ENTRADA 1
#DEFINE SAIDA   2

#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"
#INCLUDE "DelAlias.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CFINR016 ³ Autor ³ Andy Pudja   		    ³ Data ³ 23.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Naturezas Financeira                  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINR016()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1  := "Este programa ir  emitir o relat¢rio de"
LOCAL cDesc2  := "movimentacoes bancarias conciliadas. Por "
LOCAL cDesc3  := "Ordem de Data e Natureza ou vice versa."
LOCAL cString :="SE5"
LOCAL Tamanho :="G"

Private LIMITE   := 220
PRIVATE titulo   := " "
//PRIVATE tit      :=OemToAnsi("Natureza Financeira")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
PRIVATE nomeprog :="CFINR016"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg	 :="FINR16    "
Private _aAliases:= {}
Private nmoeda   := 2
Private _cArq, _nArq, _lFez
Private _EOL     := chr(13) + chr(10)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    		    ³
//³ mv_par01				// Data De        					³
//³ mv_par02				// Data Ate       					³
//³ mv_par03				// Natureza De                      ³
//³ mv_par04				// Natureza	Ate	                    ³
//³ mv_par05				// Reclassificadas                  ³
//³ mv_par06				// Conta De                         ³
//³ mv_par07				// Conta Ate                        ³
//³ mv_par08				// Data Regul. De                   ³
//³ mv_par09				// Data Regul. Ate                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aRegs := {}
aAdd(aRegs,{cPerg,"01","Data De            ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Ate           ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Natureza De        ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SED","",""})
aAdd(aRegs,{cPerg,"04","Natureza Ate       ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED","",""})
aAdd(aRegs,{cPerg,"05","Reclassificadas    ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Conta De           ?","","","mv_ch6","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
aAdd(aRegs,{cPerg,"07","Conta Ate          ?","","","mv_ch7","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
aAdd(aRegs,{cPerg,"08","Data Regul. De     ?","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Data Regul. Ate    ?","","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","De Pre Cad Mov Banc?","","","mv_chA","C",05,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SZM","",""})
aAdd(aRegs,{cPerg,"11","Ate Pre Cad Mv Banc?","","","mv_chB","C",05,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SZM","",""})
AAdd(aRegs,{cPerg,"12","Agrupamento        ?","","","mv_chC","N",01,0,0,"C","","mv_par12","Natureza","","","","","Beneficiario","","","","","Documento","","","","","Conta Corrente","","","","","Pre Cadastro","","","","","",""}) //PATRICIA FONTANEZI - 04/09/2012


nSX1Order := SX1->(IndexOrd())
SX1->(dbSetOrder(1))
For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX
SX1->(dbSetOrder(nSX1Order))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "CFINR016"
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 						     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao REPORTINI substituir as variaveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

_cGrupo := ""
Do Case
	Case mv_par12 == 1
		_cGrupo	:= " Agrupamento Natureza"
	Case mv_par12 == 2
		_cGrupo	:= " Agrupamento Beneficiario"
	Case mv_par12 == 3
		_cGrupo	:= " Agrupamento Documento"
	Case mv_par12 == 4
		_cGrupo	:= " Agrupamento Conta Corrente"
	Case mv_par12 == 5
		_cGrupo	:= " Agrupamento Pre-Cadastro"
EndCase


Do Case
	Case cEmpant == '01'
		Titulo := "Relatorio Natureza(s) Financeira(s)"+_cGrupo+" -  CIEE / SP"
	Case cEmpant == '03'
		Titulo := "Relatorio Natureza(s) Financeira(s)"+_cGrupo+" -  CIEE / RJ"
	Case cEmpant == '05'
		Titulo := "Relatorio Natureza(s) Financeira(s)"+_cGrupo+" -  CIEE / NACIONAL
EndCase

RptStatus({|lEnd| FluxoCIEE(@lEnd,wnRel,cString)},titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FluxoCIEE ³ Autor ³ Andy Pudja           ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fluxo de Caixa                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FLUXOCIEE(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL tamanho:="G"
LOCAL cBanco,cNomeBanco,cAgencia,cConta,nRec,cLimCred
LOCAL limite := 220
LOCAL nSaldoAtu:=0,nTipo,nEntradas:=0,nSaidas:=0,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil	  :=""
LOCAL nOrdSE5 :=SE5->(IndexOrd())
LOCAL cChave  := ""	
LOCAL cIndex
LOCAL aRecon := {}
Local nTxMoeda := 1
Local nValor := 0
Local aStru 	:= SE5->(dbStruct()), ni
Local nMoedaBco:=	1
LOCAL nSalIniStr := 0
LOCAL nSalIniCip := 0
LOCAL nSalIniComp := 0
LOCAL nSalStr := 0
LOCAL nSalCip := 0
LOCAL nSalComp := 0
LOCAL lSpbInUse := SpbInUse()
LOCAL aStruct := {}
Local cFilterUser
Local nRegCT := 0

AAdd( aRecon, {0,0} ) // SUB-TOTAL
AAdd( aRecon, {0,0} ) // TOTAL ou TOTAL SEMANA
AAdd( aRecon, {0,0} ) // TOTAL GERAL
AAdd( aRecon, {0,0} ) // TOTAL CONTA CORRENTE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile, lAllFil :=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Tit := OemToAnsi("Analitico de ")+DTOC(mv_par01) + " a " +Dtoc(mv_par02)+" por Natureza e Data"

//          1         2         3         4         5         6         7         8         9        10
// 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec1 := OemToAnsi("DATA         BENEFICIARIO                       DOCUMENTO      CONTA CORRENTE             ENTRADAS               SAIDAS     ORIGEM      NATUREZA     DATA REGUL.     HISTORICO")
Cabec2 := OemToAnsi("")
nTipo  :=IIF(aReturn[4]==1,15,18)

DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "     
If mv_par12 == 1 
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_NATUREZ"
Elseif mv_par12 == 2
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BENEF"
Elseif mv_par12 == 3
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_DOCUMEN"
Elseif mv_par12 == 4
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_CONTA" 
Elseif mv_par12 == 5 
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_XTIPO"
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
Endif
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
If !lAllFil
	cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
EndIf
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " AND E5_NATUREZ BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " AND E5_SITUACA <> 'C' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
cQuery += " AND E5_TIPODOC IN ('VL','CH') AND E5_MOEDA IN ('  ')"
cQuery += " AND E5_RECONC <> ' '  "
cQuery += " AND E5_RECPAG = 'P'   "
cQuery += " AND E5_CONTA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
If mv_par05 == 1
	cQuery += " AND E5_NATREC <> ' '   "
ElseIf mv_par05 == 2
	cQuery += " AND E5_NATREC =  ' '   "
EndIf
cQuery += " AND E5_VENCTO BETWEEN '"+DTOS(mv_par08)+"' AND '"+DTOS(mv_par09)+"' "
If !Empty(mv_par10) .OR. !Empty(mv_par11)
	cQuery += " AND E5_XTIPO >= '"+ mv_par10+"' AND E5_XTIPO <= '"+mv_par11+"' "   //PATRICIA FONTANEZI - 04/09/2012  
EndIf	
cQuery += " AND E5_TIPODOC <> 'ES' "
cQuery += " ORDER BY " + cOrder

cQuery := ChangeQuery(cQuery)

If Select("QE5") > 0
	QE5->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QE5', .T., .T.)

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

cFilterUser := aReturn[7]

_aEstrut  := {}

// Define a estrutura do arquivo de trabalho.
_aEstrut := {;
{"E5_BANCO"   , "C", 03, 0},;
{"E5_AGENCIA" , "C", 05, 0},;
{"E5_CONTA"   , "C", 10, 0},;
{"E5_RECPAG"  , "C", 01, 0},;
{"E5_DTDISPO" , "D", 08, 0},;
{"E5_VENCTO"  , "D", 08, 0},;
{"E5_DOCUMEN" , "C", 15, 0},;
{"E5_NUMCHEQ" , "C", 15, 0},;
{"E5_MOEDA"   , "C", 02, 0},;
{"E5_TIPODOC" , "C", 02, 0},;    
{"E5_MOTBX"   , "C", 03, 0},;
{"E5_BENEF"   , "C", 30, 0},;
{"E5_VLMOED2" , "N", 14, 2},;
{"E5_VALOR"   , "N", 17, 2},;
{"E5_RECONC"  , "C", 01, 0},;
{"E5_NATUREZ" , "C", 10, 0},;
{"E5_NATREC"  , "C", 10, 0},;
{"E5_HISTOR"  , "C", 40, 0},;
{"E5_SEMANA"  , "C", 50, 0},;
{"E5_ORDEM"   , "C", 02, 0},;
{"E5_XTIPO"   , "C", 04, 0}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)  
If mv_par12 == 1  		// NATUREZA
	IndRegua("TMP", _cArqTrab, "E5_NATUREZ+DTOS(E5_DTDISPO)+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
Elseif mv_par12 == 2    // BENEFICIARIO
	IndRegua("TMP", _cArqTrab, "E5_BENEF+DTOS(E5_DTDISPO)+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
ElseIf mv_par12 == 3    // DOCUMENTO
	IndRegua("TMP", _cArqTrab, "E5_DOCUMEN+DTOS(E5_DTDISPO)+E5_NUMCHEQ+E5_BENEF+E5_BANCO+E5_RECPAG+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)	
ElseIf mv_par12 == 4	// CONTA CORRENTE
	IndRegua("TMP", _cArqTrab, "E5_CONTA+DTOS(E5_DTDISPO)+E5_DOCUMEN+E5_RECPAG+E5_DOCUMEN+E5_BENEF+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.) 
ElseIF mv_par12 == 5	// PRE CADASTRO
	IndRegua("TMP", _cArqTrab, "E5_XTIPO+DTOS(E5_DTDISPO)+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
Else
	IndRegua("TMP", _cArqTrab, "E5_NATUREZ+DTOS(E5_DTDISPO)+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
Endif
aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

DbSelectarea("QE5")
dbGoTop()

While !Eof()
	
	dbSelectArea("SE5")
	dbSetOrder(7)
	// Cria movimentacao virtual do titulo multi-natureza
	SEV->(dbSetOrder(1))
	If SEV->(dbSeek(xFilial("SEV")+QE5->E5_PREFIXO+QE5->E5_NUMERO+QE5->E5_PARCELA+QE5->E5_TIPO+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
		While !SEV->(Eof()) .And. QE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)==SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)
			dbSelectArea("TMP")
			RecLock("TMP", .T.)
			TMP->E5_RECPAG   := "P"
			TMP->E5_BANCO    := QE5->E5_BANCO
			TMP->E5_AGENCIA  := QE5->E5_AGENCIA
			TMP->E5_CONTA    := QE5->E5_CONTA
			TMP->E5_DTDISPO  := QE5->E5_DTDISPO
			TMP->E5_NUMCHEQ  := QE5->E5_NUMCHEQ
			TMP->E5_MOEDA    := QE5->E5_MOEDA
			TMP->E5_TIPODOC  := "FF"			// SE5->E5_TIPODOC
			TMP->E5_MOTBX    := QE5->E5_MOTBX
			TMP->E5_VLMOED2  := QE5->E5_VLMOED2
			TMP->E5_VALOR    := SEV->EV_VALOR
			TMP->E5_HISTOR   := "Fundo Fixo de Caixa"
			TMP->E5_NATUREZ  := SEV->EV_NATUREZ
			
			If QE5->E5_RECPAG == "P"
				If SA2->(dbSeek(xFilial("SA2")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
					TMP->E5_BENEF := SA2->A2_NREDUZ
				EndIf
			Else
				If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
					TMP->E5_BENEF := SA1->A1_NREDUZ
				EndIf
			EndIf
			
			If QE5->E5_PREFIXO == "FFC"
				TMP->E5_DOCUMEN  := "FC "+QE5->E5_DOCUMEN
			Else
				If QE5->E5_PREFIXO == "FFQ"
					TMP->E5_DOCUMEN  := "FC "+QE5->E5_DOCUMEN
				Else
					TMP->E5_DOCUMEN  := "DV "+QE5->E5_DOCUMEN
				EndIf
			EndIf
			TMP->E5_RECONC   := QE5->E5_RECONC
			msUnLock()
			
			SEV->(dbSkip())
		EndDo
	EndIf
	DbSelectarea("QE5")
	dbSkip()
EndDo

dbSelectArea("QE5")
QE5->(dbCloseArea())

// MANUAL lancamentos do SE5 para TR-Tarifa, TB-Transferencia, BA-Pgto Bolsa Auxilio por Carta, FL-Ficha Lançamento,
// AP- Aplicação
// Contas de Consumo
// Prestacao de Contas
// CNI

DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "
//cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
If !lAllFil
	cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
EndIf
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " AND E5_NATUREZ BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += " AND E5_SITUACA <> 'C' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_CONTA BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
// Este relatorio trata as Contas de Consumo através dos registros SE5 do tipo "CC "
// gerados pela rotina CFINM04, diferentemente do CFINR009 - Extrato Bancario
// que utiliza diretamente registros incluidos na tabela SZ5.
// Os creditos do CNI tb são lançados automaticamente no Extrato Bancario, no entanto para o Fluxo
// desenvolvemos a rotina CFINR013 para gerar os registros em SE5 do tipo "CI "
If mv_par05 == 1
	cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','RC') AND E5_RECONC <> ' ' ) OR "
ElseIf mv_par05 == 2
	cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI') AND E5_RECONC <> ' ' ) OR "
Else
	cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI','RC') AND E5_RECONC <> ' ' ) OR "
EndIf

cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                         AND E5_RECONC <> ' ' ) OR "
cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                         AND E5_RECONC <> ' ' ) OR "
cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                         AND E5_RECONC <> ' ' ) OR "
// As aplicacoes da tabela SZG gera unica movimentacao em SE5 por banco com tipo "PL "
cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                         AND E5_RECONC <> ' ' ) OR"
// Titulos FL Baixados Manualmente
cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO  IN ('FL ')                                        AND E5_RECONC <> ' ' ) OR"
// Transferencias entre Contas
cQuery += "       (E5_TIPODOC IN ('TR','TE') AND E5_MOEDA IN ('TR')                                         AND E5_RECONC <> ' ' )   )"
If mv_par05 == 1
	cQuery += " AND E5_NATREC <>  ' '   "
ElseIf mv_par05 == 2
	cQuery += " AND E5_NATREC =   ' '   "
EndIf
cQuery += " AND E5_VENCTO BETWEEN '"+DTOS(mv_par08)+"' AND '"+DTOS(mv_par09)+"' "
If !Empty(mv_par10) .OR. !Empty(mv_par11)
	cQuery += " AND E5_XTIPO >= '"+ mv_par10+"' AND E5_XTIPO <= '"+ mv_par11+"' "
EndIf	
cQuery += " ORDER BY " + cOrder
cQuery := ChangeQuery(cQuery)

dbSelectArea("SE5")
dbCloseArea()

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

DbSelectarea("SE5")
dbGoTop()

While !Eof()
	
	If Empty(SE5->E5_RECONC) .And. SE5->E5_MOEDA $ "FL"
		DbSelectarea("SE5")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("TMP")
	RecLock("TMP", .T.)
	TMP->E5_BANCO    := SE5->E5_BANCO
	TMP->E5_AGENCIA  := SE5->E5_AGENCIA
	TMP->E5_CONTA    := SE5->E5_CONTA
	TMP->E5_RECPAG   := SE5->E5_RECPAG
	TMP->E5_DTDISPO  := SE5->E5_DTDISPO
	TMP->E5_VENCTO   := SE5->E5_VENCTO
	TMP->E5_NUMCHEQ  := SE5->E5_NUMCHEQ
	TMP->E5_MOEDA    := SE5->E5_MOEDA
	TMP->E5_TIPODOC  := SE5->E5_TIPODOC
	TMP->E5_MOTBX    := SE5->E5_MOTBX
	TMP->E5_VLMOED2  := SE5->E5_VLMOED2
	TMP->E5_VALOR    := SE5->E5_VALOR
	TMP->E5_HISTOR   := SE5->E5_HISTOR
	TMP->E5_NATUREZ  := SE5->E5_NATUREZ
	TMP->E5_NATREC   := SE5->E5_NATREC 
	TMP->E5_XTIPO	 := SE5->E5_XTIPO
	
	If SE5->E5_RECPAG == "P"
		If SA2->(dbSeek(xFilial("SA2")+SE5->E5_CLIFOR+SE5->E5_LOJA, .F.))
			TMP->E5_BENEF := SA2->A2_NREDUZ
		EndIf
	Else
		If SA2->(dbSeek(xFilial("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA, .F.))
			TMP->E5_BENEF := SA1->A1_NREDUZ
		EndIf
	EndIf
	
	If SE5->E5_MOEDA $ "TB"
		TMP->E5_BENEF    := "Despesa Bancaria"
//		TMP->E5_DOCUMEN  := "TARIFA"
		TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_MOEDA $ "TR"
		TMP->E5_BENEF    := "Transferencia Bancaria"
		TMP->E5_DOCUMEN  := "TRANSFERENCIA"
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_MOEDA $ "BA"
		TMP->E5_BENEF    := "Pagamento Bolsa Auxilio"
		TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_MOEDA $ "ES"
		TMP->E5_BENEF    := "Estorno Bancario"
		TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_MOEDA $ "FL;AP;CD;GE;DD;RG;CC;PC;CI;NI"
		TMP->E5_BENEF    := SE5->E5_BENEF
		TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_MOEDA $ "RC"
		TMP->E5_BENEF    := SE5->E5_BENEF
		TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
		TMP->E5_RECONC   := SE5->E5_RECONC
		TMP->E5_DTDISPO  := SE5->E5_DATA
	ElseIf SE5->E5_TIPO == "FL "
		TMP->E5_BENEF    := SE5->E5_BENEF
		TMP->E5_DOCUMEN  := "FL "+AllTrim(SE5->E5_NUMERO)
		TMP->E5_RECONC   := SE5->E5_RECONC
	EndIf
	
	msUnLock()
	
	DbSelectarea("SE5")
	dbSkip()
EndDo

dbSelectArea("SE5")
dbCloseArea()

// Inicio da Impressão
If mv_par12 == 1             //PATRICIA FONTANEZI - 24/09/2012
	cCondWhile:="!Eof() .And. _cE5_NATUREZ == E5_NATUREZ"
Elseif mv_par12 == 2
	cCondWhile:="!Eof() .And. _cE5_BENEF == E5_BENEF" 	
ElseIf mv_par12 == 3
	cCondWhile:="!Eof() .And. _cE5_NUMCHEQ == E5_NUMCHEQ .And. _cE5_DOCUMEN == E5_DOCUMEN"
ElseIf mv_par12 == 4
	cCondWhile:="!Eof() .And. _cE5_CONTA == E5_CONTA .And. _cE5_DOCUMEN == E5_DOCUMEN"
ElseIf mv_par12 == 5
	cCondWhile:="!Eof() .And. _cE5_XTIPO == E5_XTIPO "//.And. _cE5_DOCUMEN == E5_DOCUMEN" 	
Else
	cCondWhile:="!Eof() .And. _cE5_NATUREZ == E5_NATUREZ" 
Endif

dbSelectArea("TMP")
dbGoTop()

SetRegua(Reccount())

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
li := 9

While !Eof()
	IncRegua()
	dbSelectArea("TMP")
	
	_cE5_BANCO   := E5_BANCO
	_cE5_AGENCIA := E5_AGENCIA
	_cE5_CONTA   := E5_CONTA
	_cE5_SEMANA  := E5_SEMANA
	_cE5_NATUREZ := E5_NATUREZ 
	_cE5_XTIPO	 := E5_XTIPO
	_cE5_DOCUMEN := E5_DOCUMEN
	_cE5_BENEF	 := E5_BENEF   
	_cE5_ORDEM   := E5_ORDEM
	Titulo       := _cE5_SEMANA
	
   	While !Eof() .And. _cE5_NATUREZ == E5_NATUREZ
   	//While !Eof() .And. _cE5_ORDEM == E5_ORDEM	
		dbSelectArea("TMP")
		
		_dE5_DTDISPO := E5_DTDISPO
		_cE5_DOCUMEN := E5_DOCUMEN
		_cE5_NUMCHEQ := E5_NUMCHEQ
		_cE5_RECPAG  := E5_RECPAG
		_cE5_MOEDA   := E5_MOEDA
		_cE5_TIPODOC := E5_TIPODOC
		_cTit        := SUBSTR(AllTrim(E5_BENEF),1,30)
		_nTotal      := 0
		
		While &(cCondWhile)
			
			IF lEnd
				@PROW()+1,0 PSAY OemToAnsi("Cancelado pelo operador")
				EXIT
			Endif
			
			IncRegua()

			
/*        1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
DATA         BENEFICIARIO                       DOCUMENTO      CONTA CORRENTE             ENTRADAS               SAIDAS     ORIGEM      NATUREZA     DATA REGUL.     HISTORICO
99/99/99     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     9999999999     99999999-9         9,999,999,999.99     9,999,999,999.99     9.99.99     9.99.99      99/99/99        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*/

			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				li := 9
			EndIF
			
			dbSelectArea("TMP")
			
			If AllTrim(E5_NATUREZ) < AllTrim(mv_par03) .Or. AllTrim(E5_NATUREZ) >  AllTrim(mv_par04)
				dbSkip()
				Loop
			EndIf
			
			@li,000 PSAY E5_DTDISPO
			@li,013 PSAY IIF(Empty(E5_BENEF), Space(30), SUBSTR(AllTrim(E5_BENEF),1,30))
			
			If !EMPTY(E5_DOCUMEN)
				If E5_RECPAG  == "P"
					Do Case
						Case E5_TIPODOC $ "VL" //"BA" //
							@li,048 PSAY "BD "+AllTrim(E5_DOCUMEN)
							cDoc := "BD "+E5_DOCUMEN
							@li,063 PSAY +AllTrim(E5_CONTA)
						Case E5_TIPODOC $ "CH"
							@li,048 PSAY "CH "+AllTrim(E5_NUMCHEQ)
							cDoc := "CH "+E5_NUMCHEQ
							@li,063 PSAY +AllTrim(E5_CONTA)
						OtherWise
							If Left(E5_DOCUMEN,2)=="PC" .And. Subs(E5_DOCUMEN,10,1)=="/"
								@li,048 PSAY Left(E5_DOCUMEN,10)
								cDoc := Left(E5_DOCUMEN,10)
							Else
								If Left(E5_DOCUMEN,2)=="PC"
									@li,048 PSAY "BD "+AllTrim(E5_DOCUMEN)
									cDoc := "BD "+AllTrim(E5_DOCUMEN)
								Else
									Do Case //alteracao 23/03/09 emerson
										Case E5_MOEDA $ "CC"
											@li,048 PSAY "DM "+AllTrim(E5_DOCUMEN)
											cDoc := "DM "+AllTrim(E5_DOCUMEN)
											@li,063 PSAY +AllTrim(E5_CONTA)
										Case E5_MOEDA $ "RC"
											@li,048 PSAY "RC "+AllTrim(E5_DOCUMEN)
											cDoc := "RC "+AllTrim(E5_DOCUMEN)
											@li,063 PSAY +AllTrim(E5_CONTA)
										OtherWise
											@li,048 PSAY AllTrim(E5_DOCUMEN)
											cDoc := AllTrim(E5_DOCUMEN)
											@li,063 PSAY +AllTrim(E5_CONTA)
									EndCase
								EndIf
							EndIf
					EndCase
				Else
					If Left(E5_DOCUMEN,2)=="PC"
						@li,048 PSAY "BD "+Subs(E5_DOCUMEN,3,10)
						cDoc := "BD "+Subs(E5_DOCUMEN,3,10)
						@li,063 PSAY +AllTrim(E5_CONTA)
					ElseIf E5_MOEDA <> "CI"
						@li,048 PSAY AllTrim(E5_DOCUMEN)
						cDoc := E5_DOCUMEN
						@li,063 PSAY +AllTrim(E5_CONTA)
					Else
						@li,048 PSAY AllTrim(E5_DOCUMEN)
						cDoc := E5_DOCUMEN
					EndIf
				EndIf
			Else
				cDoc := E5_NUMCHEQ
				If !Empty(E5_NUMCHEQ)
					@li,048 PSAY "CH "+AllTrim(E5_NUMCHEQ)
					cDoc := "CH "+E5_NUMCHEQ
					@li,063 PSAY +AllTrim(E5_CONTA)
				Else
					@li,048 PSAY Space(15)
					cDoc := E5_NUMCHEQ
					@li,063 PSAY +AllTrim(E5_CONTA)
				EndIf
			EndIf
			
			nValor := E5_VALOR
			
			If E5_RECPAG == "P"
				@li,103 PSAY nValor Picture tm(nValor,16,nMoeda)
				aRecon[1][SAIDA]   += nValor
				aRecon[2][SAIDA]   += nValor
				aRecon[3][SAIDA]   += nValor
				aRecon[4][SAIDA]   += nValor
			Else
				@li,82 PSAY nValor Picture tm(nValor,16,nMoeda)
				aRecon[1][ENTRADA] += nValor
				aRecon[2][ENTRADA] += nValor
				aRecon[3][ENTRADA] += nValor
				aRecon[4][SAIDA]   += nValor
			EndIf
			_nTotal   += nValor
			
			If mv_par05 == 1  // Reclassificadas Sim
				@li,124 PSAY E5_NATUREZ
				@li,136 PSAY E5_NATREC
				@li,149 PSAY E5_VENCTO
			ElseIf mv_par05 == 2  // Reclassificadas Nao
				@li,124 PSAY E5_NATUREZ
			ElseIf mv_par05 == 3  // Todas
				If !Empty(E5_NATREC)
					@li,124 PSAY E5_NATUREZ
					@li,136 PSAY E5_NATREC
					@li,149 PSAY E5_VENCTO
				Else
					@li,124 PSAY E5_NATUREZ
				EndIf
			EndIf

			@li,165 PSAY IIF(Empty(E5_HISTOR), Space(40), SUBSTR(AllTrim(E5_HISTOR),1,40))
			
			dbSelectArea("TMP")
			dbSkip()
			li++
		EndDo
		
		If (aRecon[1][ENTRADA] <> 0 .Or. aRecon[1][SAIDA] <> 0)
			li++
			
			If li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				li := 9
			Endif
			
			_cDescNat := POSICIONE("SED",1,xFilial("SED")+_cE5_NATUREZ,"ED_DESCRIC")
			
			@li,013 PSAY OemToAnsi("SUB-TOTAL de "+Left(_cE5_NATUREZ,7)+" - "+Left(_cDescNat,30)+": ")
			
			If aRecon[1][ENTRADA] <> 0
				@li,082 PSAY aRecon[1][ENTRADA]   PicTure tm(aRecon[1][1],16,nMoeda)
			EndIf
			If aRecon[1][SAIDA] <> 0
				@li,103 PSAY aRecon[1][SAIDA]     PicTure tm(aRecon[1][2],16,nMoeda)
			EndIf
			li++
			@ li,000 PSAY __PrtThinLine()
			li++
		EndIf
		
		aRecon[1][ENTRADA] := 0
		aRecon[1][SAIDA]   := 0      
		
		_cE5_CONTA   := E5_CONTA
	
		_cE5_NATUREZ := E5_NATUREZ 
		_cE5_BENEF   := E5_BENEF
		_cE5_DOCUMEN := E5_DOCUMEN
		_cE5_XTIPO   := E5_XTIPO
		
	EndDo
	
	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := 9
	Endif
	
	li++
EndDo

@li,000 PSAY OemToAnsi("TOTAL................................................: ")

If aRecon[2][ENTRADA] <> 0
	@li,082 PSAY aRecon[2][ENTRADA]                            PicTure tm(aRecon[2][1],16,nMoeda)
EndIf
If aRecon[2][SAIDA] <> 0
	@li,103 PSAY aRecon[2][SAIDA]                              PicTure tm(aRecon[2][2],16,nMoeda)
EndIf

aRecon[2][ENTRADA] := 0
aRecon[2][SAIDA]   := 0

li++
li++
li++

Set Device To Screen

dbSelectArea("SE5")
dbCloseArea()
ChKFile("SE5")
dbSelectArea("SE5")
dbSetOrder(1)

FechaAlias(_aAliases)

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()
Return