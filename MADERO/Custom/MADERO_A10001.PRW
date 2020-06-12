#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} A10001
Tela de integração com a balança.
@type function
@author Funaki
@since 26/04/2018
@version 1.0
/*/
User Function A10001()

	Local _aSizeAut	:= MsAdvSize(.F.,.F.,400)
	Local _aObjects	:= {}
	Local _aInfo	:= {}
	Local _aButtons	:= {}
	Local _nTipo	:= 1
	Local _aTipo	:= {"Requisição","Devolução"}
	Local _oFont18	:= TFont():New('Arial',,-18,.T.)
	Local _oFont32	:= TFont():New('Arial',,-32,.T.)
	Local _lLibMan	:= (Alltrim(RetCodUsr())$Alltrim(GetMv("MV_XPESM",,"")))

	Private _nTpSel		:= 1
	Private oReq, oDev
	Private _cOP		:= CriaVar("D3_OP",.F.)
	Private _cOPAtu		:= CriaVar("D3_OP",.F.)
	Private _cLoteOP	:= CriaVar("C2_XLOTE",.F.)
	Private _cProd		:= CriaVar("B1_COD",.F.)
	Private _cDesPrd	:= CriaVar("B1_DESC",.F.)
	Private _cPrdAtu	:= CriaVar("B1_COD",.F.)
	Private _nTara		:= 0
	Private _nPBruto	:= 0
	Private _nPLiq		:= 0
	Private _npBal		:= 0
	Private _nPTol		:= 0
	Private _nPMan		:= 0
	Private _nTaraMan	:= 0
	Private _nQtdSD4	:= 0
	Private _cLoteSD4	:= CriaVar("D4_LOTECTL",.F.)

	oTFont := TFont():New('Arial',,16,,.T.)

	// Inicia a construção da tela
	_aObjects := {}
	AADD(_aObjects, { 0, 35, .T., .F. })
	AADD(_aObjects, { 0, 70, .T., .F. })
	AADD(_aObjects, { 0, 90, .T., .F. })
	AADD(_aObjects, { 0, 50, .T., .F. })
	AADD(_aObjects, { 0, 28, .T., .F. })

	_aInfo := {_aSizeAut[1],_aSizeAut[2],_aSizeAut[3],_aSizeAut[4],3,3}

	_aPosObj := MsObjSize(_aInfo,_aObjects)
	_aPosGet := MsObjGetPos(_aSizeAut[3]-_aSizeAut[1],310,;
							{{5,27,80,110,145,155,180,205,220,235},;
							{5,30,60,70,160,185,205,213},;
							{5,35,50,70},;
							{5,30,55,80,105,130,155,180},;
							{5,30,55,80,105,130,155,180,205,230}})

	DEFINE MSDIALOG oDlg FROM _aSizeAut[7],0 TO _aSizeAut[6],_aSizeAut[5] TITLE "[A10001] - Pesagem" Of oMainWnd PIXEL
	@_aPosObj[1,1],_aPosObj[1,2] TO _aPosObj[1,1]+45,_aPosObj[1,2]+120 LABEL "[ Tipo ]" OF oDlg PIXEL
	oReq := tPanel():New(_aPosObj[1,1]+10,_aPosObj[1,2]+5,"Requisição",oDlg,oTFont,.T.,,CLR_BLACK,CLR_LIGHTGRAY,50,30,.F.,.T.)
	oReqSel := tPanel():New(_aPosObj[1,1]+10,_aPosObj[1,2]+5,"Requisição",oDlg,oTFont,.T.,,CLR_WHITE,CLR_BLUE,50,30,.T.,.F.)
	oReq:blClicked := {|| fTipo(1) }
	oReqSel:blClicked := {|| fTipo(1) }
	oReq:lVisibleControl := .F.
	oDev := tPanel():New(_aPosObj[1,1]+10,_aPosObj[1,2]+63,"Devolução",oDlg,oTFont,.T.,,CLR_BLACK,CLR_LIGHTGRAY,50,30,.F.,.T.)
	oDevSel := tPanel():New(_aPosObj[1,1]+10,_aPosObj[1,2]+63,"Devolução",oDlg,oTFont,.T.,,CLR_WHITE,CLR_BLUE,50,30,.T.,.F.)
	oDev:blClicked := {|| fTipo(2) }
	oDevSel:blClicked := {|| fTipo(2) }
	oDevSel:lVisibleControl := .F.

	@_aPosObj[1,1],_aPosObj[1,2]+130 TO _aPosObj[1,1]+63,_aPosObj[1,4] LABEL "[ Ordem de Produção ]" OF oDlg PIXEL

	TSay():New(_aPosObj[1,1]+10,_aPosObj[1,2]+140,{|| "OP: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	_oGetOP := TGet():New(_aPosObj[1,1]+10,_aPosObj[1,2]+184,{|u| if(PCount()>0,_cOP:=u,_cOp)}, oDlg,100,11,'@!', { || fOP() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,"SC2",_cOP)

	TSay():New(_aPosObj[1,1]+10,_aPosObj[1,2]+294,{|| "Lote OP: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(_aPosObj[1,1]+10,_aPosObj[1,2]+334,{|u| if(PCount()>0,_cLoteOP:=u,_cLoteOP)}, oDlg,100,11,'@!', { || .t. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cLoteOP)

	TSay():New(_aPosObj[1,1]+28,_aPosObj[1,2]+140,{|| "Produto: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(_aPosObj[1,1]+28,_aPosObj[1,2]+184,{|u| if(PCount()>0,_cProd:=u,_cProd)}, oDlg,100,11,'@!', { || fProd() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,"SD4SB1",_cProd)
	TGet():New(_aPosObj[1,1]+28,_aPosObj[1,2]+284,{|u| if(PCount()>0,_cDesPrd:=u,_cDesPrd)}, oDlg,250,11,'@!', { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cDesPrd)

	TSay():New(_aPosObj[1,1]+46,_aPosObj[1,2]+140,{|| "Lote Prd.: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(_aPosObj[1,1]+46,_aPosObj[1,2]+184,{|u| if(PCount()>0,_cLoteSD4:=u,_cLoteSD4)}, oDlg,100,11,PesqPict("SD4","D4_LOTECTL"), { || ValLote(_cOP,_cProd,_cLoteSD4) },,,_oFont18,,,.T.,,, {|| .F. /*_nTpSel != 1 */} ,,,,.F.,,,_cLoteSD4)

	TSay():New(_aPosObj[1,1]+46,_aPosObj[1,2]+294,{|| "Saldo: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(_aPosObj[1,1]+46,_aPosObj[1,2]+334,{|u| if(PCount()>0,_nQtdSD4:=u,_nQtdSD4)}, oDlg,100,11,PesqPict("SD4","D4_QUANT"), { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,CVALTOCHAR(_nQtdSD4))

	@_aPosObj[1,1]+50,_aPosObj[1,2] TO _aPosObj[1,1]+205,_aPosObj[1,2]+120 LABEL "[ Ações ]" OF oDlg PIXEL
	TButton():New(_aPosObj[1,1]+65,_aPosObj[1,2]+10, "Realizar Pesagem", oDlg,{|| fPesagem() }, 100,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	//TButton():New(_aPosObj[1,1]+110,_aPosObj[1,2]+10, "Informar Tara", oDlg,{|| oDlg:End() }, 100,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(_aPosObj[1,1]+110,_aPosObj[1,2]+10, "Confirmar", oDlg,{|| fConfirma() }, 100,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(_aPosObj[1,1]+155,_aPosObj[1,2]+10, "Fechar", oDlg,{|| oDlg:End() }, 100,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	@_aPosObj[1,1]+68,_aPosObj[1,2]+130 TO _aPosObj[1,1]+106,_aPosObj[1,2]+285 LABEL "[ Tara ]" OF oDlg PIXEL
	//_nTara := 999999.9999
	oTara  := TSay():New(_aPosObj[1,1]+81,_aPosObj[1,2]+162,{|| Transform(_nTara, PesqPict("SB1","B1_PESO")) },oDlg,,_oFont32,,,,.T.,CLR_HBLUE,CLR_WHITE,100)

	@_aPosObj[1,1]+110,_aPosObj[1,2]+130 TO _aPosObj[1,1]+148,_aPosObj[1,2]+285 LABEL "[ Peso Bruto ]" OF oDlg PIXEL
	//_nPBruto := 999999999.99
	oPBruto  := TSay():New(_aPosObj[1,1]+123,_aPosObj[1,2]+149,{|| TRANSFORM(_nPBruto, PesqPict("SB1","B1_PESO")) },oDlg,,_oFont32,,,,.T.,CLR_BLACK,CLR_WHITE,120)

	@_aPosObj[1,1]+152,_aPosObj[1,2]+130 TO _aPosObj[1,1]+190,_aPosObj[1,2]+285 LABEL "[ Peso Líquido ]" OF oDlg PIXEL
	//_nPLiq := 999999999.99
	oPLiq  := TSay():New(_aPosObj[1,1]+165,_aPosObj[1,2]+149,{|| TRANSFORM(_nPLiq, PesqPict("SB1","B1_PESO")) },oDlg,,_oFont32,,,,.T.,CLR_BLACK,CLR_WHITE,120)

	@_aPosObj[1,1]+68,_aPosObj[1,2]+300 TO _aPosObj[1,1]+106,_aPosObj[1,2]+550 LABEL "[ Ajustar Tara ]" OF oDlg PIXEL
	TSay():New(_aPosObj[1,1]+83,_aPosObj[1,2]+310,{|| "Tara: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(_aPosObj[1,1]+83,	_aPosObj[1,2]+375	,{|u| if(PCount()>0,_nTaraMan:=u,_nTaraMan)}	, oDlg	,90	,11	,PesqPict("SB1","B1_PESO"), { || fTara() }	,,,_oFont18,,,.T.,,, {|| _lLibMan } ,,,,.F.,,,CVALTOCHAR(_nTaraMan))

	@_aPosObj[1,1]+110,_aPosObj[1,2]+300 TO _aPosObj[1,1]+148,_aPosObj[1,2]+550 LABEL "[ Peso Manual ]" OF oDlg PIXEL
	TSay():New(_aPosObj[1,1]+121,_aPosObj[1,2]+310,{|| "Peso Manual: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(_aPosObj[1,1]+121,_aPosObj[1,2]+375,{|u| if(PCount()>0,_nPMan:=u,_nPMan)}, oDlg,90,11,PesqPict("SB1","B1_PESO"), { || fPMan() },,,_oFont18,,,.T.,,, {|| _lLibMan } ,,,,.F.,,,CVALTOCHAR(_nPMan))
	ACTIVATE MSDIALOG oDlg CENTERED
Return

/*/{Protheus.doc} fConfirma
Função de confirmação da tela
@type function
@author Funaki
@since 07/05/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fConfirma()

	Local _aSD3		:= {}
	Local _cTM		:= ""
	Local _lImprime	:= GetMv("MV_XETEMP",,.F.)

	// Verifica se os parâmetros estão configurados
	If _nTpSel == 1	// Requisição
		_cTM := GetMv("MV_XREQOP",,"")
	ElseIf _nTpSel == 2	// Devolução
		_cTM := GetMv("MV_XDEVOP",,"")
	Endif

	If Empty(_cTM)
		ApMsgAlert("O parâmetro de tipo de movimentação não está preenchido."+CHR(13)+CHR(10)+"Contate o administrador do sistema!","[A10001] - Pesagem")
		Return(.F.)
	Else
		// Verifica se o TM está configurado corretamente
		dbSelectArea("SF5")
		SF5->(dbSetOrder(1))
		SF5->(dbGoTop())
		If SF5->(dbSeek(xFilial("SF5")+Alltrim(_cTM)))
			If SF5->F5_ATUEMP <> 'S' .Or. SF5->F5_APROPR <> 'S'
				ApMsgAlert("O tipo de movimentação " + Alltrim(_cTM) + ", não está configurado corretamente para utilização nesta rotina. Verifique!","[A10001] - Pesagem")
				Return(.F.)
			Endif
		Else
			ApMsgAlert("O tipo de movimentação " + Alltrim(_cTM) + ", configurado no parâmetro não existe."+CHR(13)+CHR(10)+"Contate o administrador do sistema!","[A10001] - Pesagem")
			Return(.F.)
		Endif
	Endif

	// Verifica se os campos foram preenchidos
	If Empty(_cOP) .Or. Empty(_cProd)
		ApMsgAlert("A OP e o produto devem ser informados. Verifique!","[A10001] - Pesagem")
		Return(.F.)
	Endif

	If _nPBruto == 0 .Or. _nPLiq == 0
		ApMsgAlert("A pesagem não foi realizada. Verifique!","[A10001] - Pesagem")
		Return(.F.)
	Endif

	If _nPLiq < 0
		ApMsgAlert("O peso líquido não pode ser negativo. Verifique!","[A10001] - Pesagem")
		Return(.F.)
	Endif

	// Verifica se dentro do limite de tolerância
	If _nTpSel == 1 .And. !fVerTol()
		ApMsgAlert("Pesagem fora do limite de tolerância do produto. Verifique!","[A10001] - Pesagem")
		Return(.F.)
	Endif

	// Se for devoluçao, verifica se existe saldo de requisição
	If _nTpSel == 2
//		If _nPLiq > U_A10001A(_cOP,_cProd,_cLoteSD4)
		If _nPLiq > U_A10001GP(_cOP,_cProd,_cLoteSD4)
			ApMsgAlert("A quantidade sendo estornada é maior que o requisitado. Verifique!","[A10001] - Pesagem")
			Return(.F.)
		Endif
	Endif

	_cLocal := ""

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	If SB1->(dbSeek(xFilial("SB1")+Alltrim(_cProd)))
		If SB1->B1_APROPRI == "I"
			_cLocal := GetMv("MV_LOCPROC",,"")
		Endif
	Endif

	If Empty(_cLocal)
		_cLocal := Posicione("SB1",1,xFilial("SB1")+Alltrim(_cProd),"B1_LOCPAD")
	Endif

	_aSD3 := {}
	AADD(_aSD3, {"D3_FILIAL"	,xFilial("SD3")						,Nil})
	AADD(_aSD3, {"D3_TM"		,_cTM								,Nil})
	AADD(_aSD3, {"D3_COD"		,Alltrim(_cProd)					,Nil})
	AADD(_aSD3, {"D3_UM"		,Posicione("SB1",1,xFilial("SB1")+Alltrim(_cProd),"B1_UM")   ,Nil})
	AADD(_aSD3, {"D3_LOCAL"		,_cLocal							,Nil})		//Posicione("SB1",1,xFilial("SB1")+Alltrim(_cProd),"B1_LOCPAD")
	AADD(_aSD3, {"D3_OP"		,Alltrim(_cOP)						,Nil})
	AADD(_aSD3, {"D3_QUANT"		,_nPLiq								,Nil})
	AADD(_aSD3, {"D3_EMISSAO"	,DDATABASE	   						,Nil})
	AADD(_aSD3, {"D3_DOC"		,NextNumero("SD3",2,"D3_DOC",.T.)	,Nil})
	AADD(_aSD3, {"D3_TRT"		,SD4->D4_TRT						,Nil})

	If !Empty(_cLoteSD4)
		AADD(_aSD3, {"D3_LOTECTL", _cLoteSD4,Nil})
	Endif

	Begin Transaction

	lMsErroAuto := .F.
	msExecAuto({|x, y| mata240(x, y)}, _aSD3, 3)

	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	Else

		// Verifica se imprime a etiqueta
		If _lImprime
			//TODO: Incluir aqui a função para impressão da etiqueta
		Endif

		//Grava tabela auxiliar de separação
		GrvSep()

		fZeraCpo()

	EndIf

	End Transaction

Return

User Function A10001A(_pOP,_pProd,_pLote)
	Local _aArea := GetArea()
	Local _cAlAux := GetNextAlias()
	Local _nRet := 0

	BeginSql Alias _cAlAux
		SELECT SUBSTRING(SD3.D3_CF,1,2) TIPO, SUM(SD3.D3_QUANT) QUANT
		  FROM %table:SD3% SD3
		 WHERE SD3.D3_FILIAL = %xFilial:SD3%
		   AND SD3.D3_OP = %Exp:_pOP%
		   AND SD3.D3_COD = %Exp:_pProd%
		   AND SD3.D3_LOTECTL = %Exp:_pLote%
		   AND SD3.%NotDel%
		 GROUP BY SUBSTRING(SD3.D3_CF,1,2)
	EndSql

	While !(_cAlAux)->(EOF())
		If (_cAlAux)->TIPO == "RE"
			_nRet += (_cAlAux)->QUANT
		ElseIf (_cAlAux)->TIPO == "DE"
			_nRet -= (_cAlAux)->QUANT
		Endif
		(_cAlAux)->(dbSkip())
	Enddo
	(_cAlAux)->(dbCloseArea())

	RestArea(_aArea)
Return(_nRet)

Static Function fZeraCpo()
	// Retorna os campos para os estados iniciais para uma nova pesagem
	fTipo(1)
	_cOP		:= CriaVar("D3_OP",.F.)
	_cProd		:= CriaVar("B1_COD",.F.)
	_cDesPrd	:= CriaVar("B1_DESC",.F.)
	_nTara		:= 0
	_nPBruto	:= 0
	_nPLiq		:= 0
	_npBal		:= 0
	_nPTol		:= 0
	_nPMan		:= 0
	_nTaraMan	:= 0
	_nQtdSD4	:= 0
	_cLoteSD4	:= CriaVar("D4_LOTECTL",.F.)
	_cLoteOP	:= CriaVar("C2_XLOTE",.F.)
	_oGetOP:SetFocus()
Return

/*/{Protheus.doc} fTipo
Trata a seleção do tipo de apontamento a ser realizado
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@param _pTipo, ${Int}, (Opção clicada, sendo: 1=Requisição / 2=Devolução)
/*/
Static Function fTipo(_pTipo)
	// Verifica se clicou na opção "Requisição"
	If _pTipo == 1
		// Só muda se estiver selecionado "Devolução"
		If _nTpSel == 2
			oReq:lVisibleControl := .F.
			oReqSel:lVisibleControl := .T.

			oDevSel:lVisibleControl := .F.
			oDev:lVisibleControl := .T.

			_nTpSel := 1
		Endif
	Else
		// Só muda se estiver selecionado "Requisição"
		If _nTpSel == 1
			oReq:lVisibleControl := .T.
			oReqSel:lVisibleControl := .F.

			oDevSel:lVisibleControl := .T.
			oDev:lVisibleControl := .F.

			_nTpSel := 2
		Endif
	Endif
Return


/*/{Protheus.doc} fOP
Função de validação da OP informada
@type function
@author Funaki
@since 07/05/2018
@version 1.0
@return ${.T./.F.}, ${Retorna se a OP é válida ou não}
/*/
Static Function fOP()
	If !Empty(_cOP)
		// Verifica se a OP existe
		If !ExistCpo("SC2",_cOP)
			Return(.F.)
		Else
			If Alltrim(_cOPAtu) != Alltrim(_cOP)
				fTipo(1)
				_cProd		:= CriaVar("B1_COD",.F.)
				_cDesPrd	:= CriaVar("B1_DESC",.F.)
				_nTara		:= 0
				_nPBruto	:= 0
				_nPLiq		:= 0
				_npBal		:= 0
				_nPTol		:= 0
				_nPMan		:= 0
				_nTaraMan	:= 0
				_nQtdSD4	:= 0
				_cOPAtu		:= _cOP
			Endif

			_cLoteOP := Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_XLOTE")
		Endif
	Else
		fZeraCpo()
	Endif

	DBSelectArea("CB7")
	CB7->(DBSetOrder(5))
	CB7->(DBSeek(xFilial("CB7")+_cOP))
	If CB7->(Found())
		If CB7->CB7_STATUS == "0"
			ApMsgAlert("Atenção!" + CRLF +;
					"Ordem de separação não iniciada!","[A10001] - Pesagem")
			fZeraCpo()
			Return .F.
		EndIf
	EndIf
Return(.T.)

/*/{Protheus.doc} fProd
Função de validação do produto informado
@type function
@author Funaki
@since 07/05/2018
@version 1.0
@return ${.T./.F.}, ${Retorna se o produto é válido ou não}
/*/
Static Function fProd()

	Local _lRet := .T.

	Local cQuery	:= ""
	Local cAlSD4	:= ""
	Local nRegNo	:= 0

	If !Empty(_cProd) .And. !Empty(_cOP)

		// Verifica se o produto existe
		If ExistCpo("SB1",_cProd)

			If Alltrim(_cPrdAtu) != Alltrim(_cProd)
				fTipo(1)
				_nTara		:= 0
				_nPBruto	:= 0
				_nPLiq		:= 0
				_npBal		:= 0
				_nPTol		:= 0
				_nPMan		:= 0
				_nTaraMan	:= 0
				_nQtdSD4	:= 0
				_cPrdAtu	:= _cProd
			Endif

			cQuery := "	SELECT " + CRLF
			cQuery += "		R_E_C_N_O_ REGNO " + CRLF
			cQuery += "	FROM " + RetSqlName("SD4") + " " + CRLF
			cQuery += "	WHERE " + CRLF
			cQuery += "	       D4_FILIAL  = '" + xFilial("SD4") + "' " + CRLF
			cQuery += "	   AND D4_OP      = '" + _cOP + "' " + CRLF
			cQuery += "	   AND D4_COD     = '" + _cProd + "' " + CRLF
			cQuery += "	   AND D4_LOTECTL = '" + _cLoteSd4 + "' " + CRLF
			cQuery += "	   AND D_E_L_E_T_ = ' ' " + CRLF

			MemoWrite("C:\TEMP\fValLot.SQL",cQuery)

			cQuery := ChangeQuery(cQuery)
			cAlSD4 := MPSysOpenQuery(cQuery)

			If (cAlSD4)->(Eof())
				ApMsgAlert("Lote do Produto incorreto." + CRLF + "Por favor verifique se este lote pertence a esta OP/Produto.","[A10001] - Pesagem")
				Return (.F.)
			EndIf

			nRegNo := (cAlSD4)->REGNO
			(cAlSD4)->(dbCloseArea())

			// Verifica se o produto existe no empenho da OP informada
			dbSelectArea("SD4")
			SD4->(dbGoTo(nRegNo))

			// Verifica se o produto controla o lote
			If Posicione("SB1",1,xFilial("SB1")+Alltrim(_cProd),"B1_RASTRO") == "L"
				If Empty(SD4->D4_LOTECTL)
					ApMsgAlert("O produto informado não possui lote no empenho. Verifique!","[A10001] - Pesagem")
					Return(.F.)
				ElseIf ! avalSeparacao(SD4->D4_OP, SD4->D4_COD, SD4->D4_LOTECTL) //Empty(SD4->D4_XSEPBAL)
					ApMsgAlert("O Lote do produto informado não foi separado. Verifique!","[A10001] - Pesagem")
					Return(.F.)
				Endif
			Endif

			_nTara		:= Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_XTARA")
			_nTaraMan	:= _nTara
			oTara:Refresh()

			_nPLiq := _nPBruto - _nTara

			// Verifica a quantidade do empenho abatendo a quantidade já requisitada
			_nQtdSD4 	:= SD4->D4_QTDEORI //- U_A10001GP(_cOP,_cProd,SD4->D4_LOTECTL)

		Else
			_lRet := .F.
		Endif

	Endif

Return(_lRet)



/*/{Protheus.doc} avalSeparacao
Função para avaliar as ordens de separação da OP
 se não existir... returna falso
 se existir
    se não exitir finalizada... retorna falso
    se existir uma finalizada... retorna faso

@author Rafael Ricardo Vieceli
@since 23/08/2018
@version 1.0
@return logical, se existe ordens separação finalizadas
@param cOrdemProducao, characters, Numero da ordem de separação
@type function
/*/
static function avalSeparacao(cOrdemProducao, cProduto, cLoteCtl)

	CB8->( dbSetOrder(6) )
	CB8->( dbSeek( xFilial("CB8") + cOrdemProducao ) )

	//percorre todos os itens
	While ! CB8->( Eof() ) .And. CB8->(CB8_FILIAL+CB8_OP) == xFilial("CB8") + cOrdemProducao

		IF CB8->CB8_PROD == cProduto .And. CB8->CB8_LOTECT == cLoteCtl
			IF CB8->CB8_QTDORI > CB8->CB8_SALDOS
				return .T.
			EndIF
		EndIF

		CB8->(dbSkip())
	EndDO

return .F.


/*/{Protheus.doc} fPesagem
Função para realizar a integração com a balança para pesagem
@type function
@author Funaki
@since 07/05/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fPesagem()
	Local _nHand := 1
	Local _nTempo := 700
	Local _cPorta := GetMv("MV_CONFBAL",,"COM1:9600,N,8,1") //Conteudo do parametro: "COM1:9600,N,8,1"
	Local _cRetVar := ""
	Local _cMens := "Deseja repesar?"
	Local _bEstab := .T.
	Local x
	Private _cPeso := ""

	// Verifica se foi informado a OP e o produto
	If Empty(_cOP) .Or. Empty(_cProd)
		ApMsgAlert("Deve ser informado a OP e o produto para pesagem.","[A10001] - Pesagem")
		Return(.F.)
	Endif

	While .T.
		_cPeso   := ""
		_aPesos := {}
		_bEstab := .T.

		If MsOpenPort(_nHand,_cPorta) // Abrindo porta
			Sleep(_nTempo)           // Tempo para capturar os dados
			MSRead(_nHand, @_cPeso)   // Capturando os dados

			MsClosePort(_nHand)      // Fechando porta

			_nIni := AT(CHR(1), _cPeso)
			_nFim := Rat(CHR(2), _cPeso)

			// Irregularidade de conexão ou falta dos caracteres delimitadores
			If _nIni = -1 .or. _nFim = -1
				_cMsg := "A balança está desligada ou o cabo está desconectado ou a" + CHR(13)
				_cMsg += "conexão informada no parametro MV_CONFBAL está errada," + CHR(13)
				_cMsg += "pois não foi possível encontrar os caracteres delimitadores."
				MsgBox(_cMsg)

				If MsgYesNo(_cMens,OemToAnsi('ATENCAO'))
					Loop
				Else
					Exit
				EndIf
			EndIf

			_cPeso := substr(_cPeso, _nIni, (_nFim - _nIni) + 1 )

			_aPesos := explode(chr(2), _cPeso)

			// Poucas Amostras
			If Len(_aPesos) < 4
				MsgBox("Não foi possível adquirir o peso devido a poucas amostas." + CHR(13) + "Por favor, repesar a peça.")
				If MsgYesNo(_cMens,OemToAnsi('ATENCAO'))
					Loop
				Else
					Exit
				EndIf
			EndIf

			// Verificando a Estabilidade
			For x := 2 to len(_aPesos)
				If _aPesos[x] != _aPesos[1]
					_bEstab := .F.
					Exit
				EndIf
			Next

			If ! _bEstab
				MsgBox("O peso da balança não está estabilizado." + chr(13) + "Por favor, repesar a peça.")
				If MsgYesNo(_cMens,OemToAnsi('ATENCAO'))
					Loop
				Else
					Exit
				EndIf
			Endif

			// Verificando Peso Negativo
			If asc(substr(_aPesos[1], 2, 1)) = 45
				MsgBox("O peso da balança está NEGATIVO." + chr(13) + "Por favor, repesar a peça.")
				If MsgYesNo(_cMens,OemToAnsi('ATENCAO'))
					Loop
				Else
					Exit
				EndIf
			EndIf

			// Verificando Sobrecarga
			If asc(substr(_aPesos[1], 8, 1)) = 32
				MsgBox("SOBRECARGA NA BALANÇA !!!" + chr(13) + "Por favor, retire o peso excessivo e verifique a TARA.")
				If MsgYesNo(_cMens,OemToAnsi('ATENCAO'))
					Loop
				Else
					Exit
				EndIf
			EndIf

			// Balança Zerada
			If substr(_aPesos[1], 3, 6) = " 0.000"
				MsgBox("BALANÇA SEM CARGA !!!" + chr(13) + "Por favor, coloque a peça sobre a balança.")
				If MsgYesNo(_cMens,OemToAnsi('ATENCAO'))
					Loop
				Else
					Exit
				EndIf
			EndIf

			// Peso Correto
			_cRetVar := substr(_aPesos[1], 3, 6)
			Exit
		Else
			MsgBox("Não foi possível conectar a porta especificada." + chr(13) +"Verifique se o cabo da balança está conectado" + chr(13) + chr(13) + _cPorta)
			If MsgYesNo("Deseja tentar novamente?",OemToAnsi('ATENCAO'))
				Loop
			Else
				Exit
			EndIf
		EndIf
	EndDo

	If !Empty(_cRetVar)
		_nPBruto := VAL(_cRetVar)
		_nPLiq := VAL(_cRetVar) - _nTara

		oPBruto:Refresh()
		oPLiq:Refresh()
	Endif
Return

/*/{Protheus.doc} fPMan
Função para tratar o peso digitado.
@type function
@author Funaki
@since 07/05/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Static Function fPMan()

	Local _lOk := .F.

	If _nTaraMan != _nTara
		_nTara := _nTaraMan
	Endif
	_nPBruto := _nPMan
	_nPLiq := _nPMan - _nTara

	oPBruto:Refresh()
	oPLiq:Refresh()

Return

/*/{Protheus.doc} fTara
Função para atualizar o campo de tara
@type function
@author Funaki
@since 12/06/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Static Function fTara()
	// Verifica se o valor da tara foi alterada
	If _nTaraMan != _nTara
//		If ApMsgYesNo("O valor da Tara será substituído pelo valor informado."+CHR(13)+CHR(10)+"Deseja continuar?","[A10001] - Pesagem")
		If _nPMan != _nPBruto
			_nPBruto := _nPMan
		Endif
			_nTara := _nTaraMan
			_nPLiq := _nPBruto - _nTara
//		Endif
	Endif
Return

/*/{Protheus.doc} fVerTol
Função para verificar se a pesagem está dentro do limite de tolerância
@type function
@author Funaki
@since 07/05/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fVerTol()
	Local _nPerTol := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_XTOOP")
	Local _nLimTol := 0

	// Verifica o valor total com a tolerância
	_nLimTol := _nQtdSD4 * (_nPerTol / 100)
	If _nPLiq > (_nQtdSD4 + _nLimTol)
		Return(.F.)
	Endif
Return(.T.)

/*/{Protheus.doc} GrvSep
//TODO grava tabela auxiliar de pesagem
@author Mario L. B. Faria
@since 25/06/2018
@version 1.0
/*/
Static Function GrvSep()

	dbSelectArea("ZA1")

	RecLock("ZA1",.T.)
	ZA1->ZA1_FILIAL		:= xFilial("ZA1")
	ZA1->ZA1_COD		:= SD3->D3_COD
	ZA1->ZA1_OP			:= SD3->D3_OP
	ZA1->ZA1_LOTECT		:= SD3->D3_LOTECTL
	ZA1->ZA1_QTDSEP		:= SD3->D3_QUANT
	If _nTpSel == 1
		ZA1->ZA1_TPMOV		:= "R"
	ElseIf _nTpSel == 2
		ZA1->ZA1_TPMOV		:= "D"
	EndIf
	ZA1->(MSUNLOCK())

Return


/*/{Protheus.doc} A10001GP
//TODO Descrição auto-gerada.
@author Mario L. B. Faria
@since 25/06/2018
@version 1.0
@return nRet, Numérico, Quantidade separada
@param cOP, characters, Numero da OP
@param cCodPrd, characters, Código do Produto
@param cLote, characters, Numero do Lote
/*/
User Function A10001GP(cOP,cCodPrd,cLote)
Local nRet		:= 0
Local cQuery	:= ""
Local cAlZA1	:= ""
Local aArea     := GetArea()
Local lIndus    := !u_IsBusiness()

	// -> Verifica se é industria (não pode ser executada para as unidades de negócio)
	If lIndus 
		cQuery := "	SELECT " + CRLF
		cQuery += "		SUM(CASE WHEN ZA1_TPMOV = 'R' THEN ZA1_QTDSEP ELSE -ZA1_QTDSEP END) QTDSEP " + CRLF
		cQuery += "	FROM " + RetSqlName("ZA1") + " " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "			ZA1_FILIAL	= '" + xFilial("ZA1") + "' " + CRLF
		If !Empty(cCodPrd)
			cQuery += "		AND ZA1_COD 		= '" + cCodPrd + "' " + CRLF
		EndIf
		cQuery += "		AND ZA1_OP		= '" + cOP + "' " + CRLF
		If !Empty(cLote)
			cQuery += "		AND ZA1_LOTECT	= '" + cLote + "' " + CRLF
		EndIf
		cQuery += "		AND D_E_L_E_T_ = ' ' " + CRLF

		cQuery := ChangeQuery(cQuery)
		cAlZA1 := MPSysOpenQuery(cQuery)

		nRet := (cAlZA1)->QTDSEP

		(cAlZA1)->(dbCloseArea())
	EndIf

Return nRet

/*/{Protheus.doc} ValLote
//TODO Validação do lote na devolução
@author Mario L. B. Faria
@since 26/06/2018
@version 1.0
@return lRet, lógico, continua a ou não o processo
/*/
Static Function ValLote(cOP,cCodPrd,cLote)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlSD4	:= ""

	If _nTpSel == 2

		cQuery := "	SELECT " + CRLF
		cQuery += "		D4_OP " + CRLF
		cQuery += "	FROM " + RetSqlName("SD4") + " " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "	       D4_FILIAL  = '" + xFilial("SD4") + "' " + CRLF
		cQuery += "	   AND D4_OP      = '" + cOP + "' " + CRLF
		cQuery += "	   AND D4_COD     = '" + cCodPrd + "' " + CRLF
		cQuery += "	   AND D4_LOTECTL = '" + cLote + "' " + CRLF
		cQuery += "	   AND D_E_L_E_T_ = ' ' " + CRLF

//		MemoWrite("C:\TEMP\ValLote.SQL",cQuery)

		cQuery := ChangeQuery(cQuery)
		cAlSD4 := MPSysOpenQuery(cQuery)

		If (cAlSD4)->(Eof())
			MsgBox("Lote do Produto incorreto." + CRLF + "Por favor verifique se este lote pertence a esta OP/Produto.")
			lRet := .F.
		EndIf

		(cAlSD4)->(dbCloseArea())

	EndIf

Return lRet
















