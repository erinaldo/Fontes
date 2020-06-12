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
±±³Fun‡„o	 ³ CFINA51  ³ Autor ³ Emerson Natali	    ³ Data ³ 11/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera arquivo SZZ p/ Fluxo de Caixa               		  ³±±
±±³          ³ Programa base no customizado CFINR011            		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFINA51()

LOCAL cCadastro := OemToAnsi("Fluxo de Caixa")
LOCAL aSays		:= {}
LOCAL aButtons	:= {}
LOCAL nOpca 	:= 0

PRIVATE cPerg	 	:="CFIN51    "
Private _aAliases	:= {}
Private _EOL     	:= chr(13) + chr(10)
Private _cArq, _nArq, _lFez

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_fCriaSx1()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aSays,OemToAnsi( "Esta Rotina Processa todos os Movimentos Financeiros (Receitas e Despesas)" 	) )
AADD(aSays,OemToAnsi( "Conciliados para o Fluxo de Caixa Conforme Parametros Selecionados..."	) )

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()		}})
AADD(aButtons, { 2,.T.,{|o| nOpca:= 2,o:oWnd:End()		}})
AADD(aButtons, { 5,.T.,{||  Pergunte(cPerg,.T.)		}})

//DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg1 ACTION _fFechaTela(oDlg1)

FormBatch( cCadastro, aSays, aButtons )

If nOpca ==1
	_cDtAju := STOD(GETMV("CI_DTAJUS"))

	If _cDtAju <= mv_par01 .and. mv_par02 >= _cDtAju
		Processa({|| FluxoCIEE()},"Executando importacao do registros para o Fluxo")
	Else
		MsgBox("Foi realizado ajuste no dia "+Dtoc(_cDtAju)+" e por isso nao podemos reimportar os movimentos!!!", "Atenção")
		Return
	EndIf
EndIf

If _lFez
	fClose(_nArq)
EndIf


If nOpca ==1
	//Chama rotina que monta a Tela (browse)
	u_CFINA52()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FluxoCIEE³ Autor ³ Andy Pudja            ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fluxo de Caixa                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FLUXOCIEE()

LOCAL cBanco,cNomeBanco,cAgencia,cConta,nRec,cLimCred
LOCAL nSaldoAtu:=0,nTipo,nEntradas:=0,nSaidas:=0,nSaldoIni:=0
LOCAL cDOC  := Space(15)
LOCAL cChave
LOCAL cIndex
LOCAL aRecon := {}
Local nValor := 0 
Local _nFator:= -1
Local aRet := {}
Local cNat999 := SuperGetMV("CI_NAT999",.T.,"99999999",)
AAdd( aRecon, {0,0} ) // SUB-TOTAL
AAdd( aRecon, {0,0} ) // TOTAL ou TOTAL SEMANA
AAdd( aRecon, {0,0} ) // TOTAL GERAL
AAdd( aRecon, {0,0} ) // TOTAL CONTA CORRENTE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile
PRIVATE aStruct := {}
PRIVATE aStru 	:= SE5->(dbStruct()), ni


DbSelectArea("SZZ")
DbSetOrder(1)
If DbSeek(xFilial("SZZ")+DTOS(mv_par01))
	ProcRegua(RecCount())
	Do While !EOF() .and. SZZ->ZZ_DATA <= MV_PAR02
		IncProc("Deletando Registros...")
		If SZZ->ZZ_FLAG == "IMP"
			RecLock("SZZ",.F.)
			DbDelete()
			MsUnLock()
		EndIf
		SZZ->(DbSkip())
	EndDo
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o da Exportacao                 				     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_cArq := AllTrim("H:\Protheus_Data\microsiga\fluxo\")+"FL"+SUBSTR(DTOS(dDataBase),3,6)+".flx"
//_cArq := AllTrim("\\Fenix\arq_txt\tesouraria\fluxo\")+"FL"+SUBSTR(DTOS(dDataBase),3,6)+".flx"

If cEmpant == '01' //SP
	_cArq := AllTrim("\arq_txt\tesouraria\fluxo\")+"FL"+SUBSTR(DTOS(dDataBase),3,6)+".flx"
ElseIf cEmpant == '03' //RJ
	_cArq := AllTrim("\arq_txtrj\tesouraria\fluxo\")+"FL"+SUBSTR(DTOS(dDataBase),3,6)+".flx"
EndIf

//_cArq := AllTrim("\arq_txt\tesouraria\fluxo\")+"FL"+SUBSTR(DTOS(dDataBase),3,6)+".flx"
_lFez := .T.
If (_nArq := fCreate(_cArq)) == -1
	_cMsg := "Não foi possível criar o Arquivo de Exportação " + _cArq + "."
	MsgAlert(_cMsg, "Atenção!")
	_lFez := .F.
	Return
EndIf

DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par01) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par02) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
/*
// TIRADO "AND E5_TIPO <> 'ACF'" DA QUERY CONFORME SOLICITACAO SSI NUMERO 10/0188
// DIA 23/08/10 pelo analista Emerson
cQuery += " AND E5_TIPO <> 'ACF' AND E5_TIPO <> 'FL'  "
*/
cQuery += " AND E5_TIPO <> 'FL'  "

cQuery += " AND E5_TIPODOC IN ('VL','CH','BA') " // AND E5_MOEDA IN ('01') ALTERADO MOEDA DE BRANCO PARA 01
cQuery += " AND  E5_RECONC <> ' '  AND E5_FLUXO  =  ' '"
cQuery += " AND E5_RECPAG = 'P' "
cQuery += " ORDER BY " + cOrder
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
IndRegua("TMP", _cArqTrab, "DTOS(E5_DTDISPO)+E5_CONTA+E5_DOCUMEN+E5_RECPAG+E5_DOCUMEN+E5_BENEF+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.) // chamado n. 22008 alterado por CG em 19/01/07
aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

nCtReg := VerReg(MV_PAR01,MV_PAR02)
ProcRegua(nCtReg)

DbSelectarea("QE5")
dbGoTop()

While !Eof()
	_lFF:=.T.
	
	IncProc("Lendo Movimentos Financeiros "+DTOC(QE5->E5_DTDISPO))
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
		_cArea := GetArea()
		_nCont := 0
		If QE5->E5_PREFIXO $ "FFC|FFQ"
			cQuery := "SELECT COUNT(*) SEVREG "
			cQuery += "FROM "+ RetSqlName("SEV")+ " "
			cQuery += "WHERE D_E_L_E_T_ = '' "
			cQuery += "AND EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA = '"+QE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)+"' "
			TCQUERY cQuery ALIAS "TMPREG" NEW

			DbSelectArea("TMPREG")
			_nAcresc	:= Round(QE5->E5_VLACRES / TMPREG->SEVREG,2)
			_nDecres	:= Round(QE5->E5_VLDECRE / TMPREG->SEVREG,2)
			TMPREG->(DbCloseArea())
			RestArea(_cArea)
		Else
/*
			//alterado pelo analista Emerson dia 18/02/09
			//Regra criado para tratar SE5 com decrescimo.
			//Verifica registros diferentes de FFC e FFQ
			//Nao tratamos acrescimo por nao existir nenhum
			If QE5->E5_VLDECRE > 0
				cQuery := "SELECT * "
				cQuery += "FROM "+ RetSqlName("SEV")+ " "
				cQuery += "WHERE D_E_L_E_T_ = '' "
				cQuery += "AND EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA = '"+QE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)+"' "
				cQuery += "ORDER BY EV_VALOR DESC "
				TCQUERY cQuery ALIAS "TMPREG" NEW

				DbSelectArea("TMPREG")
				DbGotop()
				_nCont	:= 0
				_nSoma	:= 0
				Do While !EOF()

					If _nSoma > QE5->E5_VLDECRE
						_nDecres := QE5->E5_VLDECRE / _nCont
					Else
						_nCont++
						_nSoma += TMPREG->EV_VALOR
					EndIf

					DbSelectArea("TMPREG")
					TMPREG->(DbSkip())
				EndDo
				TMPREG->(DbCloseArea())
				RestArea(_cArea)
			EndIf
*/
			//Alterado dia 02/03/10 pelo analista Emerson
			//Tratar Acrescimo e Decrescimo nos titulos
			//Tiramos o bloco acima por nao ter mais funcionalidade
			cQuery := "SELECT COUNT(*) SEVREG "
			cQuery += "FROM "+ RetSqlName("SEV")+ " "
			cQuery += "WHERE D_E_L_E_T_ = '' "
			cQuery += "AND EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA = '"+QE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)+"' "
			TCQUERY cQuery ALIAS "TMPREG" NEW

			DbSelectArea("TMPREG")
			_nAcresc	:= Round(QE5->E5_VLACRES / TMPREG->SEVREG,2)
			_nDecres	:= Round(QE5->E5_VLDECRE / TMPREG->SEVREG,2)
			TMPREG->(DbCloseArea())
			RestArea(_cArea)
		EndIf
		
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
				TMP->E5_BANCO    := QE5->E5_BANCO
				TMP->E5_AGENCIA  := QE5->E5_AGENCIA
				TMP->E5_CONTA    := QE5->E5_CONTA
				TMP->E5_MOTBX    := QE5->E5_MOTBX
				TMP->E5_VLMOED2  := QE5->E5_VLMOED2
//				TMP->E5_VALOR    := SEV->EV_VALOR
//				TMP->E5_VALOR    := SEV->EV_VALOR + QE5->E5_VLACRES - QE5->E5_VLDECRE // Acrescentado campos de Acre/Decres para titulos c/ rateio - 15/09/08 alteracao EMERSON NATALI
				If _nCont == 0 .and. !(QE5->E5_PREFIXO $ "FFC|FFQ") // ALTERADO DIA 15/09 PELO ANALISTA EMERSON. verifica quantos registros aplica o decres.
					TMP->E5_VALOR    := SEV->EV_VALOR + _nAcresc - _nDecres //ALTERADO DIA 02/03/10 PELO ANALISTA EMERSON (acrescentado variaveis de acrescimo e decrescimo)
				Else
					TMP->E5_VALOR    := SEV->EV_VALOR + _nAcresc - _nDecres // ALTERADO DIA 15/09 PELO ANALISTA EMERSON
					_nCont--
				EndIf
				TMP->E5_NATUREZ  := SEV->EV_NATUREZ
				TMP->E5_NATREC   := ""
				
				If QE5->E5_RECPAG == "P"
					If SA2->(dbSeek(xFilial("SA2")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
						TMP->E5_BENEF := SA2->A2_NOME
					EndIf
				Else
					If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
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
					TMP->E5_VALOR    := aRetPesq[_Ct][1]
					TMP->E5_HISTOR   := QE5->E5_HISTOR
					TMP->E5_NATUREZ  := aRetPesq[_Ct][2]
					TMP->E5_NATREC   := aRetPesq[_Ct][2]
					TMP->E5_FLUXO    := QE5->E5_FLUXO
					If Alltrim(QE5->E5_TIPODOC)=="CH"
						TMP->E5_BENEF := QE5->E5_BENEF
					Else
						If QE5->E5_RECPAG == "P"
							If SA2->(dbSeek(xFilial("SA2")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
								TMP->E5_BENEF := SA2->A2_NOME
							EndIf
						Else
							If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
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
							TMP->E5_BENEF := SA2->A2_NOME
						EndIf
					Else
						If SA2->(dbSeek(xFilial("SA1")+QE5->E5_CLIFOR+QE5->E5_LOJA, .F.))
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
cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par01) + "'"
cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par02) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
/*
// ACRESCENTADO "'NI'" NA QUERY CONFORME SOLICITACAO SSI NUMERO 10/0188
// DIA 23/08/10 pelo analista Emerson
cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RS','DE','BC') AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
*/
cQuery += " AND ( (E5_TIPODOC IN ('  ')      AND E5_MOEDA IN ('TB','BA','AP','CD','ES','GE','DD','RG','RS','DE','BC','NI') AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "

cQuery += "       (E5_TIPODOC IN ('PC')      AND E5_MOEDA IN ('PC')                                         AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
cQuery += "       (E5_TIPODOC IN ('CC')      AND E5_MOEDA IN ('CC')                                         AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
cQuery += "       (E5_TIPODOC IN ('CI')      AND E5_MOEDA IN ('CI')                                         AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
cQuery += "       (E5_TIPODOC IN ('PL')      AND E5_MOEDA IN ('PL')                                         AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) OR "
cQuery += "       (E5_TIPODOC IN ('BA')      AND E5_TIPO IN ('FL ')                                         AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) )"
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
				TMP->E5_VALOR    := QSE5->E5_VALOR * SEV->EV_PERC
				TMP->E5_NATUREZ  := SEV->EV_NATUREZ
				TMP->E5_NATREC   := ""
				
				If QSE5->E5_RECPAG == "P"
					If SA2->(dbSeek(xFilial("SA2")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
						TMP->E5_BENEF := SA2->A2_NOME
					EndIf
				Else
					If SA2->(dbSeek(xFilial("SA1")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
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
				TMP->E5_BENEF := SA2->A2_NOME
			EndIf
		Else
			If SA2->(dbSeek(xFilial("SA1")+QSE5->E5_CLIFOR+QSE5->E5_LOJA, .F.))
				TMP->E5_BENEF := SA2->A2_NOME
			EndIf
		EndIf
		
		If QSE5->E5_MOEDA $ "TB"
			TMP->E5_BENEF    := "Despesa Bancaria"
			TMP->E5_DOCUMEN  := "TARIFA"
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_MOEDA $ "TR;TE"
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
		ElseIf QSE5->E5_MOEDA $ "AP;CD;GE;DD;RG;CC;PC;CI;PL;RC"
			TMP->E5_BENEF    := QSE5->E5_BENEF
			TMP->E5_DOCUMEN  := QSE5->E5_DOCUMEN
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_TIPO == "FL "
			TMP->E5_BENEF    := QSE5->E5_BENEF
			TMP->E5_DOCUMEN  := "FL "+AllTrim(QSE5->E5_NUMERO)
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_MOEDA == "RS"
			TMP->E5_BENEF    := "Reserva Financeira"
			TMP->E5_DOCUMEN  := "RESERVA"
			TMP->E5_RECONC   := QSE5->E5_RECONC
		ElseIf QSE5->E5_MOEDA $ "DE|BC"
//Alterado dia 20/05/09 - analista Emerson Natali
//Acrescentado nome do colaborador
//			TMP->E5_BENEF    := "Movimento Cartao Empresa"
			TMP->E5_BENEF    := "Mov.Cartao "+Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(QSE5->E5_CARTAO),"SZK->ZK_NOME"),1,30)
			TMP->E5_DOCUMEN  := QSE5->E5_CARTAO
			TMP->E5_RECONC   := QSE5->E5_RECONC
//Acrescentado pelo analista Emerson conforme SSI 10/0188
		ElseIf QSE5->E5_MOEDA == "NI"
			TMP->E5_BENEF    := "Nao Identificado"
			TMP->E5_DOCUMEN  := QSE5->E5_DOCUMEN
			TMP->E5_RECONC   := QSE5->E5_RECONC
		EndIf
		
		msUnLock()
		
	EndIf
	
	DbSelectarea("QSE5")
	dbSkip()
EndDo

dbSelectAre("QSE5")
dbCloseArea()

DbSelectArea("SE5")
DbSetOrder(1)
cCondWhile := " !Eof() "
cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
cOrder := SqlOrder(cChave)
cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_VENCTO >=  '"     + DTOS(mv_par01) + "'"
cQuery += " AND E5_VENCTO <=  '"     + DTOS(mv_par02) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND ( (E5_TIPODOC IN ('  ') AND E5_MOEDA IN ('RC') AND E5_RECONC <>  ' ' AND E5_FLUXO  =  ' ' ) ) "
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

cCondWhile:="!Eof() .And. _cE5_ORDEM == E5_ORDEM .And. _cE5_CONTA == E5_CONTA .And. _cE5_DOCUMEN == E5_DOCUMEN .And. _cE5_NUMAP == AllTrim(E5_NUMAP)"	// chamado n. 22008 alterado por CG em 19/01/07

dbSelectArea("TMP")
dbGoTop()

While !Eof()
	
	dbSelectArea("TMP")
	
	_cE5_ORDEM  := E5_ORDEM
	_cE5_SEMANA := E5_SEMANA
	Titulo      := _cE5_SEMANA
	
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
			
			dbSelectArea("TMP")
			
			If !EMPTY(E5_DOCUMEN)
				If E5_RECPAG  == "P"
					Do Case
						Case E5_TIPODOC $ "BA"
							cDoc := "BD "+E5_DOCUMEN
						Case E5_TIPODOC $ "CH"
							cDoc := "AP "+AllTrim(E5_NUMAP)
							_cE5_NUMAP := AllTrim(E5_NUMAP)
						OtherWise
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
					EndCase
				Else
					If Left(E5_DOCUMEN,2)=="PC"
						cDoc := "BD"+Subs(E5_DOCUMEN,3,10)
					ElseIf E5_MOEDA <> "CI"
						cDoc := E5_DOCUMEN
					Else
						cDoc := E5_DOCUMEN
					EndIf
				EndIf
			Else
				cDoc := E5_NUMCHEQ
				If !Empty(E5_NUMCHEQ)
					cDoc := "AP "+AllTrim(E5_NUMAP)
					_cE5_NUMAP := AllTrim(E5_NUMAP)
				Else
					cDoc := "AP "+AllTrim(E5_NUMAP)
					_cE5_NUMAP := AllTrim(E5_NUMAP)
				EndIf
			EndIf
			                                                                     
			// 02/07/13 Implementação de negativar valores da movimentação cuja Natureza é Despesa, ED_COND=="D" 
			
			_nFator:=1          
			DbSelectarea("SED")
			SED->(DbSetOrder(1))
			If SED->(DbSeek(xFilial("SED")+("TMP")->E5_NATUREZ))
				If AllTrim(SED->ED_TIPO) == "2"
					If SED->ED_COND=="D"
						_nFator:= -1
					EndIf
				EndIf
			Else
				DbSelectarea("SED")
				SED->(DbOrderNickName("SUPORC"))
				If SED->(DbSeek(xFilial("SED")+("TMP")->E5_NATUREZ))
					If AllTrim(SED->ED_TIPO) == "2" // Analítica
						If SED->ED_COND=="D"        // Despesa 
							_nFator:= -1
						EndIf
					EndIf
				EndIf	
			EndIf

			dbSelectArea("TMP")
			nValor := E5_VALOR * _nFator
			
			If E5_RECPAG == "P"
				aRecon[1][SAIDA]   += nValor
				aRecon[2][SAIDA]   += nValor
				aRecon[3][SAIDA]   += nValor
				aRecon[4][SAIDA]   += nValor
			Else
				aRecon[1][ENTRADA] += nValor
				aRecon[2][ENTRADA] += nValor
				aRecon[3][ENTRADA] += nValor
				aRecon[4][ENTRADA] += nValor
			EndIf
			_nTotal   += nValor
			
			// Gerar o arquivo somente para opção Analítico, Conciliados e Realizados
			_cBufNor := LEFT(E5_BENEF,40)+space(2)+AllTrim(LEFT(cDoc,15))+Space(15-Len(AllTrim(Left(cDoc,15))))+DTOC(E5_DTDISPO)+"  "+StrZero(nValor,17,2)
			_cBufNor := StrTran(_cBufNor, ".", ",")
			If E5_MOEDA == "RC"
				_cBufNor := E5_NATREC+_cBufNor
			Else
				_cBufNor := E5_NATUREZ+_cBufNor
			EndIf
			//fWrite(_nArq, _cBufNor + _EOL , 502)
			

			_cNatureza 	:= iIf(TMP->E5_MOEDA == "RC",TMP->E5_NATREC,TMP->E5_NATUREZ)
			_cNatDePara := ""
			DbSelectarea("SED")
			SED->(DbOrderNickName("SUPORC"))
			If SED->(DbSeek(xFilial("SED")+_cNatureza))
				_cNatDePara := _cNatureza
				_cNatureza 	:= SED->ED_CODIGO 
			EndIf	
			_cDescNat 	 := POSICIONE("SED",1,xFilial("SED")+_cNatureza,"ED_DESCRIC")
//			_cDescNatDep := iIf(!Empty(_cNatDePara),POSICIONE("SED",1,xFilial("SED")+_cNatDePara,"ED_DESCRIC"),"")
			
			DbSelectArea("SZZ")
			RecLock("SZZ",.T.)
			SZZ->ZZ_FILIAL 	:= xFilial("SZZ")
			If Empty(_cNatureza)
				SZZ->ZZ_NATUREZ	:= cNat999				//"9.99.99"
				SZZ->ZZ_DESCNAT	:= "SEM NAT"
			Else                                                  
				SZZ->ZZ_NATUREZ	:= _cNatureza
				SZZ->ZZ_DESCNAT	:= _cDescNat
			EndIf                                                       
			SZZ->ZZ_NATDEP	:= _cNatDePara
//			SZZ->ZZ_NATDEPD	:= _cDescNatDep
			
			SZZ->ZZ_HIST 	:= LEFT(TMP->E5_BENEF,40)
			SZZ->ZZ_DOCUMEN	:= AllTrim(LEFT(cDoc,15))
			SZZ->ZZ_CONTA 	:= TMP->E5_CONTA
			SZZ->ZZ_DATA 	:= TMP->E5_DTDISPO
			SZZ->ZZ_VALOR 	:= nValor
			SZZ->ZZ_FLAG 	:= "IMP"
			MsUnLock()

			dbSelectArea("TMP")
			dbSkip()
		EndDo
		
		aRecon[1][ENTRADA] := 0
		aRecon[1][SAIDA]   := 0
		
	EndDo
	
	aRecon[2][ENTRADA] := 0
	aRecon[2][SAIDA]   := 0
	
EndDo

Set Device To Screen

dbSelectArea("SE5")
dbCloseArea()
ChKFile("SE5")
dbSelectArea("SE5")
dbSetOrder(1)

FechaAlias(_aAliases)

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
	_cArea := GetArea()
	cQuery := "SELECT COUNT(*) SEVREG "
	cQuery += "FROM "+ RetSqlName("SEV")+ " "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA = '"+TRB->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_FORNECE+EF_LOJA)+"' "
	TCQUERY cQuery ALIAS "TMPREG" NEW

	DbSelectArea("TMPREG")
	_nAcresc	:= Round(QE5->E5_VLACRES / TMPREG->SEVREG,2)
	_nDecres	:= Round(QE5->E5_VLDECRE / TMPREG->SEVREG,2)

	TMPREG->(DbCloseArea())
	RestArea(_cArea)

	DBSELECTAREA("SEV")
	SEV->(DBSETORDER(1))
	IF SEV->(DBSEEK(xFILIAL("SEV")+TRB->EF_PREFIXO+TRB->EF_TITULO+TRB->EF_PARCELA+TRB->EF_TIPO+TRB->EF_FORNECE+TRB->EF_LOJA))
		While TRB->EF_PREFIXO+TRB->EF_TITULO+TRB->EF_PARCELA+TRB->EF_TIPO+TRB->EF_FORNECE+TRB->EF_LOJA == SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA
//			AADD(lRetRat,{SEV->EV_VALOR, SEV->EV_NATUREZ})
//			AADD(lRetRat,{(SEV->EV_VALOR + QE5->E5_VLACRES - QE5->E5_VLDECRE) , SEV->EV_NATUREZ}) //ALTERADO 15/09 PELO ANALISTA EMERSON
			AADD(lRetRat,{(SEV->EV_VALOR + _nAcresc - _nDecres) , SEV->EV_NATUREZ}) //ALTERADO 15/09 PELO ANALISTA EMERSON
			SEV->(DBSKIP())
		End
	ENDIF
	TRB->(DBSKIP())
End

If Select("TRB") > 0
	TRB->(DBCLOSEAREA())
ENDIF

Return(lRetRat)

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
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DTDISPO >=  '" + DTOS(pPar02) + "'"
cQuery += " AND E5_DTDISPO <=  '" + DTOS(pPar03) + "'"
cQuery += " AND E5_SITUACA = ' ' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
/*
cQuery += " AND E5_TIPO <> 'ACF' AND E5_TIPO <> 'FL'  "
*/

//conforme SSI 10/0188
cQuery += " AND E5_TIPO <> 'FL'  "

cQuery += " AND E5_TIPODOC IN ('VL','CH','BA') "// AND E5_MOEDA IN ('01') ALTERADO MOEDA DE BRANCO PARA 01
cQuery += " AND  E5_RECONC <> ' '  AND E5_FLUXO  =  ' '                           "
cQuery += " AND E5_RECPAG = 'P' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QE6', .T., .T.)

lRetReg := QE6->TOTREG

If Select("QE6") > 0
	QE6->(DBCLOSEAREA())
Endif

Return(lRetReg)

Static Function _fCriaSx1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt     ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01     ,def01    ,defspa01,defeng01,cnt01 ,var02,def02 ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3 ,"","","",""
*/
aAdd(aRegs,{cPerg,"01","Data de            ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data ate           ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

Return
