#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | CFINR001 ³ Autor ³ Nadia C. D. Mamude    ³ Data ³ 15/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ C¢pia de Cheques                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modulo    | Financeiro                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	 Uso     ³ Especifico CIEE.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CFINR001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//wnrel
cDesc1  := OemToAnsi("Este programa ir  imprimir as copias dos cheques emitidos.")
cDesc2  := OemToAnsi("Em uma folha ser  impresso apenas uma copia de cheque.")
cDesc3  := ""
cString := "SEF"

titulo   := OemToAnsi("Copias de cheques")
aReturn  := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1}
nLastKey := 0
nomeprog := "CFINR001"
cPerg    := "FIN001"
li       := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros	                     |
//³ mv_par01			// Codigo do banco						 ³
//³ mv_par02			// Da agencia	                    	 ³
//³ mv_par03			// Da conta 							 ³
//³ mv_par04			// Do cheque							 ³
//³ mv_par05			// Ate o cheque							 ³
//³ mv_par06			// Imprime composicao do cheque			 |
//³ mv_par07			// Copias p/ pagina (1/2)				 ³
//³ mv_par08			// Imprime numeracao sequencial			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 					     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := nomeprog   // Nome default do relatorio em disco.
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"P")

If nLastKey = 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
Endif
// Armazena o estado original das tabelas.
Private _aAliasSA6 := SA6->(GetArea())
Private _aAliasSEF := SEF->(GetArea())
Private _aAliasSE2 := SE2->(GetArea())
Private _aContCh := {}
Private _cVencrea

// Processa o relatorio.
RptStatus({|lEnd| Fa490Imp(@lEnd,wnRel,cString)},titulo)
// Restaura o estado anterior das tabelas.
SA6->(RestArea(_aAliasSA6))
SEF->(RestArea(_aAliasSE2))
SE2->(RestArea(_aAliasSE2))
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FA490Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 13/11/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Copia de cheques                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA490Imp(lEnd, wnRel, cString)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - Acao do CodeBlock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA490Imp(lEnd, wnRel, cString)

local cExtenso := ""
local j, nTipo := 18, nRec, nContador := 0, cDocto
Local _cChave := " "
// mv_par01 := mv_par01 + Space(03 - Len(mv_par01))
// mv_par02 := mv_par02 + Space(05 - Len(mv_par02))
// mv_par03 := mv_par03 + Space(10 - Len(mv_par03))
// mv_par04 := mv_par04 + Space(15 - Len(mv_par04))
// mv_par01  -   Codigo do banco
// mv_par02  -   Da agencia
// mv_par03  -   Da conta
// mv_par04  -   Do cheque
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe o banco.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA6"); dbSetOrder(1)
If !dbSeek(xFilial("SA6") + mv_par01 + mv_par02 + mv_par03, .F.)
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o 1.Cheque a ser impresso.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEF"); dbSetOrder(1)
dbSeek(xFilial("SEF") + mv_par01 + mv_par02 + mv_par03 + mv_par04, .T.)

SetRegua(RecCount())
fa490Cabec(nTipo)
_lAchou   := .F.
_aTit     := {}
Do While !eof() .and.;
	(EF_FILIAL + EF_BANCO == xFilial("SEF") + mv_par01) .and.;
	(EF_AGENCIA == mv_par02) .and.;
	(EF_CONTA == mv_par03) .and.;
	(EF_NUM <= mv_par05)
	
	IncRegua()
	If lEnd
		@Prow() + 1,1 PSAY OemToAnsi("Cancelado pelo operador")
		Exit
	EndIF
	
	
	If  (EF_IMPRESS $ "AC" .or. SubStr(EF_TIPO,1,2) == "TB") .or.;
		(SEF->EF_NUMAP < MV_PAR09 .OR. SEF->EF_NUMAP > MV_PAR10)
		If !_lAchou
			dbSelectArea("SE2"); dbSetOrder(1)
			If dbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA,.F.)
				_lAchou:=.T.
			EndIf
		EndIf
		dbSelectArea("SEF")
		aAdd(_aTit, SEF->(RecNo()))
		SEF->(dbSkip())
		Loop
	EndIf
	
	If mv_par07 == 1    // Uma copia por folha.
		li := 1
	Elseif li > 32      // So coube uma copia.
		li := 1
	Else                // Duas copias por folha.
		If nContador == 0
			li := 1
		Else
			li := 33
		EndIf
	EndIf
	
	nContador++
	If nContador > 2; nContador := 1; li := 1; EndIf
	__LogPages()
	@li, 01 PSAY Alltrim(SM0->M0_NOMECOM) + " - " + Alltrim(SM0->M0_FILIAL) + OemToAnsi("  -  COPIA DE CHEQUE")
	li++
	@li, 00 PSAY Replicate("-",80)
	li++
	@li, 00 PSAY OemToAnsi("|  Numero Cheque ")  + EF_NUM
	@li, 35 PSAY OemToAnsi("Data da Emissao ")  + Dtoc(EF_DATA)
	@li, 79 PSAY "|"
	li++
	@li, 00 PSAY OemToAnsi("|  Banco ") + EF_BANCO +  "     "    + SA6->A6_NREDUZ
	@li, 35 PSAY OemToAnsi("Agencia   ") + SUBSTR(EF_AGENCIA,1,4)+"-"+SUBSTR(EF_AGENCIA,5,1) + OemToAnsi("   Conta ") + EF_CONTA
	@li, 79 PSAY "|"
	li++
	@li, 00 PSAY OemToAnsi("|  Valor Cheque ") + Transform(EF_VALOR,"@E 9999,999,999.99")
	@li, 35 PSAY OemToAnsi("Data do Cheque  ") + Dtoc(EF_DATA)
	@li, 79 PSAY "|"
	li++
	@li, 00 PSAY OemToAnsi("|  Favorecido ") + EF_BENEF
	@li, 79 PSAY "|"
	li++
	_cHist := SEF->EF_HIST
	Do While at("  ", _cHist) != 0
		_cHist := StrTran(_cHist, "  ", " ")
	EndDo
	@li, 00 PSAY OemToAnsi("|  Historico  ") + SUBSTR(_cHist,1,65)
	@li, 79 PSAY "|"
	li++
	@li, 00 PSAY OemToAnsi("|             ") + SUBSTR(_cHist,66,64)
	@li, 79 PSAY   "|"
	li++
	If mv_par08 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pegar e gravar o proximo numero da Copia do Cheque       ³
		//³ Posicionar no sx6 utilizando GetMv. N„o Utilize Seek !!! ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If empty(SEF->EF_NUMAP)
			cDocto := StrZero(Val(Getmv("MV_NUMCOP")) + 1, 6)
			dbSelectArea("SX6")
			GetMv("MV_NUMCOP")
			RecLock("SX6",.F.)
			Replace X6_CONTEUD With cDocto
			MsUnlock()
			dbSelectArea("SEF")
			Reclock ("SEF", .F.)
			Replace SEF->EF_NUMAP With cDocto
			MsUnlock()
			If _lAchou
				
				// Caso o AP for de vários títulos
				If Len(_aTit)>1
					_aAreaSEF := SEF->(GetArea())
					
					For _nI:=1 to Len(_aTit)
						SEF->(dbGoTo(_aTit[_nI]))
						dbSelectArea("SE2"); dbSetOrder(1)
						If dbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA,.F.)
							_cChave := xFilial("SE2")+(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
							If Empty(SE2->E2_NUMAP)
								DbSelectarea("SA2")
								SA2->(DbSetOrder(1))
								SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

								AADD(_aContCh,{IIF(!Empty(SE2->E2_RED_CRE),SE2->E2_RED_CRE,SA2->A2_REDUZ),SA2->A2_CONTA,(SE2->E2_VALOR-SE2->E2_DECRESC+SE2->E2_ACRESC),SA6->A6_CONTABI,SA6->A6_CONTA,cDocto,SEF->EF_NUM,SE2->E2_NOMFOR,_cChave})
							EndIf
							
							dbSelectArea("SE2")
							Reclock ("SE2", .F.)
							SE2->E2_SALDO   := 0
							SE2->E2_BAIXA   := dDataBase
							SE2->E2_NUMAP   := cDocto
							SE2->E2_VALLIQ  := (SE2->E2_VALOR-SE2->E2_DECRESC+SE2->E2_ACRESC)
                            MsUnlock()
							If !Empty(SE2->E2_NUMAP)
								dbSelectArea("SE5")
								SE5->(dbSetOrder(13))  
								SE5->(dbGotop())
								If SE5->(dbSeek(xFilial("SE5")+(SE2->E2_NUMBCO+SE2->E2_FORNECE+SEF->EF_BANCO))) //Acrescentado indice do Banco pelo analista Emerson 18/01/07
									Reclock ("SE5", .F.)                            
									SE5->E5_DTDISPO := SE2->E2_VENCREA							
									SE5->E5_NUMAP   := SE2->E2_NUMAP							
									SE5->E5_PREFIXO := SE2->E2_PREFIXO
									SE5->E5_NUMERO  := SE2->E2_NUM
									SE5->E5_TIPO    := SE2->E2_TIPO
									SE5->E5_CLIFOR  := SE2->E2_FORNECE
									SE5->E5_LOJA    := SE2->E2_LOJA															
									MsUnlock()
								EndIf
							EndIf						
						EndIf
						
					Next _nI
					SEF->(RestArea(_aAreaSEF))
				Else
					If Empty(SE2->E2_NUMAP)
						DbSelectarea("SA2")
						SA2->(DbSetOrder(1))
						SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
						_cChave := xFilial("SE2")+(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
						AADD(_aContCh,{IIF(!Empty(SE2->E2_RED_CRE),SE2->E2_RED_CRE,SA2->A2_REDUZ),SA2->A2_CONTA,(SE2->E2_VALOR-SE2->E2_DECRESC+SE2->E2_ACRESC),SA6->A6_CONTABI,SA6->A6_CONTA,cDocto,SEF->EF_NUM,SE2->E2_NOMFOR,_cChave})
					EndIf
					dbSelectArea("SE2")
					Reclock ("SE2", .F.)
					SE2->E2_SALDO   := 0
					SE2->E2_BAIXA   := dDataBase
					SE2->E2_NUMAP   := cDocto
					SE2->E2_VALLIQ  := (SE2->E2_VALOR-SE2->E2_DECRESC+SE2->E2_ACRESC)
					MsUnlock()
					If !Empty(SE2->E2_NUMAP)					
						dbSelectArea("SE5")
						SE5->(dbSetOrder(13))  
						SE5->(dbGotop())
						If SE5->(dbSeek(xFilial("SE5")+(SE2->E2_NUMBCO+SE2->E2_FORNECE+SEF->EF_BANCO))) //Acrescentado indice do Banco pelo analista Emerson 18/01/07
							Reclock ("SE5", .F.)					
							SE5->E5_DTDISPO := SE2->E2_VENCREA					
							SE5->E5_NUMAP   := SE2->E2_NUMAP							
							SE5->E5_PREFIXO := SE2->E2_PREFIXO
							SE5->E5_NUMERO  := SE2->E2_NUM
							SE5->E5_TIPO    := SE2->E2_TIPO
							SE5->E5_CLIFOR  := SE2->E2_FORNECE
							SE5->E5_LOJA    := SE2->E2_LOJA													
							MsUnlock()
						EndIf
                	EndIf
				EndIf
				
				_aAreaSE5 := SE5->(GetArea())
				
				SE5->(dbSetOrder(2))  
				SE5->(dbGotop())
				If SE5->(dbSeek(xFilial("SE5")+"CH"+SPACE(13)+DTOS(SE2->E2_EMISSAO)+SE2->E2_FORNECE))
					While xFilial("SE5")+"CH"+SPACE(13)+DTOS(SE2->E2_EMISSAO)+SE2->E2_FORNECE == SE5->E5_FILIAL+SE5->E5_TIPODOC+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+DTOS(SE5->E5_DATA)+SE5->E5_CLIFOR
						If SEF->EF_NUM == SE5->E5_NUMCHEQ
							Reclock ("SE5", .F.)
							SE5->E5_DTDISPO := SE2->E2_VENCREA
							SE5->E5_NUMAP   := SE2->E2_NUMAP							
							SE5->E5_PREFIXO := SE2->E2_PREFIXO
							SE5->E5_NUMERO  := SE2->E2_NUM
							SE5->E5_TIPO    := SE2->E2_TIPO
							SE5->E5_CLIFOR  := SE2->E2_FORNECE
							SE5->E5_LOJA    := SE2->E2_LOJA																																																																						
							MsUnlock()
							Exit
						EndIf
						SE5->(dbSkip())
					EndDo
				Endif                   
				SE5->(RestArea(_aAreaSE5))
				
				dbSelectArea("SEF")
				_lAchou:=.F.
				_aTit  := {}
			EndIf
		ELSE
			cDocto := SEF->EF_NUMAP
		ENDIF
		
		//dbSelectArea("SEF"); dbSetOrder(1)
		//dbSeek(xFilial("SEF") + mv_par01 + mv_par02 + mv_par03 + mv_par04, .T.)
		
		@li, 0 PSAY OemToAnsi("|  Autorizacao Pagto N.") + cDocto
		@li,79 PSAY "|"
	Else
		@li, 0 PSAY "|" + Replicate(" ", 78) + "|"
		//@li, 0 PSAY "|"
		//@li,79 PSAY "|"
	End
	li++
	@li, 0 PSAY OemToAnsi("|  Vistos")
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|" + Replicate("-", 78) + "|"
	li++
	@li, 0 PSAY OemToAnsi("|    Tesouraria     |Analise Desembolso |    Procurador    |    Procurador     |")
	//@li, 0 PSAY OemToAnsi("|Tesouraria         |Anal.de Desembolso |Procurador        |Procurador         |")
	
	li++
	@li, 0 PSAY "|-------------------|-------------------|------------------|-------------------|"
	li++
	For j := 1 to 5
		@li, 00 PSAY "|"
		@li, 20 PSAY "|"
		@li, 40 PSAY "|"
		@li, 59 PSAY "|"
		@li, 79 PSAY "|"
		li++
	Next j
	@li, 0 PSAY Replicate("-", 80)
	nRec := SEF->(RecNo())
	// mv_par06 -> Imprime composicao do cheque (1-S/2-N).
	If mv_par06 == 1
		fr490Cpos(SEF->EF_NUM)
	EndIf
	SEF->(dbGoTo(nRec))
	SEF->(dbSkip())
EndDo

GRVPRECH(_aContCh)  // Contabilizacao Das Baixas -

// Finaliza relatorio.
Set Device To Screen
Set Filter To
If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif
MS_FLUSH()

u_CFINR001()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o  	 ³ fr490Cpos³ Autor ³           		    ³ Data ³ 15.05.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copia de cheques							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³               							  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 											                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     |  especifico                 				                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

STATIC Function fr490Cpos(cCheque)
LOCAL nFirst:=0,lAglut:=.F.
aColu	:= {}
aTam    := TamSX3("E2_FORNECE")
aTam2   := TamSX3("EF_TITULO")
cCabeca := ""
cCabecb := ""

DbSelectArea("SEF")
dbSeek (xFilial("SEF") + mv_par01 + mv_par02 + mv_par03 + cCheque, .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao das colunas de impressao.                          ³
//³ aTam[1]  = Tamanho do codigo do fornecedor (6 ou 20).        ³
//³ aTam2[1] = Tamanho do nro. do titulo (6 ou 12).              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aTam[1] > 6
	aColu := {001, 025, 057, 008, 012, 026, 030, 052}
	cCabeca	:= OemToAnsi("|Fornec                  Nome Fornecedor                 Natureza              |")
	Cabecb	:= OemToAnsi("|       Prf Numero        P   Vencto                  Valor do Titulo          |")
ElseIf aTam2[1] > 6
	aColu := {001, 011, 043, 008, 012, 026, 030, 052}
	cCabeca	:= OemToAnsi("|Fornec    Nome Fornecedor                 Natureza                            |")
	cCabecb	:= OemToAnsi("|       Prf Numero        P   Vencto                  Valor do Titulo          |")
Else
	aColu := {001, 008, 029, 040, 044, 051, 053, 063}
	cCabeca	:= OemToAnsi("|Fornec   Nome Fornecedor    Natureza   Prf Numero   Vencto     Valor do Titulo|")
	//cCabeca	:= OemToAnsi("|Fornec   Nome Fornecedor   Prf Numero P| Natureza   Vencto    Valor do Titulo|")
	cCabecb	:= ""
Endif

While !Eof() .And.;
	EF_FILIAL + EF_BANCO == xFilial("SEF") + mv_par01 .and. ;
	EF_AGENCIA == mv_par02 .and.;
	EF_CONTA == mv_par03 .And. ;
	EF_NUM == cCheque
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacao da carteira³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If EF_CART = "R"
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se nao ‚ principal o cancelado.				 	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If EF_IMPRESS == "C"
		dbSkip()
		Loop
	EndIf
	If li > 58
		li:=1
		@li, 00 PSAY OemToAnsi("COPIA DO CHEQUE : ") + cCheque + OemToAnsi(" - Continuacao")
		li++
	EndIF
	IF nFirst == 0
		IF EF_IMPRESS = "A"
			lAglut := .T.
		EndIF
		IF !lAglut .and. Empty(SEF->EF_TITULO)
			dbSkip()
			Loop
		End
		li++
		@li,0 PSAY OemToAnsi("|- Composicao do Cheque ") + Replicate("-",55) + "|"
		li++
		@li,0 PSAY cCabeca
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se sera necess rio imprimir em duas linhas os deta- ³
		//³ lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF aTam[1] > 6 .or. aTam2[1] > 6
			li++
			@li,0 PSAY cCabecb
		Endif
		li++
		@li,0 PSAY Replicate("-",80)
	EndIF
	IF Empty(SEF->EF_TITULO)
		dbSkip()
		Loop
	End
	If aTam[1] == 6 .and. aTam2[1] == 6
		nTam := 20
	Else
		nTam := 30
	Endif
	nFirst++
	li++
	dbSelectArea("SE2"); dbSetOrder(1)
	dbSeek(xFilial("SE2") + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO + SEF->EF_FORNECE + SEF->EF_LOJA, .F.)
	@li, 0 PSAY "|"
	@li, aColu[1] PSAY E2_FORNECE 
	@li, aColu[2] PSAY SubStr(SEF->EF_BENEF,1,nTam) //SubStr(E2_NOMFOR,1,nTam) // Alterado dia 10/12/08 pelo analista Emerson conforme solicitacao do usuario
	@li, aColu[3] PSAY SE2->E2_NATUREZ
	dbSelectArea("SEF")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se sera necess rio imprimir em duas linhas os deta- ³
	//³ lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF aTam[1] > 6 .or. aTam2[1] > 6
		@li,79 PSAY "|"
		li++
		@li, 0 PSAY "|"
	Endif
	@li, aColu[4] PSAY EF_PREFIXO
	@li, aColu[5] PSAY EF_TITULO
	@li, aColu[6] PSAY EF_PARCELA
	@li, aColu[7] PSAY SE2->E2_VENCREA
	@li, aColu[8] PSAY EF_VALOR PicTure tm(EF_VALOR,16)
	@li,79 PSAY "|"
	dbSkip()
EndDO
IF nFirst>0
	li++
	@li, 0 PSAY Replicate("-",80)
End     
li+=3
@li,0 PSAY "Pagamento(s) Analisado(s) Anteriormente "
li++
@li,0 PSAY "Pela Analise de Desembolso  "

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Fa490Cabec³ Autor ³ Alessandro B. Freire  ³ Data ³ 18.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de leitura do driver correto de impressao	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA490cabec(nchar) 								          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nChar . 15 - Comprimido , 18 - Normal                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³ Finr490						                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa490cabec(nChar)
cTamanho := "P"
aDriver := ReadDriver()
If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif
If nChar == NIL
	@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
Else
	If nChar == 15
		@pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
	Else
		@pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))
	Endif
Endif
Return(.T.)


/*
STATIC FUNCTION GRVPRECH(pMatriz)


Private _cLoteCie := ALLTRIM(GETMV("CI_LOTEAP"))  // Lote Determinado pelo usuario no parametro
Private _cSubLCie := "001"
Private _cDocCie  := "000000"
Private _cLinCie  := 0
Private _nNroAp   := " "
Private nLanSeq   := 0 
//AADD(_aContCh,{SA2->A2_REDUZ,SA2->A2_CONTA,SE2->E2_VALOR,SA6->A6_CONTABI,SA6->A6_CONTA,cDocto,SEF->EF_NUM,SE2->E2_NOMFOR, _cChave})
//                    1              2            3               4           5            6        7           8

// pMatriz[N][1]  - Conta Contabil Reduzida Fornecedor
// pMatriz[N][2]  - Conta Contabil Estrutura Fornecedor
// pMatriz[N][3]  - Valor do Movimento
// pMatriz[N][4]  - Conta Contabil Reduzida Banco
// pMatriz[N][5]  - Conta Contabil Estrutura Banco
// pMatriz[N][6]  - Numero da Autorizacao de Pagamento
// pMatriz[N][7]  - Numero do cheque
// pMatriz[N][8]  - Nome Reduzido do Fornecedor
// pMatriz[N][9]  - Chave para CT2_KEY


dbSelectArea("CT2")
dbSetOrder(1)

If Len(pMatriz) > 0
	_nNroAp   := pMatriz[1][6]
	_cVencrea := SE2->E2_VENCREA
	pData     := dDataBase
//    _cDocCie  := CTGERDOC(_cLoteCie,_cSubLCie,_cVencrea)
    _cDocCie  := CTGERDOC(_cLoteCie,_cSubLCie,pData)    
    _cLinCie  := 0     

	For Ic := 1 To Len(pMatriz)
		RecLock("CT2",.T.)
		CT2->CT2_FILIAL := xFILIAL("CT2")
		CT2->CT2_DATA   := dDataBase //SE2->E2_VENCREA
		CT2->CT2_LOTE   :=_cLoteCie
		CT2->CT2_SBLOTE :=_cSubLCie
		
		IF _nNroAp <> pMatriz[Ic][6]
//            _cDocCie := CTGERDOC(_cLoteCie,_cSubLCie,_cVencrea)
            _cDocCie := CTGERDOC(_cLoteCie,_cSubLCie,pData)            
			_nNroAp := pMatriz[Ic][6]
			_cLinCie := 0
		ENDIF
		_cLinCie := _cLinCie + 1
		_cDocCie := _cDocCie + 1
		CT2->CT2_LINHA  :=StrZero(_cLinCie,3)
		CT2->CT2_DOC    := StrZero(_cDocCie,6)
		
		IF !Empty(pMatriz[Ic][1]) .and. Empty(pMatriz[Ic][4])
			CT2->CT2_DC  := "1"
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][1],1,6)))
			CT2->CT2_DEBITO := CT1->CT1_CONTA
		ELSEIF Empty(pMatriz[Ic][1]) .and. !Empty(pMatriz[Ic][4])
			CT2->CT2_DC  := "2"
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][4],1,6)))
			CT2->CT2_CREDIT := CT1->CT1_CONTA
		ELSE
			CT2->CT2_DC  := "3"
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][1],1,6)))
			CT2->CT2_DEBITO := CT1->CT1_CONTA
			CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][4],1,6)))
			CT2->CT2_CREDIT := CT1->CT1_CONTA
		ENDIF
		CT2->CT2_DCD:= ""
		CT2->CT2_DCC:= ""
		CT2->CT2_MOEDLC:="01"
		CT2->CT2_VALOR:=pMatriz[Ic][3]
		CT2->CT2_MOEDAS:="1"
		CT2->CT2_HP:= ""
		CT2->CT2_HIST:= pMatriz[Ic][6]+SPACE(1)+Alltrim(pMatriz[Ic][7])+SPACE(1)+SUBS(pMatriz[Ic][8],1,16)+SPACE(1)+Dtoc(_cVencrea)
		CT2->CT2_CRITER:="1"
		CT2->CT2_CCD:= ""
		CT2->CT2_CCC:= ""
		CT2->CT2_ITEMD  := pMatriz[Ic][1]
		CT2->CT2_ITEMC  := pMatriz[Ic][4]
		CT2->CT2_CLVLDB:= ""
		CT2->CT2_CLVLCR:= ""
		CT2->CT2_VLR02:= 0
		CT2->CT2_VLR03:= 0
		CT2->CT2_VLR04:= 0
		CT2->CT2_VLR05:= 0
		CT2->CT2_ATIVDE:= ""
		CT2->CT2_ATIVCR:= ""
		CT2->CT2_EMPORI:=Substr(cNumEmp,1,2)
		CT2->CT2_FILORI:=xFilial("CT2")
		CT2->CT2_INTERC:="2"
		CT2->CT2_IDENTC:= ""
		CT2->CT2_TPSALD:= "9"
		CT2->CT2_SEQUEN:=StrZero(_cLinCie,3)
		CT2->CT2_MANUAL:="1"
		CT2->CT2_ORIGEM:="010 CFINR001"
		CT2->CT2_ROTINA:="CFINR001"
		CT2->CT2_AGLUT:= "2"
		CT2->CT2_LP:="566"
		CT2->CT2_KEY := pMatriz[Ic][9]
		CT2->CT2_SEQHIS:=StrZero(_cLinCie,3)
//		nLanSeq := (VAL(CTGERLAN(_cLoteCie,_cSubLCie,_cVencrea,STRZERO(_cDocCie,6)))+1)
		nLanSeq := (VAL(CTGERLAN(_cLoteCie,_cSubLCie,pData,STRZERO(_cDocCie,6)))+1)		
		CT2->CT2_SEQLAN:=  StrZero(nLanSeq,3)
		CT2->CT2_DTVENC:= Ctod("//")
		CT2->(MSUNLOCK())
	Next
ENDIF

Return
*/
/*
--------------------------------------------------------------------------------------------------------------
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR001  ºAutor  ³Emerson Natali      º Data ³  07/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GRVPRECH(pMatriz)

Local nDecs			:=	TamSX3('CT2_VALOR')[2]
Local nX			:=	1
Local nBase			:=	1
Local nMaxLanc		:=	99
Local nContador		:=	Min(Len(pMatriz),nMaxLanc-1)
Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}
Local dDataLanc 	:= CTOD("") 

Private lMsErroAuto := .F.
Private _cLoteCie 	:= ALLTRIM(GETMV("CI_LOTEAP"))  // Lote Determinado pelo usuario no parametro
Private _cSubLCie 	:= "001"

_cVencrea := SE2->E2_VENCREA

// pMatriz[N][1]  - Conta Contabil Reduzida Fornecedor
// pMatriz[N][2]  - Conta Contabil Estrutura Fornecedor
// pMatriz[N][3]  - Valor do Movimento
// pMatriz[N][4]  - Conta Contabil Reduzida Banco
// pMatriz[N][5]  - Conta Contabil Estrutura Banco
// pMatriz[N][6]  - Numero da Autorizacao de Pagamento
// pMatriz[N][7]  - Numero do cheque
// pMatriz[N][8]  - Nome Reduzido do Fornecedor
// pMatriz[N][9]  - Chave para CT2_KEY

For nX	:= nBase To nContador

	aCab := {;
			{"dDataLanc", dDataBase,NIL},;
			{"cLote"	, _cLoteCie,NIL},;
			{"cSubLote"	, _cSubLCie,NIL}}

	IF !Empty(pMatriz[nX][1]) .and. Empty(pMatriz[nX][4])
		_cDC 	:= "1"
		_cITEMD	:= pMatriz[nX][1]
		_cITEMC := ""
	ELSEIF Empty(pMatriz[nX][1]) .and. !Empty(pMatriz[nX][4])
		_cDC 	:= "2"
		_cITEMD := ""
		_cITEMC := pMatriz[nX][4]
	ELSE
		_cDC 	:= "3"
		_cITEMD := pMatriz[nX][1]
		_cITEMC := pMatriz[nX][4]
	ENDIF
	AADD(aItem,{	{"CT2_FILIAL"	,xFilial("CT2")									, NIL},;
					{"CT2_LINHA"	,"001"											, NIL},;
					{"CT2_DC"		,_cDC	 										, NIL},;
					{"CT2_ITEMD"	,_cITEMD										, NIL},;
					{"CT2_ITEMC"	,_cITEMC										, NIL},;
					{"CT2_CCD"		, "" 											, NIL},;
					{"CT2_CCC"		, "" 											, NIL},;
					{"CT2_DCD"		, "" 											, NIL},;
					{"CT2_DCC"		, "" 											, NIL},;
					{"CT2_VALOR"	, Round(pMatriz[nX][3],nDecs)					, NIL},;
					{"CT2_HP"		, ""											, NIL},;
					{"CT2_HIST"		, pMatriz[nX][6]+SPACE(1)+Alltrim(pMatriz[nX][7])+SPACE(1)+SUBS(pMatriz[nX][8],1,16)+SPACE(1)+Dtoc(_cVencrea), NIL},;
					{"CT2_TPSALD"	, "9"											, NIL},;
					{"CT2_ORIGEM"	, "010 CFINR001"								, NIL},;
					{"CT2_MOEDLC"	, "01"											, NIL},;
					{"CT2_EMPORI"	, Substr(cNumEmp,1,2)							, NIL},;
					{"CT2_ROTINA"	, "CFINR001"									, NIL},;
					{"CT2_LP"		, "566"											, NIL},;
					{"CT2_KEY"		, pMatriz[nX][9]								, NIL}})

	aadd(aTotItem,aItem)

	MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItem,3)

	aTotItem	:=	{}

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		Return .F.
	Else
		_cAreaX		:= GetArea()
		dbclearindex()
		DbSkip(-1)
		_dData	:=	DTOS(CT2->CT2_DATA)
		_cLote	:=	CT2->CT2_LOTE
		_cSub	:=	CT2->CT2_SBLOTE
		_cDoc	:=	CT2->CT2_DOC
		DbSelectArea("CT2")
		cInd := "1"
		While TcCanOpen("CT2","CT2" + cInd)
				ORDLISTADD("CT2" + cInd)
				cInd:= soma1(cInd)
		Enddo
		DbGotop()
		DbSeek(xFilial("CT2")+_dData+_cLote+_cSub+_cDoc)
		Do While DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC==_dData+_cLote+_cSub+_cDoc
			RecLock("CT2",.F.)
			CT2->CT2_LP		:= "566"
			CT2->CT2_KEY 	:= pMatriz[nX][9]
			MsUnLock()
			CT2->(DbSkip())
		EndDo
		RestArea(_cAreaX)
	Endif

	aCab	:= {}
	aItem	:= {}

Next

nBase		:=	nX
nContador	:=	Min(Len(pMatriz),(nBase-1)+(nMaxLanc-1))

Return .T.
/*
--------------------------------------------------------------------------------------------------------------
*/
Static  Function CTGERLAN(pLote,pSbLote,pData,pDoc) 

Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0


_cQuery := " SELECT MAX(CT2_SEQLAN) AS SEQMOV FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl 
_cQuery += " AND CT2_SBLOTE = '"+pSbLote+"' "+_cFl 
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' AND CT2_DOC = '"+pDoc+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRT',.T.,.T.)


_lRet := TRT->SEQMOV


If Select("TRT") > 0
   TRT->(DBCLOSEAREA())
EndIf


Return(_lRet)   

Static  Function CTGERDOC(pLote,pSbLote,pData)


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0


_cQuery := " SELECT MAX(CT2_DOC) AS DOCMOV FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl
_cQuery += " AND CT2_SBLOTE = '"+pSbLote+"' "+_cFl
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRS',.T.,.T.)


If !Empty(TRS->DOCMOV)
    _lRet := VAL(TRS->DOCMOV)
Endif    


If Select("TRS") > 0
	TRS->(DBCLOSEAREA())
EndIf


Return(_lRet)
