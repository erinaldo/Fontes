#INCLUDE "TOTVS.CH" 

#DEFINE ENTER CHR(13)+CHR(10)

/*/

{Protheus.doc} AVALGER
                 
Lista de Pedidos que necessitam de aprovação

@author  Milton J.dos Santos	
@since   22/07/20
@version 1.0

/*/

User Function AVALGER()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
Local cCondicao := ""
Local aIndSC5   := {}
Local aCores    := {{"C5_BLQ == 'X'", "BR_BRANCO"}}

If ( cPaisLoc $ "ARG|POR|EUA" )
	Private aArrayAE:={}
EndIf
Private cCadastro := OemToAnsi("Liberacao do Bloqueio Comercial")		// STR0005   "Libera‡„o de Cr‚dito / Estoque"
Private aRotina := MenuDef()
	
If ! __cUserId $ GetMV('FS_GERMAST',,"000000")
	DbSelectArea("SA3")
	SA3->(DBSETORDER(7))
	IF ! Dbseek( xfilial("SA3") + __cUserID)
		MsgStop("Rotina disponivel apenas para o gerente comercial !")
		Return
	ENDIF
Endif

If VerSenha(136) .And. VerSenha(137)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³EXECUTAR CHAMADA DE FUNCAO p/ integracao com sistema de Distribuicao - NAO REMOVER ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	dbSetOrder(1)
    If __cUserId $ GetMV('FS_GERMAST',,"000000")
		cCondicao := "C5_FILIAL =='"+xFilial("SC5")+"' .And. C5_BLQ == 'X' "
	Else
		cCondicao := "C5_FILIAL =='"+xFilial("SC5")+"' .And. C5_BLQ == 'X' .And. C5_VEND1 $ " + U_PEGAVEN()
	Endif
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	If ( Eof() )
		HELP(" ",1,"RECNO")
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a filtragem somente na função de browse para permitir o usuário ³
		//³incluir filtros customizados na rotina                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		mBrowse( 7, 4,20,74,"SC5",,,,,,aCores,,,,,,,,,,,,cCondicao) //,,"SC9->C9_BLEST+SC9->C9_BLCRED"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a integridade da rotina                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	RetIndex("SC5")
	dbClearFilter()
	aEval(aIndSC5,{|x| Ferase(x[1]+OrdBagExt())})
Else
	HELP(" ",1,"SEMPERM")
Endif
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()
  
Private aRotina	:= {{"Avaliação", "U_APRGER", 0, 2, 0, .T.},;	// 	STR0004
               	    {"Pesquisar", "PesqBrw",    0, 1, 0, .F.}}	// STR0001
               	    //{"Automática", "U_A456LibAut", 0, 2, 0, .T.},;	// STR0003
               	    //{STR0037, "A450Legend", 0, 8, 0, .F.},;	// "Legenda"

Return(aRotina)

User Function PEGAVEN()
Local aArea     := GetArea()
Local cSQL   	:= ""
Local cGerente	:= ""

	DbSelectArea("SA3")
	SA3->(DBSETORDER(7))
	IF Dbseek( xfilial("SA3") + __cUserID)
		cGerente := SA3->A3_COD
	ENDIF
	SA3->(DBSETORDER(1))
	SA3->( DbGoTop() )
	While ! SA3->(EOF())
		If SA3->A3_GEREN == cGerente
			cSQL += "'" + AllTrim(SA3->A3_COD) + "'|"
		Endif
		SA3->( DbSkip() )
	EndDo
    cSQL := Substr(cSQL,1,len(cSQL)-1)
    RestArea(aArea)

Return(cSQL)

/*/

{Protheus.doc} APRGER
                 
Tela de Aprovação comercial

@author  Milton J.dos Santos	
@since   22/07/20
@version 1.0

/*/

User Function APRGER()
Local aArea     := GetArea()
Local cTitulo   := "Solicitação de Aprovação"
Local cNumPed   := SC5->C5_NUM // Número do Pedido
Local cNomCli 	:= AllTrim(SC5->C5_CLIENTE + " - " + POSICIONE('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE, 'A1_NOME')) // Código e Nome do Cliente
Local cDtPed    := DtoC(SC5->C5_EMISSAO) // Data do Pedido
Local cCondPG   := AllTrim(SC5->C5_CONDPAG + " - " + POSICIONE('SE4', 1, xFilial('SE4') + SC5->C5_CONDPAG, 'E4_DESCRI')) // Código e Descrição da condição de Pagamento 
Local cNomVen	:= AllTrim(SC5->C5_VEND1 + " - " + POSICIONE('SA3', 1, xFilial('SA3') + SC5->C5_VEND1, 'A3_NOME')) // Código e Nome do Vendedor 
Local oButton1
Local oButton2
Local oButton3
Local oCondPG
Local oDtPed
Local oNomCli
Local oNomVen
Local oNumPed
Local oRed1
Local oBlue1
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSay10
Local oValTot
Static oDlgMain

Private sMoeda		:= MV_SIMB1
Private nTotal		:= 0
Private aWBrowse1	:= {} 
Private cValTot 	:= "" //sMoeda+" "+TRANSFORM(nTotal, "@E 999.999,99")
Private cJust 		:= ""
Private oJust
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Leds utilizados para as legendas das rotinas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Private oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Private oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
//Private oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
//Private oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
//Private oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Private oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
//Private oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
//Private oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
//Private oPink		:= LoadBitmap( GetResources(), "BR_PINK")
//Private oGray		:= LoadBitmap( GetResources(), "BR_CINZA")

DEFINE MSDIALOG oDlgMain TITLE cTitulo  OF oMainWnd PIXEL FROM 040,040 TO 430,1200 COLORS 0, 12632256
DEFINE FONT oFont1	NAME "Mono AS"	SIZE 10, 18
DEFINE FONT oFont2	NAME "Mono AS"	SIZE 11, 19
DEFINE FONT oBold   NAME "Arial"	SIZE 0, -12 BOLD
DEFINE FONT oBold2  NAME "Arial"	SIZE 0, -40 BOLD

TGroup():New(029,008,91,571,,oDlgMain,,,.T.)

@ 007, 009 SAY   oSay1   PROMPT "Pedido"                 SIZE 043, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256
@ 015, 008 MSGET oNumPed VAR    cNumPed                  SIZE 043, 010 PIXEL OF oDlgMain When .F.   COLORS 0, 16777215
@ 007, 050 SAY   oSay2   PROMPT "Cliente"                SIZE 154, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256
@ 015, 050 MSGET oNomCli VAR    cNomCli                  SIZE 154, 010 PIXEL OF oDlgMain When .F.   COLORS 0, 16777215
@ 007, 203 SAY   oSay3   PROMPT "Data do Pedido"         SIZE 062, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256
@ 015, 203 MSGET oDtPed  VAR    cDtPed PICTURE "@!"      SIZE 062, 010 PIXEL OF oDlgMain When .F.   COLORS 0, 16777215
@ 007, 264 SAY   oSay4   PROMPT "Condição do Pagamento"  SIZE 094, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256
@ 015, 264 MSGET oCondPG VAR    cCondPG                  SIZE 094, 010 PIXEL OF oDlgMain When .F.   COLORS 0, 16777215
@ 006, 357 SAY   oSay5   PROMPT "Vendedor"               SIZE 106, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256
@ 015, 357 MSGET oNomVen VAR    cNomVen                  SIZE 106, 010 PIXEL OF oDlgMain When .F.   COLORS 0, 16777215
@ 006, 462 SAY   oSay6   PROMPT "Valor Total"            SIZE 110, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256
@ 015, 462 MSGET oValTot VAR    cValTot					 SIZE 110, 010 PIXEL OF oDlgMain When .F.   COLORS 0, 16777215
@ 100, 012 SAY   oSay7   PROMPT "JUSTIFICATIVA"          SIZE 045, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256 
@ 108, 008 GET   oJust   VAR    cJust                    SIZE 560, 066 PIXEL OF oDlgMain MULTILINE  COLORS 0, 16777215 HSCROLL 
@ 096, 385 SAY   oSay10  PROMPT "Legenda:"               SIZE 025, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256 
@ 094, 414 MSGET oRed1   VAR    oRed                     SIZE 015, 010 PIXEL OF oDlgMain READONLY   COLORS 0, 12632256  
@ 095, 432 SAY   oSay8   PROMPT "Com Bloqueio Comercial" SIZE 062, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256 
@ 094, 494 MSGET oBlue1  VAR    oBlue                    SIZE 015, 010 PIXEL OF oDlgMain READONLY   COLORS 0, 12632256  
@ 095, 512 SAY   oSay9   PROMPT "Sem Bloqueio Comercial" SIZE 059, 007 PIXEL OF oDlgMain FONT oBold COLORS 0, 12632256 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GRID 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

fWBrowse1()

@ 179, 443 BUTTON oButton1 PROMPT "Aprovar"   SIZE 037, 012 OF oDlgMain ACTION (IIF(Decisao( '2' ),oDlgMain:End(),))  PIXEL
@ 179, 487 BUTTON oButton2 PROMPT "Reprovar"  SIZE 037, 012 OF oDlgMain ACTION (IIF(Decisao( '1' ),oDlgMain:End(),)) PIXEL
@ 179, 531 BUTTON oButton3 PROMPT "Abandonar" SIZE 037, 012 OF oDlgMain ACTION (oDlgMain:End()) 				 PIXEL

ACTIVATE MSDIALOG oDlgMain  CENTERED
RestArea(aArea)
RETURN

//------------------------------------------------
Static Function fWBrowse1()
//------------------------------------------------
	Local aArea     := GetArea()
	Local aDados	:= {}
	Local oWBrowse1

	aDados := U_DADOSAPRO() // Busca dados do pedido para aprovação

	aWBrowse1 := aDados[1]
	nTotal	  := aDados[2]
	cValTot   := sMoeda+" "+AllTrim(TRANSFORM(nTotal, "@E 999,999.99"))

    @ 029, 009 LISTBOX oWBrowse1 Fields HEADER "STATUS","CODIGO","DESCRICAO","QTDE","PRECO TABELA","MINIMO ACEITAVEL","UNITÁRIO","TOTAL","DESCONTO","% DESCONTO","% MARGEM","VALOR MARGEM","DESCONTO MINIMO","DESCONTO MAXIMO","GRUPO PRODUTO" SIZE 561, 062 OF oDlgMain PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      aWBrowse1[oWBrowse1:nAt,1],;
      aWBrowse1[oWBrowse1:nAt,2],;
      aWBrowse1[oWBrowse1:nAt,3],;
      aWBrowse1[oWBrowse1:nAt,4],;
      aWBrowse1[oWBrowse1:nAt,5],;
      aWBrowse1[oWBrowse1:nAt,6],;
      aWBrowse1[oWBrowse1:nAt,7],;
      aWBrowse1[oWBrowse1:nAt,8],;
      aWBrowse1[oWBrowse1:nAt,9],;
      aWBrowse1[oWBrowse1:nAt,10],;
      aWBrowse1[oWBrowse1:nAt,11],;
      aWBrowse1[oWBrowse1:nAt,12],;
      aWBrowse1[oWBrowse1:nAt,13],;
      aWBrowse1[oWBrowse1:nAt,14],;
      aWBrowse1[oWBrowse1:nAt,15];
    }}
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
      oWBrowse1:DrawSelect()}
RestArea(aArea)
Return


Static Function Decisao( cApro )
Local aArea := GetArea()
Local lRet  := .F.
Local cBloq	:= ""

	If SC5->C5_TIPO == "N"
		If nTotal > GetMV('FS_VLRGAR',,0)
			cBloq  := "Y"
		Endif
	Endif

	If cApro == "2"
    	  	RECLOCK('SC5',.F.)
			// Altera o C5_BLQ
			SC5->C5_XDTAVAL	:= DATE()
			SC5->C5_XOBS	:= cJust
			SC5->C5_XAVAL	:= "A"
    	  	SC5->C5_BLQ 	:= Iif( cApro == "2",cBloq,"X") 
    	  	MsgInfo("Pedido " + SC5->C5_NUM + " Aprovado com Sucesso!")
			lRet := Iif( SC5->C5_BLQ <> "X",.T.,.F.) 
    	  	SC5->(MSUNLOCK())
		//ENDIF
   		DBCloseArea()
	Else
		RECLOCK('SC5',.F.)

		SC5->C5_XDTAVAL	:= DATE()
		SC5->C5_XOBS	:= cJust
		SC5->C5_XAVAL	:= "R"
		SC5->(MSUNLOCK())
   		DBCloseArea()
		MsgInfo("Pedido " + SC5->C5_NUM + " Reprovado com Sucesso!")
		lRet := .T.
	EndIF
	RestArea(aArea)
Return(lRet)

User Function DADOSAPRO()
	Local aArea     := GetArea()
	Local cQuery    := ""
	Local cAliasTRB := GetNextAlias()
	Local aDados	:= {}
	Local nValTot	:= 0
	Local sMoeda	:= MV_SIMB1

	cQuery := " SELECT DISTINCT " + ENTER
	cQuery += " SC6.C6_XOFERTA AS RB_XOFERTA, " + ENTER
	cQuery += " SC6.C6_PRODUTO AS RB_PRODUTO, " + ENTER
	cQuery += " SC6.C6_DESCRI  AS RB_DESCRI, " + ENTER
	cQuery += " SC6.C6_QTDVEN  AS RB_QTDVEN, " + ENTER
	cQuery += " DA1.DA1_PRCVEN AS RB_PRCVENT, " + ENTER
	cQuery += " ISNULL((SB2.B2_CM1 + ((SB2.B2_CM1*SBZ.BZ_MARKUP)/100)),0) AS RB_PREMIN, " + ENTER
	cQuery += " SC6.C6_PRCVEN  AS RB_PRCVEN, " + ENTER
	cQuery += " SC6.C6_VALOR   AS RB_VALOR, " + ENTER
	cQuery += " SC6.C6_VALDESC AS RB_VALDESC, " + ENTER
	cQuery += " SC6.C6_DESCONT AS RB_DESCONT, " + ENTER
	cQuery += " (SC6.C6_DESCONT-SZC.ZC_DESMAX) AS RB_MARGEMP, " + ENTER
	cQuery += " (SC6.C6_VALOR*(SC6.C6_DESCONT-SZC.ZC_DESMAX)/100) AS RB_MARGEMV, " + ENTER
	cQuery += " SZC.ZC_DESMIN AS RB_DESMIN, " + ENTER
	cQuery += " SZC.ZC_DESMAX AS RB_DESMAX, " + ENTER
	cQuery += " CONCAT(SB1.B1_GRUPO,' - ',SBM.BM_DESC) AS RB_GRUPO " + ENTER
	cQuery += " FROM " + ENTER
	cQuery += "  " + RetSQLName("SC6") + " SC6 " + ENTER
	cQuery += " INNER JOIN " + RetSQLName("SC5") + " SC5 ON SC5.D_E_L_E_T_ <> '*' AND SC5.C5_NUM = SC6.C6_NUM " + ENTER
	cQuery += " INNER JOIN " + RetSQLName("DA1") + " DA1 ON DA1.D_E_L_E_T_ <> '*' AND DA1.DA1_CODPRO = SC6.C6_PRODUTO " + ENTER
	cQuery += " 						                AND DA1_CODTAB = SC5.C5_TABELA " + ENTER
	cQuery += " LEFT JOIN " + RetSQLName("SB2") + " SB2 ON SB2.D_E_L_E_T_ <> '*' AND SB2.B2_COD = SC6.C6_PRODUTO " + ENTER
	cQuery += " LEFT JOIN " + RetSQLName("SBZ") + " SBZ ON SBZ.D_E_L_E_T_ <> '*' AND SBZ.BZ_COD = SC6.C6_PRODUTO " + ENTER
	cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = SC6.C6_PRODUTO " + ENTER
	cQuery += " INNER JOIN " + RetSQLName("SZC") + " SZC ON SZC.D_E_L_E_T_ <> '*' AND SC5.C5_VEND1 = SZC.ZC_VEND " + ENTER
	cQuery += " 						                AND SZC.ZC_GRPROD = SB1.B1_GRUPO " + ENTER
	cQuery += " INNER JOIN " + RetSQLName("SBM") + " SBM ON SBM.D_E_L_E_T_ <> '*' AND SBM.BM_GRUPO = SZC.ZC_GRPROD " + ENTER
	cQuery += " WHERE " + ENTER
	cQuery += " SC6.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " AND SC6.C6_NUM = '" + AllTrim(SC5->C5_NUM) + "' " + ENTER
	cQuery += " AND SC5.C5_VEND1 = '" + AllTrim(SC5->C5_VEND1) + "' "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)
	dbSelectArea(cAliasTRB)
	(cAliasTRB)->(dbGoTop())
	While !(cAliasTRB)->( Eof() )
		
	    Aadd(aDados,{IIF((cAliasTRB)->RB_XOFERTA == '3', oRed, oBlue),;
		                AllTrim((cAliasTRB)->RB_PRODUTO),;
		                AllTrim((cAliasTRB)->RB_DESCRI),;
		                        (cAliasTRB)->RB_QTDVEN,;
		                        sMoeda+" "+AllTrim(TRANSFORM((cAliasTRB)->RB_PRCVENT, "@E 999,999.99")),;
		                        sMoeda+" "+AllTrim(TRANSFORM((cAliasTRB)->RB_PREMIN, "@E 999,999.99")),;
		                        sMoeda+" "+AllTrim(TRANSFORM((cAliasTRB)->RB_PRCVEN, "@E 999,999.99")),;
		                        sMoeda+" "+AllTrim(TRANSFORM((cAliasTRB)->RB_VALOR, "@E 999,999.99")),;
		                        sMoeda+" "+AllTrim(TRANSFORM((cAliasTRB)->RB_VALDESC, "@E 999,999.99")),;
		                        STR((cAliasTRB)->RB_DESCONT)+"%",;
		                        STR((cAliasTRB)->RB_MARGEMP)+"%",;
		                        sMoeda+" "+AllTrim(TRANSFORM((cAliasTRB)->RB_MARGEMV, "@E 999,999.99")),;
		                        STR((cAliasTRB)->RB_DESMIN)+"%",;
		                        STR((cAliasTRB)->RB_DESMAX)+"%",;
		                AllTrim((cAliasTRB)->RB_GRUPO)})
		nValTot += (cAliasTRB)->RB_VALOR
	    (cAliasTRB)->( DbSkip() )
	EndDo
	(cAliasTRB )->( DbCloseArea() )
	RestArea(aArea)

Return({aDados,nValTot})
