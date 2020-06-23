#INCLUDE 'Protheus.ch'
#INCLUDE 'Ap5Mail.ch'
#INCLUDE "AVPRINT.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'APWEBEX.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*

{Protheus.doc} ESTR130

IMPRESSAO DO BOLETO BANCARIO COM CODIGO DE BARRAS

@author  Everton
@project F_MENSALISTAS_EF_001
@since   18/09/12
@obs PL

*/


User Function ESTR130()
Local nOpca  	:= 00
Local oDlg   	:= NIL

Private _cPathJpeg := "\BOLETOS\"
Private cPerg  	  := "ESTR130"

CriaSx1(cPerg)

Pergunte( cPerg, .F. )

DEFINE MsDialog oDlg From  96, 4 TO 355, 625 Title OemToAnsi( "Emissão Boletos" ) Pixel
@ 18, 09 TO 99,300 Label "" Of oDlg Pixel
@ 29, 15 Say OemToAnsi( "O objetivo deste programa é emitir os boletos das cobrancas selecionadas , conforme o " ) Size 275, 10 Of oDlg Pixel
@ 38, 15 Say OemToAnsi( "preenchimento dos parametros. Somente as cobrancas que ainda não foram baixadas e nem" ) Size 275, 10 Of oDlg Pixel
@ 47, 15 Say OemToAnsi( "canceladas serão consideradas." ) Size 275, 10 Of oDlg Pixel

DEFINE SButton From 108, 209 Type 05 Action Pergunte( cPerg, .T. ) Enable Of oDlg
DEFINE SButton From 108, 238 Type 1 Action (ESTVLD(), oDlg:End() ) Enable Of oDlg
DEFINE SButton From 108, 267 Type 2 Action oDlg:End() Enable Of oDlg

Activate MsDialog oDlg Center

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ListPDD   ºAutor  ³ Everton Balbino  º Data ³  19/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta ListBox com as cobrancas filtradas conforme o        º±±
±±º          ³ preenchimento dos parametros.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estapar                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ListPDD()
Local cVar         := Nil
Local oDlg         := Nil
Local oChk1        := NIL
Local oOk          := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo          := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local cTitulo      := "Selecionar Cobrancas"
Local nOpca        := 0
Local lMark        := .F.
Local cQuery       := ""
Local nQtdReg      := 0
Local cMail        := ""
Local cUniEst 	    := ''
Local cCliMBol		:= ""
Local cLojMBol		:= ""
Local cCliUBol		:= ""
Local cLojUBol		:= ""

Private aVetor     := {}
Private oLbx       := Nil
Private lChk1      := .F.

// Carrega o Vetor com as filiais
cQuery := " SELECT MAX(PDD.PDD_CODGAR) AS GARAGEM,MAX(PDD.PDD_CODEMP) AS CODEMP, MAX(PDD.PDD_CODFIL) AS CODFIL, MAX(PDD.PDD_MESANO) AS MESANO, MAX(PDD.PDD_NUM) AS NUM,"
cQuery += 			"(SELECT DISTINCT PSB.PSB_CLIENT FROM " +RetSQLName( "PSB" )+" PSB WHERE PSB.PSB_CODVAG = MAX(PDD.PDD_CODVAG) AND PSB.PSB_CGARAG=PDD.PDD_CODGAR AND D_E_L_E_T_<>'*') CLIMEN, "
cQuery +=			"(SELECT DISTINCT PSB.PSB_LOJA FROM " +RetSQLName( "PSB" )+" PSB WHERE PSB.PSB_CODVAG = MAX(PDD.PDD_CODVAG)   AND PSB.PSB_CGARAG=PDD.PDD_CODGAR AND D_E_L_E_T_<>'*') LOJMEN, "
cQuery += 			"(SELECT DISTINCT MAX(PSY_PLACA) PLACA1 FROM " +RetSQLName( "PSB" )+" PSB, " + RetSQLName( "PSY" ) + " PSY WHERE "
cQuery +=			"PSB.PSB_FILIAL = '"+FWxFilial("PSB")+"' AND PSB.D_E_L_E_T_= ' ' AND PSB.PSB_CODVAG = MAX(PDD.PDD_CODVAG) AND "
cQuery +=			"PSY.D_E_L_E_T_ = ' ' AND PSY_FILIAL = '"+FWxFilial("PSY")+"' "
cQuery += 			"AND PSB.PSB_CODVAG = PSY_ESTARP) PLACA1,   "

cQuery += 			"(SELECT DISTINCT MIN(PSY_PLACA) PLACA2 FROM "+RetSQLName( "PSB" )+" PSB, " + RetSQLName( "PSY" ) + " PSY WHERE "
cQuery +=			"PSB.PSB_FILIAL = '"+FWxFilial("PSB")+"' AND PSB.D_E_L_E_T_= ' ' AND PSB.PSB_CODVAG = MAX(PDD.PDD_CODVAG) AND "
cQuery +=			"PSY.D_E_L_E_T_ = ' '  AND PSY_FILIAL = '"+FWxFilial("PSY")+"' "
cQuery += 			"AND PSB.PSB_CODVAG = PSY_ESTARP) PLACA2,  "

cQuery += 			"MAX(PDD.PDD_NUMCOB) AS NUMCOB, MAX(PDD.PDD_EMISSA) AS EMISSAO, "
cQuery += 			"MAX(PDD.PDD_CLIENT) AS CODCLI, MAX(PDD.PDD_LOJA) AS LOJA,  "
cQuery +=			"MAX(PDD.PDD_CODUNI) AS CLIUNI, MAX(PDD.PDD_LOJUNI) AS LOJUNI, "
cQuery +=    		"MAX(PDD.PDD_VENC1) AS VENC1, SUM(PDD.PDD_VLTOT1) AS VALOR1, "
cQuery +=    		"SUM(PDD.PDD_TAXAS) AS TAXAS, MAX(PDD.PDD_VENC2) AS VENC2, "
cQuery += 			"SUM(PDD.PDD_VLTOT2) AS VALOR2, MAX(PDD.PDD_BANCO)  AS BANCO, "
cQuery +=    		"MAX(PDD.PDD_AGENC) AS AGENCIA, MAX(PDD.PDD_CONTA) AS CONTA, "
cQuery +=    		"MAX(PDD.PDD_SUBCTA) AS SUBCTA , MAX(PDD.PDD_TXREMI) AS TXREMI, "
cQuery +=			"MAX(PDD.PDD_DESCPO) AS DESCPO, MAX(PDD.PDD_PREFIX) AS PREFIX, "
cQuery +=    		"MAX(PDD.PDD_PARCEL) AS PARCELA, MAX(PDD.PDD_TIPO) AS TIPO, "
cQuery +=    		"MAX(PDD.PDD_TABELA) AS TABELA, COUNT(PDD.PDD_QTDVAG) AS QTDVAG, "
cQuery +=			"MAX(PDD_CODVAG) AS CODVAG "

cQuery += " FROM "+ RetSQLName( "PDD" ) + " AS PDD "

cQuery += " WHERE PDD.PDD_FILIAL = '" + FWXFILIAL("PDD") + "'"
cQuery += " AND PDD.D_E_L_E_T_ = ' ' "
//cQuery += " AND PDD.PDD_CODEMP = '" + cEmpAnt + "'"

If !Empty(MV_PAR01)
	cQuery += " AND PDD.PDD_CODGAR = '" + MV_PAR01 + "' "
Endif

If !Empty(MV_PAR02)
	cQuery += " AND PDD.PDD_MESANO = '" + Strzero(MV_PAR02,2) + Strzero(MV_PAR03,4)+"' "
Endif

//If !Empty(MV_PAR04)
cQuery +=    " AND PDD.PDD_NUMCOB >= '" + MV_PAR04 + "' AND PDD.PDD_NUMCOB <= '" + MV_PAR05 + "' "
//Endif

If !Empty(MV_PAR08)
	cQuery +=    " AND PDD.PDD_BANCO = '" + MV_PAR08 + "' AND PDD.PDD_AGENC = '" + MV_PAR09 + "' "
	cQuery +=    " AND PDD.PDD_CONTA = '" + MV_PAR10 + "' AND PDD.PDD_SUBCTA = '" + MV_PAR11 + "' "
Endif

cQuery +=    " AND PDD.PDD_DTBAIX = '' AND PDD.PDD_CANCEL <> '1' "
cQuery +=    " AND PDD.PDD_NUM <> '' "
//cQuery +=    " AND PDD.PDD_TIPOPS = '1' "
if MV_PAR06 == 2
	cQuery +=    " AND PDD.PDD_STATUS IN ('2',' ') "
Else
	cQuery +=    " AND PDD.PDD_STATUS IN ('1','3','4') "
Endif

cQuery += " GROUP BY PDD_CODGAR, PDD_CODEMP, PDD_NUMCOB "
cQuery += " ORDER BY PDD_CODEMP, PDD_NUMCOB "
Memowrit(CurDir()+"Query\Estm334.sql",cQuery)

cQuery := ChangeQuery(cQuery)

If Select("BOLPDD") > 0
	BOLPDD->(DbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"BOLPDD",.F.,.T.)

TCSetField( "BOLPDD", "EMISSAO" , "D",  8, 0 )
TCSetField( "BOLPDD", "VENC1"   , "D",  8, 0 )
TCSetField( "BOLPDD", "VENC2"   , "D",  8, 0 )
TCSetField( "BOLPDD", "VALOR1"  , "N", 17, 2 )
TCSetField( "BOLPDD", "VALOR2"  , "N", 17, 2 )
TCSetField( "BOLPDD", "TXREMI"  , "N", 14, 2 )
TCSetField( "BOLPDD", "DESCPO"  , "N", 14, 2 )
TCSetField( "BOLPDD", "QTDVAG"  , "N",  4, 0 )

BOLPDD->( dbEval( { || nQtdReg++ },, { || !EOF() } ) )
BOLPDD->( dbGoTop() )

If nQtdReg == 0
	MsgInfo("Nao existe nenhuma cobranca a ser considerada para geração do boleto!!!")
	Return
Endif

While BOLPDD->(!EOF())
	
	cMail 	:= ""
	cUniEst := ''
	lVagPSC:=.F.
	nQtdPSC:=0
	
	If Empty(BOLPDD->CLIUNI)//nao eh unificado
		lVagPSC:=.F.
		nQtdPSC:=0
		PSB->(dbSetOrder(2))//PSB_FILIAL+PSB_CGARAG+PSB_CLIENT+PSB_LOJA+PSB_CODVAG
		If PSB->(MsSeek(FWXFILIAL("PSB")+BOLPDD->GARAGEM+BOLPDD->CLIMEN+BOLPDD->LOJMEN+BOLPDD->CODVAG))
			cCliMBol:= PSB->PSB_CLIENT
			cLojMBol:= PSB->PSB_LOJA
			If PSB->PSB_ENVMAI == "1" //Envia e-mail
				SA1->(MsSeek(FWXFILIAL("SA1")+BOLPDD->CLIMEN+BOLPDD->LOJMEN))
				cMail := SA1->A1_EMAIL
				cUniEst := ''
			Endif
			
		Endif
	Else//eh unificado
		lVagPSC:=.F.
		nQtdPSC:=0
		PSC->(dbSetOrder(1))
		If PSC->(MsSeek(FWXFILIAL("PSC")+BOLPDD->CODEMP+BOLPDD->CLIUNI))
			cCliUBol:= PSC->PSC_CLIENT
			cLojUBol:= PSC->PSC_LOJCLI
			cUniEst := PSC->PSC_UNIEST
			If PSC->PSC_ENVIO == "1" //Envia e-mail
				SA1->(MsSeek(FWXFILIAL("SA1") + PSC->PSC_CLIENT + PSC->PSC_LOJCLI))
				cMail   := SA1->A1_EMAIL
			Endif
			If PSC->PSC_MULVAG="1" .and. PSC->PSC_QTDACE>0
				lVagPSC:=.T.
				nQtdPSC:=PSC->PSC_QTDACE
			Else
				lVagPSC:=.F.
				nQtdPSC:=0
			EndIf
		EndIf
		
	EndIf
	
	If Empty(cCliMBol) .AND. !Empty(BOLPDD->CLIUNI)
		cCliMBol := BOLPDD->CLIUNI
		cLojMBol := BOLPDD->LOJMEN
	EndIf
	
	If mv_par12 == 2 .And. Empty(cMail)  // Enviar boleto por E-mail
		BOLPDD->(dbSkip())
		Loop
	Endif
	//    1        2             	3                 	4                5
	AADD(aVetor,{lMark, BOLPDD->CODEMP	,  BOLPDD->CODFIL	, BOLPDD->MESANO	, BOLPDD->NUM,;   // 01-02-03-04-05
	BOLPDD->EMISSAO	,  cCliMBol			, cLojMBol			, cCliUBol		,;   //    06-07-08-09
	cLojUBol		,  BOLPDD->VENC1	, BOLPDD->VALOR1	, BOLPDD->VENC2,;    //    10-11-12-13
	BOLPDD->VALOR2	,  BOLPDD->BANCO	, BOLPDD->AGENCIA	, BOLPDD->CONTA,;    //    14-15-16-17
	BOLPDD->SUBCTA	,  BOLPDD->TXREMI	, BOLPDD->DESCPO	, BOLPDD->CODFIL,;   //    18-19-20-21
	BOLPDD->PREFIX	,  BOLPDD->PARCELA	, BOLPDD->TIPO		, cMail			,;   //    22-23-24-25
	BOLPDD->TABELA	,  iIf(lVagPSC,nQtdPSC,BOLPDD->QTDVAG)	, BOLPDD->CODVAG, cUniEst,BOLPDD->TAXAS      ,;    //  26-27-28-29-30
	BOLPDD->PLACA1, BOLPDD->PLACA2, lVagPSC,BOLPDD->GARAGEM,BOLPDD->NUMCOB})   // 31-32-33-34

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Leandro Kenji - 17/03/13                                          ³
	//³Correcao: Limpeza dos campos especifico de unificado antes do skip³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCliUBol:= ""
	cLojUBol:= ""
	cUniEst := ""

	BOLPDD->(dbSkip())
	
End
/*
If Empty(aVetor)
AADD(aVetor,{lMark, "000001"	,  "01",	"102011",	 "000000001",;   // 01-02-03-04-05
"10/10/11",		"000001",	 	"01"	,	 "",;   //    06-07-08-09
"",	  	"",	 	1238.00,	 "10/10/11",;    //    10-11-12-13
0.00,  	"048"	, 		"0000038",  "",;    //    14-15-16-17
"",  	"", 		"", 	 "",;   //    18-19-20-21
"BOL",  	"", 	"", 	 "" ,;   //    22-23-24-25
"",  .F., 	 "000001" ,;    //  26-27-28-29-30admin
cUniEst,	"",	"",	"",	.F.})   // 31-32-33

EndIf
*/
If Len(aVetor)>0
	Processa( { |lEnd| GeraBol() }, "Aguarde...", "Executando rotina.", .T. )
Else
	ApMsgInfo( 'Nao Há Boletos Selecionados Verifique parametros' )
Endif

Return NIL

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GeraBol  ³ Autor ³ Everton Balbino     ³ Data ³ 19/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DE BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estapar                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GeraBol()//Desta forma posso chamar direto da nota por exemplo, passando os parametros
Local aAreaSM0
Local aAreaPDD
Local nA
Local oPrint
Local cNroDoc 	  :=  " "
Local aDadoEmp     := {}
Local aDadosTit
Local aDadosBanco
Local aDatSacado
Local aBolText     := {}

Local aCB_RN_NN    := {}
Local aDadosPDD    := {}
Local cEmp         := Space(03)
Local cFil         := Space(04)
Local nTxRemi      := 0
Local nQtdVagas    := 0
Local cIdCnab      := ""

Local cCB_TOP      := ""
Local cDigCB_TOP   := ""
Local cLinha1      := ""
Local cLinha2      := ""
Local cLinha3      := ""
Local cLinha4      := ""
Local cLinha5      := ""
Local cLinha6      := ""
Local cLinha7      := ""

Local nPosEmail		:= 25
Local nCount		:= 0
Local lImprime		:= .F.

Private cCodCli    := ""
Private cLoja      := ""
Private cBanco     := ""
Private cAgencia   := ""
Private cConta     := ""
Private cSubCt     := ""
Private nDesconto  := 0
Private aCabec     := {}

Private nQtdPag := 0
Private aPgto   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Leandro Kenji                                             	 ³
//³Correcao: Somente imprime caso tenha boleto sem ser por email ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCount := 1 to Len(aVetor)

	If (Empty(aVetor[nCount][nPosEmail])) .AND. (MV_PAR12 == 1) 
		lImprime := .T.
		Exit
	EndIf 

Next nCount 

If lImprime
		
	oPrint:= TMSPrinter():New( "Boleto Laser" )
	If MV_PAR12 == 1
		If !oPrint:Setup() // ou SetLandscape()
			If Select("QRY2") > 0
				QRY2->(dbCloseArea())
			Endif                                                             '
			aVetor := {}
			Return
		Endif
	EndIf
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:StartPage()   // Inicia uma nova página

EndIf
	
ProcRegua(Len(aVetor))

For nA:=1 To Len(aVetor)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Leandro Kenji                                              ³
	//³Correcao: Caso o boleto seja enviado por email, nao imprime³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( aVetor[nA][nPosEmail] ) .AND. (MV_PAR12 == 1)
		Loop	
	EndIf
		
	nQtdPag++
	
	cEmp       := aVetor[nA][2]
	cFil       := aVetor[nA][3]
	
	_cNomeArq  := "BOL_"+cEmp+cFil+aVetor[nA][4]+aVetor[nA][5]

	aAreaSM0   := SM0->(GetArea())
	SM0->(dbSeek(cEmpAnt + cEmp + cFil))
	
	aDadosEmp  := {	SM0->M0_NOMECOM																,;	//	[1]	Nome da Empresa
	SM0->M0_ENDCOB																,;	//	[2]	Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB	,;	//	[3]	Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)				,;	//	[4]	CEP
	"PABX/FAX: "+SM0->M0_TEL															,;	//	[5]	Telefones
	"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+				 ;	//	[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+						 	 ;	//	[6]
	Subs(SM0->M0_CGC,13,2)															,;	//	[6]	CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+		 	 ;	//	[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)							,;	//	[7]	Endereço
	aVetor[na,21] + " - " + Alltrim(SM0->M0_FILIAL)  }                           //  [8] Filial
	
	RestArea(aAreaSM0)
	
	cBanco     := aVetor[nA][15]
	cAgencia   := aVetor[nA][16]
	cConta     := aVetor[nA][17]
	cSubct     := aVetor[nA][18]
	
	// Avalia o Numero de Vagas por mensalista/unificado
	nQtdVagas  := 0
	aAreaPDD   := PDD->(GetArea())
	PDD->(dbGotop())
	PDD->( dbEval( { || nQtdVagas ++ },, { || PDD_FILIAL + PDD_CODEMP + PDD_CODFIL + PDD_MESANO + PDD_NUMCOB == FWXFILIAL( "PDD" ) +aVetor[nA][2]+aVetor[nA][3]+aVetor[nA][4]+aVetor[nA][5] } ) )
	RestArea(aAreaPDD)
	
	aDadosPDD  := {aVetor[nA][2]								,;	//	[1]	Empresa
	aVetor[nA][3]									,;	//	[2]	Filial
	aVetor[nA][4]  								,;	//	[3]	Mes/Ano
	iIf(Empty(aVetor[nA][9]),aVetor[nA][7]+ " - " + aVetor[nA][8],aVetor[nA][9]+ " - " + aVetor[nA][10]) ,;
	AllTrim(Str(nQtdVagas))						,;	//	[5]	Qtd Vagas
	aVetor[nA][11]								,;	//	[6] Venc1
	aVetor[nA][13]								,;	//	[7] Venc1
	aVetor[nA][20]  								,;  //	[8]	Desconto Porto
	aVetor[nA][21]			                 ,;	//  [9] FILEST
	aVetor[nA][26]			                 ,;	//  [10] Tabela
	aVetor[nA][27]			                 ,;	//  [11] Qtde
	Iif( empty(aVetor[nA][9]), aVetor[nA][28] , aVetor[nA][9]) ,;  // [12] Codigo Vaga -Duvida sobre este campo a vaga esta na posicao 13
	aVetor[nA][28] 								,; // [13] Codigo Vaga
	aVetor[nA][31]							   ,; // [14] PLACA1
	aVetor[nA][32] 							   ,; // [15] PLACA2
	aVetor[nA][33] 							   ,; // [16] lVagPSC- Imprime Multivagas?
	aVetor[nA][26]							   ,; //[17]Modalidade
	aVetor[nA][34]								; //[18]Garagem
	}
	
	
	nDesconto  := aVetor[nA][14] - aVetor[nA][12]
	
	// Procura o banco
	PBS->(dbSetOrder(1)) //PBS_FILIAL,PBS_COD,PBS_AGENC PBS_CONT
	PBS->(dbSeek(FWXFILIAL("PBS")+MV_PAR08+MV_PAR09+MV_PAR10))
	
	//  cLinha1 := Posicione("SM4",1,FWXFILIAL("SM4")+PBS->PBS_CODFOR,"M4_FORMULA")
	//  ativa formula real do microsiga
	//cLinha1 := IIf(Empty(PBS->PBS_CODFOR),'',Iif(ValType(Formula(PBS->PBS_CODFOR))=="N",Str(Formula(PBS->PBS_CODFOR),100),Formula(PBS->PBS_CODFOR)))
	cLinha1 := ""
	cNroBco := MV_PAR08+"-"+U_Modulo11CNR(MV_PAR08,MV_PAR08)
	
	If Empty(clinha1)
		If MV_PAR08 == '399'
			cLinha1:= "Pagar preferencialmente em agência HSBC."
		ElseIf MV_PAR08 == '237'
			cLinha1:= "Pagavel Preferencialmente nas Agências Bradesco."
		ElseIf MV_PAR08 == '341'
			cLinha1:= "Pagavel Preferencialmente nas Agências Itaú."
		Else
			cLinha1:= "Pagavel em qualquer Banco até o vencimento"
		Endif
	EndIf
	
	//  cLinha2 := Posicione("SM4",1,FWXFILIAL("SM4")+PBS->PBS_CODFO2,"M4_FORMULA")
	cLinha2 := iIf(Empty(PBS->PBS_CODFO2),'',iIf(ValType(Formula(PBS->PBS_CODFO2))=="N",Str(Formula(PBS->PBS_CODFO2),100),Formula(PBS->PBS_CODFO2)))
	
	//  	cLinha3 := Posicione("SM4",1,FWXFILIAL("SM4")+PBS->PBS_CODFO3,"M4_FORMULA")
	cLinha3 := iIf(Empty(PBS->PBS_CODFO3),'',Iif(ValType(Formula(PBS->PBS_CODFO3))=="N",Str(Formula(PBS->PBS_CODFO3),100),Formula(PBS->PBS_CODFO3)))
	If Empty(clinha3)
		cLinha3:= "Após o Vencimento Multa de 2%"
	Endif
	
	//  	cLinha4 := Posicione("SM4",1,FWXFILIAL("SM4")+PBS->PBS_CODFO4,"M4_FORMULA")
	cLinha4 := Iif(Empty(PBS->PBS_CODFO4),'',Iif(ValType(Formula(PBS->PBS_CODFO4))=="N",Str(Formula(PBS->PBS_CODFO4),100),Formula(PBS->PBS_CODFO4)))
	If Empty(clinha4)
		cLinha4:= "Após o Vencimento sua Mensalidade será Cancelada e a Entrada "
	Endif
	
	//  	cLinha5 := Posicione("SM4",1,FWXFILIAL("SM4")+PBS->PBS_CODFO5,"M4_FORMULA")
	cLinha5 := Iif(Empty(PBS->PBS_CODFO5),'',Iif(ValType(Formula(PBS->PBS_CODFO5))=="N",Str(Formula(PBS->PBS_CODFO5),100),Formula(PBS->PBS_CODFO5)))
	If Empty(clinha5)
		cLinha5:= "do Veículo no Estacionamento será cobrado como Rotativo"
	Endif
	
	//  	cLinha6 := Posicione("SM4",1,FWXFILIAL("SM4")+PBS->PBS_CODFO6,"M4_FORMULA")
	cLinha6 := Iif(Empty(PBS->PBS_CODFO6),' ',Iif(ValType(Formula(PBS->PBS_CODFO6))=="N",Str(Formula(PBS->PBS_CODFO6),100),Formula(PBS->PBS_CODFO6)))
	If Empty(clinha6)
		cLinha6:= "SAC 0800-105560 - 'Sistema Estapar'"
	Endif
	
	//	cLinha7 := Posicione("SM4",1,FWXFILIAL("SM4")+PBS->PBS_CODFO7,"M4_FORMULA")
	cLinha7 := Iif(Empty(PBS->PBS_CODFO7),' ',Iif(ValType(Formula(PBS->PBS_CODFO7))=="N",Str(Formula(PBS->PBS_CODFO7),100),Formula(PBS->PBS_CODFO7)))
	
	
	//If Empty(clinha7)
	//		cLinha7:= "Tarifa de Cobrança Incluso na Mensalidade"
	//Endif
	
	
	aBolText := { "Conceder Desconto de R$ " + Transform(nDesconto,"@r 9999.99") + "  Até  " + dtoc(aVetor[nA][11]) ,; //[1] TEXTO 1
	cLinha3   	                    ,; //[2] TEXTO 2
	cLinha4 				 		,; //[3] TEXTO 3
	cLinha5							,; //[4] TEXTO 3
	cLinha6                         ,; //[5] TEXTO 4
	cLinha7 				 		,; //[6] TEXTO 5
	"Parabéns! Você como segurado da Porto Seguro agora tem"						 		,; //[7] TEXTO 6
	"Direito a 10% na sua Mensalidade ESTAPAR, que já foi levada"       			 		,; //[8] TEXTO 6
	"em Consideração no Cálculo desse Boleto."										 		,; //[9] TEXTO 6
	""																				 		,; //[10] TEXTO 7
	""																						,; //[11] TEXTO 8
	""																						,; //[12] TEXTO 9
	cLinha1																					,; //[13] TEXTO 10
	Iif( !Empty(cLinha2),cLinha2,"")														}  //[14] TEXTO 11
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA6 (Bancos)    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SA6")
	DbSetOrder(1)
	
	If !DbSeek(FWXFILIAL("SA6")+cBanco+cAgencia+cConta)
		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Banco não localizado"),{"OK"})
		Alert('Banco (SA6): ' + FWXFILIAL("SA6")+cBanco+cAgencia+cConta)
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona na Arq de Parametros CNAB   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SEE")
	DbSetOrder(1)
	
	If !DbSeek(FWXFILIAL("SEE")+cBanco+cAgencia+cConta+cSubCt)
		Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não localizado banco no cadastro de parâmetros para envio"),{"OK"})
		Alert('Parametros CNAB (SEE) ' + FWXFILIAL("SEE")+cBanco+cAgencia+cConta+cSubCt)
		Loop
	EndIf
	
	cPrefix := aVetor[nA][22]
	cNumTit := aVetor[nA][5]
	cParcel := aVetor[nA][23]
	cTipo   := aVetor[nA][24]
	If SE1->(dbSeek(FWXFILIAL("SE1")+cPrefix+cNumTit+avkey(cParcel, "E1_PARCELA")+cTipo))
		
		// ALTERAR PARAMETRO MV_PAR07 PARA ACEITAR VALOR NEGATIVO PARA REVERTER UMA COBRANCA DE TAXA INVALIDA...
		
		If MV_PAR06 == 1 .And. (MV_PAR07 < 0 .OR. MV_PAR07 > 0) .And. !Empty(SE1->E1_IDCNAB)  // ja foi emitido uma vez
			aAreaPDD := PDD->(GetArea())
			
			Begin Transaction
			
			PDD->(dbSetorder(1))
			If PDD->(dbSeek(FWXFILIAL("PDD")+aVetor[nA][2]+aVetor[nA][3]+aVetor[nA][4]+aVetor[nA][5],.T.))
				RecLock("PDD",.F.)
				PDD->PDD_TXREMI += MV_PAR07
				PDD->PDD_VLTOT1 += MV_PAR07
				PDD->PDD_VLTOT2 += MV_PAR07
				nTxRemi := PDD->PDD_TXREMI
				MsUnlock()
			Endif
			
			RestArea(aAreaPDD)
			
			RecLock("SE1",.F.)
			SE1->E1_VALOR  += MV_PAR07
			SE1->E1_VLCRUZ += MV_PAR07
			SE1->E1_SALDO  += MV_PAR07
			MsUnlock()
			
			End Transaction
			
			aBolText[10] := "Cobrado o valor de R$"+transform(mv_par07,"@r 999.99")+" na reemissão deste boleto."
		Else
			//	nTxRemi := aVetor[nA][19]
			
			aBolText[10] := "Será cobrado taxa de R$ 5,00 no caso de reemissão deste boleto."
		Endif
		
//		IF !EMPTY(SEE->EE_ULTDSK) .AND. ALLTRIM(SEE->EE_OPER)$"COBRANCA REGISTRADA"			// retirado em 13/03/2013
		IF !EMPTY(SEE->EE_ULTDSK) .AND. "COB"$ALLTRIM(SEE->EE_OPER).AND."REGISTR"$ALLTRIM(SEE->EE_OPER)			// incluido em 13/03/2013
			//If  !Empty(SE1->E1_NUMBCO) .and. SEE->EE_CODIGO=="422"		// retirado em 21/02/13 por Daniel G.Jr.
			/*If  !Empty(SE1->E1_NUMBCO) .and. SEE->EE_CODIGO$"422|399"		// incluido em 21/02/13 por Daniel G.Jr.
				cNroDoc := Substr(SE1->E1_NUMBCO,1,8)
			ElseIf  !Empty(SE1->E1_NUMBCO) .and. SEE->EE_CODIGO=="341"
				cNroDoc := Substr(SE1->E1_NUMBCO,4,8)
			ElseIf  !Empty(SE1->E1_NUMBCO) .and. SEE->EE_CODIGO<>"422"
				cNroDoc := Substr(SE1->E1_NUMBCO,1,10)
			*/
			If !Empty(SE1->E1_NUMBCO)
				If SEE->EE_CODIGO$"422|399"
					cNroDoc := Substr(SE1->E1_NUMBCO,1,8)
				ElseIf  SEE->EE_CODIGO=="341"
					cNroDoc := Substr(SE1->E1_NUMBCO,4,8)
				ElseIf  SEE->EE_CODIGO=="237"
					cNroDoc := SubStr(AllTrim(SE1->E1_NUMBCO),3,11)
				Else					
					cNroDoc := Substr(SE1->E1_NUMBCO,1,10)
				EndIf
			ElseIf !Empty(SEE->EE_FAXATU)
				IF SEE->EE_CODIGO=="341"
					cNroDoc	:= Substr(SEE->EE_FAXATU,3,8)
				else
					cNroDoc	:= SEE->EE_FAXATU
				Endif
			Else
				cNroDoc	:= SE1->E1_NUM+cParcel
			EndIf
		Endif
		If Empty(SE1->E1_IDCNAB)  // 1a emissao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gera o Sequencial do IDCNAB    ³
			//³Andreia J. da Silva  -  09/2007³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Gera identificador do registro CNAB no titulo enviado
			cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt)
			dbSelectArea("SE1")
			aOrdSE1 := SE1->(GetArea())
			dbSetOrder(16)
			While SE1->(dbSeek(FWXFILIAL("SE1")+cIdCnab))
				If ( __lSx8 )
					ConfirmSX8()
				EndIf
				cIdCnab := GetSxENum("SE1", "E1_IDCNAB","E1_IDCNAB"+cEmpAnt)
			End
			SE1->(RestArea(aOrdSE1))
			Reclock("SE1",.F.)
			SE1->E1_IDCNAB := cIdCnab
			MsUnlock()
			ConfirmSx8()
		Else
			cIdCnab := SE1->E1_IDCNAB     // 1a. reemissao
		Endif
//		IF EMPTY(SEE->EE_ULTDSK) .OR. !ALLTRIM(SEE->EE_OPER)$"COBRANCA REGISTRADA"			// retirado em 14/03/2013
		IF EMPTY(SEE->EE_ULTDSK) .OR. !("COB"$ALLTRIM(SEE->EE_OPER).AND."REGISTR"$ALLTRIM(SEE->EE_OPER))
			//cNroDoc	:= cIdCnab //cBanco			retirado em 21/02/13 por Daniel G.Jr.
			cNroDoc := IIF (!EMPTY(cIdCnab),cIdCnab,IIF(SEE->EE_CODIGO=="399",SUBSTR(SE1->E1_NUMBCO,1,8),SE1->E1_NUMBCO))	// Incluído em 21/02/13 por Daniel G.Jr.
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SA1 (Cliente)             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCodCli := IIF(!Empty(aVetor[nA][9]),aVetor[nA][9],aVetor[nA][7])
		cLoja   := IIF(!Empty(aVetor[nA][9]),aVetor[nA][10],aVetor[nA][8])
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		
		if !DbSeek(FWXFILIAL()+cCodCli+cLoja,.T.)
			Alert("Cliente (SA1) não localizado: [" + FWXFILIAL()+cCodCli+cLoja + "]")
		endif
		nBanco := ""
		BmpBanco:=""
		If SEE->EE_CODIGO == "001"
			nBanco := "Banco do Brasil"
			if file("Brasil.Bmp")
				BmpBanco :="Brasil.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "399"
			nBanco := "Banco HSBC"
			if file("Hsbc.Bmp")
				BmpBanco :="Hsbc.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "341"
			nBanco := "Banco ITAU"
			if file("Itau.Bmp")
				BmpBanco :="Itau.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "422"
			nBanco := "Banco SAFRA"
			if file("Safra.Bmp")
				BmpBanco :="Safra.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "356"
			nBanco := "Banco Real"
			if file("Real.Bmp")
				BmpBanco :="Real.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "237"
			nBanco := "Bradesco"
			if file("Bradesco.Bmp")
				BmpBanco :="Bradesco.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "104"
			nBanco   := "Caixa E.Federal"
			if file("Caixa.Bmp")
				BmpBanco :="Caixa.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "353"
			nBanco := "Santander"
			if file("Santander.Bmp")
				BmpBanco :="Santander.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "033"
			nBanco := "Santander"
			if file("Santander.Bmp")
				BmpBanco :="Santander.Bmp"
			Endif
		ElseIf SEE->EE_CODIGO == "409"
			nBanco := "Unibanco"
			if file("Unibanco.Bmp")
				BmpBanco :="Unibanco.Bmp"
			Endif
		Else
			nBanco := SUBSTR(SA6->A6_NREDUZ,1,14)
		Endif
		
		aDadosBanco  := {SEE->EE_CODIGO  										    									,;	//	[1]	Numero do Banco
		nBanco																	,;	//	[2]	Nome Reduzido Banco
		SUBSTR(SEE->EE_AGENCIA,1,4)						   										,;	//	[3]	Agência
		SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON)))								,;	//	[4]	Conta Corrente
		SUBSTR(SA6->A6_DVCTA,1,Len(AllTrim(SA6->A6_DVCTA)))	  							,;	//	[5]	Dígito da conta corrente
		Alltrim(SEE->EE_SUBCTA)	  							,;	//	[6]	Dígito da conta corrente
		BmpBanco }												   //	[7]	Loggotipo Banco
		
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)				,; 					//	[1]	Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;	//	[3]	Endereço
			AllTrim(SA1->A1_MUN )								,;	//	[4]	Cidade
			SA1->A1_EST											,;	//	[5]	Estado
			SA1->A1_CEP											,;	//	[6]	CEP
			SA1->A1_CGC											,;	//	[7]	CGC
			SA1->A1_PESSOA										}  //	[8]	PESSOA
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)				,; 					//	[1]	Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;	//	[3]	Endereço
			AllTrim(SA1->A1_MUNC)								,;	//	[4]	Cidade
			SA1->A1_ESTC										,;	//	[5]	Estado
			SA1->A1_CEPC										,;	//	[6]	CEP
			SA1->A1_CGC											,;	//	[7]	CGC
			SA1->A1_PESSOA										}   //  [8] PESSOA
		Endif
		
		cUnificado := IIF(!Empty(aVetor[nA][9]),"000"+aVetor[nA][29],'000000')
		
		cCB_TOP := 	AVetor[nA,05] + ;								    // BOLPDD->NUMCOB	01 até 06 – Código da CobrançaCódigo da Cobrança
		left(AVetor[nA,04],2) + right(AVetor[nA,04],2) +;	// BOLPDD->MESANO	07 até 10 – Mês de Referencia da Cobrança
		StrZero(AVetor[nA,13] - CtoD("07/10/1997"),4) + ;  // BOLPDD->VENC2		11 até 14 – Vencimento Sem Desconto (Padrão Febraban)
		right(strzero((AVetor[nA,14]+ nTxRemi - AVetor[nA,30] ) * 100),7)+; // BOLPDD->VALOR2 	15 até 21 – Valor Sem Desconto
		strzero(AVetor[nA,13] - AVetor[nA,11],2,0) + ;		//					22 até 23 – Numero de dias para Desconto
		right(strzero((AVetor[nA,12]+ nTxRemi -AVetor[nA,30] ) * 100),7) +; //BOLPDD->VALOR1	24 até 30 – Valor Com Desconto
		iif(!empty(aVetor[nA][9]),"2","1") + ;				//					31 até 31 – Tipo de Mensalista (1-Normal/2-Unificado)
		iif(empty(AVetor[nA][9]),AVetor[nA][28],cUnificado ) +; //AVetor[nA][9]) +; // ALTERADO PARA BOLPDD->CODVAG ou BOLPDD->CODUNI no vetor	32 até 37 – Código do vaga ou Unificado // BOLPDD->CODUNI ou BOLPDD->CODCLI no vetor	32 até 37 – Código do Mensalista ou Unificado
		"0" +; 											 //	38 ate 38 - Vago
		subs(AVetor[nA,21],1,4) + ; // BOLPDD->FILEST	39 até 42 – Código da Filial (da posição 1ª até a 4ª)
		subs(AVetor[nA,21],6,1)		 // BOLPDD->FILEST	43 até 43 – Digito Verificador da Filial (6ª posição)
		
		cCB_TOP += alltrim(U_Modu10Es(cCB_TOP))										//					44 até 44 – Digito Verificador da Barra
		
		//Monta codigo de barras FIM DA PAGINA
		aCB_RN_NN  := U_RetcBarra(Subs(aDadosBanco[1],1,3)+"9"		    ,;//Banco
		Subs(aDadosBanco[3],1,4)			,;//Agencia
		aDadosBanco[4]						,;//Conta
		aDadosBanco[5]						,;//Digito da Conta
		aDadosBanco[6]						,;//Carteira
		aVetor[nA][5]						,;//Documento
		aVetor[nA][14]+ nTxRemi				,;//Valor do Titulo
		aVetor[nA][13]						,;//Vencimento
		SEE->EE_CODEMP						,;//Convenio
		cNroDoc  							,;//Sequencial
		.F.									,;//Se tem desconto
		Space(TamSx3("E1_PARCELA")[1])		,;//Parcela
		aDadosBanco[3])				    	  //Agencia Completa
		
		aDadosTit := {AllTrim(aVetor[nA][5])		,;  //	[1]	Número do título
		aVetor[nA][6]					,;  //	[2]	Data da emissão do título
		dDataBase						,;  //	[3]	Data da emissão do boleto
		aVetor[nA][13]					,;  //	[4]	Data do vencimento
		aVetor[nA][14]+ nTxRemi			,;  //	[5]	Valor do título
		aCB_RN_NN[3]					,;  //	[6]	Nosso número (Ver fórmula para calculo)
		Space(TamSx3("E1_PREFIXO")[1])	,;  //	[7]	Prefixo da NF
		"RC"	   						}   //	[8]	Tipo do Titulo
		
		cNossoN := 	aCB_RN_NN[3]
		
		aadd(aPgto,{aVetor[nA][25], _cNomeArq,cEmp,aVetor[nA][5],aVetor[nA][4],aDadosTit[3],aDadosTit[4],aDadosTit[5],aBolText[1],aBolText[2],aCB_RN_NN[2],aDatSacado[1],"\BOLETOS\"+_cNomeArq+".jpg_pag1.jpg",aVetor[nA][35]} )  //array para controlar os titulos que serão enviados por e-mail
		
		cCodUni:= aVetor[nA][29]//AllTrim(Posicione("PSB",2,FwXFILIAL("PSB")+aVetor[nA][7]+aVetor[nA][8]+aVetor[nA][28],"PSB_CLIUNI") )
		
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cCB_TOP,aDadosPDD,cIdCnab,cNossoN,MV_PAR07, _cNomeArq)
		
		// Grava Nosso Numero
		
//		IF !EMPTY(SEE->EE_ULTDSK) .AND. ALLTRIM(SEE->EE_OPER)$"COBRANCA REGISTRADA" .AND. EMPTY(SE1->E1_NUMBCO)			// retirado em 14/03/2013
		IF !EMPTY(SEE->EE_ULTDSK) .AND. ("COB"$ALLTRIM(SEE->EE_OPER).AND."REGISTR"$ALLTRIM(SEE->EE_OPER)) .AND. EMPTY(SE1->E1_NUMBCO)
			RecLock("SEE",.F.)
			SEE->EE_FAXATU := StrZero(Val(SEE->EE_FAXATU) + 1,10)  //INCREMENTA P/ TODOS OS BANCOS
			MsUnlock()
		Endif
		
		Reclock("SE1",.F.)
//		if aDadosBanco[1] == "104" .or. aDadosBanco[1] == "033" .or. aDadosBanco[1] == "353"			// retirado em 14/03/2013
		if aDadosBanco[1] $ "104|033|353|399"
			SE1->E1_NUMBCO := aCB_RN_NN[3]
		Else
			SE1->E1_NUMBCO := aCB_RN_NN[4]
		Endif
		MsUnlock()
		
		aAreaPDDw := PDD->(GetArea())
		PDD->(dbOrderNickname("PDDTIT"))
		
		If PDD->(dbSeek(FWXFILIAL("PDD")+cPrefix+cNumTit+ALLTRIM(avkey(cParcel, "PDD_PARCEL")),.T.))
			While PDD->(!EOF()) .and. PDD->PDD_CODEMP+PDD->PDD_NUM+PDD->PDD_MESANO == aDadosPDD[1]+cNumTit+aDadosPDD[3]
				
				If MV_PAR12 == 1
					RecLock("PDD",.F.)
					PDD->PDD_DTEMCO := dDataBase
					PDD->PDD_HOREMI := Time()
					PDD->PDD_ORIEMI := 'B'
					if PDD->PDD_STATUS == '2' .OR. PDD->PDD_STATUS == ' '
						PDD->PDD_STATUS := '1'
						PDD->PDD_ERRO   := '1a.Impressao de Boleto ' + aCB_RN_NN[4]
					Else
						PDD->PDD_STATUS := '3'
						PDD->PDD_ERRO   := '2a.Impressao de Boleto ' + aCB_RN_NN[4] + ' Taxa : ' + transform(mv_par07,"@r 999.99")
					Endif
				Endif
				MsUnlock()
				PDD->(dBskip())
			End
		Endif
		RestArea(aAreaPDDw)
		
	Endif
	
	IncProc()
	
Next n

If MV_PAR12 == 1 .AND. lImprime
	oPrint:EndPage()      // Finaliza a página
	oPrint:Print()//
ElseIf MV_PAR12 == 2
	E_Mail( _cNomeArq,oPrint)
Else
	MsgInfo("Nao existem boletos para serem impressos!")
EndIf

If Select("QRY2") > 0
	QRY2->(dbCloseArea())
Endif

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Everton Balbino       ³ Data ³ 19/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cCB_TOP,aDadosPDD,cIdCnab,cNossoN,MV_PAR07, _cNomeArq)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont11
LOCAL oFont10
LOCAL oFont13
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
//Local cLogoBanco := "lgrl03"+cEmpAnt+".bmp"
Local cLogoBanco := GetNewPar( "FS_LOGOESP", "")
Local clogo_branco:= "logo_branco.bmp"


If MV_PAR12 == 2
	oPrint:= TMSPrinter():New( "Boleto Laser" )
	oPrint:SetPortrait()
	// ou SetLandscape()
Endif
oPrint:StartPage()
// Inicia uma nova página

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)


/******************************************************************/
/* CODIGO DE BARRAS DO TOPO CONFORME NOVA DEFINICAO EM 02/08/2007 */
/******************************************************************/

nRow2 := 0

//Linha Inicial
oPrint:Line (nRow2+50,100,  nRow2+50,110)
oPrint:Say  (nRow2+30,120,"Esta barra é de uso exclusivo do estacionamento",oFont11)
oPrint:Line (nRow2+50,700, nRow2+50,2300)

MSBAR("INT25", 1.0/*1.7*/ , 02.3, cCB_TOP, oPrint,.F.,Nil,Nil, 0.025, 1  ,Nil,Nil,"A",.F.)

oPrint:Say (nRow2+270,400,left(cCB_TOP, 10)     + "   " + ;
subs(cCB_TOP, 11,10)  + "   " + ;
subs(cCB_TOP, 21,10)  + "   " + ;
subs(cCB_TOP, 31,15) , oFont8)


//Verticais Laterais
oPrint:Line (nRow2+50,100,  nRow2+350,100)
oPrint:Line (nRow2+50,2300, nRow2+350,2300)


//Vertical do meio
//oPrint:Line (nRow2+50,1600, nRow2+350,1600)

//oPrint:Say (nRow2+100,1650, "                   Fique longe de Filas                ")
//oPrint:Say (nRow2+135,1650, "                  se você é cliente VISA               ")
//oPrint:Say (nRow2+170,1650, "faça o débito automático de sua mensalidade  ")
//oPrint:Say (nRow2+205,1650, "          procure um de nossos funcionários        ")
//oPrint:Say (nRow2+240,1650, "É a ESTAPAR trabalhando para o seu conforto  ")

//Linha final
oPrint:Line (nRow2+350,100,  nRow2+350,2300)

nRow2:= 260

/*****************/
/* SEGUNDA PARTE */
/*****************/

oPrint:Line (nRow2+0210,100,nRow2+0210,2300)
oPrint:Line (nRow2+0210,500,nRow2+0130, 500)
oPrint:Line (nRow2+0210,710,nRow2+0130, 710)

if !Empty(aDadosBanco[7])
	oPrint:SayBitmap(nRow2+0135,100,aDadosBanco[7],400,053)
Else
	oPrint:Say  (nRow2+0144,100,aDadosBanco[2],oFont13 )		// [2]Nome do Banco
Endif

oPrint:Say  (nRow2+0125,513,aDadosBanco[1]+"-"+U_Modulo11CNR(aDadosBanco[1],aDadosBanco[1]),oFont21 )	// [1]Numero do Banco
//	cLogoBanco := "logo_safra.bmp"

oPrint:Say  (nRow2+0144,1800,"Recibo do Sacado",oFont10)
//   alert (PDD->PDD_CODFIL)
//  IF !ALLTRIM(PDD->PDD_CODFIL) $ "HF/HG/HH/HI/HJ/HK/HL/HM/HN/HO/HP/HQ/HR/HS/HT/HU/HV/HX/HZ/HW/HY/I0/I1/I2/I3/I4/I5/I6/I7/I8/I9/IA/IB"


If mv_par13 == 1
	oPrint:SayBitmap(nRow2+0250,1900,cLogoBanco,388,200) //Logo 
		
ELSE                     
	oPrint:SayBitmap(nRow2+0250,1900,clogo_branco,388,200)
ENDIF

oPrint:Line (nRow2+0310,100,nRow2+0310,1800 )
oPrint:Line (nRow2+0410,100,nRow2+0410,1800 )
oPrint:Line (nRow2+0480,100,nRow2+0480,2300 )
oPrint:Line (nRow2+0550,100,nRow2+0550,1800 )

oPrint:Line (nRow2+0410,500,nRow2+0550,500)
oPrint:Line (nRow2+0480,750,nRow2+0550,750)
oPrint:Line (nRow2+0410,1000,nRow2+0550,1000)
oPrint:Line (nRow2+0410,1300,nRow2+0480,1300)
oPrint:Line (nRow2+0410,1480,nRow2+0550,1480)

oPrint:Say  (nRow2+0210,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0240,100 ,aBolText[13],oFont10)
oPrint:Say  (nRow2+0265,400 ," ",oFont10)

oPrint:Say  (nRow2+0310,100 ,"Cedente",oFont8)
oPrint:Say  (nRow2+0350,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0410,100 ,"Data do Documento",oFont8)
oPrint:Say  (nRow2+0440,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0410,505 ,"Nro.Documento",oFont8)
oPrint:Say  (nRow2+0440,645 ,aDadosTit[1],oFont10) //Numero Cobranca

oPrint:Say  (nRow2+0410,1005,"Espécie Doc.",oFont8)
//If aDadosBanco[1] == "422" .Or. aDadosBanco[1] == "237"
oPrint:Say  (nRow2+0440,1050,aDadosTit[8],oFont10) //Tipo do Titulo
//EndIf

oPrint:Say  (nRow2+0410,1305,"Aceite",oFont8)
//If aDadosBanco[1] == "422" .Or. aDadosBanco[1] == "237"
oPrint:Say  (nRow2+0440,1400,"N",oFont10)
//EndIf

oPrint:Say  (nRow2+0410,1485,"Data do Processamento",oFont8)
//If aDadosBanco[1] == "422" .Or. aDadosBanco[1] == "237"
oPrint:Say  (nRow2+0440,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
//EndIf

oPrint:Say  (nRow2+0480,100 ,"Uso do Banco",oFont8)

oPrint:Say  (nRow2+0480,505 ,"Carteira",oFont8)
oPrint:Say  (nRow2+0510,555 ,aDadosBanco[6],oFont10)

oPrint:Say  (nRow2+0480,755 ,"Espécie",oFont8)
oPrint:Say  (nRow2+0510,805 ,"R$",oFont10)

oPrint:Say  (nRow2+0480,1005,"Quantidade",oFont8)
oPrint:Say  (nRow2+0480,1485,"Valor"     ,oFont8)

oPrint:Say  (nRow2+0480,1810,"Vencimento",oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0510,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0580,1810,"Agência/Código Cedente",oFont8)
If aDadosBanco[1] == "399"
	cString := SEE->EE_CODEMP
ElseIf aDadosBanco[1] == "356"
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"/"+Substr(aCB_RN_NN[2],20,1))
ElseIf aDadosBanco[1] == "422"
	cString := Alltrim(aDadosBanco[3]+"/"+strzero(val(aDadosBanco[4]),8)+"-"+aDadosBanco[5])
elseif aDadosBanco[1] == "104" .or. aDadosBanco[1] == "033" .or. aDadosBanco[1] == "353"
	cString := aCB_RN_NN[4]
Else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
EndIf
if aDadosBanco[1]=="104"
	nCol := 1812+(410- IIf((len(cString)*22) > 410,(len(cString)*22),0)  )
else
	nCol := 1810+(374-(len(cString)*22))
Endif
oPrint:Say  (nRow2+0620,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0680,1810,"Nosso Número",oFont8)

cString := aDadosTit[6]

nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0720,nCol,cString,oFont11c)

oPrint:Say (nRow2+0780,1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say (nRow2+0820,nCol,cString ,oFont11c)

oPrint:Say (nRow2+0550,100 ,"Instruções",oFont8)
// Avalia se o Venc1 e diferente do Venc2
If aDadosPDD[6] <> aDadosPDD[7]
	oPrint:Say (nRow2+0620,250 ,aBolText[1],oFont8)
Endif

oPrint:Say (nRow2+0700,250 ,aBolText[2],oFont8)
oPrint:Say (nRow2+0750,250 ,aBolText[3],oFont8)
oPrint:Say (nRow2+0800,250 ,aBolText[4],oFont8)
oPrint:Say (nRow2+0850,250 ,aBolText[5],oFont8)
oPrint:Say (nRow2+0900,250 ,aBolText[6],oFont8)

If aDadosPDD[8] > 0
	oPrint:Say (nRow2+1000,250 ,aBolText[7],oFont8)
	oPrint:Say (nRow2+1050,250 ,aBolText[8],oFont8)
	oPrint:Say (nRow2+1100,250 ,aBolText[9],oFont8)
Endif

oPrint:Say (nRow2+1150,250 ,aBolText[10],oFont8)
oPrint:Say (nRow2+1200,250 ,aBolText[14],oFont8)

oPrint:Say (nRow2+0880,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say (nRow2+0980,1810,"(-)Outras Deduções"    ,oFont8)
oPrint:Say (nRow2+1080,1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say (nRow2+1210,1810,"(+)Outros Acréscimos"  ,oFont8)
oPrint:Say (nRow2+1310,1810,"(=)Valor Cobrado"      ,oFont8)

/*oPrint:Say (nRow2+1280,100,"Recebimento através do Cheque nº "  ,oFont8)
oPrint:Say (nRow2+1310,100,"do Banco"  ,oFont8)
oPrint:Say (nRow2+1340,100,"Esta quitação só terá validade após pagamento de cheque"  ,oFont8)
oPrint:Say (nRow2+1370,100,"do Banco sacado"  ,oFont8)*/

If cCodUni==""
	oPrint:Say (nRow2+1230,1470,iIF(aDadosPDD[14]<>aDadosPDD[15],"Placa: "+aDadosPDD[14],"")  ,oFont11)
	oPrint:Say (nRow2+1290,1470,"Placa: "+aDadosPDD[15]  ,oFont11)
ElseIf aDadosPDD[16]
	oPrint:Say (nRow2+1290,1470,"MultiVagas" ,oFont11)
EndIf
oPrint:Say  (nRow2+1350,1470,"Vaga : "+aDadosPDD[13]  ,oFont11)
oPrint:Say  (nRow2+1410,105 ,"Cliente",oFont8)
oPrint:Say  (nRow2+1450,155 ,Substr(aDadosPDD[4],1,6),oFont8) //Cliente + Loja
oPrint:Say  (nRow2+1410,405,"Filial",oFont8)
oPrint:Say  (nRow2+1450,405,aDadosEmp[8],oFont8) //Nome Filial
oPrint:Say  (nRow2+1410,1005,"Modalidade",oFont8)


PDT->(dbSetOrder(1))//PDT_FILIAL, PDT_CODIGO, PDT_MODAL

If PDT->(dbSeek(FWxFILIAL("PDT")+aDadosPDD[18]+aDadosPDD[17]))

	If aDadosPDD[11] == 1
		oPrint:Say  (nRow2+1450,1005,Alltrim(PDT->PDT_DESC),oFont8)
	Else
		oPrint:Say  (nRow2+1450,1005,"DIVERSOS",oFont8)
	Endif

EndIf
	
oPrint:Say  (nRow2+1410,1405,"Qtde Vagas",oFont8)
oPrint:Say  (nRow2+1450,1455,Strzero(aDadosPDD[11],6),oFont8) // Qtd. Vagas

oPrint:Say  (nRow2+1410,1605,"Referencia",oFont8)
oPrint:Say  (nRow2+1450,1605, MesExtenso(left(aDadosPDD[3],2)) + " de " + subs(aDadosPDD[3],3,4), oFont8) // Referencia

oPrint:Line (nRow2+1400,390,nRow2+1500,390)
oPrint:Line (nRow2+1400,990,nRow2+1500,990)
oPrint:Line (nRow2+1400,1390,nRow2+1500,1390)
oPrint:Line (nRow2+1400,1590,nRow2+1500,1590)

oPrint:Say  (nRow2+1500,100 ,"Sacado",oFont8)
oPrint:Say  (nRow2+1500,1810,"Autenticação Mecânica",oFont8)
oPrint:Say  (nRow2+1510,410 ,LEFT(aDatSacado[1],45),oFont8)

if aDatSacado[8] = "J" //Abramo
	oPrint:Say  (nRow2+1510,1405 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow2+1510,1405 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf

oPrint:Say  (nRow2+1560,410 ,aDatSacado[3],oFont8)
oPrint:Say  (nRow2+1610,410 ,"CEP: "+Subs(aDatSacado[6],1,5)+"-"+Subs(aDatSacado[6],6,3)+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado

oPrint:Line (nRow2+0210,1800,nRow2+1400,1800 )
oPrint:Line (nRow2+0570,1800,nRow2+0570,2300 )
oPrint:Line (nRow2+0670,1800,nRow2+0670,2300 )
oPrint:Line (nRow2+0770,1800,nRow2+0770,2300 )
oPrint:Line (nRow2+0870,1800,nRow2+0870,2300 )
oPrint:Line (nRow2+0970,1800,nRow2+0970,2300 )
oPrint:Line (nRow2+1070,1800,nRow2+1070,2300 )
oPrint:Line (nRow2+1200,1800,nRow2+1200,2300 )
oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )

oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
oPrint:Line (nRow2+1500,100 ,nRow2+1500,2300 )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 550

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1380, nI, nRow3+1380, nI+30)
Next nI

oPrint:Line (nRow3+1500,100,nRow3+1500,2300)
oPrint:Line (nRow3+1500,500,nRow3+1420, 500)
oPrint:Line (nRow3+1500,710,nRow3+1420, 710)

if !Empty(aDadosBanco[7])
	oPrint:SayBitmap(nRow3+1425,100,aDadosBanco[7],400,055)
Else
	oPrint:Say  (nRow3+1434,100,aDadosBanco[2],oFont13 )		// 	[2]Nome do Banco
Endif

oPrint:Say  (nRow3+1410,513,aDadosBanco[1]+"-"+U_Modulo11CNR(aDadosBanco[1],aDadosBanco[1]),oFont21 )	// 	[1]Numero do Banco

oPrint:Say  (nRow3+1434,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+1600,100,nRow3+1600,2300 )
oPrint:Line (nRow3+1700,100,nRow3+1700,2300 )
oPrint:Line (nRow3+1770,100,nRow3+1770,2300 )
oPrint:Line (nRow3+1840,100,nRow3+1840,2300 )

oPrint:Line (nRow3+1700,500 ,nRow3+1840,500 )
oPrint:Line (nRow3+1770,750 ,nRow3+1840,750 )
oPrint:Line (nRow3+1700,1000,nRow3+1840,1000)
oPrint:Line (nRow3+1700,1300,nRow3+1770,1300)
oPrint:Line (nRow3+1700,1480,nRow3+1840,1480)

oPrint:Say  (nRow3+1500,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+1545,100 ,aBolText[13],oFont10)
oPrint:Say  (nRow3+1555,400 ," ",oFont10)

oPrint:Say  (nRow3+1500,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+1540,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1600,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+1640,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10)//Nome + CNPJ

oPrint:Say  (nRow3+1600,1810,"Agência/Código Cedente",oFont8)
If aDadosBanco[1] == "399"
	cString := SEE->EE_CODEMP
ElseIf aDadosBanco[1] == "356"
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"/"+Substr(aCB_RN_NN[2],20,1))
ElseIf aDadosBanco[1] == "422"
	cString := Alltrim(aDadosBanco[3]+"/"+strzero(val(aDadosBanco[4]),8)+"-"+aDadosBanco[5])
elseif aDadosBanco[1] == "104" .or. aDadosBanco[1] == "033" .or. aDadosBanco[1] == "353"
	cString := aCB_RN_NN[4]
Else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
EndIf
if aDadosBanco[1]=="104"
	nCol := 1812+(410- IIf((len(cString)*22) > 410,(len(cString)*22),0)  )
else
	nCol 	 := 1810+(374-(len(cString)*22))
Endif
oPrint:Say  (nRow3+1640,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+1700,100 ,"Data do Documento",oFont8)
oPrint:Say (nRow3+1730,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+1700,505 ,"Nro.Documento",oFont8)
oPrint:Say  (nRow3+1730,605 ,aDadosTit[1],oFont10) //Numero Cobranca

oPrint:Say  (nRow3+1700,1005,"Espécie Doc.",oFont8)
//If aDadosBanco[1] == "422" .Or. aDadosBanco[1] == "237"
oPrint:Say  (nRow3+1730,1050,aDadosTit[8],oFont10) //Tipo do Titulo
//EndIf

oPrint:Say  (nRow3+1700,1305,"Aceite",oFont8)
//If aDadosBanco[1] == "422"
oPrint:Say  (nRow3+1730,1400,"N"     ,oFont10)
//EndIf

oPrint:Say  (nRow3+1700,1485,"Data do Processamento",oFont8)
//If aDadosBanco[1] == "422"
oPrint:Say  (nRow3+1730,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao
//EndIf

oPrint:Say  (nRow3+1700,1810,"Nosso Número",oFont8)

cString := aDadosTit[6]

nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+1730,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1770,100 ,"Uso do Banco",oFont8)

oPrint:Say  (nRow3+1770,505 ,"Carteira",oFont8)
oPrint:Say  (nRow3+1800,555 ,aDadosBanco[6],oFont10)

oPrint:Say  (nRow3+1770,755 ,"Espécie",oFont8)
oPrint:Say  (nRow3+1800,805 ,"R$"     ,oFont10)

oPrint:Say  (nRow3+1770,1005,"Quantidade",oFont8)
oPrint:Say  (nRow3+1770,1485,"Valor"     ,oFont8)

oPrint:Say  (nRow3+1770,1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+1800,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1840,100 ,"Instruções",oFont8)

// Avalia se o Venc1 e diferente do Venc2
If aDadosPDD[6] <> aDadosPDD[7]
	oPrint:Say  (nRow3+1870,250 ,aBolText[1],oFont8)
Endif

oPrint:Say  (nRow3+1920,250 ,aBolText[2],oFont8)
oPrint:Say  (nRow3+1970,250 ,aBolText[3],oFont8)
oPrint:Say  (nRow3+2020,250 ,aBolText[4],oFont8)

oPrint:Say  (nRow3+2150,100 ,aBolText[14],oFont8)

oPrint:Say  (nRow3+1840,1810,"(-)Desconto/Abatimento",oFont8)
oPrint:Say  (nRow3+1910,1810,"(-)Outras Deduções"    ,oFont8)
oPrint:Say  (nRow3+1980,1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say  (nRow3+2050,1810,"(+)Outros Acréscimos"  ,oFont8)
oPrint:Say  (nRow3+2120,1810,"(=)Valor Cobrado"      ,oFont8)

oPrint:Say  (nRow3+2190,100 ,"Sacado",oFont8)
oPrint:Say  (nRow3+2200,510 ,LEFT(aDatSacado[1],45),oFont8)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2200,1505,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow3+2200,1505,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf

oPrint:Say  (nRow3+2250,510 ,aDatSacado[3],oFont8)
oPrint:Say  (nRow3+2300,510 ,"CEP: "+Subs(aDatSacado[6],1,5)+"-"+Subs(aDatSacado[6],6,3)+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado

oPrint:Say  (nRow3+2365,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow3+2365,1750,"Código de Baixa",oFont8)
oPrint:Say  (nRow3+2405,1500,"Autenticação Mecânica - Ficha de Compensação",oFont8)

oPrint:Line (nRow3+1500,1800,nRow3+2190,1800)
oPrint:Line (nRow3+1910,1800,nRow3+1910,2300)
oPrint:Line (nRow3+1980,1800,nRow3+1980,2300)
oPrint:Line (nRow3+2050,1800,nRow3+2050,2300)
oPrint:Line (nRow3+2120,1800,nRow3+2120,2300)
oPrint:Line (nRow3+2190,100 ,nRow3+2190,2300)
oPrint:Line (nRow3+2400,100 ,nRow3+2400,2300)

MSBAR("INT25", 26 , 1.5  , aCB_RN_NN[1], oPrint,.F.,Nil,Nil, 0.025, 1.5  ,Nil,Nil,"A",.F.)

If MV_PAR12 == 2
	_cNomeArq := "\BOLETOS\"+_cNomeArq+".jpg"
	oPrint:SaveAllAsJpeg( _cNomeArq, 1250, 2000, 200 ) 
	oPrint:End()      // Finaliza a página
Else
	oPrint:EndPage()      // Finaliza a página
Endif



Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RetcBarra³ Autor ³ Everton Balbino       ³ Data ³ 19/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RetcBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)
//Local bldocnufinal := cAgencia + StrZero( Val( cNroDoc ) , 7 )
//Local blvalorfinal := strzero(int(nValor*100),10)
Local blvalorfinal := strzero(nValor*100,10)
Local cNNumSDig := ""
Local cCpoLivre := ""
Local cCBSemDig := ""
Local cCodBarra := ""
Local cNNum 	:= ""
Local cFatVenc  := ""
Local cNossoNum := ""
Local cLinDig	:= ""

If Left(cBanco,3) == "422"
	
	cCedente := Alltrim(cConvenio)
	_cParcela := NumParcela(_cParcela)
	
	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	
	//Nosso Numero para gravacao
	cNNum := cNNumSDig + modulo11(cNNumSDig)
	
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig)
	
	cCpoLivre := "7"+cCedente+"00"+cNroDoc+cNNum+"4"
	
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	
	//Codigo de Barras Completo
	cCodBarra := cBanco + U_Modu11Es(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(U_Modu10Es(cPrCpo))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(U_Modu10Es(cSgCpo))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(U_Modu10Es(cTrCpo))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	
ElseIf Left(cBanco,3) == "399"
	
	cSeqzero  := strzero(val(cSequencial),8)

	cCedente := Alltrim(cConvenio)
	cNroBco	:= strzero(val(cSequencial),13)
	
	//Fator de Vencimento
	cDtVencto := DtoC(dVencimento)
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	
	
	//Nosso Numero sem digito
	cNNumSDig := cSeqzero + U_Modulo11CNR(cSeqzero,SubStr(cBanco,1,3),2) + "4"
	//	cNNumSDig := strzero(val(cSequencial),12)
	
	//Nosso Numero HSBC
	//  cDVA := U_Modulo11CNR(cNNumSDig)		// retirado em 21/02/13 por Daniel G.Jr.
	//	cDVA := U_Modulo11CNR(cNNumSDig,Left(cBanco,3),2)		// incluido em 21/02/13 por Daniel G.Jr.
	if valtype(dvencimento) == "D"
		//		cDVB := "4"
		//		cAux := Str( Val(cNNumSDig+cDVA+cDVB) + Val(cCedente) + VAL(SUBSTR(DTOC(dvencimento),1,2)+SUBSTR(DTOC(dvencimento),4,2)+SUBSTR(DTOC(dvencimento),7,2)))
		cNNum := Val(cNNumSDig) + Val(cConvenio) + VAL(SUBSTR(cDtVencto,1,2)+SUBSTR(cDtVencto,4,2)+SUBSTR(cDtVencto,9,2))
	Else
		cDVB := "5"
		cAux := Str( Val(cNNumSDig+cDVA+cDVB) + Val(cCedente) )
	Endif                                                                            tot
	//cDVC := U_Modulo11CNR(cAux)		// retirado em 21/02/13 por Daniel G.Jr.
//	cDVC := U_Modulo11CNR(cAux,Left(cBanco,3),2)			// incluido em 21/02/13 por Daniel G.Jr.
	cNNum := U_Modulo11CNR(strzero(cNNum,13),SubStr(cBanco,1,3),2)
//	cDv  := cDVA + cDVB + cDVC
	
	//Nosso Numero para gravacao
	cNossoNum := cNNumSDig + cNNum
//	cNNum     := cNNumSDig + cDv
	
	//Dados para Calcular o Dig Verificador Geral
//	cCpoLivre := StrZero(Val(SubStr(cConvenio,1,7)),7)+strzero(val(cSequencial),13)+data_juliana(dVencimento)+"2"		// retirado em 14/03/2012
	cCpoLivre := StrZero(Val(SubStr(cConvenio,1,7)),7)+strzero(val(cSequencial),13)+u_data_juliana(dVencimento)+"2"		// incluido em 14/03/2012 para chamar user function
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
//	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCedente + cNroBco + "0000" + "2"
	
	//Codigo de Barras Completo
//	cCodBarra := cBanco + U_Modu11Es(cCBSemDig) + cFatVenc + blvalorfinal + cCedente + cNroBco + "0000" + "2"
	cCodBarra := cBanco + U_Modulo11CNR(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
//	cPrCpo := cBanco + Left(cCedente,5)
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(U_Modu10Es(cPrCpo))
	
	//Digito Verificador do Segundo Campo
//	cSgCpo := Right(cCedente,2) + Left(cNroBco,8)
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(U_Modu10Es(cSgCpo))
	
	//Digito Verificador do Terceiro Campo
//	cTrCpo := Right(cNroBco,5) + "0000" + "2"
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(U_Modu10Es(cTrCpo))
	
	//Quarto Campo
	cQrCpo := SubStr(cCodBarra,5,1)
	
	//Quinto Campo
	cQuCpo := cFatVenc + blvalorfinal
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cQrCpo      //dig verificador geral
	cLinDig += "  " + cQuCpo	  //fator de vencimento e valor nominal do titulo
	
	
ElseIf Left(cBanco,3) == "341"
	
	_cParcela := NumParcela(_cParcela)
	
	//Fator de Vencimento
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	
	//Nosso Numero sem digito
	cNNumSDig := cCarteira+strzero(val(cSequencial),8)
	//Nosso Numero
	cNNum := cCarteira+strzero(val(cSequencial),8) + AllTrim( Str( U_modulo10cr( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cCarteira+"/"+strzero(val(cSequencial),8) +"-"+ AllTrim( Str( U_modulo10cr( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
	
	cCpoLivre := cNNumSDig + AllTrim( Str( U_modulo10cr( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) ) + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + AllTrim( Str( U_modulo10cr( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) ) ) )+"000"
	
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	
	//Codigo de Barras Completo
	cCodBarra := cBanco + U_Modu11Es(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	//ALLTRIM( Str(U_modulo10cr(cCBSemDig)))
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + Substr(cCpoLivre,1,5)
	cDvPrCpo := AllTrim( Str(U_modulo10cr(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := Substr(cCpoLivre,6,10)
	cDvSgCpo := AllTrim( Str(U_modulo10cr(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := Substr(cCpoLivre,16,10)
	cDvTrCpo := AllTrim( Str(U_modulo10cr(cTrCpo)))
	
	//Quarto Campo
	cQrCpo := SubStr(cCodBarra,5,1)
	
	//Quinto Campo
	cQuCpo := cFatVenc + blvalorfinal
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cQrCpo      //dig verificador geral
	cLinDig += "  " + cQuCpo	  //fator de vencimento e valor nominal do titulo
	
	
	
ElseIf Left(cBanco,3) == "356"
	_cParcela := NumParcela(_cParcela)
	
	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),13)
	
	cNNum := strzero(val(cSequencial),13)
	
	//Nosso Numero para gravacao
	cDig := U_Modu10Es(cNNumSDig + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7))
	
	//Nosso Numero para impressao
	cNossoNum := strzero(val(cNNumSDig),13)
	
	cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + cDig + strzero(val(cSequencial),13)
	
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	
	//Codigo de Barras Completo
	cCodBarra := cBanco + U_Modu11Es(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + Substr(cCpoLivre,1,5)
	cDvPrCpo := AllTrim(U_Modu10Es(cPrCpo))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := Substr(cCpoLivre,6,10)
	cDvSgCpo := AllTrim(U_Modu10Es(cSgCpo))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := Substr(cCpoLivre,16,10)
	cDvTrCpo := AllTrim(U_Modu10Es(cTrCpo))
	
	//Quarto Campo
	cQrCpo := SubStr(cCodBarra,5,1)
	
	//Quinto Campo
	cQuCpo := cFatVenc + blvalorfinal
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cQrCpo      //dig verificador geral
	cLinDig += "  " + cQuCpo	  //fator de vencimento e valor nominal do titulo
	
Elseif Substr(cBanco,1,3) == "104" // Banco Caixa
	
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(cConvenio),12)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	//Nosso Numero
	_cDigito := U_Modulo11CNR("82"+cNNumSDig,SubStr(cBanco,1,3))
	cNNum := cAgencia + "." + Substr(cCodEmp,1,3) + "." + Substr(cCodEmp,4,8) + "-" + Substr(cCodEmp,12,1)
	//Nosso Numero para impressao
	cNossoNum := "82" + cNNumSDig + "-" + _cDigito
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "82" + cNNumSDig + cAgencia + Substr(cCodEmp,1,11)
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	
	//Codigo de Barras Completo
	cCodBarra := cBanco + U_Modu11Es(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + Substr(cCpoLivre,1,5)
	cDvPrCpo := AllTrim(U_Modu10Es(cPrCpo))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := Substr(cCpoLivre,6,10)
	cDvSgCpo := AllTrim(U_Modu10Es(cSgCpo))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := Substr(cCpoLivre,16,10)
	cDvTrCpo := AllTrim(U_Modu10Es(cTrCpo))
	
	//Quarto Campo
	cQrCpo := SubStr(cCodBarra,5,1)
	
	//Quinto Campo
	cQuCpo := cFatVenc + blvalorfinal
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cQrCpo      //dig verificador geral
	cLinDig += "  " + cQuCpo	  //fator de vencimento e valor nominal do titulo
	
Elseif Substr(cBanco,1,3) == "353" // Banco Santander
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),7)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	//Nosso Numero
	_cDigito := U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	cNossoNum := cNNumSDig + _cDigito
	
	cNNum := cAgencia + "/" + cCodEmp
	//Nosso Numero para impressao
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "9" + cCodEmp + "00" + cNNumSDig + _cDigito + "0102"
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	
	//Codigo de Barras Completo
	cCodBarra := cBanco + U_Modu11Es(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(U_Modu10Es(cPrCpo))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(U_Modu10Es(cSgCpo))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(U_Modu10Es(cTrCpo))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	
Elseif Substr(cBanco,1,3) == "033" // Banco Santander
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),7)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	//Nosso Numero
	_cDigito := U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	cNossoNum := cNNumSDig + _cDigito
	
	cNNum := cAgencia + "/" + cCodEmp
	//Nosso Numero para impressao
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "9" + cCodEmp + "00" + cNNumSDig + _cDigito + "0102"
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	
	//Codigo de Barras Completo
	cCodBarra := cBanco + U_Modu11Es(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(U_Modu10Es(cPrCpo))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(U_Modu10Es(cSgCpo))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(U_Modu10Es(cTrCpo))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	
ElseIf Left(cBanco,3) == "237"
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	//Montagem no NOSSO NUMERO
	snn := StrZero( Val(cSequencial),11 )
	dvnn := modulo12cnr( cCarteira + snn , Left(cBanco,3) )   //Digito verificador no Nosso Numero
	
	//Nosso Numero para gravacao
	cNNum     := cCarteira + snn + dvnn
	
	//Nosso Numero para impressao
	cNossoNum := cCarteira+"/"+ snn +"-"+dvnn
	
	//MONTAGEM DOS DADOS PARA O CODIGO DE BARRAS
	_cLivre := StrZero( Val(cAgencia),4 ) + cCarteira + snn + StrZero( Val(cConta),7 ) + '0'
	scb := cBanco	+ cFatVenc + blvalorfinal + _cLivre
	dvcb := U_Modu11Es( scb ) 	//digito verificador do codigo de barras
	cCodBarra := SubStr( scb, 1, 4 ) + AllTrim( dvcb ) + SubStr( scb, 5, 39 )
	
	//MONTAGEM DA LINHA DIGITAVEL
	srn := cBanco + SubStr( _cLivre, 1, 5 ) //( Codigo Banco + ( Codigo Moeda ) ) + 5 primeiros digitos do campo livre
	dv := U_Modu10Es( srn )
	cCampoA := SubStr( srn, 1, 5 ) + '.' + SubStr( srn, 6, 4 ) + AllTrim( dv ) + ' '
	
	srn := SubStr( _cLivre, 6, 10 ) 	// posicao 6 a 15 do campo livre
	dv := U_Modu10Es( srn )
	cCampoB := SubStr( srn, 1, 5 ) + '.' + SubStr( srn, 6, 5 ) + AllTrim( dv ) + ' '
	
	srn := SubStr( _cLivre, 16, 10 ) 	// posicao 16 a 25 do campo livre
	dv := U_Modu10Es( srn )
	cCampoC := SubStr( srn, 1, 5 ) + '.' + SubStr( srn, 6, 5 ) + AllTrim( dv ) + ' '
	
	srn := SubStr( _cLivre, 16, 10 ) 	// posicao 6 a 15 do campo livre
	dv := U_Modu10Es( srn )
	cLinDig := cCampoA + ' ' + cCampoB + ' ' + cCampoC + '  ' + dvcb + '  ' + cFatVenc + blvalorfinal
	
EndIf

Return({cCodBarra,cLinDig,cNossoNum,cNNum})


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³NumParcelaº Autor ³ Everton Balbino	     º Data ³  19/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ajusta a parcela.                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function NumParcela(_cParcela)
Local _cRet := ""
If ASC(_cParcela) >= 65 .or. ASC(_cParcela) <= 90
	_cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),2)
Else
	_cRet := StrZero(Val(_cParcela),2)
Endif
Return(_cRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSx1   ºAutor  ³Everton  Balbino   º Data ³  19/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verificacao e ajuste do SX1.					      			  º±±
±±º          ³ 				                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Estapar	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea   := GetArea()

PutSX1( cPerg, "01", "Garagem         ? ", "Garagem       ? ", "Garagem         ? ", "mv_ch1", "C", 06, 0, 0, "G", ""                                                 , "PSPS1", "", ""   , "mv_par01", ""   , "", "", ""        , ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "02", "Mes Referencia ? ", "Mes Referencia ? ", "Mes Referencia ? ", "mv_ch2", "N", 02, 0, 0, "G", "Positivo() .And. MV_PAR02 < 13"                    , ""      , "", ""   , "mv_par02", ""   , "", "", ""        , ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "03", "Ano Referencia ? ", "Ano Referencia ? ", "Ano Referencia ? ", "mv_ch3", "N", 04, 0, 0, "G", "Positivo() .And. MV_PAR03 >= (Year(dDatabase) - 1)", ""      , "", ""   , "mv_par03", ""   , "", "", ""        , ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "04", "Cobranca de    ? ", "Cobranca de    ? ", "Cobranca de    ? ", "mv_ch4", "C", 09, 0, 0, "G", ""                                                  , ""      , "", ""   , "mv_par04", ""   , "", "", ""        , ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "05", "Cobranca ate   ? ", "Cobranca ate   ? ", "Cobranca ate   ? ", "mv_ch5", "C", 09, 0, 0, "G", "(MV_PAR05 >= MV_PAR04)"                            , ""      , "", ""   , "mv_par05", ""   , "", "", ""        , ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "06", "Reemissao      ? ", "Reemissao      ? ", "Reemissao      ? ", "mv_ch6", "N", 01, 0, 1, "C", ""                                                  , ""      , "", ""   , "mv_par06", "Sim", "", "", ""        , "Nao", "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "07", "Valor Remis.   ? ", "Valor Remis.   ? ", "Valor Remis.   ? ", "mv_ch7", "N", 07, 2, 0, "G", "Positivo()"                                        , ""      , "", ""   , "mv_par07", ""   , "", "", ""        , ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "08", "Do Banco       ? ", "Do Banco       ? ", "Do Banco       ? ", "mv_ch8", "C", 03, 0, 0, "G", ""                                                  , "SEEMEM"	  , "", "007", "mv_par08", ""   , "", "", Space( 6 ), ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "09", "Da Agencia     ? ", "Da Agencia     ? ", "Da Agencia     ? ", "mv_ch9", "C", 05, 0, 0, "G", ""                                                  , ""      , "", "008", "mv_par09", ""   , "", "", Space( 6 ), ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "10", "Da Conta       ? ", "Da Conta       ? ", "Da Conta       ? ", "mv_chA", "C", 10, 0, 0, "G", ""                                                  , ""      , "", "009", "mv_par10", ""   , "", "", Space( 6 ), ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "11", "Da SubConta    ? ", "Da SubConta    ? ", "Da SubConta    ? ", "mv_chB", "C", 03, 0, 0, "G", ""                                                  , ""      , "", "018", "mv_par11", ""   , "", "", Space( 6 ), ""   , "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "12", "Envia E-mail   ? ", "Envia Email    ? ", "Envia E-mail   ? ", "mv_chC", "N", 01, 0, 1, "C", ""                                                  , ""      , "", ""   , "mv_par12", "Nao", "", "", ""        , "Sim", "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )
PutSX1( cPerg, "13", "Imprime Logo   ? ", "Imprime Logo   ? ", "Imprime Logo   ? ", "mv_chF", "N", 01, 0, 1, "C", ""                                                  , ""      , "", ""   , "mv_par13", "Sim", "", "", ""        , "Nao", "", "", "", "", "", "", "", "", "", "", "", {}, {}, {} )

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VerifConex ºAutor  ³Microsiga         º Data ³  01/17/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerifConex()
Local lRet      := .t.
Local cServer   := PadR(Trim( GetMV( 'FS_SERVER',, '' ) ), 50 ) // smtp.ig.com.br ou 200.181.100.51
Local cEmail    := PadR(Trim( GetMV( 'FS_MAIL',, '' ) ), 50 ) // fulano@ig.com.br
Local cPass     := PadR(Trim( GetMV( 'FS_PASS',, '' ) ),  50 ) // 123abc
//Local lAuth     :=            GetMV( 'MV_RELAUTH',, .F. )        // Tem Autenticacao ?
//Local cContAuth := PadR(Trim( GetMV( 'MV_RELACNT',, '' ) ), 50 ) // Conta Autenticacao
//Local cPswAuth  := PadR(Trim( GetMV( 'MV_RELAPSW',, '' ) ), 50 ) // Senha Autenticacao

If Empty( cServer ) .AND. Empty( cEmail ) .AND. Empty( cPass )
	ApMsgStop( 'Não foi definido os parâmetros do server do Protheus para envio de e-mail', 'Gerar Email' )
	lRet:= .f.
EndIf


/*If lAuth
If Empty( cContAuth ) .OR. Empty( cPswAuth )
ApMsgStop( 'Não foi definido os parâmetros de autenticação do Protheus para envio de e-mail', 'Gerar Email' )
lRet:= .f.
EndIf
EndIf
*/
Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ E_MAIL   ºAutor  ³ Everton Balbino    º Data ³  20/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function E_mail(_cNomeArq,oPrint)
Local cServer   := PadR(Trim( GetMV( 'FS_SERVER',, '' ) ), 50 ) // smtp.ig.com.br ou 200.181.100.51
Local cEmail    := PadR(Trim( GetMV( 'FS_MAIL',, '' ) ), 50 ) // fulano@ig.com.br
Local cPass     := PadR(Trim( GetMV( 'FS_PASS',, '' ) ),  50 ) // 123abc
Local lResulConn := .T.
Local lResulSEND := .T.
Local lRet       := .T.
Local lEnv       := .T.
Local cError     := ''
Local cBody  	:= "Sr. Cliente. <br>"
Local cBody1 	:= "Sr. Cliente. <br>"
Local cBody2 	:= "Sr. Cliente. <br>"
Local nPag      := 0



cBody  	:= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'
cBody  	+= '<html>'
cBody  	+= '<head>'
cBody  	+= '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
cBody  	+= '<title>Boleto</title>'
cBody  	+= '</head>'
cBody   += '<p>Sr(a) Cliente, <br />'

cServer   := AllTrim( cServer )
cEmail    := AllTrim( cEmail )
cPass     := AllTrim( cPass )

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
	Get MAIL ERROR cError
	ApMsgStop( 'Falha na conexão com server de e-mail ( ' + AllTrim( cError ) + ' ) ')
	Return  .F.
EndIf

/*If lAuth
//
// Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
//
If ! ( lRet := MailAuth( cContAuth, cPswAuth )	 )
//
// Se nao conseguiu fazer a Autenticacao usando o E-mail completo,
// tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
//
If !lRet
nA 	      := At( '@', cContAuth )
cContAuth := iIf( nA > 0, SubStr( cContAuth, 1, nA - 1 ), cContAuth )

If !( lRet  := MailAuth( cContAuth, cPswAuth ) )
ApMsgAlert( 'Não conseguiu autenticar conta ( ' + cContAuth + ' ) ')
DISCONNECT SMTP SERVER
Return  .F.
EndIf

EndIf
EndIf
EndIf

*/
conout('envio')
For nPag := 1 To Len(aPgto)
	conout(strzero(Len(aPgto),2)+''+aPgto[nPag,1]+'|')
	
	IF at("@",aPgto[nPag,1]) == 0 .or. len(alltrim(aPgto[nPag,1])) == 0
		ALERT('Mensalista cadastrado para não enviar e-mail' + chr(13) + chr(10) + ;
		'Verificar no Cadastro do Mensalista ou do Unificado para envio de e-mail'+ chr(13) + chr(10)+;
		"O Boleto " + aPgto[nPag,2]+" não será enviado " )
		lEnv := .F.
		nPag++
		loop
	endif
	
	If !Empty(aPgto[nPag,2])     //// If !Empty(aPgto[nPag,1])
		lEnv := .T.
		cAssunto := "Envio Cobranca: Boleto " + aPgto[nPag,2]
		
		//		cAttach  := _cPathJpeg + aPgto[nPag,2] + ".jpg_pag1.jpg"
		cBody1  := '<p>'+aPgto[nPag,12]+'<br />'
		cBody1  += '<p>Segue anexo o boleto bancario para pagamento de sua mensalidade de estacionamento.<br />'
		cBody1  += '- Em caso de divergencias nas informacoes, favor entrar em contato.<br />'
		cBody1  += '<p>Emissao :    '+StrZero(Day(aPgto[nPag,6]),2) +"/"+ StrZero(Month(aPgto[nPag,6]),2) +"/"+ Right(Str(Year(aPgto[nPag,6])),4)+'<br />'
		cBody1  += 'Vencimento :    '+StrZero(Day(aPgto[nPag,7]),2) +"/"+ StrZero(Month(aPgto[nPag,7]),2) +"/"+ Right(Str(Year(aPgto[nPag,7])),4)+'<br />'
		cBody1  += 'Valor      :    '+Alltrim(Transform(aPgto[nPag,8],"@E 99,999,999.99"))+'<br />'
		cBody1  += '<p>'+aPgto[nPag,9] +'<br />'
		cBody1  += aPgto[nPag,10] +'<br />'
		cBody2  := '<p>Ou, se preferir, utilize a linha digitada abaixo para pagamento via internet banking:<br />'
		cBody2  += '<p><strong>'+aPgto[nPag,11]+'</strong></p>'
		cBody2 	+= '<p><strong>Sistema Estapar Riopark</strong><br />'
		cBody2 	+= '<a title="http://www.estapar.com.br/" href="http://WWW.estapar.com.br">www.estapar.com.br</a></p>'
		cBody2 	+= '<p>0800-105560<br />'
		cBody2 	+= '<a title="mailto:sac@estapar.com.br" href="mailto:sac@estapar.com.br">sac<em title="mailto:sac@estapar.com.br"><span title="mailto:sac@estapar.com.br">@</span></em>estapar.com.br</a></p>'
		cBody2 	+= '<p>-   Instrucoes para impressao do boleto;<br />'
		cBody2 	+= '  - Este boleto deve ser impresso em papel (A4);<br />'
		cBody2 	+= '  - Para melhor impressao deixe as margens da internet explore   zeradas;</p>'
		cBody2 	+= '</html>'
		
		ConfirmMailRead( .T. )
		
		cAttach  := aPgto[nPag,13]
		
		SEND MAIL FROM cEmail ;
		TO aPgto[nPag,1] ;
		SUBJECT cAssunto ;
		BODY cBody+cBody1+cBody2 ;
		ATTACHMENT cAttach;
		RESULT lResulSEND
		
		conout(cEmail)
		
		conout(cAssunto)
		//<<<<<<<<<<<<< ALTERADO FACRI 07.10.2011>>>>>>>>>>>>
		//		SEND MAIL FROM cEmail ;
		//		TO "doliveira@facri.com.br; vinicius.batista@estapar.com.br; rgoncalves@facri.com.br" ;
		//		SUBJECT cAssunto ;
		//		BODY cBody+cBody1+cBody2 ;
		//		ATTACHMENT cAttach;
		//		RESULT lResulSEND
		
		If !lResulSEND
			Get MAIL ERROR cError
			ApMsgStop( 'Falha no Envio do e-mail ( ' + AllTrim( cError ) + ' ) '+aPgto[nPag,2] )   //+chr(13)+chr(10)+"Server: "+alltrim(cServer)+", usuário: "+cMail
			
			aAreaPDDw := PDD->(GetArea())
			
			PDD->(dbSetorder(5))
			
			If PDD->(dbSeek(FWXFILIAL("PDD")+aPgto[nPag,14]+'001'+aPgto[nPag,5],.T.))
				While PDD->(!EOF()) .and.  PDD->PDD_CODEMP+PDD->PDD_NUMCOB+PDD->PDD_MESANO == aPgto[nPag,3]+aPgto[nPag,14]+aPgto[nPag,5]
					If MV_PAR12 == 2
						RecLock("PDD",.F.)
						PDD->PDD_DTEMCO := dDataBase
						PDD->PDD_HOREMI := Time()
						PDD->PDD_ORIEMI := 'E'
						PDD->PDD_STATUS := '4'
						PDD->PDD_ERRO   := AllTrim( cError )
						MsUnlock()
					Endif
					PDD->(dBskip())
					
				End
			Endif
			RestArea(aAreaPDDw)
			
			Exit
		Else
			lEnv := .T.
			aAreaPDDw := PDD->(GetArea())
			PDD->(dbSetorder(5))
			If PDD->(dbSeek(FWXFILIAL("PDD")+aPgto[nPag,14]+'001'+aPgto[nPag,5],.T.))
				While PDD->(!EOF()) .and.  PDD->PDD_CODEMP+PDD->PDD_NUMCOB+PDD->PDD_MESANO == aPgto[nPag,3]+aPgto[nPag,14]+aPgto[nPag,5]
					
					If MV_PAR12 == 2
						RecLock("PDD",.F.)
						PDD->PDD_DTEMCO := dDataBase
						PDD->PDD_HOREMI := Time()
						PDD->PDD_ORIEMI := 'E'
						if PDD->PDD_STATUS == '2' .OR. PDD->PDD_STATUS == ' '
							PDD->PDD_STATUS := '1'
						Else
							PDD->PDD_STATUS := '3'
						Endif
						PDD->PDD_ERRO   := aPgto[nPag,1]
						MsUnlock()
					Endif
					PDD->(dBskip())
				End
				
			Endif
			RestArea(aAreaPDDw)
			
		Endif
		
	Endif
	
Next nPag

If lResulSEND .and. lEnv
	ApMsgInfo( 'E-mail enviado com sucesso' )
	conout('Envio de email teste')
Endif

DISCONNECT SMTP SERVER

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExisteDir ºAutor  ³Valdemir jose       º Data ³  13/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se existe o diretorio na maquina				      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTAPAR                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ExisteDir(pcDir)
Local lRetorno := .F.

lRetorno := (aScan(Directory(pcDir, "D"), {|z| z[5] == "D"}) > 0)

Return lRetorno

User Function Modulo10cr(cData)
Local L,D,P := 0
Local B     := .F.

L := Len(cData)  //TAMANHO DE BYTES DO CARACTER
B := .T.
D := 0     //DIGITO VERIFICADOR
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End


Return(D)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Modu10ES  ºAutor  ³Valdemir jose       º Data ³  13/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do modulo 10 									  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESTAPAR                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Modu10Es( cNum )
Local nFor    := 0
Local nTot    := 0
Local cNumAux

// Verifico o numero de digitos e impar
// Caso seja, adiciono um caracter
If Len(cNum)%2 #0
	cNum := "0"+cNum
EndIf

For nFor := 1 To Len(cNum)
	If nFor%2 == 0
		cNumAux := StrZero(2 * Val(SubStr(cNum,nFor,1)), 2)
	Else
		cNumAux := StrZero(Val(SubStr(cNum,nFor,1))    , 2)
	Endif
	nTot += ( Val(LEFT(cNumAux,1)) + Val(Right(cNumAux,1)) )
Next nFor

nTot := nTot % 10
nTot := Iif( nTot#0, 10-nTot, nTot )

Return Str(nTot,1)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³add_to_barºAutor  ³Microsiga           º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno de código de barras para boleto bancário           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function add_to_bar(code,num)
Local cBarCode := ""
DO CASE
	case code == '00'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '01'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '02'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '03'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '04'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '05'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '06'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '07'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '08'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '09'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '10'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '11'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '12'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '13'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '14'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '15'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '16'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '17'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '18'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '19'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '20'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '21'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '22'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '23'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '24'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '25'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '26'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '27'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '28'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '29'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '30'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '31'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '32'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '33'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '34'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '35'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '36'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '37'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '38'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '39'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '40'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '41'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '42'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '43'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '44'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '45'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '46'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '47'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '48'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '49'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '50'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '51'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '52'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '53'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '54'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '55'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '56'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '57'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '58'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '59'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '60'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '61'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '62'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '63'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '64'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '65'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '66'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '67'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '68'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '69'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '70'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '71'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '72'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '73'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '74'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '75'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '76'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '77'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
	case code == '78'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '79'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
	case code == '80'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '81'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '82'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '83'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '84'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '85'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '86'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '87'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '88'
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '89'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '90'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '91'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '92'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '93'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '94'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '95'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '96'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '97'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wl()
	case code == '98'
		cBarCode += add_bt()
		cBarCode += add_wl()
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '99'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bl()
		cBarCode += add_wl()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '100'
		cBarCode += add_bt()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wt()
	case code == '101'
		cBarCode += add_bl()
		cBarCode += add_wt()
		cBarCode += add_bt()
		cBarCode += add_wl()
endcase
Return cBarCode

/* funcoes utilizadas para o codigo de barra */
/* Barra branca fina */
/* autor. wilker */

Static Function add_wt()

Local cRetorno := ""
Local cFolder  := AllTrim(GetMV("ES_PATHIMG"))

cFolder := Iif( Right(cFolder,1) == "/" , Left(cFolder,Len(cFolder)-1) , cFolder )
cRetorno := "<img SRC='"+cFolder+"/w.gif' width='1' height='52'>"

Return cRetorno

//--------------------------------------
/* Barra branca larga */
/* autor. wilker */
//--------------------------------------
Static Function add_wl()

local cRetorno := ""
local cFolder  := AllTrim(GetMV("ES_PATHIMG"))

cFolder := iif( Right(cFolder,1) == "/" , Left(cFolder,Len(cFolder)-1) , cFolder )
cRetorno := "<img SRC='"+cFolder+"/w.gif' width='3' height='52'>"

Return cRetorno


/* Barra preta fina  */
/* autor. wilker */
Static Function  add_bt()

local cRetorno := ""
local cFolder  := AllTrim(GetMV("ES_PATHIMG"))

cFolder := Iif( Right(cFolder,1) == "/" , Left(cFolder,Len(cFolder)-1) , cFolder )
cRetorno := "<img SRC='"+cFolder+"/b.gif' width='1' height='52'>"

Return cRetorno


/* Barra preta larga  */
/* autor. wilker */
Static Function  add_bl()
local cRetorno := ""
local cFolder  := AllTrim(GetMV("ES_PATHIMG"))

cFolder := Iif( Right(cFolder,1) == "/" , Left(cFolder,Len(cFolder)-1) , cFolder )
cRetorno := "<img SRC='"+cFolder+"/b.gif' width='3' height='52'>"

Return cRetorno

//////////////////////////////////////////////////////////////////////////////////////


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ MODULO11()  ³ Autor ³ Microsiga        ³ Data ³ 03/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Calculo do modulo 11 para HSBC                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Modu11Es(cData)
LOCAL L, D, P := 0
L := LEN(cdata)
D := 0
P := 1
WHILE L > 0
	P := P + 1
	D := D + (VAL(SUBSTR(cData, L, 1)) * P)
	IF P = 9
		P := 1
	ENDIF
	L := L - 1
END
D := 11 - (mod(D,11))
IF (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
ENDIF
RETURN(Str(D,1))


//------------------------------------------
//
//------------------------------------------
Static Function Modulo12CNR(cData,cBanc)

Local L, D, P := 0
Local D1 := ""
If cBanc == "237"  // Bradesco
	L := Len(cData)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 7
			P := 1
		Endif
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 11)
		D1 := "0"
	ElseIf (D == 10)
		D1 := "P"
	Else
		D1 := str(D)
	Endif
Endif

Return(Alltrim(D1))

//-------------------------------------------------
// Valida se existe conexão para envio e email
// e constroe o diretorio de impressão do boleto.
//-------------------------------------------------

Static Function ESTVLD()
lEnvia	   := .F.
lContinua := .T.

If mv_par12 == 2
	lEnvia:= VerifConex()
Endif

If lContinua
	
	cResLocal := "\BOLETOS\"
	//Verifica a existencia do diretório informado
	if !ExisteDir(cResLocal)
		MontaDir(cResLocal)
	Endif
	
	ListPDD()
	
Endif

Return Nil
