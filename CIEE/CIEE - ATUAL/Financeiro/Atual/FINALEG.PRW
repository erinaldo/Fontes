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

Local aLegenda := {}
Local uRetorno := {}
Local cAlias := Alias()
Local cLibPag := GETMV("MV_CTLIPAG")
Static lVez

If Alltrim(FunName()) == "FINA050" .OR. Alltrim(FunName()) == "FINA090" .OR. Alltrim(FunName()) == "FINA080"
	aLegenda := { 	{"BR_AMARELO" , "Aguardando Liberacao" },;
					{"BR_VERDE"   , "Pgto Liberado"        },;
					{"BR_AZUL"    , "Baixado parcialmente" },;
					{"BR_VERMELHO", "Titulo Baixado"       },;
					{"BR_PRETO"   , "Titulo em Bordero"    }}
	dbSelectArea("SE2")
	dbSetOrder(1)
	uRetorno := .T.
	If Empty(lVez)   // Via menu, a opcao passada eh 1.
		lVez := .T.
		uRetorno := {}
		Aadd(uRetorno, { 'E2_DATALIB = Ctod("//")'										, aLegenda[1][1] } )
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2) = 0 .AND. !EMPTY(E2_DATALIB)'				, aLegenda[4][1] } )
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2) # ROUND(E2_VALOR,2)'						, aLegenda[3][1] } )
		Aadd(uRetorno, { 'ROUND(E2_SALDO,2) = ROUND(E2_VALOR,2) .and. !EMPTY(E2_NUMBOR)', aLegenda[5][1] } )
		Aadd(uRetorno, { '.T.'															, aLegenda[2][1] } )
	Else
		BrwLegenda(cCadastro, "Legenda", aLegenda)
	Endif
EndIf

Return uRetorno