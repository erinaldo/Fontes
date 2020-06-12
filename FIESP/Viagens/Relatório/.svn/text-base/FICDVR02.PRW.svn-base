#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  27/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICDVR02(nOrig)
Local aArea      := {GetArea(), SZ0->(GetArea()), SZ1->(GetArea()), SZ6->(GetArea())}
Local lRet       := .T.
Local cPerg      := "FICDVR01"
Local cDe        := ""
Local cAte       := ""
Local cQuery     := ""
Local cTab       := ""
Local aViagens   := {}
Local nI         := 0
Local cNum       := ""
Local cResponsa  := ""
Local cImpressao := ""
Local cImpresso  := ""
Local cViajante  := ""
Local cTipoVi    := ""
Local cTipo      := ""
Local cCCViaj    := ""
Local cCC        := ""
Local cTipoViag  := ""
Local aTrajeto   := {}
Local cHotel     := ""
Local cJustific1 := ""
Local cJustific2 := ""
Local cJustific3 := ""
Local cJustific4 := ""
Local nAdianta   := 0
Local aRateio    := {}
Local aDespesas  := {}
Local aSaldos    := {}

Local _lRet

Default nOrig := NIL

If nOrig == 1
	cDe          := AllTrim(SZ1->Z1_NUM)
	cAte         := AllTrim(SZ1->Z1_NUM)
	_lRet		 := .T.
Else
	If (Pergunte(cPerg, .T.))
		cDe          := AllTrim(mv_par01)
		cAte         := AllTrim(mv_par02)
		_lRet		 := .T.
	Else
		_lRet		 := .F.
	EndIf
EndIf

If _lRet
	
	cQuery       := "SELECT" + CRLF
	cQuery       += "Z1_NUM" + CRLF
	cQuery       += "FROM " + RetSQLName("SZ1") + "" + CRLF
	cQuery       += "WHERE Z1_FILIAL = '" + xFilial("SZ1") + "'" + CRLF
	cQuery       += "AND Z1_NUM BETWEEN '" + cDe + "' AND '" + cAte + "'" + CRLF
	cQuery       += "AND D_E_L_E_T_ = ''"
	
	cQuery       := ChangeQuery(cQuery)
	
	cTab         := GetNextAlias()
	
	TcQUERY cQuery NEW ALIAS ((cTab))
	
	DbSelectArea((cTab))
	(cTab)->(DbGoTop())
	
	While ((cTab)->(!Eof()))
		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		If (SZ1->(DbSeek(xFilial("SZ1") + (cTab)->(Z1_NUM))))
			cNum := SZ1->Z1_NUM
			cResponsa := Upper(SZ1->Z1_NOMSOL)
			cImpressao := DToC(dDataBase) + " - " + SubStr(Time(), 1, 5)
			cImpresso := Upper(UsrFullName(__cUserId))
			cViajante := SZ1->Z1_NOMVIAJ
			
			cTipoVi := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XTIPOVI")
			If !(Empty(cTipoVi))
				If (cTipoVi == "1")
					cTipo := "FUNCIONÁRIO"
				Elseif (cTipoVi == "2")
					cTipo := "DIRETOR"
				Elseif (cTipoVi == "3")
					cTipo := "CONVIDADO"
				Else
					cTipo := "OUTROS"
				Endif
			Endif
			
			cCCViaj := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XCCVIAJ")
			If !(Empty(cCCViaj))
				cCC := Posicione("CTT", 1, xFilial("CTT") + cCCViaj, "CTT_DESC01")
			Endif
			
			cTipoViag := retTpVg(xFilial("SZ1"), SZ1->Z1_NUM)
			aTrajeto := retTrajeto(xFilial("SZ1"), SZ1->Z1_NUM)
			cHotel := Iif(retHotel(xFilial("SZ1"), SZ1->Z1_NUM), "SIM", "NÃO")
			cJustific1 := Upper(SubStr(SZ1->Z1_JUSTIFI, 1, 75))
			cJustific2 := Upper(SubStr(SZ1->Z1_JUSTIFI, 76, 75))
			cJustific3 := Upper(SubStr(SZ1->Z1_JUSTIFI, 151, 75))
			cJustific4 := Upper(SubStr(SZ1->Z1_JUSTIFI, 226, 75))
			nAdianta := SZ1->Z1_ADIANTA
			aRateio := retRateio(xFilial("SZ1"), SZ1->Z1_NUM)
			aDespesas := retDespesas(xFilial("SZ1"), SZ1->Z1_NUM)
			aSaldos := retSaldos(xFilial("SZ1"), SZ1->Z1_NUM)
		Endif
		
		aAdd(aViagens, {cNum, cResponsa, cImpressao, cImpresso, cViajante, cTipo, cCC, cTipoViag, aTrajeto, ;
						cHotel, cJustific1, cJustific2, cJustific3, cJustific4, nAdianta, aRateio, aDespesas, aSaldos})

		(cTab)->(DbSkip())
	Enddo
	
	(cTab)->(DbCloseArea())

	If (Len(aViagens) > 0)
		RptStatus({|| CDVR02(aViagens)}, "Impressão de Relatório", "A g u a r d e . . .", .T.)
	Else
		Aviso("Aviso", "Nenhuma informação encontrada.", {"Ok"}, 1)
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Horizontal = 2479                                          º±±
±±º          ³ Vertical = 3508                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CDVR02(aViagens)
Local aArea     := {GetArea()}
Local lRet      := .T.
Local nValor    := 0
Local nI        := 0
Local nLinIni   := 0
Local nY        := 0

Private oPrint
Private cTitulo := "RELATÓRIO DE DESPESAS"
Private oFont1  := TFont():New("Courier New", , 16, , .T., , , , .F., .F.)
Private oFont2  := TFont():New("Courier New", , 12, , .T., , , , .F., .F.)
Private oFont3  := TFont():New("Courier New", , 12, , .F., , , , .F., .F.)
Private oFont4  := TFont():New("Courier New", , 10, , .T., , , , .F., .F.)
Private oFont5  := TFont():New("Courier New", , 10, , .F., , , , .F., .F.)
Private oFont6  := TFont():New("Courier New", , 08, , .T., , , , .F., .F.)
Private oFont7  := TFont():New("Courier New", , 08, , .F., , , , .F., .F.)

oPrint          := TMSPrinter():New(cTitulo)
oPrint:SetPortrait()
oPrint:SetPaperSize(9)
oPrint:Setup()

For nI := 1 To Len(aViagens)
	oPrint:StartPage()
	
	oPrint:Line(0100, 0100, 0100, 2379-100)
	oPrint:Line(0300, 0100, 0300, 2379-100)
	
	oPrint:Say(0305, 0150, "RESPONSÁVEL: ", oFont6)
	oPrint:Say(0335, 0150, "DATA DA IMPRESSÃO:", oFont6)
	oPrint:Say(0365, 0150, "IMPRESSO POR:", oFont6)
	
	oPrint:Say(0305, 0505, aViagens[nI][2], oFont7)
	oPrint:Say(0335, 0505, aViagens[nI][3], oFont7)
	oPrint:Say(0365, 0505, aViagens[nI][4], oFont7)
	
	oPrint:Line(0400, 0100, 0400, 2379-100)
	oPrint:Line(0450, 0100, 0450, 2379-100)
	oPrint:Line(0500, 0100, 0500, 2379-100)
	oPrint:Line(0550, 0100, 0550, 2379-100)
	oPrint:Line(0600, 0100, 0600, 2379-100)
	oPrint:Line(0650, 0100, 0650, 2379-100)
	oPrint:Line(0950, 0100, 0950, 2379-100)
	oPrint:Line(1100, 0100, 1100, 2379-100)
	
	oPrint:Say(0405, 0150, "DADOS DA AUTORIZAÇÃO", oFont2)
	
	oPrint:Say(0455, 0150, "Viajante:", oFont2)
	oPrint:Say(0505, 0150, "Tipo de Viajante:", oFont2)
	oPrint:Say(0555, 0150, "Área do Solicitante:", oFont2)
	oPrint:Say(0605, 0150, "Tipo de Viagem:", oFont2)
	oPrint:Say(0655, 0150, "Trajeto:", oFont2)
	oPrint:Say(0955, 0150, "Justificativa:", oFont2)
	
	oPrint:Say(0455, 0700, aViagens[nI][5], oFont5)
	oPrint:Say(0505, 0700, aViagens[nI][6], oFont5)
	oPrint:Say(0555, 0700, aViagens[nI][7], oFont5)
	oPrint:Say(0605, 0700, aViagens[nI][8], oFont5)
	
	nLinIni := 0655
	
	For nY := 1 To Len(aViagens[nI][9])
		oPrint:Say(nLinIni, 0700, aViagens[nI][9][nY][1], oFont5)
		
		nLinIni += 30
	Next nY
	
	oPrint:Say(0960, 0700, aViagens[nI][11], oFont6)
	oPrint:Say(1000, 0700, aViagens[nI][12], oFont6)
	oPrint:Say(1040, 0700, aViagens[nI][13], oFont6)
	oPrint:Say(1080, 0700, aViagens[nI][14], oFont6)

	oPrint:Line(0400, 0100, 1100, 0100)
	oPrint:Line(0400, 2379-100, 1100, 2379-100)
	
	oPrint:Line(1200, 0100, 1200, 2379-100)
	oPrint:Line(1250, 0100, 1250, 2379-100)
	oPrint:Line(1300, 0100, 1300, 2379-100)
	oPrint:Line(1550, 0100, 1550, 2379-100)
	
	oPrint:Say(1205, 0150, "DESPESAS", oFont2)
	
	oPrint:Say(1255, 0105, "Data", oFont2)
	oPrint:Say(1255, 0405, "Especificação", oFont2)
	oPrint:Say(1255, 2084, "Valor", oFont2)
	
	nLinIni := 1305
	
	For nY := 1 To Len(aViagens[nI][17])
		oPrint:Say(nLinIni, 0105, aViagens[nI][17][nY][1], oFont5)
		oPrint:Say(nLinIni, 0405, aViagens[nI][17][nY][2], oFont5)
		oPrint:Say(nLinIni, 2374-100, aViagens[nI][17][nY][3], oFont5, , , , 1)
		
		nLinIni += 30
	Next nY
	
	oPrint:Line(1200, 0100, 1550, 0100)
	oPrint:Line(1250, 0400, 1550, 0400)
	oPrint:Line(1250, 2079, 1550, 2079)
	oPrint:Line(1200, 2379-100, 1550, 2379-100)
	
	oPrint:Line(1650, 0100, 1650, 2379-100)
	oPrint:Line(1700, 0100, 1700, 2379-100)
	oPrint:Line(1750, 0100, 1750, 2379-100)
	oPrint:Line(1800, 0100, 1800, 2379-100)
	oPrint:Line(1850, 0100, 1850, 2379-100)
	oPrint:Line(1900, 0100, 1900, 2379-100)
	oPrint:Line(1950, 0100, 1950, 2379-100)
	oPrint:Line(2150, 0100, 2150, 2379-100)
	
	oPrint:Line(1650, 0100, 2150, 0100)
	oPrint:Line(1650, 2379-100, 2150, 2379-100)
	
	oPrint:Say(1655, 0150, "SALDO", oFont2)
	
	oPrint:Say(1705, 0105, "Total gasto:", oFont2)
	oPrint:Say(1755, 0105, "Valor do adiantamento:", oFont2)
	oPrint:Say(1805, 0105, "Valor a pagar:", oFont2)
	oPrint:Say(1855, 0105, "Valor a receber:", oFont2)
	oPrint:Say(1905, 0105, "Cedente:", oFont2)
	oPrint:Say(1955, 0105, Iif(aViagens[nI][18][1][3] > 0, "Paguei", "Recebi") + ;
							" a FIESP a quantia de R$ " + AllTrim(Transform(Iif(aViagens[nI][18][1][3] > 0, aViagens[nI][18][1][3], aViagens[nI][18][1][3]), PesqPict("SZ6", "Z6_VALOR"))) + " " + ;
							"(" + Extenso(Iif(aViagens[nI][18][1][3] > 0, aViagens[nI][18][1][3], aViagens[nI][18][1][3])) + ")", oFont7)
	oPrint:Say(1985, 0105, "referente ao acerto de contas.", oFont7)
	oPrint:Say(2085, 0105, "Data: ____/____/________					Assinatura: ______________________________", oFont5)
	
	oPrint:Say(1705, 1300, Transform(aViagens[nI][18][1][1], PesqPict("SZ6", "Z6_VALOR")), oFont5, , , , 1)
	oPrint:Say(1755, 1300, Transform(aViagens[nI][18][1][2], PesqPict("SZ6", "Z6_VALOR")), oFont5, , , , 1)
	oPrint:Say(1805, 1300, Transform(aViagens[nI][18][1][3], PesqPict("SZ6", "Z6_VALOR")), oFont5, , , , 1)
	oPrint:Say(1855, 1300, Transform(aViagens[nI][18][1][4], PesqPict("SZ6", "Z6_VALOR")), oFont5, , , , 1)
	oPrint:Say(1705, 0700, "R$", oFont5)
	oPrint:Say(1755, 0700, "R$", oFont5)
	oPrint:Say(1805, 0700, "R$", oFont5)
	oPrint:Say(1855, 0700, "R$", oFont5)
	oPrint:Say(1905, 0700, "FIESP")
	
	oPrint:Line(2250, 0100, 2250, 2379-100)
	oPrint:Line(2550, 0100, 2550, 2379-100)
	
	oPrint:Line(2250, 0100, 2550, 0100)
	oPrint:Line(2250, 2379-100, 2550, 2379-100)
	
	oPrint:Say(2255, 0150, "FATURAMENTO", oFont2)
	
	oPrint:Say(2305, 0150, "Centro de Custo", oFont6)
	oPrint:Say(2305, 0550, "Nome do Centro de Custo", oFont6)
	oPrint:Say(2305, 1150, "Convênio", oFont6)
	oPrint:Say(2305, 1450, "Nome do Convênio", oFont6)
	oPrint:Say(2305, 2050, "Percentual", oFont6)
	
	nLinIni := 2335
	
	For nY := 1 To Len(aViagens[nI][16])
		oPrint:Say(nLinIni, 0150, aViagens[nI][16][nY][1], oFont7)
		oPrint:Say(nLinIni, 0550, aViagens[nI][16][nY][2], oFont7)
		oPrint:Say(nLinIni, 1150, aViagens[nI][16][nY][3], oFont7)
		oPrint:Say(nLinIni, 1450, aViagens[nI][16][nY][4], oFont7)
		oPrint:Say(nLinIni, 2225, aViagens[nI][16][nY][5], oFont7, , , , 1)
		
		nLinIni += 30
	Next nY
	
	oPrint:Say(2495, 2225, "100,00 %", oFont6, , , , 1)
	
	oPrint:Line(2650, 0100, 2650, 2379-100)
	oPrint:Line(2700, 0100, 2700, 2379-100)
	oPrint:Line(2900, 0100, 2900, 2379-100)
	oPrint:Line(3100, 0100, 3100, 2379-100)
	oPrint:Line(3300, 0100, 3300, 2379-100)
	
	oPrint:Line(2650, 0100, 3300, 0100)
	oPrint:Line(2700, 1279, 3300, 1279)
	oPrint:Line(2650, 2379-100, 3300, 2379-100)
	
	oPrint:Say(2655, 0150, "APROVAÇÕES", oFont2)
	
	oPrint:Say(2705, 0150, "Superior Imediato:", oFont4)
	oPrint:Say(2905, 0150, "Diretor Responsável:", oFont4)
	oPrint:Say(3105, 0150, "GCF:", oFont4)
	
	oPrint:Say(2705, 1289, "Diretor Secretário:", oFont4)
	oPrint:Say(2905, 1289, "Diretor Financeiro:", oFont4)
	oPrint:Say(3105, 1289, "Presidente:", oFont4)
	
	oPrint:Say(2860, 0150, "Assinatura: ______________________    Data: ____/____/________", oFont7)
	oPrint:Say(3060, 0150, "Assinatura: ______________________    Data: ____/____/________", oFont7)
	oPrint:Say(3260, 0150, "Assinatura: ______________________    Data: ____/____/________", oFont7)
	
	oPrint:Say(2860, 1289, "Assinatura: ______________________    Data: ____/____/________", oFont7)
	oPrint:Say(3060, 1289, "Assinatura: ______________________    Data: ____/____/________", oFont7)
	oPrint:Say(3260, 1289, "Assinatura: ______________________    Data: ____/____/________", oFont7)
	
	oPrint:SayBitmap(0105, 0100, "logo_fiesp.jpg", 684, 192, , )
	oPrint:Say(0160, 1000, "RELATÓRIO DE DESPESAS", oFont1)
	oPrint:Say(0110, 2029, "Nº: " + aViagens[nI][1] + "", oFont1)
	
	oPrint:EndPage()
Next nI

oPrint:Preview()
oPrint:End()

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function retTpVg(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ2->(GetArea())}
Local cTipo := ""

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	If (SZ1->Z1_TIPO == "1")
		cTipo += "NACIONAL "
	Else
		cTipo += "INTERNACIONAL "
	Endif
	
	DbSelectArea("SZ2")
	SZ2->(DbSetOrder(1))
	If (SZ2->(DbSeek(cFil + cNum)))
		If (SZ2->Z2_CLASSE == "1")
			cTipo += "- CLASSE: EXECUTIVA"
		Else
			cTipo += "- CLASSE: ECONÔMICA"
		Endif
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(cTipo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function retTrajeto(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ2->(GetArea())}
Local aTrajeto := {}

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	DbSelectArea("SZ2")
	SZ2->(DbSetOrder(1))
	If (SZ2->(DbSeek(cFil + cNum)))
		While ((SZ2->(!Eof())) .And. (SZ2->Z2_FILIAL == cFil) .And. (SZ2->Z2_NUMSV == cNum))
			aAdd(aTrajeto, {AllTrim(SZ2->Z2_TRECHO) + " - DATA: " + DToC(SZ2->Z2_DATA) + " - HORÁRIO: " + AllTrim(SZ2->Z2_HORA)})

			SZ2->(DbSkip())
		Enddo
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(aTrajeto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function retHotel(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ3->(GetArea())}
Local lRet := .F.

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	DbSelectArea("SZ3")
	SZ3->(DbSetOrder(1))
	If (SZ3->(DbSeek(cFil + cNum)))
		While ((SZ3->(!Eof())) .And. (SZ3->Z3_FILIAL == cFil) .And. (SZ3->Z3_NUMSV == cNum))
			lRet := .T.

			SZ3->(DbSkip())
		Enddo
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function retRateio(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ0->(GetArea())}
Local aRateio := {}
Local cNomeCC := ""
Local cNomeConv := ""
Local cPerc := ""

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	If (SZ0->(DbSeek(cFil + cNum)))
		While ((SZ0->(!Eof())) .And. (SZ0->Z0_FILIAL == cFil) .And. (SZ0->Z0_NUMSV == cNum))
			cNomeCC := Posicione("CTT", 1, xFilial("CTT") + SZ0->Z0_CCUSTO, "CTT_DESC01")
			cNomeConv := Posicione("CTD", 1, xFilial("CTD") + SZ0->Z0_ITEMCTA, "CTD_DESC01")
			cPerc := Transform(SZ0->Z0_PERC, "@E 999.99")
			
			aAdd(aRateio, {SZ0->Z0_CCUSTO, cNomeCC, SZ0->Z0_ITEMCTA, cNomeConv, cPerc})

			SZ0->(DbSkip())
		Enddo
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(aRateio)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  27/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function retDespesas(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ6->(GetArea())}
Local aDespesas := {}

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	DbSelectArea("SZ6")
	SZ6->(DbSetOrder(1))
	If (SZ6->(DbSeek(cFil + cNum)))
		While ((SZ6->(!Eof())) .And. (SZ6->Z6_FILIAL == cFil) .And. (SZ6->Z6_NUMSV == cNum))
			aAdd(aDespesas, {DToC(SZ6->Z6_DATA), SZ6->Z6_DESCRI, Transform(SZ6->Z6_VALOR, PesqPict("SZ6", "Z6_VALOR"))})

			SZ6->(DbSkip())
		Enddo
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(aDespesas)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR02  ºAutor  ³Felipe Alves        º Data ³  27/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function retSaldos(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ6->(GetArea())}
Local lRet := .T.
Local nAdianta := 0
Local nDevolu := 0
Local nGasto := 0
Local nTotal := 0
Local nPagar := 0
Local nReceber := 0
Local aSaldos := {}

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	nAdianta := SZ1->Z1_ADIANTA
	
	DbSelectArea("SZ6")
	SZ6->(DbGoTop())
	SZ6->(DbSetOrder(1))
	If (SZ6->(DbSeek(cFil + cNum)))
		While ((SZ6->(!Eof())) .And. (SZ6->Z6_FILIAL == cFil) .And. (SZ6->Z6_NUMSV == cNum))
			If (SZ6->Z6_TIPO == "1")
				nGasto += SZ6->Z6_VALOR
			Elseif (SZ6->Z6_TIPO == "2")
				nDevolu += SZ6->Z6_VALOR
			Endif
		
			SZ6->(DbSkip())
		Enddo
	Endif
	
	nTotal := (nGasto - nAdianta) + nDevolu
	
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	SZ1->(DbSeek(cFil + cNum))
	
	If (nTotal > 0)
		nReceber := nTotal
	Elseif (nTotal < 0)
		nPagar := nTotal * -1
	Endif
	
	aAdd(aSaldos, {nGasto, ;
				nAdianta, ;
				nPagar, ;
				nReceber})
Endif

aEval(aArea, {|x| RestArea(x)})
Return(aSaldos)