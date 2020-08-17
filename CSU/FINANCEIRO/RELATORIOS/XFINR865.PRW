#Include "FINR865.CH"
#Include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR865	³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de titulos a pagar com rentencao PIS/Cofins/CSLL	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR865(void)			 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ 10-09-13 ³	COLOCADO A ORDEM DE RECNO PARA IMPRESSAO OS 2757/13        ±±
±±³          	- FERNANDO JOSE/TOTVS									   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XFINR865()

Local oReport
Local aArea		 := GetArea()

Return XFINR865R3()

RestArea(aArea)

Return

/*
---------------------------------------------- Release 3 ---------------------------------------------------------
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	  ³ FINR865  ³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o  ³ Relacao de titulos a pagar com rentencao PIS/Cofins/CSLL	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e  ³ FINR865(void)									            		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³ Generico 												               ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º   Data    ³    Autor   ³ BOPS ³        Manutencao Efetuada             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º31/10/2007 ³Pedro P Lima³134275³ O relatorio nao considerava o valor    º±±
±±º           ³   TI6434   ³      ³ original do titulo, que era impresso   º±±
±±º           ³            ³      ³ com o valor 0,00.                      º±±
±±º           ³            ³      ³ Foi corrigido o trecho onde a variavel º±±
±±º           ³            ³      ³ nValBase recebe o valor original do    º±±
±±º           ³            ³      ³ titulo. R3                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XFINR865R3()

Local cDesc1    := STR0001 //"Imprime a relacao dos titulos a pagar que sofreram retencao de Impostos"
Local cDesc2    := ""
Local cDesc3    := ""
Local wnrel
Local cString   := "SE2" //Contas a Pagar
Local nRegEmp   := SM0->(RecNo())
Local aTam	    := TAMSX3("E2_NUM")

Private titulo  := ""
Private cabec1  := ""
Private cabec2  := ""
Private aLinha  := {}
Private aReturn := { STR0002, 1,STR0003, 1, 2, 1, "",1 }   //"Zebrado"###"Administracao"
Private aOrd    := {STR0004,STR0005} //"Por Codigo Fornecedor"###"Por Nome Fornecedor"
Private cPerg	 := PADR("FIN865",LEN(SX1->X1_GRUPO))
Private nJuros  := 0
Private nLastKey:= 0
Private nomeprog:= "FINR865"
Private tamanho := "G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("FIN865",.T.)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01		 // Data de?   	     ³
//³ mv_par02		 // Data ate?          ³
//³ mv_par03		 // Organiza por?      ³
//³ mv_par04		 // Enviados?          ³
//³ mv_par05		 // De Emissao?	     ³
//³ mv_par06		 // Ate Emissao?       ³
//³ mv_par07		 // De Vencto?		     ³
//³ mv_par08		 // Ate Vencto?        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSX1(cPerg)

pergunte("FIN865",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := STR0007 //"Relacao de Titulos a Pagar com retencao de Impostos"
cabec1 := "Codigo         Nome do Fornecedor             CGC                          ------  Valor de IRRF  ------"
cabec2 := "  Prf Numero  Pc  Tipo  Dt.Emiss.  Dt.Vencto  Dt.Contab.  Valor Original      Calculado         Retido         Valor ISS      Valor INSS       Valor PIS    Valor COFINS      Valor CSLL   Valor Liquido"
//           xxx xxxxxx  xx  xxx   dd/mm/aa   dd/mm/aa   dd/mm/aa   9999,999,999.99   999,999,999.99 999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99
//           3   7       15  19    25         36         47         58                76             91              106             123             139             155             171             187           
//         123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
//                  10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros	³
//³ mv_par01		 // Do Cliente			³
//³ mv_par02		 // Ate o Cliente		³
//³ mv_par03		 // Da loja				³
//³ mv_par04		 // Ate a loja			³
//³ mv_par05		 // Da DaTa				³
//³ mv_par06		 // Ate Data			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR865"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,"",.T.)

If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
RptStatus({|lEnd| FA865Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	  ³ FA865Imp ³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o  ³ Imprime relat¢rio dos T¡tulos a Receber c/Retencao de INSS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e  ³ FA865Imp(lEnd,WnRel,cString)						       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd	  - A‡Æo do Codeblock						       ³±±
±±³			  ³ wnRel   - T¡tulo do relat¢rio						       ³±±
±±³			  ³ cString - Mensagem									       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		  ³ Generico											       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA865Imp(lEnd,WnRel,cString)

Local CbCont
Local CbTxt
Local cCGCAnt
Local cChaveSe2
Local lContinua	:= .T.
Local nTitCli	:= 0
Local nTitRel	:= 0
Local nVlCliOri	:= 0
Local nVlCliIns	:= 0
Local nVlCliLiq	:= 0
Local nVlTotOri	:= 0
Local nVlTotIns	:= 0
Local nVlTotPis	:= 0
Local nVlTotCof	:= 0
Local nVlTotCsl	:= 0
Local nVlTotIrf	:= 0
Local nVlCliIrf	:= 0
Local nVlTotIss	:= 0
Local nVlCliIss	:= 0
Local nVlTotRIr	:= 0
Local nVlCliRIr	:= 0
Local nVlCliPis	:= 0
Local nVlCliCof	:= 0
Local nVlCliCsl	:= 0
Local nVlTotLiq	:= 0
Local aCampos	:= {}
Local cCodFor	:= ""
Local cLojFor	:= ""
Local cNomFor	:= ""
Local aTamNum	:= TAMSX3("E2_NUM")
Local nOrdem	:= aReturn[8]
Local nValBase  := 0
Local nValLiq	:= 0
Local lFatura   := .F.
Local nMais     := 0
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ;
!Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
!Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) ) .And. ;
!Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) )

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ;
!Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
!Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
!Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local lCalcIssBx := !Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .and. ;
!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2"  //Retencao do ISS pela emissao (1) ou baixa (2)

Local cFilterUser := aReturn[7]
Local cFilADVPL   := ""
Local cFiltroSE2  := ""

aCampos	:= {	{"CODIGO"	,"C",06,0 },;
{"LOJA"	,"C",02,0 },;
{"NOMEFOR"	,"C",40,0 },;
{"CGC"		,"C",14,0 },;
{"PREFIXO"	,"C",03,0 },;
{"NUM"		,"C",aTamNum[1],0 },;
{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
{"TIPO"		,"C",03,0 },;
{"EMISSAO"	,"D",08,0 },;
{"VENCTO"	,"D",08,0 },;
{"DTCONT"	,"D",08,0 },;
{"VALBASE"  ,"N",17,2 },;
{"VALINSS"	,"N",17,2 },;
{"VALPIS"	,"N",17,2 },;
{"VALCOF"	,"N",17,2 },;
{"VALCSLL"	,"N",17,2 },;
{"VALIRRF"	,"N",17,2 },;
{"VALISS"	,"N",17,2 },;
{"VALLIQ"	,"N",17,2 },;
{"VRETPIS"	,"N",17,2 },;
{"VRETCOF"	,"N",17,2 },;
{"VRETCSL"	,"N",17,2 },;
{"VRETIRF"	,"N",17,2 },;
{"PRETPIS"	,"C",01,0 },;
{"PRETCOF"	,"C",01,0 },;
{"PRETCSL"	,"C",01,0 },;
{"PRETIRF"	,"C",01,0 },;
{"FATURA"	,"C",TamSx3("E2_FATURA")[1],0 } }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= ""
cbcont	:= 1
li 		:= 80
m_pag 	:= 1


dbSelectArea("SE2")

If nOrdem == 1  //Por Codigo
	dbSetOrder(6)
Else            //Por Nome
	dbSetOrder(2)
Endif

cChaveSe2 := IndexKey()

If !Empty(cFilterUser)
	//Transforma a expressão do filtro de ADVPL para Query SQL
	cFilADVPL := PcoParseFil(cFilterUser,"SE2")
EndIf

IF SELECT("TRB")>0              // OS 2757/13 - Fernando José     
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
ENDIF


If nOrdem == 1  //Por Codigo
	cOrder := "CODIGO,LOJA, NREC "    // OS 2757/13 - Fernando José
Else            //Por Nome
	cOrder := "NOMEFOR, NREC"         
Endif

cQuery := "SELECT A2_COD CODIGO,A2_LOJA LOJA,A2_NOME NOMEFOR,A2_CGC CGC,E2_PREFIXO PREFIXO,"
cQuery += "E2_NUM NUM,E2_PARCELA PARCELA,E2_TIPO TIPO,E2_EMISSAO EMISSAO,E2_VENCREA VENCTO,"
cQuery += "E2_IRRF VALIRRF,E2_ISS VALISS,E2_INSS VALINSS,E2_FATURA FATURA,"
cQuery += "E2_PIS VALPIS,E2_COFINS VALCOF,E2_CSLL VALCSLL,E2_EMIS1 DTCONT,"
//Se controla Retencao
If lContrRet
	cQuery += "E2_VRETPIS VRETPIS,E2_VRETCOF VRETCOF,E2_VRETCSL VRETCSL,E2_VRETIRF VRETIRF,"
	cQuery += "E2_PRETPIS PRETPIS,E2_PRETCOF PRETCOF,E2_PRETCSL PRETCSL,"
	cQuery += "'PRETIRF' = CASE WHEN E2_PARCIR =' ' AND E2_VRETIRF>0 THEN '1' "
	cQuery +=                 " WHEN E2_PARCIR<>' ' AND E2_VRETIRF<>E2_IRRF THEN '2' "
	cQuery += 			       "ELSE 'X' "
	cQuery += 			  "END,
	cQuery += "(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS) VALBASE,"
Else
	cQuery += "(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS+E2_PIS+E2_COFINS+E2_CSLL) VALBASE,"
Endif

IF lCalcIssBx
	cQuery += "E2_TRETISS TRETISS,"
Endif

cQuery += "SE2.R_E_C_N_O_ NREC,"
cQuery += "E2_VALOR VALLIQ"
cQuery += "FROM "+RetSqlName("SE2")+" SE2,"
cQuery +=         RetSqlName("SA2")+" SA2 "
cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
cQuery += " AND SA2.A2_FILIAL   = '" + xFilial("SA2") + "'"
cQuery += " AND SE2.D_E_L_E_T_  <> '*' "
cQuery += " AND SA2.D_E_L_E_T_  <> '*' "
cQuery += " AND SE2.E2_FORNECE  =  SA2.A2_COD"
cQuery += " AND SE2.E2_LOJA	  =  SA2.A2_LOJA"
cQuery += " AND SE2.E2_FORNECE  between '" + mv_par01 + "' AND '" + mv_par02 + "'"
cQuery += " AND SE2.E2_LOJA     between '" + mv_par03 + "' AND '" + mv_par04 + "'"
cQuery += " AND (SE2.E2_INSS > 0 "
cQuery += " OR SE2.E2_ISS > 0 "
cQuery += " OR SE2.E2_PIS > 0 "
cQuery += " OR SE2.E2_COFINS > 0 "
cQuery += " OR SE2.E2_CSLL > 0 "
cQuery += " OR SE2.E2_IRRF > 0
cQuery += " OR SE2.E2_VRETIRF > 0 ) "
cQuery += " AND SE2.E2_VENCREA  between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
cQuery += " AND SE2.E2_EMISSAO  between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
cQuery += " AND SE2.E2_EMISSAO  <= '"      + DTOS(dDataBase) + "'"
If !Empty(cFilADVPL)
	cQuery += " AND (" + cFilADVPL + ")"
Else
	//Coloco o filtro de usuário em outra variável, pois quando seleciona a tabela TRB
	//a variável cFilterUser é zerada.
	cFiltroSE2 := cFilterUser
EndIf
cQuery += " ORDER BY "+ cOrder
cQuery := ChangeQuery(cQuery)
MemoWrite("C:\XFINR865.sql",cQuery)
cFilterUser := ""
dbSelectArea("SE2")
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
SetRegua(TRB->(Reccount()))

While TRB->(!Eof())
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi(STR0012) //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF
	
	IncRegua()
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso a funçao PcoParseFil() retorne vazio, posiciono na      ³
	//³ tabela SE2 para fazer o filtro do usuário.				     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cFilADVPL)	.And. !Empty(cFiltroSE2)
		dbSelectArea("SE2")
		dbSetOrder(1)
		MsSeek(xFilial("SE2")+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA)
		If !SE2->(&cFiltroSE2)
			TRB->(dbSkip())
			Loop
		Endif
	EndIf
	
	nTitCli		:= 0
	nVlCliOri	:= 0
	nVlCliIns	:= 0
	nVlCliLiq	:= 0
	nVlCliPis	:= 0
	nVlCliCof	:= 0
	nVlCliCsl	:= 0
	nVlCliRIr	:= 0
	nVlCliIrf	:= 0
	nVlCliIss	:= 0
	nValBase		:= 0
	
	@li,  0 PSAY TRB->CODIGO+"-"+TRB->LOJA
	@li, 15 PSAY Substr(TRB->NOMEFOR,1,30)
	@li, 46 PSAY TRB->CGC Picture IIF(Len(Alltrim(TRB->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99")
	li++
	
	cCodFor		:= TRB->CODIGO
	cLojFor		:= TRB->LOJA
	cNomFor		:= TRB->NOMEFOR
	cCGCAnt		:= TRB->CGC
	
	li++
	While TRB->(!EOF()) .And. cCodFor+cLojFor == TRB->(CODIGO+LOJA) .And. cNomFor == TRB->NOMEFOR
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		
		lFatura := .F.
		
		If !Empty(TRB->FATURA) .And. TRB->FATURA == 'NOTFAT'
			lFatura := .T.
		EndIf
		
		@li, 003 PSAY TRB->PREFIXO
		@li, 007 PSAY TRB->NUM
		
		@li, 015 PSAY TRB->PARCELA
		@li, 019 PSAY TRB->TIPO
		
		@li, 025 PSAY STOD(TRB->EMISSAO)
		@li, 036 PSAY STOD(TRB->VENCTO)
		@li, 047 PSAY STOD(TRB->DTCONT)

		nValLiq := If (!lPccBaixa .or. !lContrRet, TRB->VALLIQ, TRB->(VALLIQ-VALPIS-VALCOF-VALCSLL) )
		
		If	lContrRet
			//Titulo que aglutinou os impostos
			If !lPccBaixa .and. ( Empty(TRB->PRETPIS) .or. Empty(TRB->PRETCOF) .or. Empty(TRB->PRETCSL))
				nValBase := TRB->(VALBASE+VRETPIS+VRETCOF+VRETCSL)
			Else
				nValBase := TRB->VALBASE
			Endif
			//Caso o calculo do ISS seja efetuado na baixa do titulo, nao somo o imposto para compor o
			//valor base
			If lCalcIssBx .and. TRB->TRETISS == "2"
				nValBase	-= TRB->VALISS
				nValLiq	-= TRB->VALISS
			Endif
			@li, 058 PSAY nValBase Picture tm (TRB->VALBASE ,16)
		Else
			//Caso o calculo do ISS seja efetuado na baixa do titulo, nao somo o imposto para compor o
			//valor base
			If lCalcIssBx .and. TRB->TRETISS == "2"
				nValBase	:= TRB->VALBASE - TRB->VALISS
				nValLiq	:= TRB->VALLIQ - TRB->VALISS
			Endif
			@li, 058 PSAY nValBase Picture tm (TRB->VALBASE ,14)
		Endif

		@li, 076 PSAY TRB->VRETIRF		Picture tm (TRB->VRETIRF ,13)
		@li, 091 PSAY TRB->VALIRRF		Picture tm (TRB->VALIRRF ,13)
		@li, 106 PSAY TRB->VALISS		Picture tm (TRB->VALISS  ,13)
		@li, 123 PSAY TRB->VALINSS  	Picture tm (TRB->VALINSS ,13)
		@li, 139 PSAY TRB->VALPIS		Picture tm (TRB->VALPIS  ,13)
		@li, 155 PSAY TRB->VALCOF		Picture tm (TRB->VALCOF  ,13)
		@li, 171 PSAY TRB->VALCSLL		Picture tm (TRB->VALCSLL ,13)
		@li, 187 PSAY nValLiq			Picture tm (TRB->VALLIQ  ,13)
		
		nMais:=0
		If lContrRet // Verifica se o sistema esta fazendo controle de retencao de impostos
			If lPccBaixa	// Geracao dos impostos lei 10925 pela baixa
				If TRB->(VALPIS+VALCOF+VALCSLL) > 0
					If TRB->TIPO $ MVPAGANT
						If TRB->PRETPIS == "1" .or. TRB->PRETCOF == "1" .or. TRB->PRETCSL == "1"
							If TRB->(VRETPIS+VRETCOF+VRETCSL) == 0
								@li, 202 PSAY "A"
							Endif
						Endif
					Else
						If TRB->PRETPIS == "3" .or. TRB->PRETCOF == "3" .or. TRB->PRETCSL == "3"
							If TRB->(VRETPIS+VRETCOF+VRETCSL) == 0
								@li, 202 PSAY "A"
							Endif
						ElseIf TRB->PRETPIS == "1" .or. TRB->PRETCOF == "1" .or. TRB->PRETCSL == "1"
							@li, 202 PSAY "B"
						Endif
					Endif
				Endif
			Else
				If TRB->PRETPIS == "2" .or. TRB->PRETCOF == "2" .or. TRB->PRETCSL == "2"
					@li, 202 PSAY "A"
					nMais++
				ElseIf TRB->PRETPIS == "1" .or. TRB->PRETCOF == "1" .or. TRB->PRETCSL == "1"
					@li, 202 PSAY "B"
					nMais++
				Endif
				If  TRB->PRETIRF == "1"
					@li, PCol() PSAY Iif(nMais>0,"/","")+"D"
					nMais++
				ElseIf TRB->PRETIRF == "2"
					@li, PCol() PSAY Iif(nMais>0,"/","")+"E"
					nMais++
				EndIf
			Endif
		Endif
		
		If lFatura
			@li, PCol() PSAY Iif(nMais>0,"/","")+"C"
		EndIf
		
		li++
		nTitCli++
		If !lFatura
			nVlCliOri += nValBase
		EndIf
		
		nVlCliLiq += nValLiq
		nVlCliIns += TRB->VALINSS
		nVlCliIrf += TRB->VALIRRF
		nVlCliIss += TRB->VALISS
		
		If lContrRet // Verifica se o sistema esta fazendo controle de retencao de impostos
			If TRB->PRETPIS <> "2" .Or. TRB->PRETCOF <> "2" .Or. TRB->PRETCSL <> "2"
				nVlCliPis += TRB->VALPIS
				nVlCliCof += TRB->VALCOF
				nVlCliCsl += TRB->VALCSLL
				nVlCliRIr += TRB->VRETIRF
			EndIf
		EndIf
		
		TRB->(dbSkip())
	Enddo
	li++
	IF nVlCliOri > 0
		SubTot865(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomFor,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliRIr,nVlCliIrf,nVlCliIss)
	Endif
	
	nTitRel	  += nTitCli
	nVlTotOri += nVlCliOri
	nVlTotLiq += nVlCliLiq
	nVlTotIns += nVlCliIns
	nVlTotPis += nVlCliPis
	nVlTotCof += nVlCliCof
	nVlTotCsl += nVlCliCsl
	nVlTotIrf += nVlCliIrf
	nVlTotIss += nVlCliIss
	nVlTotRIr += nVlCliRIr
Enddo


IF li != 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	TotGeR865(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotRIr)
	
	If lContrRet
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		@li, 001 PSAY STR0017 // A = Os valores de Pis,Cofins e Csll deste titulo foram retidos em outro titulo.
		@li++
		@li, 001 PSAY STR0018 // B = Os valores de Pis,Cofins e Csll deste titulo se referem a uma previsao, ainda nao foram retidos.
		@li++
		@li, 001 PSAY STR0019  // C = Os registros referentes a fatura não são incluidos nos totalizadores.
		@li++
		@li, 001 PSAY "D = Os valores de IRRF deste titulo foram retidos em outro titulo."
		@li++
		@li, 001 PSAY "E = Os valores de IRRF deste titulo contemplam a retenção de outros títulos."
	Endif
	
	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

dbSelectArea("SE2")
dbCloseArea()
ChKFile("SE2")
dbSelectArea("SE2")
dbSetOrder(1)
TRB->(dbCloseArea())

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot865 ³ Autor ³ Nilton Pereira        ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprimir SubTotal do Relatorio							           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot865()												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico													              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function SubTot865(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomFor,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliRIr,nVlCliIrf,nVlCliIss)

@li,000 PSAY Replicate("-",220)
li+=1
@li,000 PSAY STR0013 + Substr(cNomFor,1,09) //"Total Fornecedor  - "

@li,030 PSAY " ("+ALLTRIM(STR(nTitCli))+" "+IiF(nTitCli > 1,STR0014,STR0015)+")" //"TITULOS"###"TITULO"

@li,058 PSAY nVlCliOri		Picture TM(nVlCliOri,14)
@li,076 PSAY nVlCliRIr		Picture TM(nVlCliRIr,13)
@li,091 PSAY nVlCliIrf		Picture TM(nVlCliIrf,13)
@li,106 PSAY nVlCliIss		Picture TM(nVlCliIss,13)
@li,123 PSAY nVlCliIns		Picture TM(nVlCliIns,13)
@li,139 PSAY nVlCliPis		Picture TM(nVlCliLiq,13)
@li,155 PSAY nVlCliCof		Picture TM(nVlCliLiq,13)
@li,171 PSAY nVlCliCsl		Picture TM(nVlCliLiq,13)
@li,187 PSAY nVlCliLiq		Picture TM(nVlCliLiq,13)

li++
@li,000 PSAY Replicate("-",220)
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TotGeR865³ Autor ³ Nilton Pereira		³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ TotGeR865()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TotGeR865(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotRIr)

@li,000 PSAY Replicate("_",220)
li+= 2
@li,000 PSAY STR0016  //"TOTAL GERAL      ----> "
@li,030 PSAY "("+ALLTRIM(STR(nTitRel))+" "+IIF(nTitRel > 1,STR0014,STR0015)+")"	 //"TITULOS"###"TITULO"
@li,058 PSAY nVlTotOri	   	Picture TM(nVlTotOri,14)
@li,076 PSAY nVlTotRIr		Picture TM(nVlTotRIr,13)
@li,091 PSAY nVlTotIrf		Picture TM(nVlTotIrf,13)
@li,106 PSAY nVlTotIss		Picture TM(nVlTotIss,13)
@li,123 PSAY nVlTotIns	   	Picture TM(nVlTotIns,13)
@li,139 PSAY nVlTotPis		Picture TM(nVlTotPis,13)
@li,155 PSAY nVlTotCof		Picture TM(nVlTotCof,13)
@li,171 PSAY nVlTotCsl		Picture TM(nVlTotCsl,13)
@li,187 PSAY nVlTotLiq	   	Picture TM(nVlTotLiq,13)
li++
@li,000 PSAY Replicate("_",220)
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR865IndR ³ Autor ³ Nilton Pereira		³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01		 // Data de?   	     ³
//³ mv_par02		 // Data ate?          ³
//³ mv_par03		 // Organiza por?      ³
//³ mv_par04		 // Enviados?          ³
//³ mv_par05		 // De Emissao?	     ³
//³ mv_par06		 // Ate Emissao?       ³
//³ mv_par07		 // De Vencto?		     ³
//³ mv_par08		 // Ate Vencto?        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX1")
If MsSeek("FIN86508") // Se encontrar a pergunta 08, não faz nada, pois ja foi criada
	Return
Endif

aPergs := {}
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Selecione o código inicial do intervalo ")
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpPor,"Tecla [F3] disponível para consultar o " )
AADD(aHelpPor,"Cadastro de Fornecedores. "              )
AADD(aHelpSpa,"Selecione o código inicial do intervalo ")
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Tecla [F3] disponível para consultar o " )
AADD(aHelpSpa,"Cadastro de Fornecedores. "              )
AADD(aHelpEng,"Selecione o código inicial do intervalo ")
AADD(aHelpEng,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Tecla [F3] disponível para consultar o " )
AADD(aHelpEng,"Cadastro de Fornecedores. "              )
Aadd(aPergs  ,{ "Do Fornecedor ?","Do Fornecedor ?","Do Fornecedor ?","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","S","001","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Selecione o código final do intervalo "  )
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpPor,"Tecla [F3] disponível para consultar o " )
AADD(aHelpPor,"Cadastro de Fornecedores. "              )
AADD(aHelpSpa,"Selecione o código final do intervalo "  )
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Tecla [F3] disponível para consultar o " )
AADD(aHelpSpa,"Cadastro de Fornecedores. "              )
AADD(aHelpEng,"Selecione o código final do intervalo "  )
AADD(aHelpEng,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Tecla [F3] disponível para consultar o " )
AADD(aHelpEng,"Cadastro de Fornecedores. "              )
Aadd(aPergs,{ "Ate o Fornecedor ?","Ate o Fornecedor ?","Ate o Fornecedor ?","mv_ch2","C",6,0,0,"G","","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA2","S","001","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a loja inicial do intervalo "    )
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Informe a loja inicial do intervalo "    )
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Informe a loja inicial do intervalo "    )
AADD(aHelpEng,"considerados na geração do relatório. "  )
Aadd(aPergs,{ "Da Loja ?","¿De Tienda ?","From Unit ?","mv_ch3","C",2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","S","002","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a loja final do intervalo "    )
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Informe a loja final do intervalo "    )
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Informe a loja final do intervalo "    )
AADD(aHelpEng,"considerados na geração do relatório. "  )
Aadd(aPergs,{ "Ate a Loja ?","¿A Tienda ?","To Unit ?","mv_ch4","C",2,0,0,"G","","mv_par04","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","S","002","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a data inicial do intervalo de " )
AADD(aHelpPor,"datas de emissão dos títulos a receber " )
AADD(aHelpPor,"a Tecla [F3] disponível para consultar." )
AADD(aHelpSpa,"Informe a data inicial do intervalo de " )
AADD(aHelpSpa,"datas de emissão dos títulos a receber " )
AADD(aHelpSpa,"a Tecla [F3] disponível para consultar." )
AADD(aHelpEng,"Informe a data inicial do intervalo de " )
AADD(aHelpEng,"datas de emissão dos títulos a receber " )
AADD(aHelpEng,"a Tecla [F3] disponível para consultar." )
Aadd(aPergs,{ "Da Emissao ?","¿De Emision ?","From Issue Date ?","mv_ch5","D",8,0,0,"G","","mv_par05","","","","'01/01/02'","","","","","","","","","","","","","","","","","","","","","","S","","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a data final do intervalo de "   )
AADD(aHelpPor,"datas de emissão dos títulos a receber " )
AADD(aHelpPor,"a Tecla [F3] disponível para consultar." )
AADD(aHelpSpa,"Informe a data final do intervalo de "   )
AADD(aHelpSpa,"datas de emissão dos títulos a receber " )
AADD(aHelpSpa,"a Tecla [F3] disponível para consultar." )
AADD(aHelpEng,"Informe a data final do intervalo de "   )
AADD(aHelpEng,"datas de emissão dos títulos a receber " )
AADD(aHelpEng,"a Tecla [F3] disponível para consultar." )
Aadd(aPergs,{ "Ate a Emissao ?","¿A  Emision ?","To Issue Date ?","mv_ch6","D",8,0,0,"G","","mv_par06","","","","'31/12/04'","","","","","","","","","","","","","","","","","","","","","","S","","",aHelpPor,aHelpEng,aHelpSpa})

Aadd(aPergs,{ "Do Vencimento ?","¿De Vencto. ?","From Due Date ?","mv_ch7","D",8,0,0,"G","","mv_par07","","","","'01/01/02'","","","","","","","","","","","","","","","","","","","","","","S","",".FIN15007."})
Aadd(aPergs,{ "Ate Vencimento?","¿A  Vencto. ?","To Due Date   ?","mv_ch8","D",8,0,0,"G","","mv_par08","","","","'31/12/04'","","","","","","","","","","","","","","","","","","","","","","S","",".FIN15008."})

AjustaSx1("FIN865", aPergs)

Return
