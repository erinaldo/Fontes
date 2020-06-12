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
±±³Fun‡„o	 ³ CFINR011 ³ Autor ³ Andy Pudja   		    ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Fluxo de Caixa                      		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFINR011()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1  := "Este programa ir  emitir o relat¢rio de Fluxo de  Caixa"
LOCAL cDesc2  := "baseado no extrato das movimentacoes bancarias conciliadas. Por "
LOCAL cDesc3  := "Ordem de Data e Natureza ou vice versa."
LOCAL cString :="SE5"
LOCAL Tamanho :="G"
Private LIMITE   := 220
PRIVATE titulo   :=OemToAnsi("Fluxo de Caixa")
PRIVATE tit      :=OemToAnsi("Fluxo de Caixa")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog :="CFINR011"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg	 :="FINR11"
Private _aAliases:= {}
Private nmoeda   := 2
Private _cArq, _nArq, _lFez
Private _EOL     := chr(13) + chr(10)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FINR11",.F.)                                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    		    							³
//³ mv_par01				// Data x Natureza x Benficiario x Documento x Conta Corrente	³ // chamado n. 22008 alterado por CG em 19/01/07
//³ mv_par02				// Data De        				 								³
//³ mv_par03				// Data Ate       												³
//³ mv_par04				// Natureza De													³
//³ mv_par05				// Natureza	Ate	                    							³
//³ mv_par06				// Analitico/Sintetico           							    ³
//³ mv_par07				// Gera Exportacao              							    ³
//³ mv_par08				// Diretorio                     							    ³
//³ mv_par09				// Agrupa por Semana             							    ³
//³ mv_par10				// Sim/Nao                      							    ³
//³ mv_par11    			// Antecipados Sim/Nao            							    ³
//³ mv_par12    			// AP/Cheque                   	 						        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AAdd(_aPerg,{cPerg,"01","Agrupamento        ?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Data","","","","","Natureza","","","","","Benficiario","","","","","Documento","","","","","Conta Corrente","","","","","",""}) // chamado n. 22008 alterado por CG em 19/01/07
aAdd(_aPerg,{cPerg,"02","Da  Data           ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"03","Ate Data           ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"04","Da  Natureza       ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"05","Ate Natureza       ?","","","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"06","Tipo Relatorio     ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"07","Gera Exportacão    ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"08","Diretorio          ?","","","mv_ch8","C",50,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"09","Agrupa por Semana  ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"10","Conciliado         ?","","","mv_cha","N",01,0,0,"C","","mv_par10","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"11","Fluxo              ?","","","mv_chb","N",01,0,0,"C","","mv_par11","Antecipado","","","","","Realizado","","","","","Ambos","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"12","Impressao Cheque   ?","","","mv_chc","N",01,0,0,"C","","mv_par12","AP","","","","","Cheque","","","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "CFINR011"            //Nome Default do relatorio em Disco
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"")

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

RptStatus({|lEnd| FluxoCIEE(@lEnd,wnRel,cString)},titulo)

If mv_par07==1  .And. _lFez
	fClose(_nArq)
EndIf

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
LOCAL tamanho:="M"
LOCAL cBanco,cNomeBanco,cAgencia,cConta,nRec,cLimCred
LOCAL limite := 132
LOCAL nSaldoAtu:=0,nTipo,nEntradas:=0,nSaidas:=0,nSaldoIni:=0
LOCAL cDOC        := Space(15)
//LOCAL _cE5_NUMAP  := Space(15)
LOCAL cFil	  :=""
LOCAL nOrdSE5 :=SE5->(IndexOrd())
LOCAL cChave
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
Local aRet := {}
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
//³ Defini‡„o da Exportacao                 				     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07==1
	_cArq := AllTrim(MV_PAR08)+"FL"+SUBSTR(DTOS(dDataBase),3,6)+".flx"
	_lFez := .T.
	If (_nArq := fCreate(_cArq)) == -1
		_cMsg := "Não foi possível criar o Arquivo de Exportação " + _cArq + "."
		MsgAlert(_cMsg, "Atenção!")
		_lFez := .F.
		Return
	EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01==1
	If mv_par06==1
		Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Natureza"
	Else
		Tit := OemToAnsi("Sintetico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Natureza"
	EndIf
ElseIf mv_par01==2
	If mv_par06==1
		Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Natureza e Data"
	Else
		Tit := OemToAnsi("Sintetico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Natureza e Data"
	EndIf
ElseIf mv_par01==3
	If mv_par06==1
		Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Beneficiario"
	Else
		Tit := OemToAnsi("Sintetico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Beneficiario"
	EndIf
ElseIf mv_par01==4
	If mv_par06==1
		Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Documento"
	Else
		Tit := OemToAnsi("Sintetico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Documento"
	EndIf
ElseIf mv_par01==5 // chamado n. 22008 alterado por CG em 19/01/07
	If mv_par06==1
		Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Conta Corrente"
	Else
		Tit := OemToAnsi("Sintetico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Conta Corrente"
	EndIf
EndIf

If mv_par10==1
	Tit := Tit + " - Realizados     "
Else
	Tit := Tit + " - Nao Conciliados"
EndIf

cabec1 := OemToAnsi("DATA        BENEFICIARIO                     DOCUMENTO           C.CORRENTE          ENTRADAS          SAIDAS              NATUREZA")
cabec2 := ""
nTipo  :=IIF(aReturn[4]==1,15,18)

SetRegua(RecCount())

DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
If !lAllFil
	cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
EndIf
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par02) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par03) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
cQuery += " AND E5_TIPO <> 'ACF' AND E5_TIPO <> 'FL'  "
cQuery += " AND E5_TIPODOC IN ('VL','CH','BA') AND E5_MOEDA IN ('  ') "
If mv_par10 == 1
	If mv_par11 == 1
		cQuery += " AND  E5_RECONC =  ' '  AND E5_FLUXO  <> ' '                           "
	ElseIf mv_par11 == 2
		cQuery += " AND  E5_RECONC <> ' '  AND E5_FLUXO  =  ' '                           "
	ElseIf mv_par11 == 3
		cQuery += " AND (E5_RECONC <> ' '  OR (E5_RECONC =  ' '  AND E5_FLUXO  <>  ' '  ))"
	EndIf
Else
	If mv_par11 == 1
		cQuery += " AND  E5_RECONC =  ' '  AND E5_FLUXO  <> ' '  "
	ElseIf mv_par11 == 2
		cQuery += " AND  E5_RECONC =  ' '  AND E5_FLUXO  =  ' '  "
	ElseIf mv_par11 == 3
		cQuery += " AND  E5_RECONC =  ' '                        "
	EndIf
EndIf
cQuery += " AND E5_RECPAG = 'P' "
cQuery += " ORDER BY " + cOrder
cQuery := ChangeQuery(cQuery)

//dbSelectAre("SE5")
//dbCloseArea()
IF Select("QE5") > 0
	QE5->(dbCloseArea())
ENDIF



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
{"E5_RECPAG"  , "C", 01, 0},;
{"E5_DTDISPO" , "D", 08, 0},;
{"E5_DOCUMEN" , "C", 15, 0},;
{"E5_NUMCHEQ" , "C", 15, 0},;
{"E5_MOEDA"   , "C", 02, 0},;
{"E5_TIPODOC" , "C", 02, 0},;
{"E5_BANCO"   , "C", 03, 0},;
{"E5_AGENCIA" , "C", 05, 0},;
{"E5_CONTA"   , "C", 10, 0},;
{"E5_MOTBX"   , "C", 03, 0},;
{"E5_BENEF"   , "C", 40, 0},;
{"E5_VLMOED2" , "N", 14, 2},;
{"E5_VALOR"   , "N", 17, 2},;
{"E5_RECONC"  , "C", 01, 0},;
{"E5_NATUREZ" , "C", 10, 0},;
{"E5_NATREC"  , "C", 10, 0},;
{"E5_FLUXO"   , "C", 01, 0},;
{"E5_HISTOR"  , "C", 40, 0},;
{"E5_ORDEM"   , "C", 02, 0},;
{"E5_NUMAP"   , "C", 06, 0},;
{"E5_SEMANA"  , "C", 50, 0}}


// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)
// Cria o indice para o arquivo.
If mv_par01==1
	IndRegua("TMP", _cArqTrab, "DTOS(E5_DTDISPO)+E5_NATUREZ+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
ElseIf mv_par01==2
	IndRegua("TMP", _cArqTrab, "E5_NATUREZ+DTOS(E5_DTDISPO)+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
ElseIf mv_par01==3
	IndRegua("TMP", _cArqTrab, "DTOS(E5_DTDISPO)+E5_BENEF+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
ElseIf mv_par01==4
	IndRegua("TMP", _cArqTrab, "DTOS(E5_DTDISPO)+E5_NUMCHEQ+E5_DOCUMEN+E5_BENEF+E5_BANCO+E5_RECPAG+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
ElseIf mv_par01==5
	IndRegua("TMP", _cArqTrab, "DTOS(E5_DTDISPO)+E5_CONTA+E5_DOCUMEN+E5_RECPAG+E5_DOCUMEN+E5_BENEF+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.) // chamado n. 22008 alterado por CG em 19/01/07
EndIf
aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

DbSelectarea("QE5")
dbGoTop()

//nCtReg := VerReg(MV_PAR02,MV_PAR03)



//SetRegua(nCtReg)

//ProcRegua(nCtReg)

While !Eof()
	_lFF:=.T.
	
	//	IncProc("Lendo Movimentoc Financeiros "+QE5->E5_DTDISPO)
	dbSelectArea("SE5")
	dbSetOrder(7)
	If dbSeek(xFilial("SE5")+QE5->E5_PREFIXO+QE5->E5_NUMERO+QE5->E5_PARCELA+QE5->E5_TIPO+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.)
		While !Eof() .And. QE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)==SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
			If AllTrim(SE5->E5_TIPODOC)=="ES"
				_lFF:=.F.
			EndIf
			dbSkip()
		EndDo
	EndIf
	
	If _lFF
		// Cria movimentacao virtual do titulo multi-natureza
		SEV->(dbSetOrder(1))
		If SEV->(dbSeek(xFilial("SEV")+QE5->E5_PREFIXO+QE5->E5_NUMERO+QE5->E5_PARCELA+QE5->E5_TIPO+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
			While !SEV->(Eof()) .And. QE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)==SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)
				dbSelectArea("TMP")
				RecLock("TMP", .T.)
				TMP->E5_RECPAG   := "P"
				TMP->E5_DTDISPO  := QE5->E5_DTDISPO
				TMP->E5_NUMCHEQ  := QE5->E5_NUMCHEQ
				TMP->E5_MOEDA    := QE5->E5_MOEDA
//				TMP->E5_NUMAP    := QE5->E5_NUMAP
				TMP->E5_BANCO    := QE5->E5_BANCO
				TMP->E5_AGENCIA  := QE5->E5_AGENCIA
				TMP->E5_CONTA    := QE5->E5_CONTA
				
				TMP->E5_MOTBX    := QE5->E5_MOTBX
				TMP->E5_VLMOED2  := QE5->E5_VLMOED2
				TMP->E5_VALOR    := SEV->EV_VALOR
				
				TMP->E5_NATUREZ  := SEV->EV_NATUREZ
				TMP->E5_NATREC   := ""
				
				If QE5->E5_RECPAG == "P"
					If SA2->(dbSeek(xFilial("SA2")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
						//						TMP->E5_BENEF := SA2->A2_NREDUZ // Devera imprimir a Razao Social CFB 10/08/04 16H18
						TMP->E5_BENEF := SA2->A2_NOME
					EndIf
				Else
					If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
						//						TMP->E5_BENEF := SA1->A1_NREDUZ
						TMP->E5_BENEF := SA1->A1_NOME
					EndIf
				EndIf
				
				If QE5->E5_PREFIXO == "FFC"
					TMP->E5_TIPODOC  := "FC"
					TMP->E5_HISTOR   := "Fundo Fixo de Caixa"
					TMP->E5_DOCUMEN  := "FC "+QE5->E5_DOCUMEN
				Else
					If QE5->E5_PREFIXO == "FFQ"
						TMP->E5_TIPODOC  := "FQ"
						TMP->E5_HISTOR   := "Fundo Fixo de Quilometragem"
						TMP->E5_DOCUMEN  := "FC "+QE5->E5_DOCUMEN
					Else
						TMP->E5_TIPODOC  := "DV"
						TMP->E5_HISTOR   := "Diversos"
						TMP->E5_DOCUMEN  := "DV "+QE5->E5_DOCUMEN
					EndIf
				EndIf
				
				TMP->E5_RECONC   := QE5->E5_RECONC
				msUnLock()
				
				SEV->(dbSkip())
			EndDo
		Else
			
			// Realiza a Pesqauisa se Existe Rateio para pagamentos com  Cheque
			
			
			aRetPesq := IIF(!EMPTY(QE5->E5_NUMCHEQ),PsqTit(QE5->E5_BANCO,QE5->E5_AGENCIA, QE5->E5_CONTA,QE5->E5_NUMCHEQ,QE5->E5_CLIFOR),aRet)
			If Len(aRetPesq) > 0
				
				For _Ct := 1 To Len(aRetPesq)
					
					dbSelectArea("TMP")
					RecLock("TMP", .T.)
					TMP->E5_RECPAG   := "P"
					TMP->E5_DTDISPO  := QE5->E5_DTDISPO
					TMP->E5_NUMCHEQ  := QE5->E5_NUMCHEQ
					TMP->E5_MOEDA    := QE5->E5_MOEDA
					TMP->E5_TIPODOC  := QE5->E5_TIPODOC
					TMP->E5_NUMAP    := QE5->E5_NUMAP
					TMP->E5_BANCO    := QE5->E5_BANCO
					TMP->E5_AGENCIA  := QE5->E5_AGENCIA
					TMP->E5_CONTA    := QE5->E5_CONTA
					
					TMP->E5_MOTBX    := QE5->E5_MOTBX
					TMP->E5_VLMOED2  := QE5->E5_VLMOED2
					TMP->E5_VALOR    := aRetPesq[_Ct][1]  // QE5->E5_VALOR
					TMP->E5_HISTOR   := QE5->E5_HISTOR
					TMP->E5_NATUREZ  := aRetPesq[_Ct][2]  // QE5->E5_NATUREZ
					TMP->E5_NATREC   := aRetPesq[_Ct][2]
					TMP->E5_FLUXO    := QE5->E5_FLUXO
					If Alltrim(QE5->E5_TIPODOC)=="CH"
						TMP->E5_BENEF := QE5->E5_BENEF
					Else
						If QE5->E5_RECPAG == "P"
							If SA2->(dbSeek(xFilial("SA2")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
								//						TMP->E5_BENEF := SA2->A2_NREDUZ
								TMP->E5_BENEF := SA2->A2_NOME
							EndIf
						Else
							If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
								//						TMP->E5_BENEF := SA1->A1_NREDUZ
								TMP->E5_BENEF := SA2->A2_NOME
							EndIf
						EndIf
					EndIf
					TMP->E5_DOCUMEN  := QE5->E5_DOCUMEN
					TMP->E5_RECONC   := QE5->E5_RECONC
					msUnLock()
				Next
			Else
				dbSelectArea("TMP")
				RecLock("TMP", .T.)
				TMP->E5_RECPAG   := "P"
				TMP->E5_DTDISPO  := QE5->E5_DTDISPO
				TMP->E5_NUMCHEQ  := QE5->E5_NUMCHEQ
				TMP->E5_MOEDA    := QE5->E5_MOEDA
				TMP->E5_TIPODOC  := QE5->E5_TIPODOC
				TMP->E5_NUMAP    := QE5->E5_NUMAP
				TMP->E5_BANCO    := QE5->E5_BANCO
				TMP->E5_AGENCIA  := QE5->E5_AGENCIA
				TMP->E5_CONTA    := QE5->E5_CONTA
				
				TMP->E5_MOTBX    := QE5->E5_MOTBX
				TMP->E5_VLMOED2  := QE5->E5_VLMOED2
				TMP->E5_VALOR    := QE5->E5_VALOR
				TMP->E5_HISTOR   := QE5->E5_HISTOR
				TMP->E5_NATUREZ  := QE5->E5_NATUREZ
				TMP->E5_NATREC   := QE5->E5_NATREC
				TMP->E5_FLUXO    := QE5->E5_FLUXO
				If Alltrim(QE5->E5_TIPODOC)=="CH"
					TMP->E5_BENEF := QE5->E5_BENEF
				Else
					If QE5->E5_RECPAG == "P"
						If SA2->(dbSeek(xFilial("SA2")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
							//						TMP->E5_BENEF := SA2->A2_NREDUZ
							TMP->E5_BENEF := SA2->A2_NOME
						EndIf
					Else
						If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
							//						TMP->E5_BENEF := SA1->A1_NREDUZ
							TMP->E5_BENEF := SA2->A2_NOME
						EndIf
					EndIf
				EndIf
				TMP->E5_DOCUMEN  := QE5->E5_DOCUMEN
				TMP->E5_RECONC   := QE5->E5_RECONC
				msUnLock()
			EndIf
			
		EndIf
	EndIf
	DbSelectarea("QE5")
	dbSkip()
EndDo

dbSelectAre("QE5")
If Select("QE5") > 0
	QE5->(dbCloseArea())
EndIf

// MANUAL lancamentos do SE5 para TR-Tarifa, TB-Transferencia, BA-Pgto Bolsa Auxilio por Carta, FL-Ficha Lançamento, AP- Aplicação
// Contas de Consumo
// Prestacao de Contas
// CNI

DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
If !lAllFil
	cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
EndIf
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par02) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par03) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "

// Este relatorio trata as Contas de Consumo através dos registros SE5 do tipo "CC "
// gerados pela rotina CFINM04, diferentemente do CFINR009 - Extrato Bancario
// que utiliza diretamente registros incluidos na tabela SZ5.

// Os creditos do CNI tb são lançados automaticamente no Extrato Bancario, no entanto para o Fluxo
// desenvolvemos a rotina CFINR013 para gerar os registros em SE5 do tipo "CI "
If mv_par10 == 1
/* alteracao dia 21 e 22/03/07 pelo analista Emerson
Tudo que tem Moeda (numerario) 'NI' foi alterado para 'RC', devido alteracao da rotina CFINA25 que trata a
Regularizacao dos Creditos Nao Identificados
*/
	If mv_par11 == 1
//		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI') AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
//		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RC') AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG') AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		// As aplicacoes da tabela SZG gera unica movimentacao em SE5 por banco com tipo "PL "
		cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		// Titulos FL Baixados Manualmente
		cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO IN ('FL ')                                             AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) )"
	ElseIf mv_par11 == 2
//		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RC') AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG') AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
		cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                              AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
		cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                              AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
		cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                              AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
		// As aplicacoes da tabela SZG gera unica movimentacao em SE5 por banco com tipo "PL "
		cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                              AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
		// Titulos FL Baixados Manualmente
		cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO IN ('FL ')                                             AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) )"
	ElseIf mv_par11 == 3
//		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RC') AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' )) ) OR "
		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG') AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' )) ) OR "
		cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                              AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' )) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                              AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' )) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                              AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' )) ) OR "
		// As aplicacoes da tabela SZG gera unica movimentacao em SE5 por banco com tipo "PL "
		cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                              AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' )) ) OR "
		// Titulos FL Baixados Manualmente
		cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO IN ('FL ')                                             AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' )) ) )"
	EndIf
Else
	If mv_par11 == 1
//		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RC') AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG') AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		// As aplicacoes da tabela SZG gera unica movimentacao em SE5 por banco com tipo "PL "
		cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) OR "
		// Titulos FL Baixados Manualmente
		cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO IN ('FL ')                                             AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) )"
	ElseIf mv_par11 == 2
//		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RC') AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) ) OR "
		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG') AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) ) OR "
		cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) ) OR "
		// As aplicacoes da tabela SZG gera unica movimentacao em SE5 por banco com tipo "PL "
		cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                              AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) ) OR "
		// Titulos FL Baixados Manualmente
		cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO IN ('FL ')                                             AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) ) )"
	ElseIf mv_par11 == 3
//		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RC') AND  E5_RECONC =  ' '  ) OR "
		cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG') AND  E5_RECONC =  ' '  ) OR "
		cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                              AND  E5_RECONC =  ' '  ) OR "
		cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                              AND  E5_RECONC =  ' '  ) OR "
		cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                              AND  E5_RECONC =  ' '  ) OR "
		// As aplicacoes da tabela SZG gera unica movimentacao em SE5 por banco com tipo "PL "
		cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                              AND  E5_RECONC =  ' '  ) OR "
		// Titulos FL Baixados Manualmente
		cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO IN ('FL ')                                             AND  E5_RECONC =  ' '  ) )"
	EndIf
EndIf
cQuery += " AND E5_FLUXO  = ' ' "
cQuery += " ORDER BY " + cOrder
cQuery := ChangeQuery(cQuery)


//dbSelectAre("SE5")
//dbCloseArea()

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QSE5', .T., .T.)

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QSE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next


DbSelectarea("QSE5")
dbGoTop()

While !Eof()
	If Empty(QSE5->E5_RECONC) .And. QSE5->E5_MOEDA $ "FL"
		DbSelectarea("QSE5")
		dbSkip()
		Loop
	EndIf
	
	
	///  Rateio de Baixa Manual de FL
	
	_lGeraFL:=.T.
	If  QSE5->E5_TIPO == "FL "
		SEV->(dbSetOrder(1))
		If SEV->(dbSeek(xFilial("SEV")+QSE5->E5_PREFIXO+QSE5->E5_NUMERO+QSE5->E5_PARCELA+QSE5->E5_TIPO+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
			While !SEV->(Eof()) .And. QSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)==SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)
				dbSelectArea("TMP")
				RecLock("TMP", .T.)
				TMP->E5_RECPAG   := "P"
				TMP->E5_DTDISPO  := QSE5->E5_DTDISPO
				TMP->E5_NUMCHEQ  := QSE5->E5_NUMCHEQ
				TMP->E5_MOEDA    := QSE5->E5_MOEDA
				TMP->E5_NUMAP    := QSE5->E5_NUMAP
				TMP->E5_BANCO    := QSE5->E5_BANCO
				TMP->E5_AGENCIA  := QSE5->E5_AGENCIA
				TMP->E5_CONTA    := QSE5->E5_CONTA
				
				TMP->E5_MOTBX    := QSE5->E5_MOTBX
				TMP->E5_VLMOED2  := QSE5->E5_VLMOED2
				TMP->E5_VALOR    := QSE5->E5_VALOR * SEV->EV_PERC // SEV->EV_VALOR
				
				TMP->E5_NATUREZ  := SEV->EV_NATUREZ
				TMP->E5_NATREC   := ""
				
				If QSE5->E5_RECPAG == "P"
					If SA2->(dbSeek(xFilial("SA2")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
						//						TMP->E5_BENEF := SA2->A2_NREDUZ
						TMP->E5_BENEF := SA2->A2_NOME
					EndIf
				Else
					If SA2->(dbSeek(xFilial("SA1")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
						//						TMP->E5_BENEF := SA1->A1_NREDUZ
						TMP->E5_BENEF := SA2->A2_NOME
					EndIf
				EndIf
				
				
				TMP->E5_TIPODOC  := "FL"
				TMP->E5_HISTOR   := "Ficha de Lancamento"
				TMP->E5_DOCUMEN  := "FL "+AllTrim(QSE5->E5_NUMERO)
				
				TMP->E5_RECONC   := QSE5->E5_RECONC
				msUnLock()
				
				SEV->(dbSkip())
				_lGeraFL:=.F.
			EndDo
			
		EndIf
	EndIf
	
	
	
	If _lGeraFL // Caso Nao tenha Rateio então agrega as movimentacoes em TMP de outra forma.
		
		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->E5_RECPAG   := QSE5->E5_RECPAG
		TMP->E5_DTDISPO  := QSE5->E5_DTDISPO
		TMP->E5_NUMCHEQ  := QSE5->E5_NUMCHEQ
		TMP->E5_MOEDA    := QSE5->E5_MOEDA
		TMP->E5_TIPODOC  := QSE5->E5_TIPODOC
		TMP->E5_NUMAP    := QSE5->E5_NUMAP
		TMP->E5_BANCO    := QSE5->E5_BANCO
		TMP->E5_AGENCIA  := QSE5->E5_AGENCIA
		TMP->E5_CONTA    := QSE5->E5_CONTA
		
		TMP->E5_MOTBX    := QSE5->E5_MOTBX
		TMP->E5_VLMOED2  := QSE5->E5_VLMOED2
		TMP->E5_VALOR    := QSE5->E5_VALOR
		TMP->E5_HISTOR   := QSE5->E5_HISTOR
		TMP->E5_NATUREZ  := QSE5->E5_NATUREZ
		TMP->E5_NATREC   := QSE5->E5_NATREC
		TMP->E5_FLUXO    := QSE5->E5_FLUXO
		If QSE5->E5_RECPAG == "P"
			If SA2->(dbSeek(xFilial("SA2")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
				//				TMP->E5_BENEF := SA2->A2_NREDUZ
				TMP->E5_BENEF := SA2->A2_NOME
			EndIf
		Else
			If SA2->(dbSeek(xFilial("SA1")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
				//				TMP->E5_BENEF := SA1->A1_NREDUZ
				TMP->E5_BENEF := SA2->A2_NOME
			EndIf
		EndIf
		
		If QSE5->E5_MOEDA $ "TB"
			TMP->E5_BENEF    := "Despesa Bancaria"
			TMP->E5_DOCUMEN  := "TARIFA"
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_MOEDA $ "TR"
			TMP->E5_BENEF    := "Transferencia Bancaria"
			TMP->E5_DOCUMEN  := "TRANSFERENCIA"
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_MOEDA $ "BA"
			TMP->E5_BENEF    := "Pagamento Bolsa Auxilio"
			TMP->E5_DOCUMEN  := QSE5->E5_DOCUMEN
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_MOEDA $ "ES"
			TMP->E5_BENEF    := "Estorno Bancario"
			TMP->E5_DOCUMEN  := QSE5->E5_DOCUMEN
			TMP->E5_RECONC   := QSE5->E5_RECONC
			/*
		ElseIf QSE5->E5_MOEDA $ "AP;CD;GE;DD;RG;CC;PC;CI;PL;NI"  //Alterado para nao considerar o NI e considerar o RC*/
//		ElseIf QSE5->E5_MOEDA $ "AP;CD;GE;DD;RG;CC;PC;CI;PL;RC"
		ElseIf QSE5->E5_MOEDA $ "AP;CD;GE;DD;RG;CC;PC;CI;PL"
			TMP->E5_BENEF    := QSE5->E5_BENEF
			TMP->E5_DOCUMEN  := QSE5->E5_DOCUMEN
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_TIPO == "FL "
			TMP->E5_BENEF    := QSE5->E5_BENEF
			TMP->E5_DOCUMEN  := "FL "+AllTrim(QSE5->E5_NUMERO)
			TMP->E5_RECONC   := QSE5->E5_RECONC
		EndIf
		
		msUnLock()
		
	EndIf
	
	DbSelectarea("QSE5")
	dbSkip()
EndDo

dbSelectAre("QSE5")
dbCloseArea()

//-----------------------------------------------------------------------------------------------------------------
//								INICIO TRATAMENTO MOEDA 'RC'
//-----------------------------------------------------------------------------------------------------------------
DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
If !lAllFil
	cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
EndIf
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_VENCTO >=  '"     + DTOS(mv_par02) + "'"
cQuery += " AND E5_VENCTO <=  '"     + DTOS(mv_par03) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "

If mv_par10 == 1
	If mv_par11 == 1
		cQuery += " AND ( (E5_TIPODOC IN ('  ') AND E5_MOEDA IN ('RC') AND (E5_RECONC =  ' ' AND E5_FLUXO  <> ' ' ) )"
	ElseIf mv_par11 == 2
		cQuery += " AND ( (E5_TIPODOC IN ('  ') AND E5_MOEDA IN ('RC') AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) )"
	ElseIf mv_par11 == 3
		cQuery += " AND ( (E5_TIPODOC IN ('  ') AND E5_MOEDA IN ('RC') AND (E5_RECONC <> ' ' OR (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) ) )"
	EndIf
Else
	If mv_par11 == 1
		cQuery += " AND ( (E5_TIPODOC IN ('  ') AND E5_MOEDA IN ('RC') AND (E5_RECONC =  ' '  AND E5_FLUXO  <> ' ' ) )"
	ElseIf mv_par11 == 2
		cQuery += " AND ( (E5_TIPODOC IN ('  ') AND E5_MOEDA IN ('RC') AND (E5_RECONC =  ' '  AND E5_FLUXO  =  ' ' ) )"
	ElseIf mv_par11 == 3
		cQuery += " AND ( (E5_TIPODOC IN ('  ') AND E5_MOEDA IN ('RC') AND  E5_RECONC =  ' '  )"
	EndIf
EndIf
cQuery += " AND E5_FLUXO  = ' ' "
cQuery += " ORDER BY " + cOrder
cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QSE5', .T., .T.)

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QSE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

DbSelectarea("QSE5")
dbGoTop()

While !Eof()

		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->E5_RECPAG   := QSE5->E5_RECPAG
		TMP->E5_DTDISPO  := QSE5->E5_DTDISPO
		TMP->E5_NUMCHEQ  := QSE5->E5_NUMCHEQ
		TMP->E5_MOEDA    := QSE5->E5_MOEDA
		TMP->E5_TIPODOC  := QSE5->E5_TIPODOC
		TMP->E5_NUMAP    := QSE5->E5_NUMAP
		TMP->E5_BANCO    := QSE5->E5_BANCO
		TMP->E5_AGENCIA  := QSE5->E5_AGENCIA
		TMP->E5_CONTA    := QSE5->E5_CONTA
		TMP->E5_MOTBX    := QSE5->E5_MOTBX
		TMP->E5_VLMOED2  := QSE5->E5_VLMOED2
		TMP->E5_VALOR    := QSE5->E5_VALOR
		TMP->E5_HISTOR   := QSE5->E5_HISTOR
		TMP->E5_NATUREZ  := QSE5->E5_NATUREZ
		TMP->E5_NATREC   := QSE5->E5_NATREC
		TMP->E5_FLUXO    := QSE5->E5_FLUXO
		If QSE5->E5_RECPAG == "P"
			If SA2->(dbSeek(xFilial("SA2")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
				TMP->E5_BENEF := SA2->A2_NOME
			EndIf
		Else
			If SA1->(dbSeek(xFilial("SA1")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
				TMP->E5_BENEF := SA1->A1_NOME
			EndIf
		EndIf
		
		TMP->E5_BENEF    := QSE5->E5_BENEF
		TMP->E5_DOCUMEN  := QSE5->E5_DOCUMEN
		TMP->E5_RECONC   := QSE5->E5_RECONC
		
		msUnLock()
		
	DbSelectarea("QSE5")
	dbSkip()
EndDo

dbSelectAre("QSE5")
dbCloseArea()
//-----------------------------------------------------------------------------------------------------------------

// Tratamento da Semana em TMP

If mv_par09==1	// Tratamento de Semana
	dbSelectArea("TMP")
	dbGoTop()
	dbSelectArea("SZE")
	dbSetOrder(1)
	_cChave := SUBSTR(DTOS(TMP->E5_DTDISPO),1,6)+"01"
	_aRank:={}
	If dbSeek(xFilial("SZE")+_cChave, .T.)
		_nCont:=1
		While !Eof() .And. SUBSTR(DTOS(SZE->ZE_INICIO),1,6) <= SUBSTR(dtos(mv_par03),1,6)
			AAdd(_aRank,{SZE->ZE_INICIO,SZE->ZE_FINAL,STRZERO(_nCont,2)})
			_nCont+=1
			dbSelectArea("SZE")
			dbSkip()
		EndDo
	EndIf
	If Len(_aRank) >= 1
		dbSelectArea("TMP")
		dbGoTop()
		While !Eof()
			For _nI:=1 to Len(_aRank)
				If DTOS(_aRank[_nI,1]) <= DTOS(TMP->E5_DTDISPO) .And. DTOS(TMP->E5_DTDISPO) <= DTOS(_aRank[_nI,2])
					dbSelectArea("TMP")
					RecLock("TMP", .F.)
					TMP->E5_ORDEM  := _aRank[_nI,3]
					TMP->E5_SEMANA := " - Semana de "+DTOC(_aRank[_nI,1])+" até "+DTOC(_aRank[_nI,2])
					msUnLock()
				EndIf
			Next _nI
			dbSelectArea("TMP")
			dbSkip()
		EndDo
	EndIf
EndIf

// Inicio da Impressão

If mv_par01 == 1
	cCondWhile:="!Eof() .And. _cE5_ORDEM == E5_ORDEM .And. _dE5_DTDISPO == E5_DTDISPO .And. _cE5_NATUREZ == E5_NATUREZ"
ElseIf mv_par01 == 2
	cCondWhile:="!Eof() .And. _cE5_ORDEM == E5_ORDEM .And. _cE5_NATUREZ == E5_NATUREZ"
ElseIf mv_par01 == 3
	cCondWhile:="!Eof() .And. _cE5_ORDEM == E5_ORDEM .And. _cE5_BENEF == E5_BENEF"
ElseIf mv_par01 == 4
	cCondWhile:="!Eof() .And. _cE5_ORDEM == E5_ORDEM .And. _cE5_NUMCHEQ == E5_NUMCHEQ .And. _cE5_DOCUMEN == E5_DOCUMEN"
ElseIf mv_par01 == 5
	cCondWhile:="!Eof() .And. _cE5_ORDEM == E5_ORDEM .And. _cE5_CONTA == E5_CONTA .And. _cE5_DOCUMEN == E5_DOCUMEN .And. _cE5_NUMAP == AllTrim(E5_NUMAP)"	// chamado n. 22008 alterado por CG em 19/01/07
EndIf                                                                                                                                                       // acrescentado condicao do NUMAP em 08/03/07 por Emerson Natali

If mv_par09==1	// Tratamento de Semana
	
	If mv_par01==1
		IndRegua("TMP", _cArqTrab, "E5_ORDEM+DTOS(E5_DTDISPO)+E5_NATUREZ+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
	ElseIf mv_par01==2
		IndRegua("TMP", _cArqTrab, "E5_ORDEM+E5_NATUREZ+DTOS(E5_DTDISPO)+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
	ElseIf mv_par01==3
		IndRegua("TMP", _cArqTrab, "E5_ORDEM+DTOS(E5_DTDISPO)+E5_BENEF+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
	ElseIf mv_par01==4
		IndRegua("TMP", _cArqTrab, "E5_ORDEM+DTOS(E5_DTDISPO)+E5_NUMCHEQ+E5_DOCUMEN+E5_BENEF+E5_BANCO+E5_RECPAG+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
	ElseIf mv_par01==5
		IndRegua("TMP", _cArqTrab, "E5_ORDEM+DTOS(E5_DTDISPO)+E5_CONTA+E5_DOCUMEN+E5_RECPAG+E5_BENEF+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.) // chamado n. 22008 alterado por CG em 19/01/07
	EndIf
EndIf


dbSelectArea("TMP")
dbGoTop()

While !Eof()
	
	dbSelectArea("TMP")
	
	If AllTrim(E5_NATUREZ) < AllTrim(mv_par04) .Or. AllTrim(E5_NATUREZ) >  AllTrim(mv_par05)
		dbSkip()
		Loop
	EndIf
	
	_cE5_ORDEM  := E5_ORDEM
	_cE5_SEMANA := E5_SEMANA
	Titulo      := Tit + _cE5_SEMANA
	
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	li := 8
	
	
	While !Eof() .And. _cE5_ORDEM == E5_ORDEM
		
		dbSelectArea("TMP")
		
		If AllTrim(E5_NATUREZ) < AllTrim(mv_par04) .Or. AllTrim(E5_NATUREZ) >  AllTrim(mv_par05)
			dbSkip()
			Loop
		EndIf
		
		_dE5_DTDISPO := E5_DTDISPO
		_cE5_NATUREZ := E5_NATUREZ
		_cE5_BENEF   := E5_BENEF
		_cE5_DOCUMEN := E5_DOCUMEN
		_cE5_NUMCHEQ := E5_NUMCHEQ
		_cE5_RECPAG  := E5_RECPAG
		_cE5_MOEDA   := E5_MOEDA
		_cE5_TIPODOC := E5_TIPODOC
		_cE5_CONTA   := E5_CONTA
		_cE5_NUMAP   := AllTrim(E5_NUMAP)
		
		_cTit        := SUBSTR(AllTrim(E5_BENEF),1,30)
		_nTotal      := 0
		
		
		While &(cCondWhile)
			
			IF lEnd
				@PROW()+1,0 PSAY OemToAnsi("Cancelado pelo operador")
				EXIT
			Endif
			
			IncRegua()
			
			
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				li := 8
			EndIF
			
			dbSelectArea("TMP")
			
			If AllTrim(E5_NATUREZ) < AllTrim(mv_par04) .Or. AllTrim(E5_NATUREZ) >  AllTrim(mv_par05)
				dbSkip()
				Loop
			EndIf
			
			If mv_par06 == 1
				@li, 0 PSAY E5_DTDISPO
				@li,12 PSAY IIF(Empty(E5_BENEF),Space(30),SUBSTR(AllTrim(E5_BENEF),1,30))
			EndIf
			
			If !EMPTY(E5_DOCUMEN)
				If E5_RECPAG  == "P"
					Do Case
						Case E5_TIPODOC $ "BA"
							If mv_par06 == 1
								@li,045 PSAY "BD "+AllTrim(E5_DOCUMEN)
								cDoc := "BD "+E5_DOCUMEN
								@li,065 PSAY +AllTrim(E5_CONTA)
							ELSE
								cDoc := "BD "+E5_DOCUMEN
							EndIf
						Case E5_TIPODOC $ "CH"
							If mv_par06 == 1
								If mv_par12 == 1
/*									SEF->(dbSetOrder(1))
									SEF->(dbSeek(xFilial("SEF")+TMP->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ), .F.))
									While !SEF->(Eof()) .And. SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM) == TMP->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
										If SEF->(EF_IMPRESS) == "S" .And. !Empty(SEF->EF_NUMAP)
											Exit
										Else
											SEF->(dbSkip())
										EndIf
									EndDo   
									@li,045 PSAY "AP "+AllTrim(SEF->EF_NUMAP)
									cDoc := "AP "+AllTrim(SEF->EF_NUMAP)
									_cE5_NUMAP := AllTrim(SEF->EF_NUMAP)
									@li,065 PSAY +AllTrim(E5_CONTA)  */
									@li,045 PSAY "AP "+AllTrim(E5_NUMAP)
									cDoc := "AP "+AllTrim(E5_NUMAP)															
									_cE5_NUMAP := AllTrim(E5_NUMAP)
									@li,065 PSAY +AllTrim(E5_CONTA)											
								Else
									@li,045 PSAY "CH "+AllTrim(E5_NUMCHEQ)
									cDoc := "CH "+E5_NUMCHEQ
									@li,065 PSAY +AllTrim(E5_CONTA)
								EndIf
							ELSE
								If mv_par12 == 1
									cDoc := "AP "+AllTrim(E5_NUMAP)
								Else
									cDoc := "CH "+E5_NUMCHEQ
								EndIf
								
							EndIf
						OtherWise
							If mv_par06 == 1
								If Left(E5_DOCUMEN,2)=="PC" .And. Subs(E5_DOCUMEN,10,1)=="/"
									@li,045 PSAY Left(E5_DOCUMEN,9) // +" - "+AllTrim(E5_HISTOR)
									cDoc := Left(E5_DOCUMEN,9)
									@li,065 PSAY +AllTrim(E5_CONTA)
								Else
									If Left(E5_DOCUMEN,2)=="PC"
										@li,045 PSAY "BD"+Subs(E5_DOCUMEN,3,10) // +" - "+AllTrim(E5_HISTOR)
										cDoc := "BD"+Subs(E5_DOCUMEN,3,10)
										@li,065 PSAY +AllTrim(E5_CONTA)
									Else
										Do Case //alteracao 23/03 emerson
											Case E5_MOEDA $ "CC"
												@li,045 PSAY "DM "+AllTrim(E5_DOCUMEN) // +" - "+AllTrim(E5_HISTOR)
												cDoc := "DM "+AllTrim(E5_DOCUMEN)
												@li,065 PSAY +AllTrim(E5_CONTA)
											Case E5_MOEDA $ "RC"
												@li,045 PSAY "RC "+AllTrim(E5_DOCUMEN) // +" - "+AllTrim(E5_HISTOR)
												cDoc := "RC "+AllTrim(E5_DOCUMEN)
												@li,065 PSAY +AllTrim(E5_CONTA)
											OtherWise										
												@li,045 PSAY AllTrim(E5_DOCUMEN) // +" - "+AllTrim(E5_HISTOR)
												cDoc := AllTrim(E5_DOCUMEN)
												@li,065 PSAY +AllTrim(E5_CONTA)
										EndCase
									EndIf
								EndIf
							Else
								If Left(E5_DOCUMEN,2)=="PC" .And. Subs(E5_DOCUMEN,10,1)=="/"
									cDoc := Left(E5_DOCUMEN,9)
								Else
									If Left(E5_DOCUMEN,2)=="PC"
										cDoc := "BD"+Subs(E5_DOCUMEN,3,10)
									Else
										Do Case
											Case E5_MOEDA $ "CC"
												cDoc := "DM "+AllTrim(E5_DOCUMEN)
											Case E5_MOEDA $ "RC"
												cDoc := "RC "+AllTrim(E5_DOCUMEN)
											OtherWise
												cDoc := AllTrim(E5_DOCUMEN)
										EndCase
									EndIf
								EndIf
							EndIf
					EndCase
				Else
					If mv_par06 == 1
						If Left(E5_DOCUMEN,2)=="PC"
							@li,045 PSAY "BD"+Subs(E5_DOCUMEN,3,10) // +" - "+AllTrim(E5_HISTOR)
							cDoc := "BD"+Subs(E5_DOCUMEN,3,10)
							@li,065 PSAY +AllTrim(E5_CONTA)
						ElseIf E5_MOEDA <> "CI"
							@li,045 PSAY AllTrim(E5_DOCUMEN) // +" - "+AllTrim(E5_HISTOR)
							cDoc := E5_DOCUMEN
							@li,065 PSAY +AllTrim(E5_CONTA)
						Else
							@li,045 PSAY AllTrim(E5_DOCUMEN) // +" - "+AllTrim(E5_HISTOR)
							cDoc := E5_DOCUMEN
						EndIf
						
					Else
						If Left(E5_DOCUMEN,2)=="PC"
							cDoc := "BD"+Subs(E5_DOCUMEN,3,10)
						Else
							cDoc := E5_DOCUMEN
						EndIf
						
					EndIf
				EndIf
			Else
				cDoc := E5_NUMCHEQ
				If mv_par06 == 1
					If !Empty(E5_NUMCHEQ)
						If mv_par12 == 1
/*							DbSelectArea("SEF")
							SEF->(dbSetOrder(1))
							IF SEF->(dbSeek(xFilial("SEF")+TMP->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ), .F.))
								While !SEF->(Eof()) .And. SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM) == TMP->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
									If SEF->(EF_IMPRESS) == "S" .And. !Empty(SEF->EF_NUMAP)
										Exit
									Else
										SEF->(dbSkip())
									EndIf
								EndDo 
								@li,045 PSAY "AP "+AllTrim(SEF->EF_NUMAP)
								cDoc := "AP "+AllTrim(SEF->EF_NUMAP)
								_cE5_NUMAP := AllTrim(SEF->EF_NUMAP)
								@li,065 PSAY +AllTrim(E5_CONTA)  */
								@li,045 PSAY "AP "+AllTrim(E5_NUMAP)
								cDoc := "AP "+AllTrim(E5_NUMAP)
								_cE5_NUMAP := AllTrim(E5_NUMAP)
								@li,065 PSAY +AllTrim(E5_CONTA)
//							ENDIF    
						Else
							@li,045 PSAY "CH "+AllTrim(E5_NUMCHEQ)// +" - "+AllTrim(E5_HISTOR)
							cDoc := "CH "+E5_NUMCHEQ
							@li,065 PSAY +AllTrim(E5_CONTA)
						EndIf
					Else
						If mv_par12 == 1
/*							SEF->(dbSetOrder(1))
							IF SEF->(dbSeek(xFilial("SEF")+TMP->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ), .F.))
								While !SEF->(Eof()) .And. SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM) == TMP->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
									If SEF->(EF_IMPRESS) == "S" .And. !Empty(SEF->EF_NUMAP)
										Exit
									Else
										SEF->(dbSkip())
									EndIf
								EndDo   */
							@li,045 PSAY "AP "+AllTrim(E5_NUMAP)
							cDoc := "AP "+AllTrim(E5_NUMAP)
							_cE5_NUMAP := AllTrim(E5_NUMAP)
							@li,065 PSAY +AllTrim(E5_CONTA)
//							ENDIF
						Else
							@li,045 PSAY AllTrim(E5_NUMCHEQ)// +" - "+AllTrim(E5_HISTOR)
							cDoc := E5_NUMCHEQ
							@li,065 PSAY +AllTrim(E5_CONTA)
						EndIf
					EndIf
				EndIf
			EndIf
			
			
			nValor := E5_VALOR
			
			If E5_RECPAG == "P"
				If mv_par06 == 1
					@li,94 PSAY nValor Picture tm(nValor,15,nMoeda)
				EndIf
				aRecon[1][SAIDA]   += nValor
				aRecon[2][SAIDA]   += nValor
				aRecon[3][SAIDA]   += nValor
				aRecon[4][SAIDA]   += nValor
			Else
				If mv_par06 == 1
					@li,78 PSAY nValor Picture tm(nValor,15,nMoeda)
				EndIf
				aRecon[1][ENTRADA] += nValor
				aRecon[2][ENTRADA] += nValor
				aRecon[3][ENTRADA] += nValor
				aRecon[4][ENTRADA] += nValor
			EndIf
			_nTotal   += nValor
			If mv_par06 == 1
				If E5_MOEDA $ "RC"
					@li,123 PSAY  AllTrim(E5_NATREC) + " " + E5_FLUXO
				Else
					@li,123 PSAY  AllTrim(E5_NATUREZ) + " " + E5_FLUXO				
				EndIf
			EndIf
			
			If mv_par07 == 1 .And. mv_par06 == 1 .And. mv_par10 == 1 .And. mv_par11 == 2 // Gerar o arquivo somente para opção Analítico, Conciliados e Realizados
				_cBufNor := LEFT(E5_BENEF,40)+space(2)+AllTrim(LEFT(cDoc,15))+Space(15-Len(AllTrim(Left(cDoc,15))))+DTOC(E5_DTDISPO)+"  "+StrZero(nValor,17,2)
				_cBufNor := StrTran(_cBufNor, ".", ",")
				_cBufNor := E5_NATUREZ+_cBufNor
				fWrite(_nArq, _cBufNor + _EOL , 502) //len(_cBufNor))
			EndIf
			
			dbSelectArea("TMP")
			dbSkip()
			If mv_par06 == 1
				li++
			EndIf
			
		EndDo
		
		
		If (aRecon[1][ENTRADA] <> 0 .Or. aRecon[1][SAIDA] <> 0)
			If mv_par06 == 1
				li++
			EndIf
			
			If li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				li := 8
			Endif
			
			_cDescNat := POSICIONE("SED",1,xFilial("SED")+_cE5_NATUREZ,"ED_DESCRIC")
			
			If mv_par06 == 2 // .And. mv_par01==1  // Sintetico e por Data
				If mv_par01 == 1 // Sintetico e por Data
					@li, 0 PSAY _dE5_DTDISPO
				ElseIf mv_par01 == 2
					@li,012 PSAY OemToAnsi("SUB-TOTAL de "+Left(_cE5_NATUREZ,7)+" - "+Left(_cDescNat,30)+": ")
				ElseIf mv_par01 == 3
					@li,012 PSAY OemToAnsi("SUB-TOTAL de "+_cE5_BENEF+": ")
				ElseIf mv_par01 == 4
					If !Empty(_cE5_NUMCHEQ)
						If mv_par12 == 1
							//							@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim("AP "+_cE5_NUMAP)+": ")  //_cE5_DOCUMEN)+": ")
							@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim("AP "+cDoc)+": ")  //_cE5_DOCUMEN)+": ")
						Else
							//							@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim("CH "+_cE5_NUMCHEQ)+": ") //_cE5_DOCUMEN)+": ")
							@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim("CH "+cDoc)+": ") //_cE5_DOCUMEN)+": ")
						EndIf
					Else
						@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim(cDoc)+": ") //_cE5_DOCUMEN)+": ")
						//						@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim(_cE5_DOCUMEN)+": ")
					EndIf
				ElseIf mv_par01 == 5
					@li,012 PSAY OemToAnsi("SUB-TOTAL de "+_cE5_CONTA+": ")  // chamado n. 22008 alterado por CG em 19/01/07
				EndIf
			Else
				If mv_par01 == 3
					@li,012 PSAY OemToAnsi("SUB-TOTAL de "+_cE5_BENEF+": ")
				Else
					If mv_par01 == 4
						If !Empty(_cE5_NUMCHEQ)
							If mv_par12 == 1
								@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim("AP "+_cE5_NUMAP)+": ")  //_cE5_DOCUMEN)+": ")
							Else
								@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim("CH "+_cE5_NUMCHEQ)+": ") //_cE5_DOCUMEN)+": ")
							EndIf
						Else
							@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim(cDoc)+": ") //_cE5_DOCUMEN)+": ")
						EndIf
					Else
						If mv_par01 == 5
							@li,012 PSAY OemToAnsi("SUB-TOTAL de "+_cE5_CONTA+": ")   // chamado n. 22008 alterado por CG em 19/01/07
						Else
							@li,000 PSAY OemToAnsi("SUB-TOTAL de "+Left(_cE5_NATUREZ,7)+" - "+Left(_cDescNat,30)+": ")
						EndIf
					EndIf
				EndIf
			EndIf
			
			If aRecon[1][ENTRADA] <> 0
				@li,078 PSAY aRecon[1][ENTRADA]                            PicTure tm(aRecon[1][1],15,nMoeda)
			EndIf
			If aRecon[1][SAIDA] <> 0
				@li,094 PSAY aRecon[1][SAIDA]                              PicTure tm(aRecon[1][2],15,nMoeda)
			EndIf
			
			If mv_par06 <> 1  // Sintetico
				@li,125 PSAY _cE5_NATUREZ
			EndIf
			
			If mv_par06 == 1
				li++
			EndIf
			li++
		EndIf
		
		aRecon[1][ENTRADA] := 0
		aRecon[1][SAIDA]   := 0
/*
Alterado por Emerson Natali dia 08/03/07
Criado matriz aRecon[4] para totalizar por Conta Corrente dentro do paramentro mv_par05(conta corrente)
*/
		If _cE5_CONTA <> E5_CONTA
			If !Empty(_cE5_CONTA)
				If (aRecon[4][ENTRADA] <> 0 .Or. aRecon[4][SAIDA] <> 0)
					If mv_par06 == 1
						If li > 58
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
							li := 8
						Endif
						If mv_par01 == 5
							@li,012 PSAY OemToAnsi("TOTAL DA CONTA "+_cE5_CONTA+": ")
						EndIf
						If aRecon[4][ENTRADA] <> 0
							@li,078 PSAY aRecon[4][ENTRADA]                      PicTure tm(aRecon[1][1],15,nMoeda)
						EndIf
						If aRecon[4][SAIDA] <> 0
							@li,094 PSAY aRecon[4][SAIDA]                        PicTure tm(aRecon[1][2],15,nMoeda)
						EndIf
						li++
						@ li,000 PSAY __PrtThinLine()
						li++
					EndIf
				EndIf
			Else
				@ li,000 PSAY __PrtThinLine()
				li++
			EndIf
			aRecon[4][ENTRADA]   := 0
			aRecon[4][SAIDA]     := 0
		EndIf
		
	EndDo
	
	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := 8
	Endif
	
	li++
	li++
	
	If mv_par09==1	// Tratamento de Semana
		@li,000 PSAY OemToAnsi("TOTAL " + AllTrim(_cE5_SEMANA) + "..............: ")
	Else
		@li,000 PSAY OemToAnsi("TOTAL................................................: ")
	EndIf
	
	If aRecon[2][ENTRADA] <> 0
		@li,078 PSAY aRecon[2][ENTRADA]                            PicTure tm(aRecon[2][1],15,nMoeda)
	EndIf
	If aRecon[2][SAIDA] <> 0
		@li,094 PSAY aRecon[2][SAIDA]                              PicTure tm(aRecon[2][2],15,nMoeda)
	EndIf
	
	aRecon[2][ENTRADA] := 0
	aRecon[2][SAIDA]   := 0
	
EndDo

li++
li++
li++

If mv_par09==1	// Tratamento de Semana
	
	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := 8
	Endif
	
	@li,000 PSAY OemToAnsi("TOTAL GERAL..........................................: ")
	
	If aRecon[3][ENTRADA] <> 0
		@li,078 PSAY aRecon[3][ENTRADA]                            PicTure tm(aRecon[3][1],15,nMoeda)
	EndIf
	If aRecon[3][SAIDA] <> 0
		@li,094 PSAY aRecon[3][SAIDA]                              PicTure tm(aRecon[3][2],15,nMoeda)
	EndIf
	If li != 80
		roda(cbcont,cbtxt,Tamanho)
	EndIf
EndIf


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

Static Function PsqTit(pNroBco,pNroAge, pNroCc,pNroCh,pNroFor)


Local cQuery := " "
Local cAlias := " "
Local lRetRat := {}
Local LF := chr(13)+chr(10)


// Localiza o Cheque no Cadastro de Cheques para pegar Número dos Titulos

cQuery := " SELECT EF_PREFIXO, EF_TITULO, EF_PARCELA, EF_TIPO, EF_FORNECE, EF_LOJA" +LF
cQuery += " FROM " + RetSqlName("SEF") + "  " +LF
cQuery += " WHERE D_E_L_E_T_ <> '*' AND EF_NUM = '"+pNroCh+"' " +LF
cQuery += " AND EF_BANCO = '"+pNroBco+"' AND EF_CONTA = '"+pNroCc+"' " +LF
cQuery += " AND EF_FORNECE = '"+pNroFor+"' " +LF
cQuery += " AND EF_FILIAL = '"+xFilial("SEF")+"' "+LF
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TRB', .T., .T.)


While !TRB->(EOF())
	DBSELECTAREA("SEV")
	SEV->(DBSETORDER(1))
	
	IF SEV->(DBSEEK(xFILIAL("SEV")+TRB->EF_PREFIXO+TRB->EF_TITULO+TRB->EF_PARCELA+TRB->EF_TIPO+TRB->EF_FORNECE+TRB->EF_LOJA))
		While TRB->EF_PREFIXO+TRB->EF_TITULO+TRB->EF_PARCELA+TRB->EF_TIPO+TRB->EF_FORNECE+TRB->EF_LOJA == SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA
			AADD(lRetRat,{SEV->EV_VALOR, SEV->EV_NATUREZ})
			SEV->(DBSKIP())
		End
	ENDIF
	TRB->(DBSKIP())
End


If Select("TRB") > 0
	TRB->(DBCLOSEAREA())
ENDIF


Return(lRetRat)



Static Function VerReg(pPar02,pPar03)


Local cQuery := " "
Local lRetReg := 0
DbSelectArea("SE5")
DbSetOrder(1)

cQuery := "SELECT COUNT(E5_VALOR) AS TotReg "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
If !lAllFil
	cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
EndIf
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(pPar02) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(pPar03) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
cQuery += " AND E5_TIPO <> 'ACF' "
cQuery += " AND E5_TIPODOC IN ('VL','CH','BA') AND E5_MOEDA IN ('  ') "
If mv_par10 == 1
	If mv_par11 == 1
		cQuery += " AND  E5_RECONC =  ' '  AND E5_FLUXO  <> ' '                           "
	ElseIf mv_par11 == 2
		cQuery += " AND  E5_RECONC <> ' '  AND E5_FLUXO  =  ' '                           "
	ElseIf mv_par11 == 3
		cQuery += " AND (E5_RECONC <> ' '  OR (E5_RECONC =  ' '  AND E5_FLUXO  <>  ' '  ))"
	EndIf
Else
	If mv_par11 == 1
		cQuery += " AND  E5_RECONC =  ' '  AND E5_FLUXO  <> ' '  "
	ElseIf mv_par11 == 2
		cQuery += " AND  E5_RECONC =  ' '  AND E5_FLUXO  =  ' '  "
	ElseIf mv_par11 == 3
		cQuery += " AND  E5_RECONC =  ' '                        "
	EndIf
EndIf
cQuery += " AND E5_RECPAG = 'P' "

cQuery := ChangeQuery(cQuery)


dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QE6', .T., .T.)


lRetReg := QE6->TOTREG


If Select("QE6") > 0
	QE6->(DBCLOSEAREA())
Endif


Return(lRetReg)



