#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFATR01  ºAutor  ³Microsiga           º Data ³  05/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFATR01()
Local lRet := .T.
Local aPerguntas := {}
Local aRetorno := {}

aAdd(aPerguntas, {1, "Nota......", Space(TamSX3("F2_DOC")[1])  , ""  , , "SF2", , TamSX3("F2_DOC")[1]  , .T.})
aAdd(aPerguntas, {1, "Série.....", Space(TamSX3("F2_SERIE")[1]), "@!", , ""   , , TamSX3("F2_SERIE")[1], .T.})

If !(ParamBox(aPerguntas, "Impressão Nota de Débito", @aRetorno))
	lRet := .F.
Endif

If (lRet)
	Processa({|| ImpRel()}, "Processando Arquivos...")
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFATR01  ºAutor  ³Microsiga           º Data ³  05/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel()
Local lRet := .T.
Local oPrint
Local cDoc := ""
Local cSerie := ""
Local cCliente := ""
Local cLoja := ""
Local lBrush := .F.
Local nTotal := 0
Local nCont := 1
Local cObs := ""
Local cLocal := "São Paulo, " + DToC(dDataBase)

Private cTitulo := "NOTA DE DÉBITO"
Private oFont1 := TFont():New("Courier New", , 16, , .T., , , , .F., .F.)
Private oFont2 := TFont():New("Courier New", , 12, , .T., , , , .F., .F.)
Private oFont3 := TFont():New("Courier New", , 12, , .F., , , , .F., .F.)
Private oFont4 := TFont():New("Courier New", , 10, , .T., , , , .F., .F.)
Private oFont5 := TFont():New("Courier New", , 10, , .F., , , , .F., .F.)
Private oFont6 := TFont():New("Courier New", , 08, , .T., , , , .F., .F.)
Private oFont7 := TFont():New("Courier New", , 08, , .F., , , , .F., .F.)
Private oBrush  := TBrush():New(, CLR_HGRAY)

DbSelectArea("SD2")
SD2->(DbSetOrder(3))

If (SD2->(DbSeek(xFilial("SD2") + mv_par01 + mv_par02)))
	cDoc := SD2->D2_DOC
	cSerie := SD2->D2_SERIE
	cCliente := SD2->D2_CLIENTE
	cLoja := SD2->D2_LOJA
	cObs := ""//???
	
	oPrint := TMSPrinter():New(cTitulo)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(9)
	oPrint:Setup()
	oPrint:StartPage()
	
	oPrint:Box(0050, 0100, 0200, 2379-100)
	
//	oPrint:SayBitmap(053, 0103, "logo_fiesp.jpg", 524, 147, , )
	_cEmp	:= Substr(FWCODFIL(),1,2)
	oPrint:SayBitmap(053, 0103, "ND"+_cEmp+".jpg", 524, 147, , )
	oPrint:Say(0055, 2374-100, "NOTA DE DÉBITO Nº: " + AllTrim(cDoc) + "/" + AllTrim(cSerie) + "", oFont1, , , , 1)
	
	oPrint:Box(0200, 0100, 0250, 2379-100)
	oPrint:Box(0250, 0100, 0300, 2379-100)
	oPrint:Box(0300, 0100, 0350, 2379-100)
	oPrint:Box(0350, 0100, 0400, 2379-100)
	
	oPrint:Say(0205, 0105, "Razão Social", oFont4)
	oPrint:Say(0305, 0105, "Endereço", oFont4)
	
	oPrint:Say(0260, 0105, Posicione("SA1", 1, xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA, "A1_NOME"), oFont7)
	oPrint:Say(0360, 0105, Posicione("SA1", 1, xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA, "A1_END"), oFont7)
	
	oPrint:Box(0400, 0100, 0450, 0669)
	oPrint:Box(0450, 0100, 0500, 0669)
	
	oPrint:Say(0405, 0105, "Telefone", oFont4)
	
	oPrint:Say(0460, 0105, AllTrim(Transform(Posicione("SA1", 1, xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA, "A1_TEL"), PesqPict("SA1", "A1_TEL"))), oFont7)
	
	oPrint:Box(0400, 0669, 0450, 1238)
	oPrint:Box(0450, 0669, 0500, 1238)
	
	oPrint:Say(0405, 0674, "E-mail", oFont4)
	
	oPrint:Say(0460, 0674, AllTrim(Transform(Posicione("SA1", 1, xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA, "A1_EMAIL"), PesqPict("SA1", "A1_EMAIL"))), oFont7)
	
	oPrint:Box(0400, 1238, 0450, 1806)
	oPrint:Box(0450, 1238, 0500, 1806)
	
	oPrint:Say(0405, 1243, "Inscr. Est.", oFont4)
	
	oPrint:Say(0460, 1243, AllTrim(Transform(Posicione("SA1", 1, xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA, "A1_INSCR"), PesqPict("SA1", "A1_INSCR"))), oFont7)
	
	oPrint:Box(0400, 1806, 0450, 2379-100)
	oPrint:Box(0450, 1806, 0500, 2379-100)
	
	oPrint:Say(0405, 1811, "CNPJ", oFont4)
	
	oPrint:Say(0460, 1811, AllTrim(Transform(Posicione("SA1", 1, xFilial("SA1") + SD2->D2_CLIENTE + SD2->D2_LOJA, "A1_CGC"), PesqPict("SA1", "A1_CGC"))), oFont7)
	
	oPrint:Box(0600, 0100, 0650, 2379-100)
	
	oPrint:Say(0605, 0105, "MATERIAIS/ CONSULTAS", oFont4)
	
	oPrint:Box(0650, 0100, 0700, 0400)
	oPrint:Box(0650, 0400, 0700, 1179)
	oPrint:Box(0650, 1179, 0700, 1479)
	oPrint:Box(0650, 1479, 0700, 1779)
	oPrint:Box(0650, 1779, 0700, 2079)
	oPrint:Box(0650, 2079, 0700, 2379-100)
	
	oPrint:Say(0655, 0105, "Código", oFont4)
	oPrint:Say(0655, 0405, "Descrição", oFont4)
	oPrint:Say(0655, 1184, "Nr. Pedido", oFont4)
	oPrint:Say(0655, 1483, "Qtde.", oFont4)
	oPrint:Say(0655, 1783, "Unitário", oFont4)
	oPrint:Say(0655, 2083, "Total", oFont4)
	
	oPrint:Box(0700, 0100, 2633, 2379-100)
	
	nLinha := 0710
	
	While ((SD2->(!Eof())) .And. ;
			(cDoc == SD2->D2_DOC) .And. ;
			(cSerie == SD2->D2_SERIE) .And. ;
			(cCliente == SD2->D2_CLIENTE) .And. ;
			(cLoja == SD2->D2_LOJA))
		If (lBrush)
			oPrint:FillRect({nLinha, 0100, nLinha + 30, 2379-100}, oBrush)
			lBrush := .F.
		Else
			lBrush := .T.
		Endif
	
		oPrint:Say(nLinha, 0105, AllTrim(SD2->D2_COD), oFont7)
		oPrint:Say(nLinha, 0405, Alltrim(Posicione("SB1", 1, xFilial("SB1") + SD2->D2_COD, "B1_DESC")), oFont7)
		oPrint:Say(nLinha, 1184, AllTrim(SD2->D2_PEDIDO), oFont7)
		oPrint:Say(nLinha, 1774, AllTrim(Transform(SD2->D2_QUANT, PesqPict("SD2", "D2_QUANT"))), oFont7, , , , 1)
		oPrint:Say(nLinha, 2074, AllTrim(Transform(SD2->D2_PRCVEN, PesqPict("SD2", "D2_PRCVEN"))), oFont7, , , , 1)
		oPrint:Say(nLinha, 2374-100, AllTrim(Transform(SD2->D2_TOTAL, PesqPict("SD2", "D2_TOTAL"))), oFont7, , , , 1)
		
		nTotal += SD2->D2_TOTAL
		
		nLinha += 0030
	
		SD2->(DbSkip())
	Enddo
	
	oPrint:Box(2733, 0100, 2783, 2379-100)
	
	oPrint:Say(2738, 2374-100, "TOTAL (R$): " + AllTrim(Transform(nTotal, PesqPict("SD2", "D2_TOTAL"))), oFont4, , , , 1)
	
	oPrint:Box(2883-40, 0100, 2933-40, 0425)
	oPrint:Box(2933-40, 0100, 2983-40, 0425)
	
	oPrint:Say(2888-40, 0105, "1º Vencimento", oFont6)
	
	oPrint:Box(2883-40, 0425, 2933-40, 0750)
	oPrint:Box(2933-40, 0425, 2983-40, 0750)
	
	oPrint:Say(2888-40, 0430, "2º Vencimento", oFont6)
	
	oPrint:Box(2883-40, 0750, 2933-40, 1075)
	oPrint:Box(2933-40, 0750, 2983-40, 1075)
	
	oPrint:Say(2888-40, 0755, "3º Vencimento", oFont6)
	
	oPrint:Box(2883-40, 1075, 2933-40, 1400)
	oPrint:Box(2933-40, 1075, 2983-40, 1400)
	
	oPrint:Say(2888-40, 1080, "4º Vencimento", oFont6)
	
	oPrint:Box(2883-40, 1400, 2933-40, 1725)
	oPrint:Box(2933-40, 1400, 2983-40, 1725)
	
	oPrint:Say(2888-40, 1405, "5º Vencimento", oFont6)
	
	oPrint:Box(2883-40, 1725, 2933-40, 2050)
	oPrint:Box(2933-40, 1725, 2983-40, 2050)
	
	oPrint:Say(2888-40, 1730, "6º Vencimento", oFont6)
	
	oPrint:Box(2883-40, 2050, 2933-40, 2379-100)
	oPrint:Box(2933-40, 2050, 2983-40, 2379-100)
	
	oPrint:Say(2888-40, 2055, "7º Vencimento", oFont6)
	
	oPrint:Box(2983-40, 0100, 3033-40, 0425)
	oPrint:Box(3033-40, 0100, 3083-40, 0425)
	
	oPrint:Say(2988-40, 0105, "Valor", oFont6)
	
	oPrint:Box(2983-40, 0425, 3033-40, 0750)
	oPrint:Box(3033-40, 0425, 3083-40, 0750)
	
	oPrint:Say(2988-40, 0430, "Valor", oFont6)
	
	oPrint:Box(2983-40, 0750, 3033-40, 1075)
	oPrint:Box(3033-40, 0750, 3083-40, 1075)
	
	oPrint:Say(2988-40, 0755, "Valor", oFont6)
	
	oPrint:Box(2983-40, 1075, 3033-40, 1400)
	oPrint:Box(3033-40, 1075, 3083-40, 1400)
	
	oPrint:Say(2988-40, 1080, "Valor", oFont6)
	
	oPrint:Box(2983-40, 1400, 3033-40, 1725)
	oPrint:Box(3033-40, 1400, 3083-40, 1725)
	
	oPrint:Say(2988-40, 1405, "Valor", oFont6)
	
	oPrint:Box(2983-40, 1725, 3033-40, 2050)
	oPrint:Box(3033-40, 1725, 3083-40, 2050)
		
	oPrint:Say(2988-40, 1730, "Valor", oFont6)
	
	oPrint:Box(2983-40, 2050, 3033-40, 2379-100)
	oPrint:Box(3033-40, 2050, 3083-40, 2379-100)
	
	oPrint:Say(2988-40, 2055, "Valor", oFont6)
	
	DbSelectArea("SE1")
	SE1->(DbSetOrder(2))

	If (SE1->(DbSeek(xFilial("SE1") + cCliente + cLoja + cSerie + cDoc)))
		While ((SE1->(!Eof())) .And. ;
				(xFilial("SE1") == SE1->E1_FILIAL) .And. ;
				(cCliente == SE1->E1_CLIENTE) .And. ;
				(cLoja == SE1->E1_LOJA) .And. ;
				(cSerie == SE1->E1_PREFIXO) .And. ;
				(cDoc == SE1->E1_NUM) .And. ;
				(nCont <= 6))
			If (nCont == 1)
				oPrint:Say(2938-40, 0110, DToC(SE1->E1_VENCREA), oFont7)
				oPrint:Say(3038-40, 0110, AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))), oFont7)
			Elseif (nCont == 2)
				oPrint:Say(2938-40, 0435, DToC(SE1->E1_VENCREA), oFont7)
				oPrint:Say(3038-40, 0435, AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))), oFont7)
			Elseif (nCont == 3)
				oPrint:Say(2938-40, 0760, DToC(SE1->E1_VENCREA), oFont7)
				oPrint:Say(3038-40, 0760, AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))), oFont7)
			Elseif (nCont == 4)
				oPrint:Say(2938-40, 1085, DToC(SE1->E1_VENCREA), oFont7)
				oPrint:Say(3038-40, 1085, AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))), oFont7)
			Elseif (nCont == 5)
				oPrint:Say(2938-40, 1410, DToC(SE1->E1_VENCREA), oFont7)
				oPrint:Say(3038-40, 1410, AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))), oFont7)
			Elseif (nCont == 6)
				oPrint:Say(2938-40, 1735, DToC(SE1->E1_VENCREA), oFont7)
				oPrint:Say(3038-40, 1735, AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))), oFont7)
			Elseif (nCont == 7)
				oPrint:Say(2938-40, 2060, DToC(SE1->E1_VENCREA), oFont7)
				oPrint:Say(3038-40, 2060, AllTrim(Transform(SE1->E1_VALOR, PesqPict("SE1", "E1_VALOR"))), oFont7)
			Endif
			
			nCont++

			SE1->(DbSkip())
		Enddo
	Endif
	
	oPrint:Box(3083-40, 0100, 3133-40, 2379-100)
	oPrint:Box(3133-40, 0100, 3183-40, 2379-100)
	
	oPrint:Say(3088-40, 0105, "Observações", oFont4)
	
	oPrint:Box(3183-40, 0100, 3233-40, 2379-100)
	oPrint:Box(3233-40, 0100, 3283-40, 2379-100)
	
	oPrint:Say(3188-40, 0105, "Local e Data", oFont4)
	oPrint:Say(3243-40, 0105, cLocal, oFont7)
	
	oPrint:Say(3333-35-40, 1343, AllTrim(SM0->M0_ENDCOB), oFont6)
	oPrint:Say(3383-35-40, 1912, "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, PesqPict("SA1", "A1_CGC"))), oFont6)
	oPrint:Say(3433-35-40, 1343, AllTrim(SM0->M0_CEPCOB) + " " + AllTrim(SM0->M0_CIDCOB) + " - " + AllTrim(SM0->M0_ESTCOB), oFont6)
	oPrint:Say(3333-35-40, 1912, "Inscr. Est.: " + AllTrim(SM0->M0_INSC), oFont6)
	oPrint:Say(3383-35-40, 1343, "Tel.: " + AllTrim(SM0->M0_TEL), oFont6)
	oPrint:Say(3433-35-40, 1912, "fiespciesp@fiesp.org.br", oFont6)
	
	oPrint:EndPage()
	oPrint:Preview()
	oPrint:End()
Else
	Aviso("Aviso", "Nenhum registro encontrado.", {"Ok"}, 1)
	lRet := .F.
Endif
Return(lRet)