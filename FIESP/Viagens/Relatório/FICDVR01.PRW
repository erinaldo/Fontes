#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR01  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICDVR01(nOrig)
Local aArea      := {GetArea(), SZ0->(GetArea()), SZ1->(GetArea())}
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
Local lCancel	 := .F.
Local aRateio    := {}

Private nAdianta   := 0

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
			cResponsa := AllTrim(UsrFullName(SZ1->Z1_SOLICIT)) //Upper(SZ1->Z1_NOMSOL)
			cImpressao := DToC(dDataBase) + " - " + SubStr(Time(), 1, 5)
			cImpresso := Upper(UsrFullName(__cUserId))
			cViajante := SZ1->Z1_NOMVIAJ
			lCancel   := IIF(SZ1->Z1_STATUS == "W",.T.,.F.) //Se for Status = W esta cancelado imprimindo assim na autorização de viagem
			
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
			cHotel := retHotel(xFilial("SZ1"), SZ1->Z1_NUM)
			cJustific1 := ALLTRIM(MemoLine(SZ1->Z1_JUSTIFI,75,1)) //Upper(SubStr(SZ1->Z1_JUSTIFI, 1, 75))
			cJustific2 := ALLTRIM(MemoLine(SZ1->Z1_JUSTIFI,75,2)) //Upper(SubStr(SZ1->Z1_JUSTIFI, 76, 75))
			cJustific3 := ALLTRIM(MemoLine(SZ1->Z1_JUSTIFI,75,3)) //Upper(SubStr(SZ1->Z1_JUSTIFI, 151, 75))
			cJustific4 := ALLTRIM(MemoLine(SZ1->Z1_JUSTIFI,75,4)) //Upper(SubStr(SZ1->Z1_JUSTIFI, 226, 75))

			nAdianta := SZ1->Z1_ADIANTA
			aRateio := retRateio(xFilial("SZ1"), SZ1->Z1_NUM)
		Endif
		
		aAdd(aViagens, {cNum, cResponsa, cImpressao, cImpresso, cViajante, cTipo, cCC, cTipoViag, aTrajeto, ;
						cHotel, cJustific1, cJustific2, cJustific3, cJustific4, nAdianta, aRateio, lCancel})

		(cTab)->(DbSkip())
	Enddo
	
	(cTab)->(DbCloseArea())

	If (Len(aViagens) > 0)
		RptStatus({|| CDVR01(aViagens)}, "Impressão de Relatório", "A g u a r d e . . .", .T.)
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
±±ºPrograma  ³FICDVR01  ºAutor  ³Felipe Alves        º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Horizontal = 2479                                          º±±
±±º          ³ Vertical = 3508                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CDVR01(aViagens)
Local aArea     := {GetArea()}
Local lRet      := .T.
Local nValor    := 0
Local nI        := 0
Local nLinIni   := 0
Local nY        := 0

Private oPrint
Private cTitulo := "AUTORIZAÇÃO DE VIAGEM"
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
	
	oPrint:Line(0200, 0100, 0200, 2379-100)
	oPrint:Line(0500, 0100, 0500, 2379-100)
	
	oPrint:Line(0700, 0100, 0700, 2379-100)
	oPrint:Line(0800, 0100, 0800, 2379-100)
	oPrint:Line(0850, 0100, 0850, 2379-100)
	oPrint:Line(0900, 0100, 0900, 2379-100)
	oPrint:Line(0950, 0100, 0950, 2379-100)
	oPrint:Line(1000, 0100, 1000, 2379-100)
	oPrint:Line(1325, 0100, 1325, 2379-100)
	oPrint:Line(1375, 0100, 1375, 2379-100)
	oPrint:Line(1525, 0100, 1525, 2379-100)
	
	oPrint:Line(0700, 0100, 1525, 0100)
	oPrint:Line(0700, 2379-100, 1525, 2379-100)
	
	oPrint:Line(2325, 0100, 2325, 2379-100)
	oPrint:Line(2625, 0100, 2625, 2379-100)
	oPrint:Line(2725, 0100, 2725, 2379-100)
	oPrint:Line(2925, 0100, 2925, 2379-100)
	oPrint:Line(3125, 0100, 3125, 2379-100)
	oPrint:Line(3325, 0100, 3325, 2379-100)
	
	oPrint:Line(2325, 0100, 3325, 0100)
	oPrint:Line(2725, 1239, 3325, 1239)
	oPrint:Line(2325, 2379-100, 3325, 2379-100)
	
	oPrint:SayBitmap(0236, 0100, "logo_fiesp.jpg", 798, 224, , )
	oPrint:Say(0330, 1023, "AUTORIZAÇÃO DE VIAGEM", oFont1)
	oPrint:Say(0236, 2029-100, "Nº: " + aViagens[nI][1] + "", oFont1)

	If aViagens[nI][17]
		oPrint:Say(0286, 2029-100, " CANCELADO ", oFont1)
	EndIf
	
	oPrint:Say(0520, 0150, "RESPONSÁVEL:", oFont2)
	oPrint:Say(0580, 0150, "DATA DE IMPRESSÃO:", oFont2)
	oPrint:Say(0640, 0150, "IMPRESSO POR:", oFont2)
	
	oPrint:Say(0520, 0650, aViagens[nI][2], oFont3)
	oPrint:Say(0580, 0650, aViagens[nI][3], oFont3)
	oPrint:Say(0640, 0650, aViagens[nI][4], oFont3)
	
	oPrint:Say(0720, 0150, "DADOS DA VIAGEM", oFont2)
	
	oPrint:Say(0810, 0150, "Viajante:", oFont4)
	oPrint:Say(0860, 0150, "Tipo do Viajante:", oFont4)
	oPrint:Say(0910, 0150, "Área Solicitante:", oFont4)
	oPrint:Say(0960, 0150, "Tipo de Viagem:", oFont4)
	oPrint:Say(1010, 0150, "Trajeto:", oFont4)
	oPrint:Say(1335, 0150, "Incluir Hotel:", oFont4)
	oPrint:Say(1385, 0150, "Justificativa:", oFont4)
	
	oPrint:Say(0805, 0650, aViagens[nI][5], oFont5)
	oPrint:Say(0855, 0650, aViagens[nI][6], oFont5)
	oPrint:Say(0905, 0650, aViagens[nI][7], oFont5)
	oPrint:Say(0955, 0650, aViagens[nI][8], oFont5)
	
	nLinIni := 1005
	
	For nY := 1 To Len(aViagens[nI][9])
		oPrint:Say(nLinIni, 0650, aViagens[nI][9][nY][1], oFont5)
		
		nLinIni += 30
	Next nY

	oPrint:Say(1335, 0650, aViagens[nI][10], oFont5)
	oPrint:Say(1385, 0650, aViagens[nI][11], oFont5)
	oPrint:Say(1415, 0650, aViagens[nI][12], oFont5)
	oPrint:Say(1445, 0650, aViagens[nI][13], oFont5)
	oPrint:Say(1475, 0650, aViagens[nI][14], oFont5)

//Inicio Box Despesas	

	oPrint:Line(1725-200, 0100, 2125-200, 0100) //Linhas vertical esquerda
	oPrint:Line(1725-200, 2379-100, 2125-200, 2379-100) //Linhas vertical direta

	_xGetArea 	:= GetArea()
	_nValPas 	:= 0
	_nValHot 	:= 0
	_nValVei 	:= 0
	_lPas		:= .F.
	_lHot		:= .F.
	_lVei		:= .F.
	_aHotNom	:= {}
	_nPosHot	:= 0

	//PASSAGEM
	DbSelectArea("SZ2")
	If DbSeek(xFilial("SZ2")+aViagens[nI][1])
		_lPas	:= .T.
		Do While !EOF() .and. SZ2->Z2_NUMSV == aViagens[nI][1]
			_nValPas	+= SZ2->Z2_VALOR
			DbSelectArea("SZ2")
			SZ2->(DbSkip())
		EndDo
	EndIf
		
	//HOTEL
	DbSelectArea("SZ3")
	If DbSeek(xFilial("SZ3")+aViagens[nI][1])
		_lHot	:= .T.
		Do While !EOF() .and. SZ3->Z3_NUMSV == aViagens[nI][1]
			_nPosHot := ascan(_aHotNom,SZ3->Z3_NOME)
			If _nPosHot == 0
				AADD(_aHotNom,SZ3->Z3_NOME)
			EndIf
			_nValHot	+= SZ3->Z3_VALOR
			DbSelectArea("SZ3")
			SZ3->(DbSkip())
		EndDo
	EndIf

	//VEICULO
	DbSelectArea("SZ4")
	If DbSeek(xFilial("SZ4")+aViagens[nI][1])
		_lVei	:= .T.
		Do While !EOF() .and. SZ4->Z4_NUMSV == aViagens[nI][1]
			_nValVei	+= SZ4->Z4_VALOR
			DbSelectArea("SZ4")
			SZ4->(DbSkip())
		EndDo
	EndIf

	oPrint:Say(1525, 0150, "HOTEL    R$ " + AllTrim(Transform(_nValHot, PesqPict("SZ3", "Z3_VALOR"))), oFont5)
	nLin := 1575
	If !Empty(_aHotNom)
		For xnI := 1 to min(len(_aHotNom),4)
			oPrint:Say(nLin, 0150, _aHotNom[xnI], oFont5)
			nLin+=50
		Next xnI
	EndIf

	oPrint:Say(1525, 1050, "PASSAGEM R$ " + AllTrim(Transform(_nValPas, PesqPict("SZ2", "Z2_VALOR"))), oFont5)
	oPrint:Say(1525, 1550, "VEICULO  R$ " + AllTrim(Transform(_nValVei, PesqPict("SZ4", "Z4_VALOR"))), oFont5)

	RestArea(_xGetArea)
//************************Fim Box Despesas

//Inicio Box Adiantamento

	oPrint:Line(1725+100, 0100, 1725+100, 2379-100) //Linhas horizontais1
	oPrint:Line(1825+050, 0100, 1825+050, 2379-100) //Linhas horizontais2
	oPrint:Line(1875+050, 0100, 1875+050, 2379-100) //Linhas horizontais3
	oPrint:Line(1925+050, 0100, 1925+050, 2379-100) //Linhas horizontais4
	oPrint:Line(2125+050, 0100, 2125+050, 2379-100) //Linhas horizontais5
	
	oPrint:Line(1725+100, 0100, 2125+100, 0100) //Linhas vertical esquerda
	oPrint:Line(1725+100, 2379-100, 2125+100, 2379-100) //Linhas vertical direta

	oPrint:Say(1732+100, 0150, "ADIANTAMENTO", oFont2)
	
	oPrint:Say(1825+050, 0150, "Tipo de Diária:", oFont4)
	oPrint:Say(1825+050, 1050, "ADIANTAMENTO PARA DESPESAS", oFont5)

	oPrint:Say(1875+050, 0150, "Valor Autorizado para adiantamento:", oFont4)
	oPrint:Say(1875+050, 1050, "R$ " + AllTrim(Transform(aViagens[nI][15], PesqPict("SZ1", "Z1_ADIANTA"))) + "", oFont5)

	oPrint:Say(1925+050, 0150, "Recebi da FIESP a quantia de R$ " + AllTrim(Transform(aViagens[nI][15], PesqPict("SZ1", "Z1_ADIANTA"))) + ;
							" (" + AllTrim(Extenso(aViagens[nI][15], .F., 1, )) + "),", oFont7)
	oPrint:Say(1955+050, 0150, "correspondente ao adiantamento para despesas de viagem.", oFont7)
	
	oPrint:Say(2065+050, 0150, "Assinatura: ______________________    Data: ____/____/________", oFont5)
//************************Fim Box Adiantament0	


//Inicio Box Observação e Total Geral

	oPrint:Line(2225, 0100, 2335, 0100) //Linhas vertical esquerda
	oPrint:Line(2225, 2379-100, 2335, 2379-100) //Linhas vertical direta

	oPrint:Say(2215-45, 0150, "Observação", oFont4)

	cObs1 := ALLTRIM(MemoLine(SZ1->Z1_OBS,50,1)) //Upper(SubStr(SZ1->Z1_OBS, 1, 75))
	cObs2 := ALLTRIM(MemoLine(SZ1->Z1_OBS,50,2)) //Upper(SubStr(SZ1->Z1_OBS, 76, 75))
	cObs3 := ALLTRIM(MemoLine(SZ1->Z1_OBS,50,3)) //Upper(SubStr(SZ1->Z1_OBS, 151, 75))
	cObs4 := ALLTRIM(MemoLine(SZ1->Z1_OBS,50,4)) //Upper(SubStr(SZ1->Z1_OBS, 226, 75))

	oPrint:Say(2265-45, 0150, cObs1+" "+cObs2, oFont5)
	oPrint:Say(2315-45, 0150, cObs3+" "+cObs4, oFont5)


	_lAdt		:= If(nAdianta>0,.T.,.F.)
	oPrint:Say(2215-45   , 1050, "TOTAL GERAL ("+IIF((_lPas),"PASS ","")+IIF((_lHot),"HOTEL ","")+IIF((_lVei),"VEIC ","")+IIF((_lAdt),"ADT ","")+") R$ " + AllTrim(Transform(_nValPas+_nValHot+_nValVei+nAdianta, "@E 999,999,999.99")), oFont4)

//************************Fim Box Observação e Total Geral
	
	oPrint:Say(2335, 0150, "FATURAMENTO", oFont2)
	
	oPrint:Say(2375, 0150, "Centro de Custo", oFont6)
	oPrint:Say(2375, 0550, "Nome do Centro de Custo", oFont6)
	oPrint:Say(2375, 1150, "Convênio", oFont6)
	oPrint:Say(2375, 1450, "Nome do Convênio", oFont6)
	oPrint:Say(2375, 2050, "Percentual", oFont6)
	
	nLinIni := 2405
	
	For nY := 1 To Len(aViagens[nI][16])
		oPrint:Say(nLinIni, 0150, aViagens[nI][16][nY][1], oFont7)
		oPrint:Say(nLinIni, 0550, aViagens[nI][16][nY][2], oFont7)
		oPrint:Say(nLinIni, 1150, aViagens[nI][16][nY][3], oFont7)
		oPrint:Say(nLinIni, 1450, aViagens[nI][16][nY][4], oFont7)
		oPrint:Say(nLinIni, 2225, aViagens[nI][16][nY][5], oFont7, , , , 1)
		
		nLinIni += 30
	Next nY
	
	oPrint:Say(2565, 2225, "100,00 %", oFont6, , , , 1)
	
	oPrint:Say(2635, 0150, "APROVAÇÕES", oFont2)
	
	oPrint:Say(2735, 0150, "Superior Imediato:", oFont4)
	oPrint:Say(2935, 0150, "Diretor Responsável:", oFont4)
	oPrint:Say(3145, 0150, "GCF:", oFont4)
	
	oPrint:Say(2735, 1289, "Diretor Secretário:", oFont4)
	oPrint:Say(2935, 1289, "Diretor Financeiro:", oFont4)
	oPrint:Say(3145, 1289, "Presidente:", oFont4)
	
	oPrint:Say(2880, 0150, "Assinatura: ___________________   Data: ____/____/________", oFont7)
	oPrint:Say(3080, 0150, "Assinatura: ___________________   Data: ____/____/________", oFont7)
	oPrint:Say(3280, 0150, "Assinatura: ___________________   Data: ____/____/________", oFont7)
	
	oPrint:Say(2880, 1289, "Assinatura: ___________________   Data: ____/____/________", oFont7)
	oPrint:Say(3080, 1289, "Assinatura: ___________________   Data: ____/____/________", oFont7)
	oPrint:Say(3280, 1289, "Assinatura: ___________________   Data: ____/____/________", oFont7)
	
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
±±ºPrograma  ³FICDVR01  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
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
±±ºPrograma  ³FICDVR01  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
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
±±ºPrograma  ³FICDVR01  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
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
Local cRet := "NÃO"

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	DbSelectArea("SZ3")
	SZ3->(DbSetOrder(1))
	If (SZ3->(DbSeek(cFil + cNum)))
		While ((SZ3->(!Eof())) .And. (SZ3->Z3_FILIAL == cFil) .And. (SZ3->Z3_NUMSV == cNum))
			cRet := "SIM - " + Iif(SZ3->Z3_DIARIAS == "1", "DIÁRIAS", "DIÁRIAS + EXTRAS")

			SZ3->(DbSkip())
		Enddo
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICDVR01  ºAutor  ³Felipe Alves        º Data ³  22/11/13   º±±
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