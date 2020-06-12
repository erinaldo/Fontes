#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

#DEFINE ENTRADA 1
#DEFINE SAIDA   2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CFINA15  ³ Autor ³ Andy Pudja   		    ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Fluxo de Caixa                      		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFINA15()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1  := "Este programa ir  emitir o relat¢rio de Desp.Mov.Cartao"
LOCAL cDesc2  := "baseado no extrato das movimentacoes bancarias conciliadas. Por"
LOCAL cDesc3  := "Ordem de Data e Natureza ou vice versa."
LOCAL cString := "SE5"
LOCAL Tamanho := "G"

Private LIMITE   := 220
PRIVATE titulo   :=OemToAnsi("Despesas - Movimento Cartão")
PRIVATE tit      :=OemToAnsi("Despesas - Movimento Cartão")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog := "CFINA15"
PRIVATE nLastKey := 0
PRIVATE cPerg	 := "CFINA15   "
Private _aAliases:= {}
Private nmoeda   := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_fCriaSX1()

pergunte(cPerg,.F.)                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "CFINA15"            //Nome Default do relatorio em Disco
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

LOCAL tamanho	:= "M"
LOCAL limite 	:= 132
LOCAL nTipo
LOCAL cDOC 		:= Space(15)
LOCAL cChave
LOCAL aRecon := {}
Local nValor := 0

AAdd( aRecon, {0,0} ) // SUB-TOTAL
AAdd( aRecon, {0,0} ) // TOTAL ou TOTAL SEMANA
AAdd( aRecon, {0,0} ) // TOTAL GERAL
AAdd( aRecon, {0,0} ) // TOTAL CONTA CORRENTE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile
PRIVATE aStru 	:= SE5->(dbStruct())
PRIVATE ni
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li 		:= 80
m_pag 	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01==1
	Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Natureza"
ElseIf mv_par01==2
	Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Natureza e Data"
ElseIf mv_par01==3
	Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Beneficiario"
ElseIf mv_par01==4
	Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Data e Documento"
ElseIf mv_par01==5
	Tit := OemToAnsi("Analitico de ")+DTOC(mv_par02) + " a " +Dtoc(mv_par03)+" por Conta Corrente"
EndIf

Tit := Tit + " - Realizados     "

cabec1 := OemToAnsi("DATA        BENEFICIARIO                     DOCUMENTO           C.CORRENTE          ENTRADAS          SAIDAS              NATUREZA")
cabec2 := ""
nTipo  := IIF(aReturn[4]==1,15,18)

DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += "FROM "+RetSqlName("SE5")+"  "
cQuery += "WHERE D_E_L_E_T_ <> '*' "
cQuery += "AND E5_FILIAL = '"+xFilial("SE5")+"' "
cQuery += "AND E5_DTDISPO BETWEEN '"+DTOS(mv_par02)+"' AND '"+DTOS(mv_par03)+"' "
cQuery += "AND E5_CARTAO BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
cQuery += "AND E5_NATUREZ BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
cQuery += "AND E5_SITUACA = ' ' "
cQuery += "AND E5_VALOR <> 0 "
cQuery += "AND E5_NUMCHEQ NOT LIKE '%*' "
cQuery += "AND E5_TIPO <> 'ACF' AND E5_TIPO <> 'FL'  "
cQuery += "AND E5_TIPODOC IN ('  ')  AND E5_MOEDA IN ('DE','BC') AND (E5_RECONC <> ' '  AND E5_FLUXO  =  ' ') "
cQuery += "AND E5_TIPODOC <> 'ES' "
cQuery += "ORDER BY " + cOrder
cQuery := ChangeQuery(cQuery)

IF Select("QE5") > 0
	QE5->(dbCloseArea())
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QE5', .T., .T.)

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('QE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

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

nCtReg := VerReg(MV_PAR02,MV_PAR03)
SetRegua(nCtReg)
ProcRegua(nCtReg)

DbSelectarea("QE5")
dbGoTop()

While !Eof()

	IncProc("Lendo Movimentoc Financeiros "+DTOC(QE5->E5_DTDISPO))
	
	_cArea := GetArea()
	_nCont := 0

	dbSelectArea("TMP")
	RecLock("TMP", .T.)
	TMP->E5_RECPAG   := QE5->E5_RECPAG
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

	If QE5->E5_RECPAG == "P"
		If SA2->(dbSeek(xFilial("SA2")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
			TMP->E5_BENEF := SA2->A2_NOME
		EndIf
	Else
		If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
			TMP->E5_BENEF := SA2->A2_NOME
		EndIf
	EndIf

	If QE5->E5_MOEDA $ "DE|BC"
		TMP->E5_BENEF    := "Mov.Cartao "+Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(QE5->E5_CARTAO),"SZK->ZK_NOME"),1,30)
		TMP->E5_DOCUMEN  := QE5->E5_CARTAO
		TMP->E5_RECONC   := QE5->E5_RECONC
	EndIf
	msUnLock()
	DbSelectarea("QE5")
	dbSkip()
EndDo

dbSelectAre("QE5")
If Select("QE5") > 0
	QE5->(dbCloseArea())
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

dbSelectArea("TMP")
dbGoTop()

While !Eof()
	
	dbSelectArea("TMP")
	_cE5_ORDEM  := E5_ORDEM
	_cE5_SEMANA := E5_SEMANA
	Titulo      := Tit + _cE5_SEMANA

	Do Case
		Case cEmpant == '01'
			Titulo := alltrim(Titulo) + " -  CIEE / SP"
		Case cEmpant == '03'
			Titulo := alltrim(Titulo) + " -  CIEE / RJ"
		Case cEmpant == '05'
			Titulo := alltrim(Titulo) + " -  CIEE / NACIONAL"
	EndCase
	
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	li := 8
	
	While !Eof() .And. _cE5_ORDEM == E5_ORDEM
		
		dbSelectArea("TMP")
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
			@li, 0 PSAY E5_DTDISPO
			@li,12 PSAY IIF(Empty(E5_BENEF),Space(30),SUBSTR(AllTrim(E5_BENEF),1,30))
			
			If !EMPTY(E5_DOCUMEN)
				If E5_RECPAG  == "P"
					Do Case
						Case E5_TIPODOC $ "BA"
							@li,045 PSAY "BD "+AllTrim(E5_DOCUMEN)
							cDoc := "BD "+E5_DOCUMEN
							@li,065 PSAY +AllTrim(E5_CONTA)
						Case E5_TIPODOC $ "CH"
							@li,045 PSAY "AP "+AllTrim(E5_NUMAP)
							cDoc := "AP "+AllTrim(E5_NUMAP)															
							_cE5_NUMAP := AllTrim(E5_NUMAP)
							@li,065 PSAY +AllTrim(E5_CONTA)											
						OtherWise
							If Left(E5_DOCUMEN,2)=="PC" .And. Subs(E5_DOCUMEN,10,1)=="/"
								@li,045 PSAY Left(E5_DOCUMEN,9)
								cDoc := Left(E5_DOCUMEN,9)
								@li,065 PSAY +AllTrim(E5_CONTA)
							Else
								If Left(E5_DOCUMEN,2)=="PC"
									@li,045 PSAY "BD"+Subs(E5_DOCUMEN,3,10)
									cDoc := "BD"+Subs(E5_DOCUMEN,3,10)
									@li,065 PSAY +AllTrim(E5_CONTA)
								Else
									Do Case
										Case E5_MOEDA $ "CC"
											@li,045 PSAY "DM "+AllTrim(E5_DOCUMEN)
											cDoc := "DM "+AllTrim(E5_DOCUMEN)
											@li,065 PSAY +AllTrim(E5_CONTA)
										Case E5_MOEDA $ "RC"
											@li,045 PSAY "RC "+AllTrim(E5_DOCUMEN)
											cDoc := "RC "+AllTrim(E5_DOCUMEN)
											@li,065 PSAY +AllTrim(E5_CONTA)
										OtherWise										
											@li,045 PSAY AllTrim(E5_DOCUMEN)
											cDoc := AllTrim(E5_DOCUMEN)
											@li,065 PSAY +AllTrim(E5_CONTA)
									EndCase
								EndIf
							EndIf
					EndCase
				Else
					If Left(E5_DOCUMEN,2)=="PC"
						@li,045 PSAY "BD"+Subs(E5_DOCUMEN,3,10)
						cDoc := "BD"+Subs(E5_DOCUMEN,3,10)
						@li,065 PSAY +AllTrim(E5_CONTA)
					ElseIf E5_MOEDA <> "CI"
						@li,045 PSAY AllTrim(E5_DOCUMEN)
						cDoc := E5_DOCUMEN
						@li,065 PSAY +AllTrim(E5_CONTA)
					Else
						@li,045 PSAY AllTrim(E5_DOCUMEN)
						cDoc := E5_DOCUMEN
					EndIf
				EndIf
			Else
				cDoc := E5_NUMCHEQ
				If !Empty(E5_NUMCHEQ)
					@li,045 PSAY "AP "+AllTrim(E5_NUMAP)
					cDoc := "AP "+AllTrim(E5_NUMAP)
					_cE5_NUMAP := AllTrim(E5_NUMAP)
					@li,065 PSAY +AllTrim(E5_CONTA)
				Else
					@li,045 PSAY "AP "+AllTrim(E5_NUMAP)
					cDoc := "AP "+AllTrim(E5_NUMAP)
					_cE5_NUMAP := AllTrim(E5_NUMAP)
					@li,065 PSAY +AllTrim(E5_CONTA)
				EndIf
			EndIf
			
			nValor := E5_VALOR
			
			If E5_RECPAG == "P"
				@li,94 PSAY nValor Picture tm(nValor,15,nMoeda)
				aRecon[1][SAIDA]   += nValor
				aRecon[2][SAIDA]   += nValor
				aRecon[3][SAIDA]   += nValor
				aRecon[4][SAIDA]   += nValor
			Else
				@li,78 PSAY nValor Picture tm(nValor,15,nMoeda)
				aRecon[1][ENTRADA] += nValor
				aRecon[2][ENTRADA] += nValor
				aRecon[3][ENTRADA] += nValor
				aRecon[4][ENTRADA] += nValor
			EndIf
			_nTotal   += nValor
			If E5_MOEDA $ "RC"
				@li,123 PSAY  AllTrim(U_DePaNat2013(E5_NATREC)) + " " + E5_FLUXO     	// User Função DePaNat2013() em CFINR011
			Else
				@li,123 PSAY  AllTrim(U_DePaNat2013(E5_NATUREZ)) + " " + E5_FLUXO		// User Função DePaNat2013() em CFINR011		
			EndIf
		
			dbSelectArea("TMP")
			dbSkip()
			li++
		
		EndDo
		
		If (aRecon[1][ENTRADA] <> 0 .Or. aRecon[1][SAIDA] <> 0)
			li++
		
			If li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				li := 8
			Endif
			
			_cDescNat := POSICIONE("SED",1,xFilial("SED")+U_DePaNat2013(_cE5_NATUREZ),"ED_DESCRIC") // User Função DePaNat2013() em CFINR011
			
			If mv_par01 == 3
				@li,012 PSAY OemToAnsi("SUB-TOTAL de "+_cE5_BENEF+": ")
			Else
				If mv_par01 == 4
					If !Empty(_cE5_NUMCHEQ)
						@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim("AP "+_cE5_NUMAP)+": ")
					Else
						@li,012 PSAY OemToAnsi("SUB-TOTAL de "+AllTrim(cDoc)+": ")
					EndIf
				Else
					If mv_par01 == 5
						@li,012 PSAY OemToAnsi("SUB-TOTAL de "+_cE5_CONTA+": ")
					Else
						@li,000 PSAY OemToAnsi("SUB-TOTAL de "+U_DePaNat2013(_cE5_NATUREZ)+" - "+Left(_cDescNat,30)+": ") // Left(_cE5_NATUREZ,7)+" - "+Left(_cDescNat,30)+": ")
					EndIf
				EndIf
			EndIf
			
			If aRecon[1][ENTRADA] <> 0
				@li,078 PSAY aRecon[1][ENTRADA]                            PicTure tm(aRecon[1][1],15,nMoeda)
			EndIf
			If aRecon[1][SAIDA] <> 0
				@li,094 PSAY aRecon[1][SAIDA]                              PicTure tm(aRecon[1][2],15,nMoeda)
			EndIf
			
			li++
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
	
	@li,000 PSAY OemToAnsi("TOTAL................................................: ")
	
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR011  ºAutor  ³Microsiga           º Data ³  05/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerReg(pPar02,pPar03)

Local cQuery := " "
Local lRetReg := 0

DbSelectArea("SE5")
DbSetOrder(1)
cQuery := "SELECT COUNT(E5_VALOR) AS TotReg "
cQuery += "FROM "+RetSqlName("SE5")+" "
cQuery += "WHERE D_E_L_E_T_ <> '*' "
cQuery += "AND E5_FILIAL = '"+xFilial("SE5")+"' "
cQuery += "AND E5_DTDISPO BETWEEN '"+DTOS(pPar02)+"' AND '"+DTOS(mv_par03)+"' "
cQuery += "AND E5_CARTAO BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
cQuery += "AND E5_NATUREZ BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
cQuery += "AND E5_SITUACA = ' ' "
cQuery += "AND E5_VALOR <> 0 "
cQuery += "AND E5_NUMCHEQ NOT LIKE '%*' "
cQuery += "AND E5_TIPO <> 'ACF' AND E5_TIPO <> 'FL'  "
cQuery += "AND E5_TIPODOC IN ('  ')  AND E5_MOEDA IN ('DE','BC') AND (E5_RECONC <> ' '  AND E5_FLUXO  =  ' ') "
cQuery += "AND E5_TIPODOC <> 'ES' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QE6', .T., .T.)

lRetReg := QE6->TOTREG

If Select("QE6") > 0
	QE6->(DBCLOSEAREA())
Endif

Return(lRetReg)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SX1       ºAutor  ³Microsiga           º Data ³  08/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parametros da rotina                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fCriaSX1()

_aPerg := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt               ,perg spa              ,perg eng              , variav ,tipo,tam,dec,pres,gsc,valid     ,var01     ,def01                 ,defspa01,defeng01,cnt01       ,var02,def02           ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
AAdd(_aPerg,{cPerg,"01","Agrupamento        ?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Data","","","","","Natureza","","","","","Benficiario","","","","","Documento","","","","","Conta Corrente","","","","","",""}) // chamado n. 22008 alterado por CG em 19/01/07
aAdd(_aPerg,{cPerg,"02","Da  Data           ?","","","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","","","",""        ,"","","","",""           ,"","","","",""         ,"","","","",""              ,"","","","","",""})
aAdd(_aPerg,{cPerg,"03","Ate Data           ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"04","Da  Natureza       ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"05","Ate Natureza       ?","","","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"06","Cartao De          ?","","","mv_ch6","C",06,0,0,"G","","mv_par06",""  ,"","","","",""      ,"","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"07","Cartao Ate         ?","","","mv_ch7","C",06,0,0,"G","","mv_par07",""  ,"","","","",""      ,"","","","","","","","","","","","","","","","","","","","",""})

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

Return