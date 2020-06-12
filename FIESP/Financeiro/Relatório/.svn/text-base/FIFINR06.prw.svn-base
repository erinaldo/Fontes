#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR06  ºAutor  ³                    º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINR06()
Local lRet := .T.
Local aPerguntas := {}
Local aRetorno := {}

aAdd(aPerguntas, {1, "Prefixo...", Space(TamSX3("E1_PREFIXO")[1]), "@!", , "FILSE5"   , , TamSX3("E1_PREFIXO")[1], .F.})
aAdd(aPerguntas, {1, "Documento.", Space(TamSX3("E1_NUM")[1])  , ""  , , "", , TamSX3("E1_NUM")[1]  , .T.})
aAdd(aPerguntas, {1, "Parcela...", Space(TamSX3("E1_PARCELA")[1])  , ""  , , "", , TamSX3("E1_PARCELA")[1]  , .F.})
aAdd(aPerguntas, {1, "Tipo......", Space(TamSX3("E1_TIPO")[1])  , ""  , , "", , TamSX3("E1_TIPO")[1]  , .F.})
If !(ParamBox(aPerguntas, "Impressão Recibo da Nota de Débito", @aRetorno))
	lRet := .F.
Endif

If (lRet)
	Processa({|| ImpRel06()}, "Processando Arquivos...")
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPREL06  ºAutor  ³                    º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel06()
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

_aMes:={}

AADD(_aMes,{"01","JANEIRO"})
AADD(_aMes,{"02","FEVEREIRO"})
AADD(_aMes,{"03","MARCO"})
AADD(_aMes,{"04","ABRIL"})
AADD(_aMes,{"05","MAIO"})
AADD(_aMes,{"06","JUNHO"})
AADD(_aMes,{"07","JULHO"})
AADD(_aMes,{"08","AGOSTO"})
AADD(_aMes,{"09","SETEMBRO"})
AADD(_aMes,{"10","OUTUBRO"})
AADD(_aMes,{"11","NOVEMBRO"})
AADD(_aMes,{"12","DEZEMBRO"})

Private cTitulo := "RECIBO"
Private oFont1 := TFont():New("Courier New", , 16, , .T., , , , .F., .F.)
Private oFont2 := TFont():New("Courier New", , 12, , .T., , , , .F., .F.)
Private oFont3 := TFont():New("Courier New", , 12, , .F., , , , .F., .F.)
Private oFont4 := TFont():New("Courier New", , 10, , .T., , , , .F., .F.)
Private oFont5 := TFont():New("Courier New", , 10, , .F., , , , .F., .F.)
Private oFont6 := TFont():New("Courier New", , 08, , .T., , , , .F., .F.)
Private oFont7 := TFont():New("Courier New", , 08, , .F., , , , .F., .F.)
Private oFont8 := TFont():New("Courier New", , 18, , .T., , , , .F., .F.)
Private oBrush  := TBrush():New(, CLR_HGRAY)

Dbselectarea("SE5")
Dbsetorder(7)
If Dbseek(xFilial("SE5") + mv_par01 + mv_par02+mv_par03)
		cDoc := SE5->E5_NUMERO
		cSerie := SE5->E5_PREFIXO
		cParcela:= SE5->E5_PARCELA
		cCliente := SE5->E5_CLIFOR
		cLoja := SE5->E5_LOJA
		cObs := ""//???
		
		oPrint := TMSPrinter():New(cTitulo)
		oPrint:SetPortrait()
		oPrint:SetPaperSize(9)
		oPrint:Setup()
		oPrint:StartPage()
		
		oPrint:Box(0050, 0100, 0200, 2379)
		
		oPrint:SayBitmap(053, 0103, "logo_fiesp.jpg", 524, 147, , )
		oPrint:Say(0055, 2374, "RECIBO Nº: " + AllTrim(cDoc) + "/" + AllTrim(cSerie) + "-"+aLLTRIM(cParcela), oFont8, , , , 1)
		
		oPrint:Box(0200, 0100, 0250, 2379)
		
		oPrint:Box(0250, 1874, 0400, 2379)
		oPrint:Say(0270, 2374, "R$ "+AllTrim(Transform(SE5->E5_VALOR, PesqPict("SE5", "E5_VALOR"))), oFont8, , , , 1)
		
		oPrint:Box(0400, 0100, 0550, 2379)
		oPrint:Say(0420, 0105, "RECEBEMOS DE: ", oFont2)
		oPrint:Say(0500, 0105, SE5->E5_CLIFOR +"/"+SE5->E5_LOJA+" - "+Posicione("SA1", 1, xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA, "A1_NOME")+" - ("+ALLTRIM(Posicione("SA1", 1, xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA, "A1_NREDUZ"))+")", oFont3)
		
		oPrint:Box(0550, 0100, 0750, 2379)
		oPrint:Say(0570, 0105, "A QUANTIA DE: ", oFont2)
		
		_nVlExt:=len(EXTENSO(SE5->E5_VALOR))
		
		If _nVlExt < 230
			_cVlExt:=EXTENSO(SE5->E5_VALOR)+""+Repl("*",(230-_nVlExt))
		Endif
		
		_clIni:=0
		_cLinha:=0650
		For n:=1 to 2
			oPrint:Say(_cLinha, 0105, substr(_cVlExt,_clIni,115), oFont3)
			_clIni:=116
			_cLinha:=_cLinha+050
		Next n
		
		
		oPrint:Box(0750, 0100, 1300, 2379)
		oPrint:Say(0770, 0105, "REFERENTE: ", oFont2)
		oPrint:Say(0840, 0105, "Referente ao pagamento da Nota de débito: "+ALLTRIM(cDoc)+".", oFont5)
		oPrint:Say(0900, 0105, "Produtos: ", oFont5)
		
		_nLIN:=0940
	If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf
_aProd:={}		
cQuery := "SELECT D2_COD, B1_DESC "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SD2")+" SD2 ,   "
cQuery := cQuery + RetSQLname("SB1")+" SB1     "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SD2.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SD2.D2_DOC     = '"+SE5->E5_NUMERO+"'  "
cQuery := cQuery + " AND SD2.D2_SERIE   = '"+SE5->E5_PREFIXO+"' "
cQuery := cQuery + " AND SD2.D2_CLIENTE = '"+SE5->E5_CLIFOR+"'  "
cQuery := cQuery + " AND SD2.D2_LOJA    = '"+SE5->E5_LOJA+"'  "
cQuery := cQuery + " AND SB1.B1_COD     = SD2.D2_COD            " 
cQuery := cQuery + " AND SB1.D_E_L_E_T_ = ''  "
cQuery := cQuery + " GROUP BY D2_COD, B1_DESC "
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
Dbgotop()

While !EOF()
oPrint:Say(_nLin, 0105, TMP->D2_COD+" - "+TMP->B1_DESC, oFont5)
_nLin:=_nLin+40
dbSelectArea("TMP")
Dbskip()
Enddo		
		
		
		_cMES:=SUBSTR(DTOS(SE5->E5_DATA),5,2)
		_cDescMes:=""
		For n:=1 to len(_aMes)
		   If _aMes[n,1] == _cMES
		  _cDescMes:= ALLTRIM(_aMes[n,2])
		  Endif
		Next n
		
		oPrint:Say(1350, 0105, "SÃO PAULO, "+SUBSTR(DTOS(SE5->E5_DATA),7,2)+" DE "+_cDescMes+" DE "+SUBSTR(DTOS(SE5->E5_DATA),1,4)+".", oFont2)
		
		oPrint:Say(1420, 1150, "FEDERAÇÃO DAS INDUSTRIAS DO ESTADO DE SÃO PAULO", oFont1)
		
		oPrint:Box(1470, 0100, 1510, 2379)
		
		oPrint:Say(1530, 1350, "Av.Paulista, 1313          C.N.P.J.: 62.225.933/0001-34", oFont5)
		oPrint:Say(1570, 1350, "01311-923 São Paulo - SP   Inscr.Est.: ISENTO          ", oFont5)
		oPrint:Say(1610, 1350, "Tel.: (011) 3549-4323      www.fiesp.com.br            ", oFont5)
		oPrint:Say(1650, 1350, "Fax.: (011) 3549-4664      contasareceber@fiesp.org.br ", oFont5)
				
		oPrint:EndPage()
		oPrint:Preview()
		oPrint:End()
	/*Else
		Aviso("Aviso", "Nenhum registro encontrado.", {"Ok"}, 1)
		lRet := .F.
	Endif*/
Else
	alert("Não houve baixa nesse título. Então não será possível emitir o recibo!")
Endif
Return(lRet)
