#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TopConn.CH"

/*/{Protheus.doc} EST550
//TODO Rotina para Cadastro de Inventários
@author Mario L. B. Faria
@since 19/07/2018
@version 1.0
/*/
User Function EST550()
	
	Local oBrowse := Nil

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z23")
	oBrowse:SetDescription("Inventário")
	oBrowse:SetMenuDef("MADERO_EST550")
	oBrowse:Activate()

Return

Static Function MenuDef()

	Local aRotina := {}

	aAdd(aRotina,{'Visualizar'	,'VIEWDEF.MADERO_EST550'	,0,2,0,NIL})
//	aAdd(aRotina,{'Incluir'		,'VIEWDEF.MADERO_EST550'	,0,3,0,NIL})
//	aAdd(aRotina,{'Alterar'		,'VIEWDEF.MADERO_EST550'	,0,4,0,NIL})
	aAdd(aRotina,{'Excluir'		,'VIEWDEF.MADERO_EST550'	,0,5,0,NIL})
//	aAdd(aRotina,{'Imprimir' 	,'VIEWDEF.MADERO_EST550'	,0,8,0,NIL})
//	aAdd(aRotina,{'Copiar'		,'VIEWDEF.MADERO_EST550'	,0,9,0,NIL})

Return( aRotina )

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Mario L. B. Faria

@since 19/07/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel
	Local oStr1	:= FWFormStruct(1,'Z23')
	
	oModel:=MPFormModel():New('EST550_MAIN', ,{ |oModel| EST550E( oModel ) } )
	oModel:SetDescription('Inventário')
	oModel:addFields('MODEL_Z23',,oStr1)
	oModel:SetPrimaryKey({ 'Z23_FILIAL', 'Z23_ID' })
	oModel:getModel('MODEL_Z23'):SetDescription('Inventário')
	
Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Mario L. B. Faria

@since 19/07/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

	Local oView
	Local oModel	:= ModelDef()
	Local oStr1		:= FWFormStruct(2, 'Z23')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('VIEW_Z23' , oStr1,'MODEL_Z23' ) 
	oView:CreateHorizontalBox( 'BOX_Z23', 100)
	oView:SetOwnerView('VIEW_Z23','BOX_Z23')

Return oView

/*/{Protheus.doc} EST550I
//TODO Funlção de inclusão de inventário
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return cRet, Mensage de erro. Se estiver vazia não houve erro
@param cFunName, characters, Nome da função
@param cFilInv, characters, Filial do inventátio
@param cCodUsr, characters, Código do usuátio
@param cDtaInv, characters, data do inventário
@param aGrpInv, array, grupos de produtos a inventariar
@param nOpc, Numerico, operação a executar
@param cArqCSV, characters, Nome do arquivo CSV
/*/
User Function EST550I(cFunName, cFilInv, cCodUsr, cDtaInv, aGrpInv, nOpc, cArqCSV)
Local nX		:= 0
Local cGrpInv	:= ""
Local cRet		:= ""
Local dDtaInv	:= ""
Local oModel	:= FWLoadModel("MADERO_EST550")
Default cDtaInv := ""
Default cArqCSV := ""	
	
	dDtaInv	:= StoD(cDtaInv)
		
	For nX := 1 to Len(aGrpInv)
		cGrpInv += aGrpInv[nX] + "," 
	Next nX
	cGrpInv := SubStr(cGrpInv,1,Len(cGrpInv)-1)
	
	oModel:SetOperation(nOpc)
	oModel:Activate()
	
	If nOpc == 3
		oModel:SetValue("MODEL_Z23", "Z23_FILIAL"	, xFilial("Z23"))
		oModel:SetValue("MODEL_Z23", "Z23_DATA"		, dDtaInv)
		oModel:SetValue("MODEL_Z23", "Z23_GRUPOS"	, cGrpInv)
		oModel:SetValue("MODEL_Z23", "Z23_DTINC"	, Date())
		oModel:SetValue("MODEL_Z23", "Z23_HRINC"	, Time())
		oModel:SetValue("MODEL_Z23", "Z23_USERI"	, cCodUsr)
	ElseIf nOpc == 4
		oModel:SetValue("MODEL_Z23", "Z23_FILIAL"	, Z23->Z23_FILIAL)
		oModel:SetValue("MODEL_Z23", "Z23_ID"		, Z23->Z23_ID)
		oModel:SetValue("MODEL_Z23", "Z23_DTINV"	, dDataBase)
		oModel:SetValue("MODEL_Z23", "Z23_HRINV"	, Time())
		oModel:SetValue("MODEL_Z23", "Z23_ARQINV"	, cArqCSV)
	EndIf

	If oModel:VldData()
		oModel:CommitData()
	Else
	
		aErro := oModel:GetErrorMessage()
		
		AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
		AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
		AutoGrLog( "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
		AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
		AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
		AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
		AutoGrLog( "Mensagem da solução: " + ' [' + AllToChar( aErro[7] ) + ']' )
		AutoGrLog( "Valor atribuído: " + ' [' + AllToChar( aErro[8] ) + ']' )
		AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
		
		cRet := RetErro()
		ConOut("Erro.")
		
	EndIf
	
	oModel:DeActivate()

Return cRet

/*/{Protheus.doc} EST550G
//TODO Gera itens a inventariar
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return cMsg, characters, mensagem de retorno
@param cFunName, characters, Nome da funcção que esta chamando
@param cGrpInv, characters, Cruopos a inventariar
@param cFilInv, characters, Filial 
@param cIdInv, characters, Id do Inventário
@param cEmpTek, characters, Empresa no Teknisa
@param cFilTek, characters, Filial no Teknisa
@param cMailUnid, characters, email da unidade
/*/
User Function EST550G(cFunName, cGrpInv, cFilInv, cIdInv, cEmpTek, cFilTek, cMailUnid)

	Local cQuery	:= ""
	Local cAlQry	:= ""	
	Local cPath		:= ""
	Local cArqCSV	:= "INV" + cIdInv + ".CSV"	
	Local nRetAux	:= 0
	Local cMsg		:= ""
	Local cMsgOk	:= ""
	
	cGrpInv := AllTrim(StrTran(cGrpInv,",","','"))

	ConOut("Gerando lista de itens a inventariar no. " + cIdInv + " para filial " + cFilInv )

	cQuery := "	SELECT " + CRLF
	cQuery += "	    SB1.B1_COD		B1COD, " + CRLF 
	cQuery += "	    SB1.B1_DESC		B1DESC, " + CRLF
	cQuery += "	    SB1.B1_GRUPO	B1GRUPO, " + CRLF
	cQuery += "	    SB1.B1_UM		B1UM, " + CRLF
	cQuery += "	    SA5.A5_UNID		A5UNID, " + CRLF
	cQuery += "	    SA5.A5_XTPCUNF	A5XTPCUNF, " + CRLF
	cQuery += "	    SA5.A5_XCVUNF	A5XCVUNF, " + CRLF
	cQuery += "	    SA5.A5_CODBAR	A5CODBAR " + CRLF
	cQuery += "	FROM " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += "	INNER JOIN " + RetSqlName("SA5") + " SA5 ON " + CRLF
	cQuery += "	        SA5.A5_FILIAL = SB1.B1_FILIAL " + CRLF 
	cQuery += "	    AND SA5.A5_PRODUTO = SB1.B1_COD " + CRLF
	cQuery += "	    AND SA5.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "	WHERE " + CRLF
	cQuery += "	    SB1.B1_FILIAL = '" + cFilInv + "' " + CRLF
	cQuery += "	    AND SB1.B1_GRUPO IN ('" + cGrpInv + "') " + CRLF
	cQuery += "	    AND SB1.D_E_L_E_T_ = ' '  " + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)

	//verifica se possui as pastas do inventario no server
	cPath := U_EST550PT(cFilTek)
	
	If !File(cPath + cArqCSV)	//Se não existe o arquivo prossegue
		GeraCSV(cAlQry, cPath , cArqCSV)
	Else	//caso o arquivo exista gera erro
		cMsg := "Nao foi possivel gerar o arquivo " + cArqCSV + ".csv no diretório " + cPath
	EndIf
	
	If Empty(cMsg)
		//Atualiza Z23
		U_EST550I("", "", "", "", "", 4, cArqCSV)
		
		cMsgOk := "-->Ok."
	Else
		cMsgOk := "-->Nao Ok."
	EndIf
	
	ConOut(cMsgOk)
	
	(cAlQry)->(dbCloseArea())

Return {cMsg,cArqCSV}

/*/{Protheus.doc} EST550E
//TODO Valida a Exclusão do inventário
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return lRet, logico, .T. ou .F.
@param oModel, object, Objeto do modelo de dados
/*/
Static Function EST550E(oModel)

	Local lRet		:= .T.
	Local cPath		:= ""
	Local aArquivos	:= {}
	Local cArqCSV	:= FWFldGet("Z23_ARQINV")
	Local cFilTek	:= ""
	
	//Valida somente a Exclusão
	If oModel:GetOperation() == 5
		
		//valida inventario ja processado
		If Empty(FWFldGet("Z23_DTPROC")) 
		
			Begin Transaction
		
				//Verifica se possui itens processados na SB7
				If STATSB7(oModel)
				
					//Exclui itens SB7
					If EXCLSB7(oModel)
					
						dbSelectArea("ADK")
						 //busca pelo indice customizado
						 ADK->( dbOrderNickName("ADKXFILI") )    
						 ADK->( dbGoTop() )
						 If !ADK->( dbSeek(xFilial("ADK") + cFilAnt) )
						 	cFilTek := ADK->ADK_XFIL
						 EndIf
						//verifica se possui as pastas do inventario no server
						cPath := U_EST550PT(cFilTek)
						
						aArquivos := Directory(cPath + cArqCSV)
						If Len(aArquivos) > 0
							//Se nçao conseguiu deletar o arquivo interrompe o processo
							If fErase(cPath + cArqCSV) == -1
								DisarmTransaction()	
								lRet	:= .F.	
								Help("",1,"Exclusão",,"Erro na exclusão do inventário. Não foi possivel excluir o arquivo CSV. " + cPath + cArqCSV ,4,1)
							EndIf		
						EndIf				
					
					Else
						DisarmTransaction()	
						lRet	:= .F.		
					EndIf
				
				Else
					DisarmTransaction()	
					lRet	:= .F.
					Help("",1,"Exclusão",,"Erro na exclusão do inventário. Existem itens processados para o inventário INV" + FWFldGet("Z23_ID") + " de " + DtoC(FWFldGet("Z23_DATA")) ,4,1)
				EndIf
			
			End Transaction
		
		Else
			Help("",1,"Exclusão",,"Erro na exclusão do inventário. Inventário Já processado. [Z23_DTPROC =" + DtoC(FWFldGet("Z23_DTPROC")) + "]",4,1)
			lRet	:= .F.
		EndIf
		
	EndIf


Return lRet

/*/{Protheus.doc} STATSB7
//TODO Verifica se possui SB7 processada
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return lRet, logico, .T. ou .F.
@param oModel, object, Objeto do modelo de dados
/*/
Static Function STATSB7(oModel)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlQry	:= ""
	
	cQuery := "	SELECT R_E_C_N_O_ B7_REGNO " + CRLF 
	cQuery += "	FROM " + RetSqlName("SB7") + " " + CRLF 
	cQuery += "	WHERE " + CRLF 
	cQuery += "	    B7_FILIAL = '" + xFilial("SB7") + "' " + CRLF 
	cQuery += "	AND B7_DOC = 'INV' || '" + FWFldGet("Z23_ID") + "' " + CRLF 
	cQuery += "	AND B7_DATA = '" + DtoS(FWFldGet("Z23_DATA")) + "' " + CRLF 
	cQuery += "	AND B7_STATUS = '2' " + CRLF 
	cQuery += "	AND D_E_L_E_T_ = ' ' " + CRLF 	

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	If !(cAlQry)->(Eof())
		lRet := .F.
	EndIf
	
	(cAlQry)->(dbCloseArea())

Return lRet

/*/{Protheus.doc} EXCLSB7
//TODO Função para excluir SB7
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return lRet, logico, .T. ou .F.
@param oModel, object, Objeto do modelo de dados
/*/
Static Function EXCLSB7(oModel)
Local lRet		:= .T.
Local cQuery	:= ""
Local cAlQry	:= ""
Local aMata270	:= {}
Local nModAux	:= nModulo
Local cFilAux	:= cFilAnt
Local dDatAux	:= dDataBase
Local cPergunta := "MTA270"
Private lMsErroAuto := .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile	:= .T.
	
	cQuery := "	SELECT R_E_C_N_O_ B7_REGNO " + CRLF 
	cQuery += "	FROM " + RetSqlName("SB7") + " " + CRLF 
	cQuery += "	WHERE " + CRLF 
	cQuery += "	    B7_FILIAL = '" + xFilial("SB7") + "' " + CRLF 
	cQuery += "	AND B7_DOC = 'INV' || '" + FWFldGet("Z23_ID") + "' " + CRLF 
	cQuery += "	AND B7_DATA = '" + DtoS(FWFldGet("Z23_DATA")) + "' " + CRLF 
	cQuery += "	AND D_E_L_E_T_ = ' ' " + CRLF 	
	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	dbSelectArea("SB7")
	
	Pergunte(cPergunta,.F.)
	mv_par01 := 1
	mv_par02 := 1
	mv_par03 := dDataBase
	mv_par04 := 1
	mv_par05 := dDataBase
	mv_par06 := "001"
	
	While !(cAlQry)->(Eof())
	
		SB7->(dbGoTo((cAlQry)->B7_REGNO))
		
		nModulo	 := 4
		dDataBase:= SB7->B7_DATA
		cFilAnt	 := SB7->B7_FILIAL
	
		aMata270 := {}
		aAdd( aMata270, { "B7_DOC"    , SB7->B7_DOC    , Nil })
		aAdd( aMata270, { "B7_COD"    , SB7->B7_COD    , Nil })
		aAdd( aMata270, { "B7_LOCAL"  , SB7->B7_LOCAL  , Nil })
		//tem que setar o indice 3, porque no indice 1 e 2 não tem documento
		//e busca registros diferentes por não ter o documento na chave
		aAdd( aMata270, { "INDEX"     , 3 , Nil })
				        
		lMsErroAuto := .F.              
		MSExecAuto({|x,y,z| mata270(x,y,z)},aMata270,.T.,5)
		
		If lMsErroAuto
		    MostraErro()
		    lRet := .F.
		    Exit
		EndIf		
		
		(cAlQry)->(dbSkip())
	
	EndDo
	
	(cAlQry)->(dbCloseArea())

	cFilAnt  := cFilAux
	nModulo  := nModAux
	dDataBase:= dDatAux

Return lRet

/*/{Protheus.doc} GeraCSV
//TODO Função para gerar arquivo CSV
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return ${return}, ${return_description}
@param cAlQry, characters, Alias das informações
@param cPath, characters, Path onde será gravado o arquivo
@param cArqCSV, characters, Nome do arquivo CSV
/*/
Static Function GeraCSV(cAlQry, cPath, cArqCSV)

	Local nArq		:= ""
	Local cLinha	:= ""

	nArq := fCreate(cPath + cArqCSV)
	
	//Grava Cabeçalho
	cLinha := "b1cod;b1desc;b1grupo;bmdesc;b1um;a5unid;a5xtpcunf;a5xcvunf;a5codbar;" + CRLF
	fSeek(nArq,0,2)
	fWrite(nArq,cLinha)	

	//Grava linhas
	While !(cAlQry)->(Eof())
	
		ConOut("-->"  + PadR((cAlQry)->B1COD,TamSx3("B1_COD")[01]) + " - " + AllTrim((cAlQry)->B1DESC))
		
		cLinha := ""
		cLinha +=  AllTrim((cAlQry)->B1COD)     + ";"
		cLinha +=  AllTrim((cAlQry)->B1DESC)    + ";"
		cLinha +=  AllTrim((cAlQry)->B1GRUPO)   + ";"
		cLinha +=  AllTrim(Posicione("SBM",1,xFilial("SBM")+(cAlQry)->B1GRUPO,"BM_DESC")) + ";"
		cLinha +=  AllTrim((cAlQry)->B1UM)      + ";"
		cLinha +=  AllTrim((cAlQry)->A5UNID)    + ";"
		cLinha +=  AllTrim((cAlQry)->A5XTPCUNF) + ";"
		cLinha +=  AllTrim(TransForm((cAlQry)->A5XCVUNF,PesqPict("SA5","A5_XCVUNF"))) + ";"
		cLinha +=  AllTrim((cAlQry)->A5CODBAR)  + ";"
			
		cLinha += CRLF
		
		fSeek(nArq,0,2)
		fWrite(nArq,cLinha)	
		
		(cAlQry)->(dbSkip())

	EndDo
	
	fClose(nArq)

Return

/*/{Protheus.doc} EST550PT
//TODO Função para verifica se pastas de gravação existem no servidor
@author Mario L. B. Faria
@since 25/07/2018
@version 1.0
@return cPath, characters, Path para gravação 
@param cFilInv, characters, Filial
/*/
User Function EST550PT(cFilInv)
Local cPathImp	:= "\IMPORT"
Local cPathInv	:= "\INV" 
Local cPathFil	:= "\" + cFilInv + ""	
Local cPath		:= cPathImp + cPathInv + cPathFil + "\"

	If !ExistDir(cPathImp)
		MakeDir(cPathImp)
	EndIf   
	
	If !ExistDir(cPathImp + cPathInv)
		MakeDir(cPathImp + cPathInv)
	EndIf 
	
	If !ExistDir(cPathImp + cPathInv + cPathFil)
		MakeDir(cPathImp + cPathInv + cPathFil)
	EndIf 

Return cPath



/*/{Protheus.doc} RetErro
//TODO Formata erro
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return cErro, caracter, descrição do erro
/*/
Static Function RetErro()

	Local nX     := 0
	Local cErro  := ""
	Local aLog	 := GetAutoGRLog()

	For nX := 1 To Len(aLog)
		cErro += aLog[nX] + CRLF
	Next nX

Return cErro