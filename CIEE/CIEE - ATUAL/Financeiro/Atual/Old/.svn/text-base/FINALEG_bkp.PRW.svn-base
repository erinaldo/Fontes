#INCLUDE "rwmake.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FINALEG     ³ Autor ³ CLAUDIO BARROS      ³ Data ³ 20.05.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse ou retorna a ³±±
±±³          ³ para o BROWSE                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fina050                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FINALEG(nOpcLeg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aLegenda := {}
Local uRetorno
Local cAlias := Alias()
Local cLibPag := GETMV("MV_CTLIPAG")
Static lVez

//MSGINFO("Conteudo Liberacao  ",GETMV("MV_CTLIPAG"))

IF cLibPag == .F.
	aLegenda := { 	{"BR_VERDE"   , "Titulo em aberto"     },;
					{"BR_AZUL"    , "Baixado parcialmente" },;
					{"BR_VERMELHO", "Titulo Baixado"       }}
	If Empty(lVez) 	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
		lVez := .T.
		uRetorno := {}
		If cAlias = "SE1"
			Aadd(aLegenda, {"BR_AMARELO", "Titulo Protestado"})
			Aadd(uRetorno, { 'ROUND(E1_SALDO,2) = 0', aLegenda[3][1] } )
			Aadd(uRetorno, { 'ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2)', aLegenda[2][1] } )
			Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F"', aLegenda[4][1] } )
			Aadd(uRetorno, { '.T.', aLegenda[1][1] } )
		Else
			Aadd(uRetorno, { 'ROUND(E2_SALDO,2) = 0', aLegenda[3][1] } )
			Aadd(uRetorno, { 'ROUND(E2_SALDO,2) # ROUND(E2_VALOR,2)', aLegenda[2][1] } )
			Aadd(uRetorno, { '.T.', aLegenda[1][1] } )
		Endif
	Else
		BrwLegenda(cCadastro, "Legenda", aLegenda)
	Endif
ELSE
	If Alltrim(FunName()) == "FINA050" .OR. Alltrim(FunName()) == "FINA090" .OR. Alltrim(FunName()) == "FINA080"
		aLegenda := { 	{"BR_AMARELO" , "Aguardando Liberacao" },;	// "Liberador Pgto."
						{"BR_VERDE"   ,"Pgto Liberado"         },;	// "Titulo em aberto"
						{"BR_AZUL"    , "Baixado parcialmente" },;
						{"BR_VERMELHO", "Titulo Baixado"       },;
						{"BR_PRETO"   , "Titulo em Bordero"    }}
		dbSelectArea("SE2")
		dbSetOrder(1)
		uRetorno := .T.
		If Empty(lVez)   // Via menu, a opcao passada eh 1.
			lVez := .T.
			uRetorno := {}
			Aadd(uRetorno, { 'E2_DATALIB = Ctod("//")'							, aLegenda[1][1] } )
			Aadd(uRetorno, { 'ROUND(E2_SALDO,2) = 0 .AND. !EMPTY(E2_DATALIB)'	, aLegenda[4][1] } )
			Aadd(uRetorno, { 'ROUND(E2_SALDO,2) # ROUND(E2_VALOR,2)'			, aLegenda[3][1] } )
			Aadd(uRetorno, { 'ROUND(E2_SALDO,2) = ROUND(E2_VALOR,2) .and. !EMPTY(E2_NUMBOR)', aLegenda[5][1] } )
			Aadd(uRetorno, { '.T.'												, aLegenda[2][1] } )
		Else
			BrwLegenda(cCadastro, "Legenda", aLegenda)
		Endif
	Else
		cAlias := "SE1"
		aLegenda := { 	{"BR_VERDE", "Titulo em aberto" },;	
						{"BR_AZUL", "Baixado parcialmente" },;
						{"BR_VERMELHO", "Titulo Baixado" } }
		dbSelectArea("SE1")
		dbSetOrder(1)
		
		uRetorno := .T.
		
		If Empty(lVez) 	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
			lVez := .T.
			uRetorno := {}
			If cAlias = "SE1"
				Aadd(aLegenda, {"BR_AMARELO", "Titulo Protestado"})
				Aadd(uRetorno, { 'ROUND(E1_SALDO,2) = 0', aLegenda[3][1] } )
				Aadd(uRetorno, { 'ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2)', aLegenda[2][1] } )
				Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F"', aLegenda[4][1] } )
				Aadd(uRetorno, { '.T.', aLegenda[1][1] } )
			Else
				Aadd(uRetorno, { 'ROUND(E2_SALDO,2) = 0', aLegenda[3][1] } )
				Aadd(uRetorno, { 'ROUND(E2_SALDO,2) # ROUND(E2_VALOR,2)', aLegenda[2][1] } )
				Aadd(uRetorno, { '.T.', aLegenda[1][1] } )
			Endif
		Else
//		If cAlias = "SE1"
//			Aadd(aLegenda,{"BR_AMARELO", "Titulo Protestado"}) //"Titulo Protestado"
//		Endif
		BrwLegenda(cCadastro, "Legenda", aLegenda)
		Endif
	Endif
EndIf

Return uRetorno