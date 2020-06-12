#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR05  ºAutor  ³Felipe Alves        º Data ³  25/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINR05()
Local aArea      := {GetArea(), SZ0->(GetArea()), SZ1->(GetArea())}
Local lRet       := .T.
Local cPerg      := "FIFINR05"
Local cFornDe    := ""
Local cFornAte   := ""
Local cLojaDe    := ""
Local cLojaAte   := ""
Local cQuery     := ""
Local cTab       := ""
Local nI         := 0
Local cFornece   := ""
Local cLoja      := ""
Local cNomFor    := ""
Local cTpPatr    := ""
Local cNumPai    := ""
Local cPrefPai   := ""
Local cEmiPai    := ""
Local cValPai    := 0
Local cPrefixo   := ""
Local cNum       := ""
Local cParcela   := ""
Local cTipo      := ""
Local cNaturez   := ""
Local cPerc      := 0
Local cValor     := 0
Local cVencRea   := dDataBase
Local aDados     := {}

If (Pergunte(cPerg, .T.))
	cFornDe      := AllTrim(mv_par01)
	cLojaDe      := AllTrim(mv_par02)
	cFornAte     := AllTrim(mv_par03)
	cLojaAte     := AllTrim(mv_par04)
	
	cQuery       := "SELECT" + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_FORNECE FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_FORNECE FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) AS E2_FORNECE," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_LOJA FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_LOJA FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) AS E2_LOJA," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT A2_NOME FROM " + RetSQLName("SA2") + " WHERE A2_COD = (SELECT F1_FORNECE FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)) AND A2_LOJA = (SELECT F1_LOJA FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)))" + CRLF
    cQuery       += "ELSE (SELECT A2_NOME FROM " + RetSQLName("SA2") + " WHERE A2_COD = (SELECT E2_FORNECE FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)) AND A2_LOJA = (SELECT E2_LOJA FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)))" + CRLF
    cQuery       += "END) AS E2_NOMFOR," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT A2_XINSSP FROM " + RetSQLName("SA2") + " WHERE A2_COD = (SELECT F1_FORNECE FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)) AND A2_LOJA = (SELECT F1_LOJA FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)))" + CRLF
    cQuery       += "ELSE (SELECT A2_XINSSP FROM " + RetSQLName("SA2") + " WHERE A2_COD = (SELECT E2_FORNECE FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)) AND A2_LOJA = (SELECT E2_LOJA FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)))" + CRLF
    cQuery       += "END) AS A2_XINSSP," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_DOC FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_NUM FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) AS NUMPAI," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_SERIE FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_PREFIXO FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) AS PREFPAI," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_EMISSAO FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_EMISSAO FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) AS EMIPAI," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_VALBRUT FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_VALOR FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) AS VALPAI," + CRLF
    cQuery       += "E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_TIPO, E2.E2_NATUREZ," + CRLF
    cQuery       += "(CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT A2_XPERCP FROM " + RetSQLName("SA2") + " WHERE A2_COD = (SELECT F1_FORNECE FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)) AND A2_LOJA = (SELECT F1_LOJA FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)))" + CRLF
    cQuery       += "ELSE (SELECT A2_XPERCP FROM " + RetSQLName("SA2") + " WHERE A2_COD = (SELECT E2_FORNECE FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)) AND A2_LOJA = (SELECT E2_LOJA FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9)))" + CRLF
    cQuery       += "END) AS A2_XPERCP," + CRLF
    cQuery       += "E2.E2_VALOR, E2.E2_VENCREA" + CRLF
    cQuery       += "FROM " + RetSQLName("SE2") + " E2" + CRLF
    cQuery       += "WHERE E2_FILIAL = '" + xFilial("SE2") + "'" + CRLF
    cQuery       += "AND E2_PREFIXO = 'INS'" + CRLF
    cQuery       += "AND ((CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_FORNECE FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_FORNECE FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) BETWEEN '" + cFornDe + "' AND '" + cFornAte + "')" + CRLF
    cQuery       += "AND ((CASE" + CRLF
    cQuery       += "WHEN SUBSTRING(E2.E2_XRECPAI, 1, 3) = 'SF1' THEN (SELECT F1_LOJA FROM " + RetSQLName("SF1") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "ELSE (SELECT E2_LOJA FROM " + RetSQLName("SE2") + " WHERE R_E_C_N_O_ = SUBSTRING(E2.E2_XRECPAI, 4, 9))" + CRLF
    cQuery       += "END) BETWEEN '" + cLojaDe + "' AND '" + cLojaAte + "')" + CRLF
    cQuery       += "AND D_E_L_E_T_ = ''"
	
	cQuery       := ChangeQuery(cQuery)
	
	cTab         := GetNextAlias()
	
	TcQUERY cQuery NEW ALIAS ((cTab))
	
	DbSelectArea((cTab))
	(cTab)->(DbGoTop())
	
	While ((cTab)->(!Eof()))
		cFornece   := AllTrim((cTab)->(E2_FORNECE))
		cLoja      := AllTrim((cTab)->(E2_LOJA))
		cNomFor    := AllTrim((cTab)->(E2_NOMFOR))
		cTpPatr    := AllTrim(Iif((cTab)->(A2_XINSSP) == "1", "COOPERATIVA", "AUTÔNOMO"))
		cNumPai    := AllTrim((cTab)->(NUMPAI))
		cPrefPai   := AllTrim((cTab)->(PREFPAI))
		cEmiPai    := AllTrim(DToC(SToD((cTab)->(EMIPAI))))
		cValPai    := AllTrim(Transform((cTab)->(VALPAI), PesqPict("SE2", "E2_VALOR")))
		cPrefixo   := AllTrim((cTab)->(E2_PREFIXO))
		cNum       := AllTrim((cTab)->(E2_NUM))
		cParcela   := AllTrim((cTab)->(E2_PARCELA))
		cTipo      := AllTrim((cTab)->(E2_TIPO))
		cNaturez   := AllTrim((cTab)->(E2_NATUREZ))
		cPerc      := AllTrim(Transform((cTab)->(A2_XPERCP), PesqPict("SA2", "A2_XPERCP")))
		cValor     := AllTrim(Transform((cTab)->(E2_VALOR), PesqPict("SE2", "E2_VALOR")))
		cVencRea   := AllTrim(DToC(SToD((cTab)->(E2_VENCREA))))
		
		aAdd(aDados, {cFornece, cLoja, cNomFor, cTpPatr, cNumPai, cPrefPai, cEmiPai, cValPai, ;
					cPrefixo, cNum, cParcela, cTipo, cNaturez, cPerc, cValor, cVencRea})
		
		(cTab)->(DbSkip())
	Enddo
	
	(cTab)->(DbCloseArea())

	If (Len(aDados) > 0)
		RptStatus({|| FINR05(aDados)}, "Impressão de Relatório", "A g u a r d e . . .", .T.)
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
±±ºPrograma  ³FIFINR05  ºAutor  ³Microsiga           º Data ³  25/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FINR05(aDados)
Local aArea     := {GetArea()}
Local lRet      := .T.
Local cLinIni   := 0
Local nI        := 0
Local lBrush    := .T.
Local nPage     := 1

Private oPrint
Private cTitulo := "INSS PATRONAL"
Private oFont1  := TFont():New("Courier New", , 16, , .T., , , , .F., .F.)
Private oFont2  := TFont():New("Courier New", , 12, , .T., , , , .F., .F.)
Private oFont3  := TFont():New("Courier New", , 12, , .F., , , , .F., .F.)
Private oFont4  := TFont():New("Courier New", , 10, , .T., , , , .F., .F.)
Private oFont5  := TFont():New("Courier New", , 10, , .F., , , , .F., .F.)
Private oFont6  := TFont():New("Courier New", , 08, , .T., , , , .F., .F.)
Private oFont7  := TFont():New("Courier New", , 08, , .F., , , , .F., .F.)
Private oBrush  := TBrush():New(, CLR_HGRAY)

oPrint          := TMSPrinter():New(cTitulo)
oPrint:SetLandScape()
oPrint:SetPaperSize(9)
oPrint:Setup()

oPrint:StartPage()

oPrint:Box(0100, 0100, 0250, 3383)
oPrint:Box(0250, 0100, 2379, 3383)

oPrint:SayBitmap(0110, 0110, "logo_fiesp.jpg", 456, 128, , )
oPrint:Say(0155, 1354, "RELATÓRIO INSS PATRONAL", oFont1)

oPrint:Say(0260, 0110, "FORNECEDOR", oFont6)
oPrint:Say(0260, 0360, "RAZÃO SOCIAL", oFont6)
oPrint:Say(0260, 1060, "TIPO", oFont6)
oPrint:Say(0260, 1260, "DOC. ENT.", oFont6)
oPrint:Say(0260, 1460, "SÉRIE", oFont6)
oPrint:Say(0260, 1610, "EMISSÃO", oFont6)
oPrint:Say(0260, 1860, "VALOR", oFont6)
oPrint:Say(0260, 2060, "PREFIXO", oFont6)
oPrint:Say(0260, 2210, "NÚMERO", oFont6)
oPrint:Say(0260, 2360, "PARCELA", oFont6)
oPrint:Say(0260, 2510, "TIPO", oFont6)
oPrint:Say(0260, 2610, "NATUREZA", oFont6)
oPrint:Say(0260, 2810, "%", oFont6)
oPrint:Say(0260, 3010, "VALOR", oFont6)
oPrint:Say(0260, 3210, "VENCTO.", oFont6)

oPrint:Say(2389, 3233, "PÁGINA: " + cValToChar(nPage), oFont6)

nLinIni := 300

For nI := 1 To Len(aDados)
	If (nLinIni >= 2370)
		oPrint:EndPage()
		
		nLinIni := 300
		nPage++
		
		oPrint:StartPage()
	
		oPrint:Box(0100, 0100, 0250, 3383)
		oPrint:Box(0250, 0100, 2379, 3383)
		
		oPrint:SayBitmap(0110, 0110, "logo_fiesp.jpg", 456, 128, , )
		oPrint:Say(0155, 1354, "RELATÓRIO INSS PATRONAL", oFont1)
		
		oPrint:Say(0260, 0110, "FORNECEDOR", oFont6)
		oPrint:Say(0260, 0360, "RAZÃO SOCIAL", oFont6)
		oPrint:Say(0260, 1060, "TIPO", oFont6)
		oPrint:Say(0260, 1260, "DOC. ENT.", oFont6)
		oPrint:Say(0260, 1460, "SÉRIE", oFont6)
		oPrint:Say(0260, 1610, "EMISSÃO", oFont6)
		oPrint:Say(0260, 1860, "VALOR", oFont6)
		oPrint:Say(0260, 2060, "PREFIXO", oFont6)
		oPrint:Say(0260, 2210, "NÚMERO", oFont6)
		oPrint:Say(0260, 2360, "PARCELA", oFont6)
		oPrint:Say(0260, 2510, "TIPO", oFont6)
		oPrint:Say(0260, 2610, "NATUREZA", oFont6)
		oPrint:Say(0260, 2810, "%", oFont6)
		oPrint:Say(0260, 3010, "VALOR", oFont6)
		oPrint:Say(0260, 3210, "VENCTO.", oFont6)
		
		oPrint:Say(2389, 3233, "PÁGINA: " + cValToChar(nPage), oFont6)
	Endif
	
	If (lBrush)
		oPrint:FillRect({nLinIni, 0100, nLinIni + 30, 3383}, oBrush)
		lBrush := .F.
	Else
		lBrush := .T.
	Endif
	
	oPrint:Say(nLinIni, 0110, aDados[nI][1] + " " + aDados[nI][2], oFont7)
	oPrint:Say(nLinIni, 0360, aDados[nI][3], oFont7)
	oPrint:Say(nLinIni, 1060, aDados[nI][4], oFont7)
	oPrint:Say(nLinIni, 1260, aDados[nI][5], oFont7)
	oPrint:Say(nLinIni, 1460, aDados[nI][6], oFont7)
	oPrint:Say(nLinIni, 1619, aDados[nI][7], oFont7)
	oPrint:Say(nLinIni, 2040, aDados[nI][8], oFont7, , , , 1)
	oPrint:Say(nLinIni, 2060, aDados[nI][9], oFont7)
	oPrint:Say(nLinIni, 2210, aDados[nI][10], oFont7)
	oPrint:Say(nLinIni, 2360, aDados[nI][11], oFont7)
	oPrint:Say(nLinIni, 2510, aDados[nI][12], oFont7)
	oPrint:Say(nLinIni, 2610, aDados[nI][13], oFont7)
	oPrint:Say(nLinIni, 2990, aDados[nI][14], oFont7, , , , 1)
	oPrint:Say(nLinIni, 3190, aDados[nI][15], oFont7, , , , 1)
	oPrint:Say(nLinIni, 3210, aDados[nI][16], oFont7)
	
	nLinIni += 30
Next nI

oPrint:EndPage()
oPrint:Preview()
oPrint:End()

aEval(aArea, {|x| RestArea(x)})
Return(lRet)