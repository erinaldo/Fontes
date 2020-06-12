#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR02  ºAutor  ³TOTVS               º Data ³  08/21/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de Fatura em formato HTML                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINR02()

aPerguntas := {}
aRetorno   := {}

//Perguntas
AAdd(aPerguntas,{ 1,"Fatura    ",Space(TamSx3("E1_NUM")[1])    ,""  ,,"SE1FAT",,TamSx3("E1_NUM")[1]    ,.T.})
Aadd(aPerguntas,{ 1,"Prefixo   ",Space(TamSx3("E1_PREFIXO")[1]),"@!",,""      ,,TamSx3("E1_PREFIXO")[1],.T.})

If !ParamBox(aPerguntas,"Impressão Fatura",@aRetorno)
	Return(Nil)
EndIf

Processa( {|| ImpRel() }, "Processando Arquivos..." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINR02  ºAutor  ³Microsiga           º Data ³  08/21/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel()

Local _cWfDir    := Iif(RTrim(Right(GetNewPar("MV_WFDIR"),1))=="\",GetNewPar("MV_WFDIR"),GetNewPar("MV_WFDIR")+"\")
Local cWFHTTP    := Iif(Right(RTrim(GetNewPar("MV_WFDHTTP")),1)=="/",GetNewPar("MV_WFDHTTP"),GetNewPar("MV_WFDHTTP")+"/")
Local cDirHtml   := "html\"
Local cDirPasta  := "faturas\"
Local cFile      := ""
Local cFileHTML  := CriaTrab( NIL , .F. ) + ".htm"
Local oBrowser   := nil
Local oNavigate  := nil
Local oHtml      := nil
Local aButtons   := {}

// Verifica e cria, se necessario, o diretorio para gravacao do HTML
aDirHtml   := Directory(_cWfDir+"emp"+cEmpAnt+"\*.*", "D",Nil,.T.)		
If aScan( aDirHtml, {|aDir| aDir[1] == Upper( Iif(Right(cDirHtml,1)=="\", Left(cDirHtml,Len(cDirHtml)-1), cDirHtml) ) } ) == 0
	If MakeDir(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml)	 == 0
		ConOut(":: Diretorio dos HTML's criado com sucesso. -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )		
	Else
		ConOut(":: Erro na criacao do diretorio dos HTML's! -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )
		cDirHtml := "temp\"
	EndIf
EndIf
		
// Verifica e cria, se necessario, a pasta especifica do Workflow para gravacao do HTML
aDirHtml   := Directory(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+"*.*", "D",Nil,.T.)
If aScan( aDirHtml, {|aDir| aDir[1] == Upper(Iif(Right(cDirPasta,1)=="\", Left(cDirPasta,Len(cDirPasta)-1), cDirPasta) ) } ) == 0
	If MakeDir(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta) == 0
		ConOut(":: Diretorio de Pasta dos HTML's criado com sucesso. -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta )		
	Else
		ConOut(":: Erro na criacao do diretorio dos HTML's! -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta )
		cDirPasta := ""
	EndIf
EndIf

cFile      := _cWfDir +"fatura.html"
oHtml := TWFHtml():New(cFile)

DbSelectArea("SE1")
DbSetOrder(1)
If SE1->(DbSeek(xFilial("SE1")+mv_par02+mv_par01)) //Prefixo e Numero

	oHtml:ValByName("nfatura"	,	SE1->E1_NUM )
	oHtml:ValByName("razsoc"	,	Posicione("SA1",1,XFILIAL("SA1")+SE1->(E1_CLIENTE+E1_LOJA), "A1_NOME"))
	oHtml:ValByName("end"		,	Posicione("SA1",1,XFILIAL("SA1")+SE1->(E1_CLIENTE+E1_LOJA), "A1_END"))
	oHtml:ValByName("tel"		,	Posicione("SA1",1,XFILIAL("SA1")+SE1->(E1_CLIENTE+E1_LOJA), "A1_TEL"))
	oHtml:ValByName("fax"		,	Posicione("SA1",1,XFILIAL("SA1")+SE1->(E1_CLIENTE+E1_LOJA), "A1_FAX"))
	oHtml:ValByName("email"		,	Posicione("SA1",1,XFILIAL("SA1")+SE1->(E1_CLIENTE+E1_LOJA), "A1_EMAIL"))
	oHtml:ValByName("cnpj"		,	Posicione("SA1",1,XFILIAL("SA1")+SE1->(E1_CLIENTE+E1_LOJA), "A1_CGC"))

	// verifica se o pedido foi totalmente liberado
	_cQuery  := "SELECT E1_NUM, E1_PARCELA, E1_EMISSAO, E1_NATUREZ, E1_VALOR, ED_DESCRIC  "
	_cQuery  += "FROM " + RetSqlName("SE1")+ " SE1, "+ RetSqlName("SED")+ " SED "
	_cQuery  += "WHERE SE1.D_E_L_E_T_ = '' AND SED.D_E_L_E_T_ = '' "
	_cQuery  += "AND SE1.E1_NATUREZ = SED.ED_CODIGO "
	_cQuery  += "AND SE1.E1_FATURA BETWEEN '"+mv_par01+"' AND '"+mv_par01+"' "
	_cQuery  += "AND SE1.E1_FATPREF = '" + mv_par02   +"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBFAT",.t.,.t.)  

	TcSetField("TRBFAT","E1_EMISSAO","D",8, 0 )
	
	DbSelectArea("TRBFAT")
	DbGotop()
	_nTot	:= 0
	IF TRBFAT->(!Eof())
		Do While !EOF()
			AAdd( (oHTML:ValByName("t.1"))			, TRBFAT->(E1_NUM)+"/"+TRBFAT->(E1_PARCELA))
			AAdd( (oHTML:ValByName("t.2"))			, TRBFAT->(E1_EMISSAO))
			AAdd( (oHTML:ValByName("t.3"))			, TRBFAT->(E1_NATUREZ))
			AAdd( (oHTML:ValByName("t.4"))			, TRBFAT->(ED_DESCRIC))
			AAdd( (oHTML:ValByName("t.5"))			, TRANSFORM(TRBFAT->(E1_VALOR),'@E 9,999,999.99'))
			_nTot:= _nTot + TRBFAT->(E1_VALOR)
			TRBFAT->(DbSkip())
		EndDo
	EndIf

	oHtml:ValByName("total"		, TRANSFORM(_nTot,'@E 9,999,999.99') )

	DbSelectArea("SE1")
	DbSetOrder(1)
	_nCont	:= 1
	Do While !EOF() .and. SE1->(E1_PREFIXO+E1_NUM) == mv_par02+mv_par01
			If _nCont == 1
				oHTML:ValByName("d1"			, SE1->E1_VENCREA)
				oHTML:ValByName("d2"			, "")
				oHTML:ValByName("d3"			, "")
				oHTML:ValByName("d4"			, "")
				oHTML:ValByName("d5"			, "")
				oHTML:ValByName("d6"			, "")
				oHTML:ValByName("d7"			, "")

				oHTML:ValByName("v1"			, TRANSFORM(SE1->E1_VALOR,'@E 9,999,999.99'))
				oHTML:ValByName("v2"			, 0)
				oHTML:ValByName("v3"			, 0)
				oHTML:ValByName("v4"			, 0)
				oHTML:ValByName("v5"			, 0)
				oHTML:ValByName("v6"			, 0)
				oHTML:ValByName("v7"			, 0)
			ElseIf _nCont == 2
				oHTML:ValByName("d2"			, SE1->E1_VENCREA)
				oHTML:ValByName("d3"			, "")
				oHTML:ValByName("d4"			, "")
				oHTML:ValByName("d5"			, "")
				oHTML:ValByName("d6"			, "")
				oHTML:ValByName("d7"			, "")

				oHTML:ValByName("v2"			, TRANSFORM(SE1->E1_VALOR,'@E 9,999,999.99'))
				oHTML:ValByName("v3"			, 0)
				oHTML:ValByName("v4"			, 0)
				oHTML:ValByName("v5"			, 0)
				oHTML:ValByName("v6"			, 0)
				oHTML:ValByName("v7"			, 0)
			ElseIf _nCont == 3
				oHTML:ValByName("d3"			, SE1->E1_VENCREA)
				oHTML:ValByName("d4"			, "")
				oHTML:ValByName("d5"			, "")
				oHTML:ValByName("d6"			, "")
				oHTML:ValByName("d7"			, "")

				oHTML:ValByName("v3"			, TRANSFORM(SE1->E1_VALOR,'@E 9,999,999.99'))
				oHTML:ValByName("v4"			, 0)
				oHTML:ValByName("v5"			, 0)
				oHTML:ValByName("v6"			, 0)
				oHTML:ValByName("v7"			, 0)
			ElseIf _nCont == 4
				oHTML:ValByName("d4"			, SE1->E1_VENCREA)
				oHTML:ValByName("d5"			, "")
				oHTML:ValByName("d6"			, "")
				oHTML:ValByName("d7"			, "")

				oHTML:ValByName("v4"			, TRANSFORM(SE1->E1_VALOR,'@E 9,999,999.99'))
				oHTML:ValByName("v5"			, 0)
				oHTML:ValByName("v6"			, 0)
				oHTML:ValByName("v7"			, 0)
			ElseIf _nCont == 5
				oHTML:ValByName("d5"			, SE1->E1_VENCREA)
				oHTML:ValByName("d6"			, "")
				oHTML:ValByName("d7"			, "")

				oHTML:ValByName("v5"			, TRANSFORM(SE1->E1_VALOR,'@E 9,999,999.99'))
				oHTML:ValByName("v6"			, 0)
				oHTML:ValByName("v7"			, 0)
			ElseIf _nCont == 6
				oHTML:ValByName("d6"			, SE1->E1_VENCREA)
				oHTML:ValByName("d7"			, "")

				oHTML:ValByName("v6"			, TRANSFORM(SE1->E1_VALOR,'@E 9,999,999.99'))
				oHTML:ValByName("v7"			, 0)
			ElseIf _nCont == 7
				oHTML:ValByName("d7"			, SE1->E1_VENCREA)

				oHTML:ValByName("v7"			, TRANSFORM(SE1->E1_VALOR,'@E 9,999,999.99'))
			EndIf	

			_nCont++
		SE1->(DbSkip())
	EndDo
	oHtml:ValByName("obs"		, SE1->E1_HIST)
	oHtml:ValByName("local"		, "____________________")

	oHtml:ValByName("endemp"		, SM0->M0_ENDCOB)
	oHtml:ValByName("cnpjemp"		, SM0->M0_CGC)
	oHtml:ValByName("munemp"		, SM0->(M0_CEPCOB +" "+ M0_CIDCOB+"-"+M0_ESTCOB))
	oHtml:ValByName("inscemp"		, SM0->M0_INSC)
	oHtml:ValByName("telemp"		, SM0->M0_TEL)
	oHtml:ValByName("emailemp"		, "fiespciesp@fiesp.org.br")
Else
	msgBox("Titulo não Encontrado!","Atencao")
	Return
EndIf
DbSelectArea("TRBFAT")
TRBFAT->(DbCloseArea())

oHTML:SaveFile( cFileHTML )
cHtml := WFLoadFile(cFileHTML)
cHtml := StrTran(cHtml,chr(13),"")
cHtml := StrTran(cHtml,chr(10),"")
FErase(cFileHTML)

cDirHtml2  := "emp"+cEmpAnt+"\" + cDirHtml + cDirPasta
// Grava o arquivo no computador cliente.
cNomeFile := CriaTrab(nil, .F.) + ".html"
nHdlHTML  := fCreate(_cWfDir + cDirHtml2 + cNomeFile)
FWrite(nHdlHTML, cHtml)
FClose(nHdlHTML)

// Desenha a DIALOG para visualizar o relatorio.
define MSDialog oBrowser from 0, 0 to 600, 800 title 'Impressão Fatura' pixel

oBrowser:lMaximized := .T.
oNavigate := TIBrowser():New(100, 100, 600, 800, '', oBrowser)
oNavigate:Align := CONTROL_ALIGN_ALLCLIENT
oNavigate:Navigate(cWFHTTP+cDirHtml2+cNomeFile)

//aAdd(aButtons, {"WEB", {|| EnvioEmail(aDados, cFile) }, "E-Mail"})
aAdd(aButtons, {"WEB", {|| oNavigate:Print() }, "Print"})

Activate MSDialog oBrowser centered on init EnchoiceBar(oBrowser, {|| oBrowser:End()}, {|| oBrowser:End()},, aButtons)

//fErase(cNomeFile)

Return