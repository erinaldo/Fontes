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
±±³Fun‡„o	 ³ CFINR009 ³ Autor ³ Andy Pudja   		    ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Bancario Especifico CIEE	baseado em FINR470		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR470(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ CIEE     												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ Modificado relatorio para tratar a pesquisa de Conta DE a  ³±±
±±³          ³ Conta ATE. Esta alteracao foi realizada no dia 28/08 pelo  ³±±
±±³          ³ analista Emerson.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFINR009()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1	 := "Este programa ir  emitir o relat¢rio de movimenta‡”es"
LOCAL cDesc2	 := "banc rias em ordem de data. Poder  ser utilizado para"
LOCAL cDesc3	 := "conferencia de extrato."
LOCAL cString	 := "SE5"
LOCAL Tamanho	 := "G"
Local _aAreaSE5 := SE5->(GetArea())

PRIVATE LIMITE   := 220
PRIVATE titulo   := OemToAnsi("Extrato Bancario")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog := "CFINR009"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg	 := "CFIN09    "
PRIVATE _aAliases:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						³
//³ mv_par01				// Conta De							³
//³ mv_par02				// Conta Ate						³
//³ mv_par03				// Data De     						³
//³ mv_par04				// Data Ate							³
//³ mv_par05				// Todos/Conciliados/Nao Conciliados³
//³ mv_par06				// Analitico/Sintetico				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)
/*
             grupo ,ordem ,pergunt             ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01                 ,defspa01,defeng01,cnt01,var02,def02           ,defspa02,defeng02,cnt02,var03,def03             ,defspa03,defeng03,cnt03,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(_aPerg,{cPerg  ,"01" ,"Conta De          ","      ","       ","mv_ch1","C" ,10 ,00 ,0  ,"G",""   ,"mv_par01",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""                ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"BZC","","","",""})
aAdd(_aPerg,{cPerg  ,"02" ,"Conta Ate         ","      ","       ","mv_ch2","C" ,10 ,00 ,0  ,"G",""   ,"mv_par02",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""                ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"BZC","","","",""})
aAdd(_aPerg,{cPerg  ,"03" ,"Data De           ","      ","       ","mv_ch3","D" ,08 ,00 ,0  ,"G",""   ,"mv_par03",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""                ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(_aPerg,{cPerg  ,"04" ,"Data Ate          ","      ","       ","mv_ch4","D" ,08 ,00 ,0  ,"G",""   ,"mv_par04",""                    ,""      ,""      ,""   ,""   ,""             ,""      ,""      ,""   ,""   ,""                ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(_aPerg,{cPerg  ,"05" ,"Conciliado        ","      ","       ","mv_ch5","N" ,01 ,00 ,0  ,"C",""   ,"mv_par05","Todos"               ,""      ,""      ,""   ,""   ,"Conciliados"  ,""      ,""      ,""   ,""   ,"Nao Conciliados" ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
AADD(_aPerg,{cPerg  ,"06" ,"Tipo Relatorio   ?","      ","       ","mv_ch6","N" ,01 ,00 ,0  ,"C",""   ,"mv_PAR06","Analitico"           ,""      ,""      ,""   ,""   ,"Sintetico"    ,""      ,""      ,""   ,""   ,""                ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})

For nX := 1 to Len(_aPerg)
	If !SX1->(dbSeek(cPerg+_aPerg[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(_aPerg[nX])
				SX1->(FieldPut(nY,_aPerg[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "CFINR009"            //Nome Default do relatorio em Disco
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

RptStatus({|lEnd| CIEEFa470(@lEnd,wnRel,cString)},titulo)

DbSelectArea("SE5")
DbGotop()
RestArea(_aAreaSE5)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ cFA470IMP ³ Autor ³ Wagner Xavier        ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio. 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CIEEFA470(lEnd,wnRel,cString)

LOCAL CbCont,CbTxt
LOCAL tamanho	  := "M"
LOCAL cBanco,cNomeBanco,cAgencia,cConta,nRec,cLimCred
LOCAL limite 	  := 132
LOCAL nSaldoAtu	  := 0,nTipo,nEntradas:=0,nSaidas:=0,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil	  	  := ""
LOCAL nOrdSE5 	  := SE5->(IndexOrd())
LOCAL cChave
LOCAL cIndex
LOCAL aRecon 	  := {}
Local nTxMoeda 	  := 1
Local nValor 	  := 0
Local aStru 	  := SE5->(dbStruct()), ni
Local nMoeda	  := 1
Local nMoedaBco	  := 1
LOCAL nSalIniStr  := 0
LOCAL nSalIniCip  := 0
LOCAL nSalIniComp := 0
LOCAL nSalStr	  := 0
LOCAL nSalCip	  := 0
LOCAL nSalComp	  := 0
LOCAL lSpbInUse	  := SpbInUse()
LOCAL aStruct	  := {}
Local cFilterUser

AAdd( aRecon, {0,0} ) // CONCILIADOS
AAdd( aRecon, {0,0} ) // NAO CONCILIADOS
AAdd( aRecon, {0,0} ) // SUB-TOTAL
AAdd( aRecon, {0,0} ) // SUB-TOTAL DIA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1
nTipo   :=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case cEmpant == '01'
	If mv_par05 == 1
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Geral CIEE / SP Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Geral CIEE / SP Entre "
		EndIf
	ElseIf mv_par05 == 2
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Dos Conciliados CIEE / SP Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Dos Conciliados CIEE / SP Entre "
		EndIf
	ElseIf mv_par05 == 3
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Dos Nao Conciliados CIEE / SP Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Dos Nao Conciliados CIEE / SP Entre "
		EndIf
	EndIf
	Case cEmpant == '03'
	If mv_par05 == 1
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Geral CIEE / RJ Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Geral CIEE / RJ Entre "
		EndIf
	ElseIf mv_par05 == 2
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Dos Conciliados CIEE / RJ Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Dos Conciliados CIEE / RJ Entre "
		EndIf
	ElseIf mv_par05 == 3
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Dos Nao Conciliados CIEE / RJ Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Dos Nao Conciliados CIEE / RJ Entre "
		EndIf
	EndIf
	Case cEmpant == '05'
	If mv_par05 == 1
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Geral CIEE / NACIONAL Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Geral CIEE / NACIONAL Entre "
		EndIf
	ElseIf mv_par05 == 2
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Dos Conciliados CIEE / NACIONAL Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Dos Conciliados CIEE / NACIONAL Entre "
		EndIf
	ElseIf mv_par05 == 3
		If mv_par06 == 1
			_cExtrato:="EXTRATO BANCARIO Analitico Dos Nao Conciliados CIEE / NACIONAL Entre "
		Else
			_cExtrato:="EXTRATO BANCARIO Sintetico Dos Nao Conciliados CIEE / NACIONAL Entre "
		EndIf
	EndIf
EndCase	

/*
-----------------------------------------------------------------------------------------------------------------
PRIMEIRO FILTRO
-----------------------------------------------------------------------------------------------------------------
*/

SetRegua(RecCount())
DbSelectArea("SE5")
DbSetOrder(1)
cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
cQuery += "		E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par03) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par04) + "'"
cQuery += " AND E5_CONTA BETWEEN '"   + mv_par01 + "' AND '"+ mv_par02 +"' "
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
cQuery += " AND E5_TIPODOC IN ('BA','VL','CH') " //AND E5_MOEDA IN ('01') ALTERADO MOEDA DE BRANCO PARA 01
If mv_par05 == 2
	cQuery += " AND E5_RECONC <> ' ' "
ElseIf mv_par05 == 3
	cQuery += " AND E5_RECONC = ' ' "
EndIf
cQuery += " AND E5_RECPAG = 'P' "
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

cFilterUser := aReturn[7]
_aEstrut  	:= {}

// Define a estrutura do arquivo de trabalho.
_aEstrut := {	{"E5_RECPAG"  , "C", 01, 0},;
				{"E5_DTDISPO" , "D", 08, 0},;
				{"E5_DOCUMEN" , "C", 15, 0},;
				{"E5_NUMCHEQ" , "C", 15, 0},;
				{"E5_MOEDA"   , "C", 02, 0},;
				{"E5_TIPODOC" , "C", 02, 0},;
				{"E5_BANCO"   , "C", 03, 0},;
				{"E5_MOTBX"   , "C", 03, 0},;
				{"E5_BENEF"   , "C", 30, 0},;
				{"E5_VLMOED2" , "N", 14, 2},;
				{"E5_VALOR"   , "N", 17, 2},;
				{"E5_RECONC"  , "C", 01, 0},;
				{"E5_HISTOR"  , "C", 40, 0},;
				{"E5_AGENCIA" , "C", 05, 0},;
				{"E5_CONTA"   , "C", 10, 0}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)

// Cria o indice para o arquivo.
//IndRegua("TMP", _cArqTrab, "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
IndRegua("TMP", _cArqTrab, "E5_BANCO+E5_AGENCIA+E5_CONTA+DTOS(E5_DTDISPO)+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
aAdd(_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

DbSelectarea("SE5")
dbGoTop()
While !Eof()
	If SE5->E5_TIPO == "FL "
	   SE5->(DBSKIP())
	   LOOP
	ENDIF   
	dbSelectArea("TMP")
	RecLock("TMP", .T.)
	TMP->E5_RECPAG   := "P"
	TMP->E5_DTDISPO  := SE5->E5_DTDISPO
	TMP->E5_NUMCHEQ  := SE5->E5_NUMCHEQ
	TMP->E5_MOEDA    := SE5->E5_MOEDA
	TMP->E5_TIPODOC  := SE5->E5_TIPODOC
	TMP->E5_BANCO    := SE5->E5_BANCO
	TMP->E5_AGENCIA  := SE5->E5_AGENCIA
	TMP->E5_CONTA    := SE5->E5_CONTA
	TMP->E5_MOTBX    := SE5->E5_MOTBX
	TMP->E5_VLMOED2  := SE5->E5_VLMOED2
	TMP->E5_VALOR    := SE5->E5_VALOR
	TMP->E5_HISTOR   := SE5->E5_HISTOR
	If !EMPTY(SE5->E5_NUMCHEQ)
		TMP->E5_BENEF    := SE5->E5_BENEF
	Else
		TMP->E5_BENEF    := "Bordero para pgto."
	EndIf
	TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
	TMP->E5_RECONC   := SE5->E5_RECONC
	msUnLock()
	DbSelectarea("SE5")
	dbSkip()
EndDo

dbSelectArea("SE5")
dbCloseArea()

/*
--------------------------------------------------------------------------------------------------------------------------------
MANUAL lancamentos do SE5 para TR-Tarifa, TB-Transferencia, BA-Pgto Bolsa Auxilio por Carta, FL-Ficha Lançamento, AP- Aplicação
--------------------------------------------------------------------------------------------------------------------------------
*/

DbSelectArea("SE5")
DbSetOrder(1)
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par03) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par04) + "'"
cQuery += " AND E5_CONTA BETWEEN '"   + mv_par01 + "' AND '"+ mv_par02 +"' "
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
/*
Alterado dia 10/03/10 pelo analista Emerson
Tiramos a MOEDA = 'RC' (Reclassificacao) do relatorio do Extrato pois este movimento deve aparecer apenas uma vez com a MOEDA = 'NI'
*/
If mv_par05 ==1 // Todos
	cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI','RS','DE'))OR "
    cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO  IN ('FL ')                                       )OR "	
	cQuery += "       (E5_TIPODOC IN ('TR') AND E5_MOEDA IN ('TR','TE')                                        )  )"
ElseIf mv_par05 == 2 // Conciliados
	cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI','RS','DE') AND E5_RECONC <> ' ' ) OR "
    cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO  IN ('FL ')                                        AND E5_RECONC <> ' ' ) OR "		
	cQuery += "       (E5_TIPODOC IN ('TR') AND E5_MOEDA IN ('TR','TE')                                         AND E5_RECONC <> ' ' )   )"
ElseIf mv_par05 == 3 // Nao Conciliados
	cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI','RS','DE') AND E5_RECONC =  ' ' ) OR "
    cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO  IN ('FL ')                                   AND E5_RECONC =  ' ' ) OR "			
	cQuery += "       (E5_TIPODOC IN ('TR') AND E5_MOEDA IN ('TR','TE')                                         AND E5_RECONC =  ' ' )   ) "
EndIf
cQuery += " ORDER BY " + cOrder

cQuery := ChangeQuery(cQuery)

dbSelectAreA("SE5")
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
	dbSelectArea("TMP")
	RecLock("TMP", .T.)
	TMP->E5_RECPAG   := SE5->E5_RECPAG //"P"
	TMP->E5_DTDISPO  := SE5->E5_DTDISPO
	TMP->E5_NUMCHEQ  := SE5->E5_NUMCHEQ
	TMP->E5_MOEDA    := SE5->E5_MOEDA
	TMP->E5_TIPODOC  := SE5->E5_TIPODOC
	TMP->E5_BANCO    := SE5->E5_BANCO
	TMP->E5_AGENCIA  := SE5->E5_AGENCIA
	TMP->E5_CONTA    := SE5->E5_CONTA
	TMP->E5_MOTBX    := SE5->E5_MOTBX
	TMP->E5_VLMOED2  := SE5->E5_VLMOED2
	TMP->E5_VALOR    := SE5->E5_VALOR
	TMP->E5_HISTOR   := SE5->E5_HISTOR
	If SE5->E5_MOEDA $ "TB"
		TMP->E5_BENEF    := "Despesa Bancaria"
		TMP->E5_DOCUMEN  := "TARIFA"
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_MOEDA $ "TR;TE"
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
	ElseIf SE5->E5_MOEDA $ "AP;CD;GE;DD;RG;RS"
		TMP->E5_BENEF    := SE5->E5_BENEF
		TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_TIPO == "FL "
		TMP->E5_BENEF    := SE5->E5_BENEF
		TMP->E5_DOCUMEN  := "FL "+AllTrim(SE5->E5_NUMERO)
		TMP->E5_RECONC   := SE5->E5_RECONC
	ElseIf SE5->E5_MOEDA == "NI"
		TMP->E5_BENEF    := "Nao Identificados"
		TMP->E5_DOCUMEN  := SE5->E5_DOCUMEN
		TMP->E5_RECONC   := SE5->E5_RECONC		
	ElseIf SE5->E5_MOEDA == "DE"
//Alterado dia 18/05/09 - analista Emerson Natali
//Acrescentado nome do colaborador
//		TMP->E5_BENEF    := "Movimento Cartao Empresa"
		TMP->E5_BENEF    := "Mov.Cartao "+Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(SE5->E5_CARTAO),"SZK->ZK_NOME"),1,30)
		TMP->E5_DOCUMEN  := SE5->E5_CARTAO
		TMP->E5_RECONC   := SE5->E5_RECONC				
	EndIf
	msUnLock()
	DbSelectarea("SE5")
	dbSkip()
EndDo

dbSelectArea("SE5")
dbCloseArea()
/*
-----------------------------------------------------------------------------------------------------------------
PROVISIONAMENTO
No provisionamento altera a data para o dia seguinte
-----------------------------------------------------------------------------------------------------------------
*/

If mv_par05 <> 2 // Todos e Nao Conciliados
	
	DbSelectarea("SE2")
	_xFilSE2:=xFilial("SE2")
	_xFilSEA:=xFilial("SEA")
	_cOrdem := " E2_FILIAL"
	_cQuery := " SELECT E2_FILIAL, E2_VENCREA, E2_NUMBOR, E2_NUM, E2_NOMFOR, E2_VALOR, E2_DECRESC, E2_ACRESC, E2_SALDO, E2_MOVIMEN, EA_NUMBOR, EA_PORTADO, EA_AGEDEP, EA_NUMCON"
	_cQuery += " FROM "
	_cQuery += RetSqlName("SE2")+" SE2,"
	_cQuery += RetSqlName("SEA")+" SEA"
	_cQuery += " WHERE '"+ _xFilSE2 +"' = E2_FILIAL"
	_cQuery += " AND   '"+ _xFilSEA +"' = EA_FILIAL"
	_cQuery += " AND    E2_NUMBOR   = EA_NUMBOR"
	_cQuery += " AND    E2_VENCREA = '"+DTOS(mv_par04)+"'"
	_cQuery += " AND    E2_SALDO   > 0 "
	_cQuery += " AND    E2_NUMBOR <> ''"
	_cQuery += " AND    E2_MOVIMEN = ''"
	_cQuery += " AND    EA_NUMCON  BETWEEN '"   + mv_par01 + "' AND '"+ mv_par02 +"' "

	U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SE2","SEA" },,,.T. )
	
	DbSelectarea("QUERY")
	dbGoTop()
	While !Eof()
		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->E5_RECPAG   := "P"
		TMP->E5_DTDISPO  := QUERY->E2_VENCREA
		TMP->E5_DOCUMEN  := QUERY->E2_NUMBOR
		TMP->E5_NUMCHEQ  := Space(06)
		TMP->E5_MOEDA    := " "
		TMP->E5_TIPODOC  := "VL"
		TMP->E5_BANCO    := QUERY->EA_PORTADO
		TMP->E5_AGENCIA  := QUERY->EA_AGEDEP
		TMP->E5_CONTA    := QUERY->EA_NUMCON
		TMP->E5_MOTBX    := "DEB"
		TMP->E5_BENEF    := "Bordero para pgto." //QUERY->E2_NOMFOR
		TMP->E5_VLMOED2  := 0.00
		TMP->E5_VALOR    := (QUERY->E2_VALOR - QUERY->E2_DECRESC + QUERY->E2_ACRESC)
		TMP->E5_RECONC   := " "
		TMP->E5_HISTOR   := " "
		msUnLock()
		DbSelectarea("QUERY")
		dbSkip()
	EndDo
	DbSelectarea("QUERY")
	dbCloseArea()
	
EndIf
/*
-----------------------------------------------------------------------------------------------------------------
CNI
-----------------------------------------------------------------------------------------------------------------
*/

If mv_par05 <> 3 // Todos e Conciliados
	
	DbSelectarea("SZ8")
	_xFilSZ8:=xFilial("SZ8")
	_cOrdem := " Z8_FILIAL"
	_cQuery := " SELECT * "
	_cQuery += " FROM "
	_cQuery += RetSqlName("SZ8")+" SZ8,"
	_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"
	_cQuery += " AND Z8_EMISSAO >= '"+DTOS(mv_par03)+"'"
	_cQuery += " AND Z8_EMISSAO <= '"+DTOS(mv_par04)+"'"
	_cQuery += " AND Z8_CONTA  BETWEEN '"   + mv_par01 + "' AND '"+ mv_par02 +"' "
	_cQuery += " AND Z8_VALOR    > 0 "
	
	U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ8" },,,.T. )
	
	DbSelectarea("QUERY")
	dbGoTop()
	While !Eof()
		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->E5_RECPAG   := "R"
		TMP->E5_DTDISPO  := QUERY->Z8_EMISSAO
		TMP->E5_DOCUMEN  := "EXTRATO"
		TMP->E5_NUMCHEQ  := Space(06)
		TMP->E5_MOEDA    := " "
		TMP->E5_TIPODOC  := "VL"
		TMP->E5_BANCO    := QUERY->Z8_BANCO
		TMP->E5_AGENCIA  := QUERY->Z8_AGENCIA
		TMP->E5_CONTA    := QUERY->Z8_CONTA
		TMP->E5_MOTBX    := "DEB"
		TMP->E5_BENEF    := "Deposito Bancario"
		TMP->E5_VLMOED2  := 0.00
		TMP->E5_VALOR    := QUERY->Z8_VALOR
		TMP->E5_RECONC   := "x"
		TMP->E5_HISTOR   := " "
		msUnLock()
		DbSelectarea("QUERY")
		dbSkip()
	EndDo
	DbSelectarea("QUERY")
	dbCloseArea()
	
EndIf

/*
-----------------------------------------------------------------------------------------------------------------
Contas de Consumo
-----------------------------------------------------------------------------------------------------------------
*/

If mv_par05 <> 3 // Todos e Conciliados
	
	_xFilSZ5:=xFilial("SZ5")
	_cOrdem := " Z5_FILIAL"
	_cQuery := " SELECT * "
	_cQuery += " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND Z5_LANC >= '"+DTOS(mv_par03)+"'"
	_cQuery += " AND Z5_LANC <= '"+DTOS(mv_par04)+"'"
	_cQuery += " AND Z5_CCONTA BETWEEN '"   + mv_par01 + "' AND '"+ mv_par02 +"' "
	_cQuery += " AND Z5_VALOR    > 0 "
	
	U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5"},,,.T. )
	
	DbSelectarea("QUERY")
	dbGoTop()
	While !Eof()
		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->E5_RECPAG   := "P"
		TMP->E5_DTDISPO  := QUERY->Z5_LANC
		TMP->E5_DOCUMEN  := "DEB AUTOMATICO"
		TMP->E5_NUMCHEQ  := Space(06)
		TMP->E5_MOEDA    := " "
		TMP->E5_TIPODOC  := "CC"
		TMP->E5_BANCO    := QUERY->Z5_BANCO
		TMP->E5_AGENCIA  := QUERY->Z5_AGENCIA
		TMP->E5_CONTA    := QUERY->Z5_CCONTA
		TMP->E5_MOTBX    := "DEB"
		TMP->E5_BENEF    := "Conta Consumo"
		TMP->E5_VLMOED2  := 0.00
		TMP->E5_VALOR    := QUERY->Z5_VALOR
		TMP->E5_RECONC   := "x"
		TMP->E5_HISTOR   := " "
		msUnLock()
		DbSelectarea("QUERY")
		dbSkip()
	EndDo
	DbSelectarea("QUERY")
	dbCloseArea()
	
EndIf

/*
-----------------------------------------------------------------------------------------------------------------
INICIO DA IMPRESSAO
-----------------------------------------------------------------------------------------------------------------
*/
dbSelectArea("TMP")
dbGoTop()
_lPrim:=.T.

If TMP->(EOF())
	MsgBox("Conta(s) sem movimentacao Bancaria!!!")
	dbSelectArea("SE5")
	dbCloseArea()
	ChKFile("SE5")
	dbSelectArea("SE5")
	dbSetOrder(1)
	FechaAlias(_aAliases)
	MS_FLUSH()
	Return
EndIf

cNomeBanco	:= SA6->A6_NREDUZ

titulo := OemToAnsi(_cExtrato)+DTOC(mv_par03) + " e " +Dtoc(mv_par04)
cabec1 := OemToAnsi("BANCO ")+ TMP->E5_BANCO +" - " + ALLTRIM(cNomeBanco) + OemToAnsi("   AGENCIA ")+ TMP->E5_AGENCIA + OemToAnsi("   CONTA ")+ TMP->E5_CONTA
cabec2 := OemToAnsi("DATA        OPERACAO/BENEFICIARIO          DOCUMENTO                                 ENTRADAS          SAIDAS          SALDO ATUAL")

//Saldo de Partida
dbSelectArea("SE8")
dbSetOrder(1)
If dbSeek(xFilial("SE8")+TMP->E5_BANCO+TMP->E5_AGENCIA+TMP->E5_CONTA+Dtos(mv_par03))
	nSaldoAtu:=SE8->E8_SALCIEE
	nSaldoIni:=SE8->E8_SALCIEE
Else
	nSaldoAtu:=0
	nSaldoIni:=0
EndIf

If lSpbInUse
	nSalIniStr := 0
	nSalIniCip := 0
	nSalIniComp := 0
Endif

cBanAgCC := TMP->E5_BANCO+TMP->E5_AGENCIA+TMP->E5_CONTA

dbSelectArea("TMP")
While !Eof()

	_dE5_DTDISPO := E5_DTDISPO
	_cE5_DOCUMEN := E5_DOCUMEN
	_cE5_NUMCHEQ := E5_NUMCHEQ
	_cE5_RECPAG  := E5_RECPAG
	_cE5_MOEDA   := E5_MOEDA
	_cE5_TIPODOC := E5_TIPODOC
	_cTit        := SUBSTR(AllTrim(E5_BENEF),1,30)
	_nTotal      := 0
	_cStatus     := " C"
	
	If TMP->E5_BANCO+TMP->E5_AGENCIA+TMP->E5_CONTA <> cBanAgCC
		/*
		*****************************************************************************************************************************
		*/
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif

		li+=2
		@li,048 PSAY OemToAnsi("SALDO INICIAL...........: ")
		@li,113 PSAY nSaldoIni	Picture tm(nSaldoIni,16,2)

		li+=2
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif

		li++
		@li,048 PSAY OemToAnsi("CONCILIADOS.............: ")
		@li,078 PSAY aRecon[1][ENTRADA]                            PicTure tm(aRecon[1][1],15,2)
		@li,094 PSAY aRecon[1][SAIDA]                              PicTure tm(aRecon[1][2],15,2)
		@li,113 PSAY nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA] PicTure tm(nSaldoIni+aRecon[1][1]-aRecon[1][2],16,2)
		li++
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		@li,048 PSAY OemToAnsi("NAO CONCILIADOS.........: ")
		@li,078 PSAY aRecon[2][ENTRADA]                  PicTure tm(aRecon[2][1],15,2)
		@li,094 PSAY aRecon[2][SAIDA]                    PicTure tm(aRecon[2][2],15,2)
		@li,113 PSAY nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]+aRecon[2][ENTRADA]-aRecon[2][SAIDA] PicTure tm(nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]+aRecon[2][ENTRADA]-aRecon[2][SAIDA],16,2)
		li++
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		@li,048 PSAY OemToAnsi("SUB-TOTAL...............: ")
		@li,078 PSAY aRecon[3][ENTRADA]                             PicTure tm(aRecon[3][1],15,2)
		@li,094 PSAY aRecon[3][SAIDA]                               PicTure tm(aRecon[3][2],15,2)
		@li,113 PSAY nSaldoIni+aRecon[3][ENTRADA]-aRecon[3][SAIDA] PicTure tm(nSaldoIni+aRecon[3][1]-aRecon[3][2],16,2)
		li++
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif

		li+=2

		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		@li, 48 PSAY OemToAnsi("SALDO ATUAL ............: ")
		@li,113 PSAY nSaldoAtu	Picture tm(nSaldoAtu,16,2)

		IF li != 80
			roda(cbcont,cbtxt,Tamanho)
		EndIF

		//Gravando Saldo Bancario SE8 no dia posterior
		If mv_par05==1
			_dDtSld := mv_par04+1
			dbSelectArea("SE8")
			dbSeek(xFilial("SE8")+cBanAgCC+Dtos(_dDtSld))
			If Eof()
				RecLock("SE8",.t.)
			Else
				RecLock("SE8",.f.)
			EndIf
			Replace 	E8_FILIAL   With xFilial("SE8"),;
						E8_BANCO    With Substr(cBanAgCC,1,3),;
						E8_AGENCIA  With Substr(cBanAgCC,4,5),;
						E8_CONTA    With Substr(cBanAgCC,9,10)
			Replace E8_DTSALAT With _dDtSld
			Replace E8_SALCIEE With nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]
			Replace E8_FLAG    With "X"
			MsUnlock()
		EndIf
		/*
		*****************************************************************************************************************************
		*/

		cabec1 := OemToAnsi("BANCO ")+ TMP->E5_BANCO +" - " + ALLTRIM(cNomeBanco) + OemToAnsi("   AGENCIA ")+ TMP->E5_AGENCIA + OemToAnsi("   CONTA ")+ TMP->E5_CONTA
		li 			:= 80 
		_lPrim		:= .T.
		cBanAgCC 	:= TMP->E5_BANCO+TMP->E5_AGENCIA+TMP->E5_CONTA
		//Saldo de Partida
		dbSelectArea("SE8")
		dbSetOrder(1)
		If dbSeek(xFilial("SE8")+TMP->E5_BANCO+TMP->E5_AGENCIA+TMP->E5_CONTA+Dtos(mv_par03))
			nSaldoAtu:=SE8->E8_SALCIEE
			nSaldoIni:=SE8->E8_SALCIEE
		Else
		nSaldoAtu:=0
		nSaldoIni:=0
		EndIf
		aRecon := {}
		AAdd( aRecon, {0,0} ) // CONCILIADOS
		AAdd( aRecon, {0,0} ) // NAO CONCILIADOS
		AAdd( aRecon, {0,0} ) // SUB-TOTAL
		AAdd( aRecon, {0,0} ) // SUB-TOTAL DIA

	EndIf
	dbSelectArea("TMP")
	While !Eof() .And. _dE5_DTDISPO == E5_DTDISPO .And. _cE5_DOCUMEN == E5_DOCUMEN .And. _cE5_NUMCHEQ == E5_NUMCHEQ .And. _cE5_RECPAG == E5_RECPAG .And. _cE5_TIPODOC == E5_TIPODOC
		
		IF lEnd
			@PROW()+1,0 PSAY OemToAnsi("Cancelado pelo operador")
			EXIT
		Endif
		
		IncRegua()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSkip()
			Loop
		Endif
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			If _lPrim
			   @li ++,113 PSAY nSaldoIni   Picture tm(nSaldoAtu,16,2)
			   _lPrim:=.F.
			Else 
			   @li ++,113 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,2)
			EndIf   
		EndIF
		
		dbSelectArea("TMP")
		If mv_par06 == 1
			@li, 0 PSAY E5_DTDISPO
		EndIf
		
		If mv_par06 == 1
			@li,12 PSAY SUBSTR(AllTrim(E5_BENEF),1,30)
		EndIf
		
		cDoc := E5_NUMCHEQ
		
		IF Empty( cDoc )
			cDoc := E5_DOCUMEN
		Endif
		IF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 19
			cDoc := Alltrim(E5_DOCUMEN) +if(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ )
		Endif
		If Substr( cDoc ,1, 1 ) == "*"
			dbSkip( )
			Loop
		Endif
		
		If mv_par06 == 1
			If !EMPTY(E5_DOCUMEN)
				If E5_RECPAG  == "P"
					Do Case
						Case ALLTRIM(E5_TIPODOC) $ "VL"
							@li,043 PSAY "BD "+AllTrim(E5_DOCUMEN)
						Case ALLTRIM(E5_TIPODOC) $ "BA"
							@li,043 PSAY "BD "+AllTrim(E5_DOCUMEN)
						Case ALLTRIM(E5_TIPODOC) $ "CH"
							@li,043 PSAY "CH "+AllTrim(E5_DOCUMEN)
						OtherWise
							@li,043 PSAY AllTrim(E5_DOCUMEN)
					EndCase
				Else
					@li,043 PSAY AllTrim(E5_DOCUMEN)
				EndIf
			Else
				@li,043 PSAY "CH "+AllTrim(E5_NUMCHEQ)
			EndIf
		EndIf

/*		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nMoeda > 1 .and. !Empty(E5_VLMOED2)
			If  E5_VALOR != E5_VLMOED2
				IF Round(xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DTDISPO,nMoeda+1),nMoeda) != E5_VLMOED2
					nTxMoeda := (E5_VALOR * RecMoeda(E5_DTDISPO,nMoedaBco)) / E5_VLMOED2
				Else
					nTxMoeda := RecMoeda(E5_DTDISPO,nMoeda)
				EndIf
				nTxMoeda :=if(nTxMoeda=0,1,nTxMoeda)
				nValor := Round(xMoeda(E5_VALOR,nMoedaBco,nMoeda,,nMoeda+1,,nTxMoeda),nMoeda)
			Else
				nValor := Round(xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DTDISPO,nMoeda+1),nMoeda)
			EndIf
		Else
			nValor := Round(xMoeda(E5_VALOR,nMoedaBco,nMoeda,E5_DTDISPO,nMoeda+1),nMoeda)
		Endif
*/
		nValor := TMP->E5_VALOR
		
		If mv_par06 == 1
			If E5_RECPAG == "P"
				@li,94 PSAY nValor Picture tm(nValor,15,2)
			Else
				@li,78 PSAY nValor Picture tm(nValor,15,2)
			EndIf
		EndIf
		
		If E5_RECPAG  == "P"
			nSaldoAtu -= nValor
		Else
			nSaldoAtu += nValor
		EndIf
		
		_nTotal   += nValor
		
		If Empty( E5_RECONC )
			If E5_RECPAG  == "P"
				aRecon[2][SAIDA]   += nValor
			Else
				aRecon[2][ENTRADA] += nValor
			EndIf
		Else
			If E5_RECPAG  == "P"
				aRecon[1][SAIDA]   += nValor
			Else
				aRecon[1][ENTRADA] += nValor
			EndIf
		EndIf
		
		If E5_RECPAG  == "P"
			aRecon[3][SAIDA]   += nValor
			aRecon[4][SAIDA]   += nValor
		Else
			aRecon[3][ENTRADA] += nValor
			aRecon[4][ENTRADA] += nValor
		EndIf
		
		If mv_par06 == 1
			@li,113 PSAY nSaldoAtu Picture tm(nSaldoAtu,16,2)
			@li++,pCol()PSAY Iif(Empty(E5_RECONC), " ", " C")
		Else
			If Empty(E5_RECONC)
				_cStatus:= " "
			EndIf
		EndIf
		
		dbSelectArea("TMP")
		dbSkip()
		
	EndDo
	
	If mv_par06 == 2 .And. _nTotal <> 0
		@li, 0 PSAY _dE5_DTDISPO
		@li,12 PSAY _cTit
		
		If !EMPTY(_cE5_DOCUMEN)
			If _cE5_RECPAG  == "P"
				Do Case
					Case _cE5_TIPODOC $ "VL"
						@li,043 PSAY "BD "+AllTrim(_cE5_DOCUMEN)
					Case _cE5_TIPODOC $ "BA"
						@li,043 PSAY "BD "+AllTrim(_cE5_DOCUMEN)
					Case _cE5_TIPODOC $ "CH"
						@li,043 PSAY "CH "+AllTrim(_cE5_DOCUMEN)
					OtherWise
						@li,043 PSAY AllTrim(_cE5_DOCUMEN)
				EndCase
			Else
				@li,043 PSAY AllTrim(_cE5_DOCUMEN)
			EndIf
		Else
			@li,043 PSAY "CH "+AllTrim(_cE5_NUMCHEQ)
		EndIf
		
		If _cE5_RECPAG == "P"
			@li,94 PSAY _nTotal Picture tm(nValor,15,2)
		Else
			@li,78 PSAY _nTotal	Picture tm(nValor,15,2)
		EndIf
		
		@li,113 PSAY nSaldoAtu Picture tm(nSaldoAtu,16,2)
		@li++,pCol()PSAY _cStatus
	EndIf
	
	If mv_par05 == 2 .And. _dE5_DTDISPO <> E5_DTDISPO
		li++
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		@li,000 PSAY OemToAnsi("SUB-TOTAL...............: ")
		@li,078 PSAY aRecon[4][ENTRADA]                            PicTure tm(aRecon[3][1],15,2)
		@li,094 PSAY aRecon[4][SAIDA]                              PicTure tm(aRecon[3][2],15,2)
		@li,113 PSAY nSaldoAtu                                     PicTure tm(nSaldoAtu   ,16,2)
		aRecon[4][ENTRADA] := 0
		aRecon[4][SAIDA]   := 0
		li++
		li++
	EndIf
	
EndDo

If li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

li+=2
@li,048 PSAY OemToAnsi("SALDO INICIAL...........: ")
@li,113 PSAY nSaldoIni	Picture tm(nSaldoIni,16,2)

li+=2
If li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

li++
@li,048 PSAY OemToAnsi("CONCILIADOS.............: ")
@li,078 PSAY aRecon[1][ENTRADA]                            PicTure tm(aRecon[1][1],15,2)
@li,094 PSAY aRecon[1][SAIDA]                              PicTure tm(aRecon[1][2],15,2)
@li,113 PSAY nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA] PicTure tm(nSaldoIni+aRecon[1][1]-aRecon[1][2],16,2)
li++
If li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li,048 PSAY OemToAnsi("NAO CONCILIADOS.........: ")
@li,078 PSAY aRecon[2][ENTRADA]                  PicTure tm(aRecon[2][1],15,2)
@li,094 PSAY aRecon[2][SAIDA]                    PicTure tm(aRecon[2][2],15,2)
@li,113 PSAY nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]+aRecon[2][ENTRADA]-aRecon[2][SAIDA] PicTure tm(nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]+aRecon[2][ENTRADA]-aRecon[2][SAIDA],16,2)
li++
If li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li,048 PSAY OemToAnsi("SUB-TOTAL...............: ")
@li,078 PSAY aRecon[3][ENTRADA]                             PicTure tm(aRecon[3][1],15,2)
@li,094 PSAY aRecon[3][SAIDA]                               PicTure tm(aRecon[3][2],15,2)
@li,113 PSAY nSaldoIni+aRecon[3][ENTRADA]-aRecon[3][SAIDA] PicTure tm(nSaldoIni+aRecon[3][1]-aRecon[3][2],16,2)
li++
If li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

li+=2

If li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li, 48 PSAY OemToAnsi("SALDO ATUAL ............: ")
@li,113 PSAY nSaldoAtu	Picture tm(nSaldoAtu,16,2)

IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

//Gravando Saldo Bancario SE8 no dia posterior
If mv_par05==1
	_dDtSld := mv_par04 + 1
	dbSelectArea("SE8")
	dbSeek(xFilial("SE8")+cBanAgCC+Dtos(_dDtSld))
	If Eof()
		RecLock("SE8",.t.)
	Else
		RecLock("SE8",.f.)
	EndIf
	Replace 	E8_FILIAL   With xFilial("SE8"),;
				E8_BANCO    With Substr(cBanAgCC,1,3),;
				E8_AGENCIA  With Substr(cBanAgCC,4,5),;
				E8_CONTA    With Substr(cBanAgCC,9,10)
	Replace E8_DTSALAT With _dDtSld
	Replace E8_SALCIEE With nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]
	Replace E8_FLAG    With "X"
	MsUnlock()
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