#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"
#INCLUDE "DelAlias.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CFINR010 clone do FINR620 ³ Andy Pudja   ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
User Function CFINR010()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := "Este programa ir  emitir a rela‡„o da movimenta‡„o banc ria"
LOCAL cDesc2 := "de acordo com os parametros definidos pelo usuario. Poder  ser"
LOCAL cDesc3 := "impresso em ordem de data disponivel,banco,natureza ou dt.digita‡„o."
LOCAL limite  := 132
LOCAL cString := "SE5"
LOCAL aOrd := {OemToAnsi("Por Dt.Dispo"),OemToAnsi("Por Banco"),OemToAnsi("Por Natureza"),OemToAnsi("Dt.Digitacao")},nOrdem := 1
LOCAL Tamanho:="M"

PRIVATE titulo := OemToAnsi("Relacao da Movimentacao Bancaria")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE cNomeArq
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog:="FINR010"
PRIVATE nLastKey := 0
PRIVATE cPerg	 :="CFINR010  " //"FIN620"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros			    		 ³
//³ mv_par01				// da data							 ³
//³ mv_par02				// ate a data						 ³
//³ mv_par03				// do banco     					 ³
//³ mv_par04				// da agencia 						 ³
//³ mv_par05				// da conta		        			 ³
//³ mv_par06				// da natureza 						 ³
//³ mv_par07				// ate a natureza 					 ³
//³ mv_par08				// da data de digitacao 			 ³
//³ mv_par09				// ate a data de digitacao 	    	 ³
//³ mv_par10				// qual moeda						 ³
//³ mv_par11				// tipo de historico 			     ³
//³ mv_par12				// Analitico / Sintetico			 ³
//³ mv_par13				// Considera filiais      		     ³
//³ mv_par14				// Filial De					     ³
//³ mv_par15				// Filial Ate			   		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


wnrel := "FINR010"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa620Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA620Imp ³ Autor ³ Wagner Xavier 		  ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA620Imp(lEnd,wnRel,Cstring)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock								  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 							  ³±±
±±³			 ³ cString - Mensagem										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA620Imp(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL tamanho := "M"
LOCAL nTotEnt := 0,nTotSai := 0,nGerEnt := 0,nGerSai := 0,nTipo := 0,nColuna := 0,lContinua := .T.
LOCAL nValor,cDoc
LOCAL lVazio  := .T.
LOCAL nMoeda, cTexto
LOCAL nOrdSE5 :=SE5->(IndexOrd())
LOCAL cChave
LOCAL cIndex
LOCAL cHistor
LOCAL cChaveSe5
LOCAL cFiltro := ""
LOCAL bFiltro
Local nTxMoeda:=0
Local aStru 	:= SE5->(dbStruct())
Local cIndice	:= SE5->(IndexKey())
Local cFilterUser := aReturn[7]
Local nMoedaBco	:=	1
Local nCasas		:= GetMv("MV_CENT"+(IIF(mv_par10 > 1 , STR(mv_par10,1),"")))
LOCAL bWhile   := { || IF( mv_par13 == 1, .T., SE5->E5_FILIAL == xFilial("SE5") ) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso so'exista uma empresa/filial ou o SE5 seja compartilhado³
//³ nao ha' necessidade de ser processado por filiais            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par13 := Iif(SM0->(Reccount()) == 1 .or. Empty(xFilial("SE5")),2,mv_par13)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

nOrdem := aReturn[8]
nTipo  := aReturn[4]
cMoeda := Str(mv_par10,1,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("Relacao da Movimentacao Bancaria em ")
cabec1 := OemToAnsi("DATA     BCO AGENCIA      CONTA   NATUREZA  DOCUMENTO                                                   HISTORICO")
cabec1 := OemToAnsi("DATA      BCO  AGENCIA  CONTA      NATUREZA    DOCUMENTO                                                HISTORICO")
cabec2 := OemToAnsi("                                                                           ENTRADA             SAIDA            ")

nMoeda	:= mv_par10
cTexto	:= GetMv("MV_MOEDA"+Str(nMoeda,1))
Titulo	+= cTexto

dbSelectArea("SE5")

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5")
IF mv_par13 == 1
	cQuery += " WHERE E5_FILIAL BETWEEN '" + mv_par14 + "' AND '" + mv_par15 + "'"
ELSE
	cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"
ENDIF
cQuery += " AND D_E_L_E_T_ <> '*' "

If nOrdem == 1
	titulo += OemToAnsi(" por data")
	cCondicao 	:= ".T."
	cCond2 		:= "E5_DTDISPO"
	IF mv_par13 == 1
		cOrder		:= "E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
	ELSE
		cOrder		:= "E5_FILIAL+E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA"
	ENDIF
	cOrder		:= SqlOrder(cOrder)
	
Elseif nOrdem == 2
	titulo += OemToAnsi(" por Banco")
	SE5->(dbSetOrder(3))
	cCondicao 	:= ".T."
	cCond2 := "E5_BANCO+E5_AGENCIA+E5_CONTA"
	cIndice := SE5->(IndexKey())
	IF mv_par13 == 1
		cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1)) + "+E5_FILIAL"
	ENDIF
	cOrder := SqlOrder(cIndice)
Elseif nOrdem == 3
	titulo += OemToAnsi(" por Natureza")
	SE5->(dbSetOrder(4))
	cCondicao 	:= ".T."
	cCond2		:= "E5_NATUREZ"
	cIndice := SE5->(IndexKey())
	IF mv_par13 == 1
		cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1))+"+E5_FILIAL"
	ENDIF
	cOrder := SqlOrder(cIndice)
Elseif nOrdem >= 4 // Digitacao
	IF mv_par13 == 1
		cOrder	 := "E5_DTDIGIT+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
	ELSE
		cOrder	 := "E5_FILIAL+E5_DTDIGIT++E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	ENDIF
	cCondicao := "E5_DTDIGIT >= mv_par08 .and. E5_DTDIGIT <= mv_par09"
	cCond2	  := "E5_DTDIGIT"
	titulo += OemToAnsi("  Por Data de Digitacao")
	cNomeArq:=CriaTrab("",.F.)
	dbSelectArea("SE5")
	IF mv_par13 == 1
		IndRegua("SE5",;
		cNomeArq ,;
		"DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL",,;
		"E5_FILIAL >= '" + mv_par14 + "' .AND. E5_FILIAL <= '" + mv_par15 + "'",OemToAnsi("Selecionando Registros..."))
		SE5->(dbSeek(DTOS(mv_par08),.T.))
	ELSE
		IndRegua("SE5",cNomeArq,"E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA",,,OemToAnsi("Selecionando Registros..."))
		SE5->(dbSeek(xFilial("SE5")+DTOS(mv_par08),.T.))
	ENDIF
EndIF
cFilterUser:=aReturn[7]

cQuery += " AND E5_SITUACA <> 'C' "
cQuery += " AND E5_NUMCHEQ <> '%*'"
cQuery += " AND E5_VENCTO <= E5_DATA "
cQuery += " AND E5_DTDISPO BETWEEN '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02)       + "'"
If !Empty(mv_par03)
    cQuery += " AND E5_BANCO   =   '" + mv_par03        + "' " 
EndIf              
If !Empty(mv_par04)
   cQuery += " AND E5_AGENCIA =   '" + mv_par04        + "' " 
EndIf   
If !Empty(mv_par05)   
   cQuery += " AND E5_CONTA   =   '" + mv_par05        + "' " 
EndIf   
cQuery += " AND E5_BANCO <> '   ' "
cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par06        + "' AND '" + mv_par07       + "'"
cQuery += " AND E5_DTDIGIT BETWEEN '" + DTOS(mv_par08)        + "' AND '" + DTOS(mv_par09)       + "'"
cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','BA','MT','CM','D2','J2','M2','C2','V2','CX','CP','TL') "

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

Set Softseek Off
SetRegua(RecCount())

While ! Eof() .And. EVAL(bWhile) .And. &cCondicao .and. lContinua
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		lContinua:=.F.
		Exit
	End
	
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif
	
	IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Na transferencia somente considera nestes numerarios 		  ³
	//³ No Fina100 ‚ tratado desta forma.                    		  ³
	//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
	//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
	//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
	//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
	//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
		If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
			dbSkip()
			Loop
		Endif
	Endif
	
	If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
		.or. Substr(E5_DOCUMEN,1,1) == "*" )
		dbSkip()
		Loop
	Endif
	
	If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		//Sangria
		dbSkip()
		Loop
	Endif
	
	cAnterior:=&cCond2
	nTotEnt:=0
	nTotSai:=0
	
	While !EOF() .and. &cCond2 = cAnterior .and. EVAL(bWhile) .and. lContinua
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
			lContinua:=.F.
			Exit
		EndIF
		
		IF Empty(E5_BANCO)
			dbSkip()
			Loop
		Endif
		
		IncRegua()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSkip()
			Loop
		Endif
		
		IF E5_SITUACA == "C"
			dbSkip()
			Loop
		EndIF
		
		IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
			dbSkip()
			Loop
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Na transferencia somente considera nestes numerarios 		  ³
		//³ No Fina100 ‚ tratado desta forma.                    		  ³
		//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
		//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
		//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
		//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
		//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
			If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
				dbSkip()
				Loop
			Endif
		Endif
		
		If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
			.or. Substr(E5_DOCUMEN,1,1) == "*" )
			dbSkip()
			Loop
		Endif
		
		
		If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		// Sangria
			dbSkip()
			Loop
		Endif
		
		IF E5_VENCTO > E5_DATA
			dbSkip()
			Loop
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta' FORA dos parametros                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF (E5_DTDISPO < mv_par01) .or. (E5_DTDISPO > mv_par02)
			dbSkip()
			Loop
		Endif
		
		IF (E5_BANCO	< mv_par03) //.or. (E5_BANCO  > mv_par04)
			dbSkip()
			Loop
		EndIf
		
		IF (E5_NATUREZ < mv_par06) .or. (E5_NATUREZ > mv_par07)
			dbSkip()
			Loop
		EndIF
		
		IF (E5_DTDIGIT < mv_par08) .or. (E5_DTDIGIT > mv_par09)
			dbSkip()
			Loop
		EndIF
		
		IF E5_TIPODOC $ "DCüJRüMTüBAüMTüCMüD2/J2/M2/C2/V2/CX/CP/TL"
			dbSkip()
			Loop
		Endif
		
		//  Para o Sigaloja, quando for sangria e nao for R$, nÆo listar nos
		// movimentos bancarios
		
		If (E5_TIPODOC == "SG") .And. (!E5_MOEDA $ "R$"+IIf(cPaisLoc=="BRA","","/$ ")) //Sangria com moeda <> R$
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("SE5")
		
		If SubStr(E5_NUMCHEQ,1,1)=="*"      //cheque para juntar (PA)
			dbSkip()
			Loop
		Endif
		
		If !Empty( E5_MOTBX )
			If !MovBcoBx(E5_MOTBX)
				dbSkip()
				Loop
			Endif
		Endif
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
		Endif
		
		nValor := xMoeda(E5_VALOR,1,mv_par10,E5_DATA)
		
		mv_par12 := Iif(Empty(mv_par11),1,mv_par11)
		lVazio := .F.
		
		If mv_par12 == 1
			@li,000 PSAY E5_DTDISPO
			@li,010 PSAY E5_BANCO
			@li,015 PSAY E5_AGENCIA
			@li,024 PSAY E5_CONTA
			@li,035 PSAY E5_NATUREZ
			cDoc := E5_NUMCHEQ
			If Empty( cDoc )
				cDoc := E5_DOCUMEN
			Endif
			
			IF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 14
				cDoc := Alltrim(E5_DOCUMEN) + if(!empty(E5_DOCUMEN).and. !empty(E5_NUMCHEQ),"-","") + Alltrim(E5_NUMCHEQ )
			Endif
			
			If Empty(cDoc)
				cDoc := Alltrim(E5_PREFIXO)+if(!empty(E5_PREFIXO),"-","")+;
				Alltrim(E5_NUMERO )+if(!empty(E5_PARCELA),"-"+E5_PARCELA,"")
			Endif
			
			If Substr( cDoc,1,1 ) == "*"
				dbSkip()
				Loop
			Endif
			// ajusta otamanho do documento para nao desposicionar o relatorio
			cDoc := If(Len(cDoc)==0,Space(1),cDoc)
			@li,47 PSAY cDoc
			nColuna := IIF(E5_RECPAG = "R" ,66, 84)
			
			@li,nColuna PSAY nValor PicTure tm(nValor,16)
			
		Endif
		
		IF E5_RECPAG = "R"
			nTotEnt += nValor
		Else
			nTotSai += nValor
		Endif
		
		If mv_par12 == 1
			If mv_par11 == 1	// Imprime normalmente
				@li,104 PSAY SUBSTR(E5_HISTOR,1,25)
			Else					// Busca historico do titulo
				If E5_RECPAG == "R"
					cHistor		:= E5_HISTOR
					cChaveSe5	:= E5_FILIAL + E5_PREFIXO + ;
					E5_NUMERO + E5_PARCELA + ;
					E5_TIPO
					dbSelectArea("SE1")
					dbSeek( cChaveSe5 )
					@li,104 PSAY Left( iif( Empty(SE1->E1_HIST), cHistor, SE1->E1_HIST) , 25 )
				Else
					cHistor		:= E5_HISTOR
					cChaveSe5	:= E5_FILIAL + E5_PREFIXO + ;
					E5_NUMERO + E5_PARCELA + ;
					E5_TIPO	 + E5_CLIFOR
					dbSelectArea("SE2")
					dbSeek( cChaveSe5 )
					@li,104 PSAY Left( iif( Empty(SE2->E2_HIST), cHistor, SE2->E2_HIST) , 25 )
				Endif
			Endif
			li++
		Endif
		dbSelectArea("SE5")
		dbSkip()
	Enddo
	
	If ( nTotEnt + nTotSai ) != 0
		li++
		IF nOrdem == 1 .or. nOrdem == 4
			@li, 0 PSAY "Total : " + DTOC(cAnterior)
		Elseif nOrdem == 2
			// Banco+Agencia+Conta
			@li, 0 PSAY "Total : " + Substr(cAnterior,1,3)+" "+Substr(cAnterior,4,5)+" "+Substr(cAnterior,9,10)
		Elseif nOrdem == 3
			dbSelectArea("SED")
			dbSeek(cFilial+cAnterior)
			@li, 0 PSAY "Total : " + cAnterior + " "+ED_DESCRIC
		EndIF
		@li,66 PSAY nTotEnt	  PicTure tm(nTotEnt,16)
		@li,84 PSAY nTotSai	  PicTure tm(nTotSai,16)
		nGerEnt += nTotEnt
		nGerSai += nTotSai
		nTotEnt := 0
		nTotSai := 0
		li+=2
	Endif
	dbSelectArea("SE5")
Enddo

IF li != 80
	li++
	@li,	0 PSAY OemToAnsi("Total Geral : ")
	@li, 66 PSAY nGerEnt 	PicTure tm(nGerEnt,16)
	@li, 84 PSAY nGerSai 	PicTure tm(nGerSai,16)
	li++
	roda(cbcont,cbtxt,Tamanho)
End

If lVazio
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
	End
	@li, 0 PSAY OemToAnsi("Nao existem lancamentos neste periodo")
	li++
	roda(cbcont,cbtxt,Tamanho)
End


Set Device To Screen

dbSelectArea("SE5")
dbCloseArea()
ChKFile("SE5")
dbSelectArea("SE5")
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
End
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr620Skip1³ Autor ³ Pilar S. Albaladejo	  ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR620.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr620Skip1()

Local lRet := .T.

If Empty(E5_BANCO)
	lRet := .F.
ElseIf E5_SITUACA == "C"
	lRet := .F.
ElseIf E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ)
	lRet := .F.
ElseIf E5_VENCTO > E5_DATA
	lRet := .F.
Endif

Return lRet
