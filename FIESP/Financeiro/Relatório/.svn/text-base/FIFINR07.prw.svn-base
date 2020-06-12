#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR07  ºAutor  ³Lígia Sarnauskas    º Data ³  17/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão de Relatório de Prestação de Contas de despesas   º±±
±±º          ³de Caixinha                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINR07()
Local lRet := .T.
Local aPerguntas := {}
Local aRetorno := {}

aAdd(aPerguntas, {1, "Caixa ...", Space(TamSX3("EU_CAIXA")[1]), "@!", , "SET"   , , TamSX3("EU_CAIXA")[1], .F.})
If !(ParamBox(aPerguntas, "Impressão Relatório de Prestação de Contas - Caixinha", @aRetorno))
	lRet := .F.
Endif

If (lRet)
	Processa({|| ImpRel07()}, "Processando Arquivos...")
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPREL07  ºAutor  ³                    º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel07()
Local lRet := .T.
Local cDoc := ""
Local cSerie := ""
Local cCliente := ""
Local cLoja := ""
Local lBrush := .F.
Local nTotal := 0
Local nCont := 1
Local cObs := ""
Public oPrint

_aMes:={}

Private cTitulo := "PRESTAÇÃO DE CONTAS CAIXA: "+MV_PAR01
Private oFont1 := TFont():New("Courier New", , 16, , .T., , , , .F., .F.)
Private oFont2 := TFont():New("Courier New", , 12, , .T., , , , .F., .F.)
Private oFont3 := TFont():New("Courier New", , 12, , .F., , , , .F., .F.)
Private oFont4 := TFont():New("Courier New", , 10, , .T., , , , .F., .F.)
Private oFont5 := TFont():New("Courier New", , 10, , .F., , , , .F., .F.)
Private oFont6 := TFont():New("Courier New", , 08, , .T., , , , .F., .F.)
Private oFont7 := TFont():New("Courier New", , 08, , .F., , , , .F., .F.)
Private oFont8 := TFont():New("Courier New", , 18, , .T., , , , .F., .F.)
Private oFont9 := TFont():New("Courier New", , 14, , .T., , , , .F., .F.)
Private oFont10:= TFont():New("Courier New", , 11, , .F., , , , .F., .F.)
Private oBrush  := TBrush():New(, CLR_HGRAY)

oPrint := TMSPrinter():New(cTitulo)
oPrint:SetLandScape()
oPrint:SetPaperSize(9)
oPrint:Setup()
oPrint:StartPage()

FieCabRel()  

_nLinha:=0410

If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf
_aProd:={}
cQuery := "SELECT EU_CAIXA, EU_TIPO, EU_HISTOR, EU_NRCOMP, EU_VALOR, EU_BENEF, EU_DTDIGIT, EU_EMISSAO, EU_NOME"
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SEU")+" SEU    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SEU.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SEU.EU_CAIXA   = '"+MV_PAR01+"'  "
cQuery := cQuery + " ORDER BY EU_DTDIGIT, EU_EMISSAO "
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
Dbgotop() 
_nRepos:=0
_nSaldo:=0
_nLinCx:=400
_nNumPg:=1        
_cDatab:=DTOS(DDATABASE)
_cHora:=TIME()
_cUsuario:=""
_NomeUser := substr(cUsuario,7,15)
// Defino a ordem
PswOrder(2) // Ordem de nome
     
// Efetuo a pesquisa, definindo se pesquiso usuário ou grupo
If PswSeek(_NomeUser,.T.)

// Obtenho o resultado conforme vetor
   _aRetUser := PswRet(1)

   _cUsuario:= upper(alltrim(_aRetUser[1,2]))
         
EndIf     

While !EOF()                                                                                                                          

If TMP->EU_TIPO == "10"                                                                                                           
oPrint:Say(_nLinha,0280, SUBSTR(TMP->EU_DTDIGIT,7,2)+"/"+SUBSTR(TMP->EU_DTDIGIT,5,2)+"/"+SUBSTR(TMP->EU_DTDIGIT,1,4), oFont7, , , , 1)
eLSE
oPrint:Say(_nLinha,0280, SUBSTR(TMP->EU_EMISSAO,7,2)+"/"+SUBSTR(TMP->EU_EMISSAO,5,2)+"/"+SUBSTR(TMP->EU_EMISSAO,1,4), oFont7, , , , 1)
Endif
If (TMP->EU_TIPO == "00" .OR. TMP->EU_TIPO == "01")
_cTipo:="Despesa"
ElseIf TMP->EU_TIPO == "10"
_cTipo:="Reposição"
ElseIf TMP->EU_TIPO == "02"           
_cTipo:="Devolução Adto"
ElseIf TMP->EU_TIPO == "03"           
_cTipo:="Complemento Adto"
Endif
oPrint:Say(_nLinha,0510, ALLTRIM(_cTipo), oFont7, , , , 1)

//oPrint:Say(_nLinha,980, ALLTRIM(TMP->EU_NOME), oFont7, , , , 1)
oPrint:Say(_nLinha,1250, ALLTRIM(TMP->EU_BENEF), oFont7, , , , 1)

oPrint:Say(_nLinha,2250, ALLTRIM(TMP->EU_HISTOR), oFont7, , , , 1)

If (TMP->EU_TIPO == "00" .OR. TMP->EU_TIPO == "01")
_nSaldo:=_nSaldo-TMP->EU_VALOR
oPrint:Say(_nLinha,2830,AllTrim(Transform(TMP->EU_VALOR, PesqPict("SEU", "EU_VALOR"))), oFont5, , , , 1)
ElseIf TMP->EU_TIPO == "10"   
_nRepos:=_nRepos+TMP->EU_VALOR
_nSaldo:=_nSaldo+TMP->EU_VALOR
oPrint:Say(_nLinha,2550,AllTrim(Transform(TMP->EU_VALOR, PesqPict("SEU", "EU_VALOR"))), oFont5, , , , 1)
ElseIf TMP->EU_TIPO == "02"           
_nSaldo:=_nSaldo+TMP->EU_VALOR
oPrint:Say(_nLinha,2550,AllTrim(Transform(TMP->EU_VALOR, PesqPict("SEU", "EU_VALOR"))), oFont5, , , , 1)
ElseIf TMP->EU_TIPO == "03"           
_nSaldo:=_nSaldo-TMP->EU_VALOR
oPrint:Say(_nLinha,2830,AllTrim(Transform(TMP->EU_VALOR, PesqPict("SEU", "EU_VALOR"))), oFont5, , , , 1)
Endif
oPrint:Say(_nLinha,3160,AllTrim(Transform(_nSaldo, PesqPict("SEU", "EU_VALOR"))), oFont5, , , , 1)

/* ********** Moldura da tabela ********** */
oPrint:Box(_nLinCx, 0100,_nLinCx+100, 3220)
// Data
oPrint:Box(_nLinCx, 0100,_nLinCx+100, 0300)
// Tp Movto
oPrint:Box(_nLinCx, 0300,_nLinCx+100, 0550)
// Num.Docto- Fornecedor
oPrint:Box(_nLinCx, 0550,_nLinCx+100, 1350)
// Beneficiario
//oPrint:Box(_nLinCx, 1000,_nLinCx+100, 1350)
// Observacoes
oPrint:Box(_nLinCx, 1350,_nLinCx+100, 2260)
// Créditos
oPrint:Box(_nLinCx, 2260,_nLinCx+100, 3220)
//Débitos
oPrint:Box(_nLinCx, 2580,_nLinCx+100, 3220)
//Saldo
oPrint:Box(_nLinCx, 2900,_nLinCx+100, 3220)

_nLinCx:=_nLinCx+100
_nLinha:=_nLinha+100

If _nLinha >= 2210
oPrint:Say(2310,3200,"Data de Impressão: "+SUBSTR(_cDatab,7,2)+"/"+SUBSTR(_cDatab,5,2)+"/"+SUBSTR(_cDatab,1,4)+" Hora: "+_cHora+" Usuário: "+_cUsuario+" Pg. "+ALLTRIM(STR(_nNumPg)), oFont6, , , , 1)
	    _nNumPg:=_nNumPg+1
	    _nLinha:=0410
	    _nLinCx:=400
	    oPrint:EndPage(.T.)
        oPrint:StartPage()  
        FieCabRel()
Endif
	
dbSelectArea("TMP")
Dbskip()	
Enddo

If _nLinha >= 2210                                    
oPrint:Say(2310,3200,"Data de Impressão: "+SUBSTR(_cDatab,7,2)+"/"+SUBSTR(_cDatab,5,2)+"/"+SUBSTR(_cDatab,1,4)+" Hora: "+_cHora+" Usuário: "+_cUsuario+" Pg. "+ALLTRIM(STR(_nNumPg)), oFont6, , , , 1)
	    _nNumPg:=_nNumPg+1
	    _nLinha:=0410
	    _nLinCx:=400
	    oPrint:EndPage(.T.)
        oPrint:StartPage() 
        FieCabRel()
Endif                                 

//Moldura Totais
//Descritivo    
oPrint:Box(_nLinCx, 2580,_nLinCx+100, 3220)
oPrint:Box(_nLinCx, 2900,_nLinCx+100, 3220)
_nLinCx:=_nLinCx+100
//Valor
oPrint:Box(_nLinCx, 2580,_nLinCx+100, 3220)
oPrint:Box(_nLinCx, 2900,_nLinCx+100, 3220)

oPrint:Say(_nLinha,2870,"DEVOLUÇÃO:", oFont2, , , , 1)
oPrint:Say(_nLinha,3160,AllTrim(Transform(_nSaldo, PesqPict("SEU", "EU_VALOR"))), oFont2, , , , 1)
_nLinha:=_nLinha+100
oPrint:Say(_nLinha,2870,"GASTOS:", oFont2, , , , 1)
oPrint:Say(_nLinha,3160,AllTrim(Transform((_nRepos-_nSaldo), PesqPict("SEU", "EU_VALOR"))), oFont2, , , , 1)

oPrint:Say(2310,3200, "Data de Impressão: "+SUBSTR(_cDatab,7,2)+"/"+SUBSTR(_cDatab,5,2)+"/"+SUBSTR(_cDatab,1,4)+" Hora: "+_cHora+" Usuário: "+_cUsuario+" Pg. "+ALLTRIM(STR(_nNumPg)), oFont6, , , , 1)

oPrint:EndPage()
oPrint:Preview()
oPrint:End()

Return(lRet)

Static Function FieCabRel()
oPrint:Box(0050, 0100, 0200, 3220)
oPrint:SayBitmap(053, 0103, "logo_fiesp.jpg", 524, 147, , )

oPrint:Box(0230, 0100, 0300, 3220)
oPrint:Say(0238, 0150, "    PRESTAÇÃO DE CONTAS - NUMERÁRIO: "+MV_PAR01+" - "+Posicione("SET", 1, xFilial("SET")+MV_PAR01, "ET_NOME"), oFont9, , , , 1)

/*****CABEÇALHO DA TABELA*****/
oPrint:Box(0320, 0100, 0400, 3220)

// Data
oPrint:Box(0320, 0100, 0400, 0300)
oPrint:Say(0330, 0250, "Data", oFont2, , , , 1)
// Tp Movto
oPrint:Box(0320, 0300, 0400, 0550)
oPrint:Say(0330, 0520, "Tp Movto", oFont2, , , , 1)
// Num.Docto- Fornecedor
oPrint:Box(0320, 0550, 0400, 1350)
oPrint:Say(0330, 1280, "No/Fornecedor/Beneficiário", oFont2, , , , 1)
// Beneficiario
/*oPrint:Box(0320, 1000, 0400, 1350)
oPrint:Say(0330, 1310, "Beneficiario", oFont2, , , , 1)*/
// Observacoes
oPrint:Box(0320, 1350, 0400, 2260)
oPrint:Say(0330, 1950, "Observaçoes", oFont2, , , , 1)
// Créditos
oPrint:Say(0330, 2520, "Créditos", oFont2, , , , 1)
oPrint:Box(0320, 2260, 0400, 3220)
//Débitos
oPrint:Say(0330, 2820, "Débitos", oFont2, , , , 1)
oPrint:Box(0320, 2580, 0400, 3220)
//Saldo
oPrint:Say(0330, 3120, "Saldo", oFont2, , , , 1)
oPrint:Box(0320, 2900, 0400, 3220)

Return()
