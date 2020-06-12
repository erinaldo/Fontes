#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR02  ºAutor  ³Felipe Alves        º Data ³  03/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINR02()
Local lRet := .T.
Local aPerguntas := {}
Local aRetorno := {}
Local cQuery := ""
Local cTab := ""
Local cNome := ""
Local cEnd := ""
Local cTel := ""
Local cFax := ""
Local cEmail := ""
Local cCGC := ""
Local aFaturas := {}
Local nTotal := 0
Local cTotal := ""
Local aVenctos := {}
Local cObs := ""
Local aDados := {}

aAdd(aPerguntas, {1, "Fatura.........", Space(TamSX3("E1_NUM")[1])    , ""  , , "SE1FAT", , TamSX3("E1_NUM")[1]    , .T.})
aAdd(aPerguntas, {1, "Prefixo........", Space(TamSX3("E1_PREFIXO")[1]), "@!", , ""      , , TamSX3("E1_PREFIXO")[1], .T.})

If !(ParamBox(aPerguntas, "Impressão Fatura", @aRetorno))
	lRet := .F.
Else
	cQuery := "SELECT" + CRLF
	cQuery += "A1.A1_NOME," + CRLF
	cQuery += "A1.A1_END," + CRLF
	cQuery += "A1.A1_TEL," + CRLF
	cQuery += "A1.A1_FAX," + CRLF
	cQuery += "A1.A1_EMAIL," + CRLF
	cQuery += "A1.A1_CGC," + CRLF
	cQuery += "RTRIM(E1.E1_NUM) + '/' + E1.E1_PARCELA AS E1_NUM," + CRLF
	cQuery += "E1.E1_EMISSAO," + CRLF
	cQuery += "ED.ED_CODIGO," + CRLF
	cQuery += "ED.ED_DESCRIC," + CRLF
	cQuery += "E1.E1_VALOR" + CRLF
	cQuery += "FROM " + RetSQLName("SE1") + " E1" + CRLF
	cQuery += "INNER JOIN " + RetSQLName("SA1") + " A1 ON ((A1.A1_COD = E1.E1_CLIENTE) AND (A1.A1_LOJA = E1.E1_LOJA))" + CRLF
	cQuery += "INNER JOIN " + RetSQLName("SED") + " ED ON (ED.ED_CODIGO = E1.E1_NATUREZ)" + CRLF
	cQuery += "WHERE E1.E1_FILIAL = '" + xFilial("SE1") + "'" + CRLF
	cQuery += "AND E1.E1_FATURA = '" + AllTrim(mv_par01) + "'" + CRLF
	cQuery += "AND E1.E1_FATPREF = '" + AllTrim(mv_par02) + "'" + CRLF
	cQuery += "AND E1.D_E_L_E_T_ = ''" + CRLF
	cQuery += "AND A1.A1_FILIAL = '" + xFilial("SA1") + "'" + CRLF
	cQuery += "AND A1.D_E_L_E_T_ = ''" + CRLF
	cQuery += "AND ED.ED_FILIAL = '" + xFilial("SED") + "'" + CRLF
	cQuery += "AND ED.D_E_L_E_T_ = ''"
	
	cQuery := ChangeQuery(cQuery)
	
	cTab := GetNextAlias()
	
	TcQUERY cQuery NEW ALIAS ((cTab))
	
	DbSelectArea((cTab))
	(cTab)->(DbGoTop())
	
	While ((cTab)->(!Eof()))
		cNome := (cTab)->(A1_NOME)
		cEnd := (cTab)->(A1_END)
		cTel := (cTab)->(A1_TEL)
		cFax := (cTab)->(A1_FAX)
		cEmail := (cTab)->(A1_EMAIL)
		cCGC := (cTab)->(A1_CGC)
		
		aAdd(aFaturas, {(cTab)->(E1_NUM), (cTab)->(E1_EMISSAO), (cTab)->(ED_CODIGO), (cTab)->(ED_DESCRIC), Transform((cTab)->(E1_VALOR), PesqPict("SE1", "E1_VALOR"))})
		
		nTotal += (cTab)->(E1_VALOR)

		(cTab)->(DbSkip())
	Enddo
	
	(cTab)->(DbCloseArea())
	
	cTotal := Transform(nTotal, PesqPict("SE1", "E1_VALOR"))
	
	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))
	If (SE1->(DbSeek(xFilial("SE1") + mv_par02 + mv_par01)))
		aAdd(aVenctos, {Transform(SE1->E1_VENCREA, PesqPict("SE1", "E1_VENCREA")), Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))})
		
		cObs += AllTrim(SE1->E1_HIST) + CRLF
		
		SE1->(DbSkip())
	Endif
	
	aAdd(aDados, {AllTrim(mv_par01), cNome, cEnd, cTel, cFax, cEmail, cCGC, aFaturas, cTotal, aVenctos, cObs})
Endif

If (lRet)
	Processa({|| ImpRel(aDados)}, "Processando Arquivos...")
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR02  ºAutor  ³Felipe Alves        º Data ³  03/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel(aDados)
Local lRet := .T.
Local oPrint
Local nI := 0
Local nLinha := 0
Local nY := 0
Local lBrush := .F.

Private cTitulo := "FATURAS"
Private oFont1 := TFont():New("Courier New", , 16, , .T., , , , .F., .F.)
Private oFont2 := TFont():New("Courier New", , 12, , .T., , , , .F., .F.)
Private oFont3 := TFont():New("Courier New", , 12, , .F., , , , .F., .F.)
Private oFont4 := TFont():New("Courier New", , 10, , .T., , , , .F., .F.)
Private oFont5 := TFont():New("Courier New", , 10, , .F., , , , .F., .F.)
Private oFont6 := TFont():New("Courier New", , 08, , .T., , , , .F., .F.)
Private oFont7 := TFont():New("Courier New", , 08, , .F., , , , .F., .F.)
Private oBrush  := TBrush():New(, CLR_HGRAY)

oPrint := TMSPrinter():New(cTitulo)
oPrint:SetPortrait()
oPrint:SetPaperSize(9)
oPrint:Setup()

For nI := 1 To Len(aDados)
	oPrint:StartPage()
	
	oPrint:Line(0050, 0100, 0050, 2379-100)
	oPrint:Line(0250, 0100, 0250, 2379-100)
	
	_cEmp	:= Substr(FWCODFIL(),1,2)
	oPrint:SayBitmap(0055, 0105, "FT"+_cEmp+".jpg", 684, 192, , )
	oPrint:Say(0055, 2374-100, "FATURA Nº: " + AllTrim(aDados[nI][1]), oFont1, , , , 1)
	
	oPrint:Line(0050, 0100, 0250, 0100)
	oPrint:Line(0050, 2379-100, 0250, 2379-100)
	
	oPrint:Line(0275, 0100, 0275, 2379-100)
	oPrint:Line(0325, 0100, 0325, 2379-100)
	oPrint:Line(0375, 0100, 0375, 2379-100)
	oPrint:Line(0425, 0100, 0425, 2379-100)
	oPrint:Line(0475, 0100, 0475, 2379-100)
	
	oPrint:Say(0280, 0105, "Razão Social", oFont4)
	oPrint:Say(0330, 0105, AllTrim(aDados[nI][2]), oFont5)
	oPrint:Say(0380, 0105, "Endereço", oFont4)
	oPrint:Say(0430, 0105, AllTrim(aDados[nI][3]), oFont5)
	
	oPrint:Line(0275, 0100, 0475, 0100)
	oPrint:Line(0275, 2379-100, 0475, 2379-100)
	
	oPrint:Line(0500, 0100, 0500, 2379-100)
	oPrint:Line(0550, 0100, 0550, 2379-100)
	oPrint:Line(0600, 0100, 0600, 2379-100)
	
	oPrint:Line(0500, 0100, 0600, 0100)
	oPrint:Line(0500, 0519, 0600, 0519)
	oPrint:Line(0500, 0938, 0600, 0938)
	oPrint:Line(0500, 1807, 0600, 1807)
	oPrint:Line(0500, 2379-100, 0600, 2379-100)
	
	oPrint:Say(0505, 0105, "Telefone", oFont4)
	oPrint:Say(0555, 0105, AllTrim(aDados[nI][4]), oFont5)
	oPrint:Say(0505, 0524, "Fax", oFont4)
	oPrint:Say(0555, 0524, AllTrim(aDados[nI][5]), oFont5)
	oPrint:Say(0505, 0943, "E-mail", oFont4)
	oPrint:Say(0555, 0943, AllTrim(aDados[nI][6]), oFont5)
	oPrint:Say(0505, 1812, "CNPJ", oFont4)
	oPrint:Say(0555, 1812, AllTrim(aDados[nI][7]), oFont5)
	
	oPrint:Line(0625, 0100, 0625, 2379-100)
	oPrint:Line(0675, 0100, 0675, 2379-100)
	oPrint:Line(0725, 0100, 0725, 2379-100)
	oPrint:Line(2500, 0100, 2500, 2379-100)
	
	oPrint:Say(0630, 0105, "NOTAS DE DÉBITO", oFont4)
	
	oPrint:Say(0680, 0105, "Número", oFont6)
	oPrint:Say(0680, 0380, "Emissão", oFont6)
	oPrint:Say(0680, 0580, "Código", oFont6)
	oPrint:Say(0680, 0880, "Produto", oFont6)
	oPrint:Say(0680, 2079, "Total", oFont6)
	
	nLinha := 0730
	
	For nY := 1 To Len(aDados[nI][8])
		If (lBrush)
			oPrint:FillRect({nLinha, 0100, nLinha + 30, 2379-100}, oBrush)
			lBrush := .F.
		Else
			lBrush := .T.
		Endif
		
		oPrint:Say(nLinha, 0105, aDados[nI][8][nY][1], oFont7)
		oPrint:Say(nLinha, 0380, aDados[nI][8][nY][2], oFont7)
		oPrint:Say(nLinha, 0580, aDados[nI][8][nY][3], oFont7)
		oPrint:Say(nLinha, 0880, aDados[nI][8][nY][4], oFont7)
		oPrint:Say(nLinha, 2374-100, aDados[nI][8][nY][5], oFont7, , , , 1)
		
		nLinha += 30
	Next nY
	
	oPrint:Line(0625, 0100, 2500, 0100)
	oPrint:Line(0625, 2379-100, 2500, 2379-100)
	
	oPrint:Line(2525, 0100, 2525, 2379-100)
	oPrint:Line(2575, 0100, 2575, 2379-100)
	
	oPrint:Say(2530, 2374-100, "TOTAL R$: " + aDados[nI][9], oFont4, , , , 1)
	
	oPrint:Line(2525, 0100, 2575, 0100)
	oPrint:Line(2525, 2379-100, 2575, 2379-100)
	
	oPrint:Line(2600, 0100, 2600, 2379-100)
	oPrint:Line(2650, 0100, 2650, 2379-100)
	oPrint:Line(2700, 0100, 2700, 2379-100)
	oPrint:Line(2750, 0100, 2750, 2379-100)
	oPrint:Line(2800, 0100, 2800, 2379-100)
	
	oPrint:Say(2605, 0105, "1º Vencimento", oFont6)
	oPrint:Say(2605, 0430, "2º Vencimento", oFont6)
	oPrint:Say(2605, 0755, "3º Vencimento", oFont6)
	oPrint:Say(2605, 1080, "4º Vencimento", oFont6)
	oPrint:Say(2605, 1405, "5º Vencimento", oFont6)
	oPrint:Say(2605, 1730, "6º Vencimento", oFont6)
	oPrint:Say(2605, 2055, "7º Vencimento", oFont6)
	
	oPrint:Say(2705, 0105, "Valor", oFont6)
	oPrint:Say(2705, 0430, "Valor", oFont6)
	oPrint:Say(2705, 0755, "Valor", oFont6)
	oPrint:Say(2705, 1080, "Valor", oFont6)
	oPrint:Say(2705, 1405, "Valor", oFont6)
	oPrint:Say(2705, 1730, "Valor", oFont6)
	oPrint:Say(2705, 2055, "Valor", oFont6)
	
	For nY := 1 To Len(aDados[nI][10])
		If (nY == 1)
			oPrint:Say(2655, 0105, aDados[nI][10][nY][1], oFont7)
			oPrint:Say(2755, 0420, aDados[nI][10][nY][2], oFont7, , , , 1)
		Elseif (nY == 2)
			oPrint:Say(2655, 0430, aDados[nI][10][nY][1], oFont7)
			oPrint:Say(2755, 0745, aDados[nI][10][nY][2], oFont7, , , , 1)
		Elseif (nY == 3)
			oPrint:Say(2655, 0755, aDados[nI][10][nY][1], oFont7)
			oPrint:Say(2755, 1070, aDados[nI][10][nY][2], oFont7, , , , 1)
		Elseif (nY == 4)
			oPrint:Say(2655, 1080, aDados[nI][10][nY][1], oFont7)
			oPrint:Say(2755, 1395, aDados[nI][10][nY][2], oFont7, , , , 1)
		Elseif (nY == 5)
			oPrint:Say(2655, 1405, aDados[nI][10][nY][1], oFont7)
			oPrint:Say(2755, 1720, aDados[nI][10][nY][2], oFont7, , , , 1)
		Elseif (nY == 6)	
			oPrint:Say(2655, 1730, aDados[nI][10][nY][1], oFont7)
			oPrint:Say(2755, 2045, aDados[nI][10][nY][2], oFont7, , , , 1)
		Elseif (nY == 7)
			oPrint:Say(2655, 2055, aDados[nI][10][nY][1], oFont7)
			oPrint:Say(2755, 2374-100, aDados[nI][10][nY][2], oFont7, , , , 1)
		Endif
	Next nY

	oPrint:Line(2600, 0100, 2800, 0100)
	oPrint:Line(2600, 0425, 2800, 0425)
	oPrint:Line(2600, 0750, 2800, 0750)
	oPrint:Line(2600, 1075, 2800, 1075)
	oPrint:Line(2600, 1400, 2800, 1400)
	oPrint:Line(2600, 1725, 2800, 1725)
	oPrint:Line(2600, 2050, 2800, 2050)
	oPrint:Line(2600, 2379-100, 2800, 2379-100)
	
	oPrint:Line(2825, 0100, 2825, 2379-100)
	oPrint:Line(2875, 0100, 2875, 2379-100)
	oPrint:Line(3075, 0100, 3075, 2379-100)
	oPrint:Line(3025, 0100, 3025, 2379-100)
	oPrint:Line(3075, 0100, 3075, 2379-100)
	oPrint:Line(3175, 0100, 3175, 2379-100)
	
	oPrint:Say(2830, 0105, "Observações", oFont6)
	oPrint:Say(2880, 0105, aDados[nI][11], oFont7)
	oPrint:Say(3030, 0105, "Local e Data", oFont6)
	oPrint:Say(3080, 0105, "", oFont6)
	
	oPrint:Line(2825, 0100, 3175, 0100)
	oPrint:Line(2825, 2379-100, 3175, 2379-100)
	
	oPrint:Say(3205-35, 1343, AllTrim(SM0->M0_ENDCOB), oFont6)
	oPrint:Say(3205-35, 1912, "CNPJ: " + AllTrim(SM0->M0_CGC), oFont6)
	oPrint:Say(3255-35, 1343, AllTrim(SM0->M0_CEPCOB) + " " + AllTrim(SM0->M0_CIDCOB) + " - " + AllTrim(SM0->M0_ESTCOB), oFont6)
	oPrint:Say(3255-35, 1912, "Inscr. Est.: " + AllTrim(SM0->M0_INSC), oFont6)
	oPrint:Say(3305-35, 1343, "Tel.: " + AllTrim(SM0->M0_TEL), oFont6)
	oPrint:Say(3305-35, 1912, "fiespciesp@fiesp.org.br", oFont6)
	
	oPrint:EndPage()
Next nI
oPrint:Preview()
oPrint:End()
Return(lRet)