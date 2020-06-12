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
±±³Fun‡„o	 ³ CFINR017 ³ Autor ³ Andy Pudja   		    ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Apuracao de Saldos Bancarios baseado em CFINR009    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINR017()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL wnrel
LOCAL cDesc1	 := "Este programa emitir a Apuracao de Saldos Bancarios"
LOCAL cDesc2	 := "atraves das movimentacoes bancarias"
LOCAL cDesc3	 := "conforme extrato bancario - CFINR009."
LOCAL cString	 := "SE5"
LOCAL Tamanho	 := "G"
Private LIMITE	 := 220
Private titulo	 :=OemToAnsi("Apuração de Saldos Bancarios")
Private cabec1
Private cabec2
Private aReturn	 := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
Private nomeprog :="CFINR017"
Private aLinha	 := { },nLastKey := 0
Private cPerg	 :="FINR17"
Private _aAliases:= {}
Private _nTotA   := _nTotB:= _nTotC:= _nTotD:= _nTotE:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("FINR17",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					    ³
//³ mv_par01				// Conta de 					    ³
//³ mv_par02				// Conta Ate					    ³
//³ mv_par03				// Data Referencia  			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Data Referencia    ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 				         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "CFINR017"            //Nome Default do relatorio em Disco
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

RptStatus({|lEnd| SalBan(@lEnd,wnRel,cString)},titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ SalBan ³   Autor  ³ Wagner Xavier        ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Saldos Bancarios 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SalBan(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL tamanho		:="M"
LOCAL _cBanco,_cNomeBanco,_cAgencia,_cConta,nRec,cLimCred
LOCAL limite		:= 132
LOCAL nSaldoAtu		:=0,nTipo,nEntradas:=0,nSaidas:=0,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil			:=""
LOCAL nOrdSE5		:=SE5->(IndexOrd())
LOCAL cChave
LOCAL cIndex
LOCAL aRecon		:= {}
Local nTxMoeda		:= 1
Local nValor		:= 0
Local aStru			:= SE5->(dbStruct()), ni
Local nMoeda		:= GetMv("MV_CENT")
Local nMoedaBco		:=	1
LOCAL nSalIniStr	:= 0
LOCAL nSalIniCip	:= 0
LOCAL nSalIniComp	:= 0
LOCAL nSalStr		:= 0
LOCAL nSalCip		:= 0
LOCAL nSalComp		:= 0
LOCAL lSpbInUse		:= SpbInUse()
LOCAL aStruct		:= {}
Local cFilterUser

AAdd( aRecon, {0,0} ) // CONCILIADOS
AAdd( aRecon, {0,0} ) // NAO CONCILIADOS
AAdd( aRecon, {0,0} ) // SUB-TOTAL
AAdd( aRecon, {0,0} ) // SUB-TOTAL DIA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE cCondWhile, lAllFil :=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

If cPaisLoc	#	"BRA"
	nMoedaBco	:=	Max(A6_MOEDA,1)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case cEmpant == '01'
		titulo := OemToAnsi("Apuração de Saldos Bancários CIEE / SP   -  ")+DTOC(mv_par03)
	Case cEmpant == '03'
		titulo := OemToAnsi("Apuração de Saldos Bancários CIEE / RJ   -  ")+DTOC(mv_par03)
	Case cEmpant == '05'
		titulo := OemToAnsi("Apuração de Saldos Bancários CIEE NACIONAL   -  ")+DTOC(mv_par03)
EndCase		

//titulo := OemToAnsi("Apuração de Saldos Bancários - ")+DTOC(mv_par03)

//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         BBBBBBBBBBBBBBB CCCCCCCCCCC
//         00              16            30                  50                  70                  90                  110
cabec1 := "                                              Saldo     Nao Conciliados     Nao Conciliados             Saldo                  Saldo"
cabec2 := "Banco           Agencia Conta                Inicial        Entrada              Saida                Aplicacao                Atual"

nTipo  :=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Define a estrutura do arquivo de trabalho.                    |
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

_aEstrut  := {}

_aEstrut := {;
{"E5_RECPAG"  , "C", 01, 0},;
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
{"E5_HISTOR"  , "C", 40, 0}}

_lUmaVez:=.F.
dbSelectArea("SA6")
dbSetOrder(1)
dbGoTop()

While !Eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vamos percorrer todo cadastro de Banco                       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    IF SA6->A6_BLOCKED == "1"
       SA6->(DBSKIP())
       LOOP
    ENDIF   

	If (mv_par01 == mv_par02)
		dbSelectArea("SA6")
		dbSetOrder(5)
		IF !(dbSeek(xFilial("SA6")+mv_par01))
			Help(" ",1,"BCONAOEXIST")
			Return
		EndIF
		_lUmaVez:=.T.
	Else
		dbSelectArea("SA6")
		If A6_NUMCON < mv_par01 .Or. A6_NUMCON > mv_par02
			dbSkip()
			Loop
		EndIf
	EndIf
	
	dbSelectArea("SA6")
	
	_cBanco		:= A6_COD
	_cNomeBanco	:= A6_NREDUZ
	_cAgencia	:= A6_AGENCIA
	_cConta		:= A6_NUMCON
	nLimCred	:= A6_LIMCRED
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Saldo de Partida 											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SE8")
	dbSetOrder(1)
	If dbSeek(xFilial("SE8")+_cBanco+_cAgencia+_cConta+Dtos(mv_par03))
		nSaldoAtu:=SE8->E8_SALCIEE
		nSaldoIni:=SE8->E8_SALCIEE
	Else
		//Este Bloco pesquisa o Saldo de Partida verificando o ultimo saldo atualizado pelo Extrato. Alteracao dia 28/08 pelo analista Emerson.
		DbGotop()
		If !dbSeek(xFilial("SE8")+_cBanco+_cAgencia+_cConta+Dtos(mv_par03-1),.t.)
			SE8->(DbSkip(-1))
		EndIf
		If _cBanco+_cAgencia+_cConta == SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA
			Do While _cBanco+_cAgencia+_cConta == SE8->E8_BANCO+SE8->E8_AGENCIA+SE8->E8_CONTA
				If	SE8->E8_FLAG == "X"
					nSaldoAtu:=SE8->E8_SALCIEE
					nSaldoIni:=SE8->E8_SALCIEE
					Exit
				EndIf
				SE8->(DbSkip(-1))
			EndDo
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo por tipo e vencimento						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SetRegua(RecCount())
	DbSelectArea("SE5")
	DbSetOrder(1)
	cCondWhile := " !Eof() "
	cChave  := "E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+DTOS(E5_DTDISPO)"
	cOrder := SqlOrder(cChave)
	cQuery := "SELECT * "
	cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
	If !lAllFil
		cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
	EndIf
	cQuery += " D_E_L_E_T_ <> '*' "
	cQuery += " AND E5_CONTA    =  '"     + _cConta + "'"
	cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par03) + "'"
	cQuery += " AND E5_SITUACA = ' ' "
	cQuery += " AND E5_VALOR <> 0 "
	cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
	cQuery += " AND E5_TIPODOC IN ('VL','CH','BA') AND E5_MOEDA IN ('  ') "
	cQuery += " AND E5_RECONC = ' ' "
	cQuery += " AND E5_RECPAG = 'P' "
	cQuery += " ORDER BY " + cOrder
	cQuery := ChangeQuery(cQuery)
	
	dbSelectAre("SE5")
	dbCloseArea()
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)
	
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
	
	cFilterUser := aReturn[7]
	
	_cArqTrab := CriaTrab(_aEstrut, .T.)
	dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)
	// Cria o indice para o arquivo.
	IndRegua("TMP", _cArqTrab, "DTOS(E5_DTDISPO)+E5_BANCO+E5_NUMCHEQ+E5_DOCUMEN+E5_RECPAG+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
	aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})
	
	DbSelectarea("SE5")
	dbGoTop()
	
	While !Eof()
		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->E5_RECPAG   := "P"
		TMP->E5_DTDISPO  := SE5->E5_DTDISPO
		TMP->E5_NUMCHEQ  := SE5->E5_NUMCHEQ
		TMP->E5_MOEDA    := SE5->E5_MOEDA
		TMP->E5_TIPODOC  := SE5->E5_TIPODOC
		TMP->E5_BANCO    := SE5->E5_BANCO
		TMP->E5_MOTBX    := SE5->E5_MOTBX
		TMP->E5_VLMOED2  := SE5->E5_VLMOED2
		TMP->E5_VALOR    := SE5->E5_VALOR
		TMP->E5_RECONC   := SE5->E5_RECONC
		msUnLock()
		DbSelectarea("SE5")
		dbSkip()
	EndDo
	
	dbSelectAre("SE5")
	dbCloseArea()
	
	// MANUAL lancamentos do SE5 para TR-Tarifa, TB-Transferencia, BA-Pgto Bolsa Auxilio por Carta, FL-Ficha Lançamento, AP- Aplicação
	
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
	cQuery += " AND E5_CONTA    =  '"     + _cConta + "'"
	cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par03) + "'"
	cQuery += " AND E5_SITUACA = ' ' "
	cQuery += " AND E5_VALOR <> 0 "
	cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','FL','AP','CD','ES','GE','DD','RG','NI') AND E5_RECONC =  ' ' ) OR "
	cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO  IN ('FL ')                                             AND E5_RECONC =  ' ' ) OR "
	cQuery += "       (E5_TIPODOC IN ('TR') AND E5_MOEDA IN ('TR')                                              AND E5_RECONC =  ' ' ) ) "
	cQuery += " ORDER BY " + cOrder
	
	cQuery := ChangeQuery(cQuery)
	
	dbSelectAre("SE5")
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
		TMP->E5_MOTBX    := SE5->E5_MOTBX
		TMP->E5_VLMOED2  := SE5->E5_VLMOED2
		TMP->E5_VALOR    := SE5->E5_VALOR
		TMP->E5_RECONC   := SE5->E5_RECONC
		msUnLock()
		DbSelectarea("SE5")
		dbSkip()
	EndDo
	
	dbSelectAre("SE5")
	dbCloseArea()
	
	// PROVISIONAMENTO
	// No provisionamento altera a data para o dia seguinte

	dbSelectArea("TMP")
	dbGoTop()
	While &(cCondWhile)
		
		If Empty( E5_RECONC )
			nValor := Round(xMoeda(E5_VALOR,nMoedaBco,1,E5_DTDISPO,nMoeda+1),nMoeda)
			If E5_RECPAG  == "P"
				nSaldoAtu          -= nValor
				aRecon[2][SAIDA]   += nValor
				aRecon[3][SAIDA]   += nValor
				aRecon[4][SAIDA]   += nValor
			Else
				nSaldoAtu          += nValor
				aRecon[2][ENTRADA] += nValor
				aRecon[3][ENTRADA] += nValor
				aRecon[4][ENTRADA] += nValor
			EndIf
		Else
			If E5_RECPAG  == "P"
				nSaldoAtu -= nValor
			Else
				nSaldoAtu += nValor
			EndIf
			_nTotal   += nValor
			aRecon[1][ENTRADA] += nValor
			aRecon[3][SAIDA]   += nValor
			aRecon[4][SAIDA]   += nValor
		EndIf
		IncRegua()
		
		dbSelectArea("TMP")
		dbSkip()
		
	EndDo
	
	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li:=9
	Endif
	
	//  00 16 30 50 70 90 110
	
	_nAplicacao := 0
	
	dbSelectArea("SZG")
	dbSetOrder(1)
	_nContador:=1
	While .T. .AND. _nContador <= 30 
		If dbSeek(xFilial("SZG")+_cBanco+_cAgencia+_cConta+DTOS(MV_PAR03-_nContador))
			If SZG->ZG_VALFIN >= 0			
				_nAplicacao := SZG->ZG_VALFIN
				Exit
			EndIf
		EndIf
		_nContador += 1
	EndDo
	
	@li,000 PSAY _cNomeBanco
	@li,016 PSAY _cAgencia
	@li,022 PSAY _cConta
	@li,036 PSAY nSaldoIni	Picture tm(nSaldoIni,16,nMoeda) // A
	@li,056 PSAY aRecon[2][ENTRADA]                  PicTure tm(aRecon[2][1],15,nMoeda) // B
	@li,076 PSAY aRecon[2][SAIDA]                    PicTure tm(aRecon[2][2],15,nMoeda) // C
	@li,096 PSAY _nAplicacao                         PicTure tm(_nAplicacao,15,nMoeda)  // D
	@li,116 PSAY nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]+aRecon[2][ENTRADA]-aRecon[2][SAIDA]+_nAplicacao PicTure tm(nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]+aRecon[2][ENTRADA]-aRecon[2][SAIDA]+_nAplicacao,16,nMoeda) // E
	
	_nTotA+= nSaldoIni
	_nTotB+= aRecon[2][ENTRADA]
	_nTotC+= aRecon[2][SAIDA]
	_nTotD+= _nAplicacao
	_nTotE+= nSaldoIni+aRecon[1][ENTRADA]-aRecon[1][SAIDA]+aRecon[2][ENTRADA]-aRecon[2][SAIDA]+_nAplicacao
	
	If _lUmaVez
		li := li + 2
		Exit
	Else
		FechaAlias(_aAliases)
		li := li + 2
		
		aRecon[1][ENTRADA] := 0
		aRecon[2][ENTRADA] := 0
		aRecon[3][ENTRADA] := 0
		aRecon[4][ENTRADA] := 0
		
		aRecon[1][SAIDA]   := 0
		aRecon[2][SAIDA]   := 0
		aRecon[3][SAIDA]   := 0
		aRecon[4][SAIDA]   := 0
		
		dbSelectArea("SA6")
		dbSkip()
	EndIf
	
EndDo

@li,000 PSay Replicate("-",limite)
li := li + 2
@li,000 PSAY "Total Geral"
@li,036 PSAY _nTotA	Picture tm(_nTotA,16,nMoeda) // A
@li,056 PSAY _nTotB PicTure tm(_nTotB,15,nMoeda) // B
@li,076 PSAY _nTotC PicTure tm(_nTotC,15,nMoeda) // C
@li,096 PSAY _nTotD PicTure tm(_nTotD,15,nMoeda) // D
@li,116 PSAY _nTotE PicTure tm(_nTotE,16,nMoeda) // E

If li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIf

Set Device To Screen

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

STATIC FUNCTION CFINR017C(pPrefixo,pNum,pParc,pTipo,pFornec,pLoja)

Local lRet   := " "
Local cAlias := GetArea()

DbSelectarea("SE5")
SE5->(DbSetorder(7))
SE5->(DbGotop())
IF SE5->(DbSeek(xFilial("SE5")+pPrefixo+pNum+pParc+pTipo+pFornec+pLoja))
	lRet := SE5->E5_RECONC
ENDIF

RestArea(cAlias)

Return(lRet)
