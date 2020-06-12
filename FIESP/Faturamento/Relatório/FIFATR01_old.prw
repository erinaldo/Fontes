#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFATR01  ºAutor  ³TOTVS               º Data ³  08/21/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de Nota de Debito em formato HTML                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFATR01()

aPerguntas := {}
aRetorno   := {}

//Perguntas
AAdd(aPerguntas,{ 1,"Nota    ",Space(TamSx3("F2_DOC")[1])    ,""  ,,"SF2",,TamSx3("F2_DOC")[1]  ,.T.})
Aadd(aPerguntas,{ 1,"Serie   ",Space(TamSx3("F2_SERIE")[1])  ,"@!",,"",,TamSx3("F2_SERIE")[1],.T.})

If !ParamBox(aPerguntas,"Impressão Nota de Debito",@aRetorno)
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
Local cDirPasta  := "nfdebito\"
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

cFile      := _cWfDir +"nfdebito.html"
oHtml := TWFHtml():New(cFile)

DbSelectArea("SF2")
DbSetOrder(1)
If SF2->(DbSeek(xFilial("SF2")+mv_par01+mv_par02)) //Numero e Serie

	oHtml:ValByName("ndebito"	,	SF2->F2_DOC )
	oHtml:ValByName("razsoc"	,	Posicione("SA1",1,XFILIAL("SA1")+SF2->(F2_CLIENTE+F2_LOJA), "A1_NOME"))
	oHtml:ValByName("end"		,	Posicione("SA1",1,XFILIAL("SA1")+SF2->(F2_CLIENTE+F2_LOJA), "A1_END"))
	oHtml:ValByName("tel"		,	Posicione("SA1",1,XFILIAL("SA1")+SF2->(F2_CLIENTE+F2_LOJA), "A1_TEL"))
	oHtml:ValByName("email"		,	Posicione("SA1",1,XFILIAL("SA1")+SF2->(F2_CLIENTE+F2_LOJA), "A1_EMAIL"))
	oHtml:ValByName("insc"		,	Posicione("SA1",1,XFILIAL("SA1")+SF2->(F2_CLIENTE+F2_LOJA), "A1_INSCR"))
	oHtml:ValByName("cnpj"		,	Posicione("SA1",1,XFILIAL("SA1")+SF2->(F2_CLIENTE+F2_LOJA), "A1_CGC"))

	// verifica se o pedido foi totalmente liberado
	_cQuery  := "SELECT D2_COD, D2_PEDIDO, D2_QUANT, D2_PRCVEN, D2_TOTAL,  B1_DESC  "
	_cQuery  += "FROM " + RetSqlName("SD2")+ " SD2, "+ RetSqlName("SB1")+ " SB1 "
	_cQuery  += "WHERE SD2.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
	_cQuery  += "AND SD2.D2_COD = SB1.B1_COD "
	_cQuery  += "AND SD2.D2_DOC = '"+mv_par01+"' "
	_cQuery  += "AND SD2.D2_SERIE = '"+mv_par02+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBDEB",.t.,.t.)  

	DbSelectArea("TRBDEB")
	DbGotop()
	_nTot	:= 0
	IF TRBDEB->(!Eof())
		Do While !EOF()
			AAdd( (oHTML:ValByName("t.1"))			, TRBDEB->(D2_COD))
			AAdd( (oHTML:ValByName("t.2"))			, TRBDEB->(B1_DESC))
			AAdd( (oHTML:ValByName("t.3"))			, TRBDEB->(D2_PEDIDO))
			AAdd( (oHTML:ValByName("t.4"))			, TRANSFORM(TRBDEB->(D2_QUANT),'@E 9,999.99'))
			AAdd( (oHTML:ValByName("t.5"))			, TRANSFORM(TRBDEB->(D2_PRCVEN),'@E 9,999,999.99'))
			AAdd( (oHTML:ValByName("t.6"))			, TRANSFORM(TRBDEB->(D2_TOTAL),'@E 9,999,999.99'))
			_nTot:= _nTot + TRBDEB->(D2_TOTAL)
			TRBDEB->(DbSkip())
		EndDo
	EndIf

	oHtml:ValByName("total"		, TRANSFORM(_nTot,'@E 9,999,999.99') )

	DbSelectArea("SE1")
	DbSetOrder(1)
	If DbSeek(xFilial("SE1")+mv_par02+mv_par01)
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
	EndIf
	oHtml:ValByName("obs"		, "____________________")
	oHtml:ValByName("local"		, "____________________")

	oHtml:ValByName("endemp"		, SM0->M0_ENDCOB)
	oHtml:ValByName("cnpjemp"		, SM0->M0_CGC)
	oHtml:ValByName("munemp"		, SM0->(M0_CEPCOB +" "+ M0_CIDCOB+"-"+M0_ESTCOB))
	oHtml:ValByName("inscemp"		, SM0->M0_INSC)
	oHtml:ValByName("telemp"		, SM0->M0_TEL)
	oHtml:ValByName("emailemp"		, "contasareceber@fiesp.org.br")

Else
	msgBox("Nota de Debito não Encontrado!","Atencao")
	Return
EndIf

DbSelectArea("TRBDEB")
TRBDEB->(DbCloseArea())

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