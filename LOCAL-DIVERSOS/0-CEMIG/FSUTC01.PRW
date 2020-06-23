#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'REPORT.CH'

/*/{Protheus.doc} FSUTC01
Cadastro de Gerador de Relatórios
@author Felipe Caiado
@since 19/03/2017
@version undefined

@type function
/*/
User Function FSUTC01()

	Local oBrowse
	Local oLastError := ErrorBlock({|e| Alert(Substring(e:Description + e:ErrorStack,1,500))})

	oBrowse := FWmBrowse():New()

	//Alias do Browse do Modelo
	oBrowse:SetAlias( 'P93' )

	//Descrição do modelo
	oBrowse:SetDescription( 'Relatórios Dinâmicos' )

	//Ativar modelo
	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef
Cadastro de Gerador de Relatórios
@author Felipe Caiado
@since 19/03/2017
@version undefined

@type function
/*/
Static Function MenuDef()

	Local aRotina 	:= {}
	Local aGerar	:= {}

	aAdd(aGerar, {"Excel",'StaticCall(FSUTC01,GERAR)', 0, 3})
	aAdd(aGerar, {"Relatório",'StaticCall(FSUTC01,FRELAT)', 0, 3})
	aAdd(aGerar, {"Arquivo Texto",'StaticCall(FSUTC01,FARQUIV)', 0, 3})

	ADD OPTION aRotina TITLE 'Visualizar' 	ACTION 'VIEWDEF.FSUTC01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir' 		ACTION 'VIEWDEF.FSUTC01' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar' 		ACTION 'VIEWDEF.FSUTC01' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir' 		ACTION 'VIEWDEF.FSUTC01' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar' 		ACTION aGerar OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   	ACTION 'VIEWDEF.FSUTC01' OPERATION 8 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Cadastro de Gerador de Relatórios
@author Felipe Caiado
@since 19/03/2017
@version undefined

@type function
/*/
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruP93 	:= FWFormStruct( 1, 'P93')
	Local oStruP94 	:= FWFormStruct( 1, 'P94')
	Local oStruP92 	:= FWFormStruct( 1, 'P92')
	Local oStruP91 	:= FWFormStruct( 1, 'P91')
	Local oStruP90 	:= FWFormStruct( 1, 'P90')
	Local oStruP89 	:= FWFormStruct( 1, 'P89')
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'FSUTC01M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'P93MASTER', /*cOwner*/, oStruP93 )

	// Adiciona ao modelo uma estrutura de formulário de edição por grid
	oModel:AddGrid( 'P94DETAIL', 'P93MASTER', oStruP94, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	oModel:AddGrid( 'P92DETAIL', 'P93MASTER', oStruP92, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	oModel:AddGrid( 'P91DETAIL', 'P93MASTER', oStruP91, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	oModel:AddGrid( 'P90DETAIL', 'P93MASTER', oStruP90, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
	oModel:AddGrid( 'P89DETAIL', 'P93MASTER', oStruP89, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'P94DETAIL', { { 'P94_FILIAL', 'xFilial( "P94" )' }, { 'P94_CODIGO', 'P93_CODIGO' }}, P94->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'P92DETAIL', { { 'P92_FILIAL', 'xFilial( "P92" )' }, { 'P92_CODIGO', 'P93_CODIGO' }}, P92->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'P91DETAIL', { { 'P91_FILIAL', 'xFilial( "P91" )' }, { 'P91_CODIGO', 'P93_CODIGO' }}, P91->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'P90DETAIL', { { 'P90_FILIAL', 'xFilial( "P90" )' }, { 'P90_CODIGO', 'P93_CODIGO' }}, P90->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'P89DETAIL', { { 'P89_FILIAL', 'xFilial( "P89" )' }, { 'P89_CODIGO', 'P93_CODIGO' }}, P89->( IndexKey( 1 ) ) )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Relatórios Dinâmicos' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'P93MASTER' ):SetDescription( 'Cabeçalho' )
	oModel:GetModel( 'P94DETAIL' ):SetDescription( 'Colunas'  )
	oModel:GetModel( 'P92DETAIL' ):SetDescription( 'Parâmetros'  )
	oModel:GetModel( 'P91DETAIL' ):SetDescription( 'Módulos'  )
	oModel:GetModel( 'P90DETAIL' ):SetDescription( 'Usuários'  )
	oModel:GetModel( 'P89DETAIL' ):SetDescription( 'Grupos'  )

	//Seta model opicional
	oModel:GetModel( 'P92DETAIL' ):SetOptional( .T. )
	oModel:GetModel( 'P91DETAIL' ):SetOptional( .T. )
	oModel:GetModel( 'P90DETAIL' ):SetOptional( .T. )
	oModel:GetModel( 'P89DETAIL' ):SetOptional( .T. )

Return oModel

/*/{Protheus.doc} ViewDef
Cadastro de Gerador de Relatórios
@author Felipe Caiado
@since 19/03/2017
@version undefined

@type function
/*/
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oStruP93 := FWFormStruct( 2, 'P93',/*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruP94 := FWFormStruct( 2, 'P94',/*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruP92 := FWFormStruct( 2, 'P92',/*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruP91 := FWFormStruct( 2, 'P91',/*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruP90 := FWFormStruct( 2, 'P90',/*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruP89 := FWFormStruct( 2, 'P89',/*bAvalCampo*/,/*lViewUsado*/ )

	// Cria a estrutura a ser usada na View
	Local oModel   := FWLoadModel( 'FSUTC01' )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_P93', oStruP93, 'P93MASTER' )

	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid( 'DET_P94', oStruP94, 'P94DETAIL' )
	oView:AddGrid( 'DET_P92', oStruP92, 'P92DETAIL' )
	oView:AddGrid( 'DET_P91', oStruP91, 'P91DETAIL' )
	oView:AddGrid( 'DET_P90', oStruP90, 'P90DETAIL' )
	oView:AddGrid( 'DET_P89', oStruP89, 'P89DETAIL' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 50 )
	oView:CreateHorizontalBox( 'INFERIOR', 50 )

	// Cria Folder na view
	oView:CreateFolder( 'PASTAS','INFERIOR' )

	// Cria pastas nas folders
	oView:AddSheet( 'PASTAS', 'ABA01', 'Campos' )
	oView:AddSheet( 'PASTAS', 'ABA02', 'Parâmetros' )
	oView:AddSheet( 'PASTAS', 'ABA03', 'Módulos' )
	oView:AddSheet( 'PASTAS', 'ABA04', 'Usuários' )
	oView:AddSheet( 'PASTAS', 'ABA05', 'Grupos' )

	oView:CreateHorizontalBox( 'INFERU02', 100,,, 'PASTAS', 'ABA01' )
	oView:CreateHorizontalBox( 'INFERU03', 100,,, 'PASTAS', 'ABA02' )
	oView:CreateHorizontalBox( 'INFERU04', 100,,, 'PASTAS', 'ABA03' )
	oView:CreateHorizontalBox( 'INFERU05', 100,,, 'PASTAS', 'ABA04' )
	oView:CreateHorizontalBox( 'INFERU06', 100,,, 'PASTAS', 'ABA05' )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_P93', 'SUPERIOR' )
	oView:SetOwnerView( 'DET_P94', 'INFERU02' )
	oView:SetOwnerView( 'DET_P92', 'INFERU03' )
	oView:SetOwnerView( 'DET_P91', 'INFERU04' )
	oView:SetOwnerView( 'DET_P90', 'INFERU05' )
	oView:SetOwnerView( 'DET_P89', 'INFERU06' )

	// Criar novo botao na barra de botoes
	oView:AddUserButton( 'Campos', 'CLIPS', { |oView| MsgRun("Gerando Campos",,{| _lEnd | CriaCampo(oView) } ) } )
	oView:AddUserButton( 'Módulos', 'CLIPS', { |oView| MsgRun("Gerando Módulos",,{| _lEnd | CriaModulo() } ) } )

	//Campo Incremental
	oView:AddIncrementField("DET_P94","P94_ITEM")
	oView:AddIncrementField("DET_P92","P92_ITEM")

Return oView

/*/{Protheus.doc} GERAR
Cadastro de Gerador de Relatórios
@author Felipe Caiado
@since 19/03/2017
@version undefined

@type function
/*/
Static Function GERAR()

	Local aPerg 	:= {}
	Local aCodPerg 	:= {}
	Local aRet 		:= {}

	DbSelectArea("P92")
	P92->(DbSetOrder(1))
	If P92->(DbSeek(xFilial("P92")+P93->P93_CODIGO))
		While !P92->(Eof()) .And. xFilial("P92")+P93->P93_CODIGO == P92->(P92_FILIAL+P92_CODIGO)

			aAdd(aCodPerg,Alltrim(P92->P92_PARAM))

			aAdd( aPerg ,{1,Alltrim(P92->P92_DESCRI),Space(P92->P92_TAMANH),"@!",".T.","","",40,.F.})

			P92->(DbSkip())

		End
	EndIf

	If Len(aPerg) > 0

		If !ParamBox(aPerg ,"Parametros da Consulta",@aRet)
			Return()
		EndIf

	EndIf

	MsgRun("Gerando Relatório",,{| _lEnd | ProcRel(aCodPerg, aPerg) } )

Return()

/*/{Protheus.doc} ProcRel
Cadastro de Gerador de Relatórios
@author Felipe Caiado
@since 19/03/2017
@version undefined
@param aCodPerg, array, Parâmetros
@type function
/*/
Static Function ProcRel(aCodPerg, aPerg)

	Local cArquivo  := lower(Alltrim(P93->P93_NOMARQ) + DtoS(Date()) + StrTran(Time(),":","") + ".XLS")
	Local oExcelApp := Nil
	Local cPath     := "C:\TEMP\"
	Local cQry		:= ""
	Local cAliasQry	:= GetNextAlias()
	Local aDescCpo	:= {}
	Local aCampos	:= {}
	Local cCampo	:= ""
	Local nX		:= 0
	Local nY		:= 0
	Local oExcel
	Local oExcelApp
	Local cValPar	:= ""
	Local nT		:= 0
	Local aCmpPerg	:= {}
	Local cComandNo :=	"DELETE/UPDATE/INSERT/DROP/CREATE/#/##/TRUNCATE/ALTER/CHECK/SP_/SYS./RENAME/OBJECT/DATABASE/SCHEMA/"+;
						"KILL/SID/RESTORE/BACKUP"

	// Verifica se o Excel está instalado na máquina
	If !ApOleClient("MSExcel")

		MsgAlert("Microsoft Excel não instalado!")

		Return()

	EndIf

	oExcel  := FWMSExcel():New()
	cAba    := Alltrim(P93->P93_NOMABA)
	cTabela := Alltrim(P93->P93_NOMTAB)

	If Len(aPerg) > 0
		// Criação de nova aba
		oExcel:AddworkSheet("Parâmetros")

		// Criação de tabela
		oExcel:AddTable ("Parâmetros","Parâmetros")

		oExcel:AddColumn("Parâmetros","Parâmetros", "Pergunta", 1, 1, .F.)
		oExcel:AddColumn("Parâmetros","Parâmetros", "Conteúdo", 1, 1, .F.)

		For nT:=1 To Len(aPerg)

			aCmpPerg := {}

			cValPar := "MV_PAR" + StrZero(nT,2)

			aAdd(aCmpPerg,aPerg[nT][2])
			aAdd(aCmpPerg,Alltrim(&(cValPar)))

			oExcel:AddRow("Parâmetros","Parâmetros", aCmpPerg)

		Next nT

	EndIf

	// Criação de nova aba
	oExcel:AddworkSheet(cAba)

	// Criação de tabela
	oExcel:AddTable (cAba,cTabela)

	oExcel:SetLineBgColor("#FFFFFF")

	oExcel:Set2LineBgColor("#FFFFFF")

	cQry := Alltrim(P93->P93_SQL)

	For nY:=1 To Len(aCodPerg)
		cValPar := "MV_PAR" + StrZero(nY,2)
		cQry := StrTran(cQry,Alltrim(aCodPerg[nY]),ValToSql(Alltrim(&(cValPar))))
	Next nY

	If "!ACESSOFILIAL!" $ cQry
		cAcessFil		:= fValidFil()

		cWhereFil := FormatIn(cAcessFil,"/")

		cQry := StrTran(cQry,"!ACESSOFILIAL!",cWhereFil)
	EndIf

	If cComandNo $ UPPER(cQry)
		Help(,,'HELP',,"Comandos não permitidos.",1,0)
		Return()
	EndIf

	If TcSqlExec(cQry) <> 0
		Help(,,'HELP',,"SQL incorreto.",1,0)
		Return()
	EndIf

	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf

	If "EXEC" $ cQry

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAliasQry,.F.,.T.)

	Else

		TCQUERY ChangeQuery(cQry) NEW ALIAS (cAliasQry)

	EndIf

	(cAliasQry)->(DbGoTop())

	// Criação de colunas
	DbSelectArea("P94")
	P94->(DbSetOrder(1))
	If P94->(DbSeek(xFilial("P94")+P93->P93_CODIGO))

		While !P94->(Eof()) .And. xFilial("P94")+P93->P93_CODIGO == P94->(P94_FILIAL+P94_CODIGO)

			aAdd(aDescCpo,{Alltrim(P94->P94_NOMCAM),P94->P94_FORMAT})

			oExcel:AddColumn(cAba, cTabela, Alltrim(P94->P94_NOMCOL), Val(P94->P94_ALINHA), Val(P94->P94_FORMAT), P94->P94_TOTAL)

			P94->(DbSkip())

		End

	EndIf

	While !(cAliasQry)->(Eof())

		nX := 0

		aCampos := {}

		For nX:=1 To Len(aDescCpo)

			cCampo := aDescCpo[nX][1]

			If aDescCpo[nX][2] == "4"

				aAdd(aCampos,DtoC(StoD((cAliasQry)->&(cCampo))))

			Else

				aAdd(aCampos,(cAliasQry)->&(cCampo))

			EndIf

		Next nX

		// Criação de Linhas
		oExcel:AddRow(cAba,cTabela, aCampos)

		(cAliasQry)->(dbSkip())

	End

	If !Empty(oExcel:aWorkSheet)

		oExcel:Activate()
		oExcel:GetXMLFile(cArquivo)
		oExcel:DeActivate()
		FwFreeObj(oExcel)

		CpyS2T("\SYSTEM\"+cArquivo, cPath)

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
		oExcelApp:SetVisible(.T.)

	EndIf

	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf

Return()

/*/{Protheus.doc} CriaCampo
Criação dos campos
@author Felipe Caiado
@since 22/03/2017
@version undefined
@param oView, object, descricao
@param lCopy, logical, descricao
@type function
/*/
Static Function CriaCampo(oView)

	Local cQry 		:= ""
	Local cValPar	:= ""
	Local nY		:= 0
	Local cAliasQry := GetNextAlias()
	Local oModel     := FWModelActive()
	Local oModelP94  := oModel:GetModel( 'P94DETAIL' )
	Local nLinhaP94  := 1

	If oModelP94:Length() > 1
		ApMsgInfo("Ja existe registros no campo, preenchimento não executado")
		Return()
	EndIf

	cQry := Alltrim(oModel:GetValue( 'P93MASTER', 'P93_SQL'))

	If "DELETE/UPDATE" $ cQry
		Help(,,'HELP',,"Comandos não permitidos.",1,0)
		Return()
	EndIf

	If TcSqlExec(cQry) <> 0
		Help(,,'HELP',,"SQL incorreto.",1,0)
		Return()
	EndIf

	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf

	If "EXEC" $ cQry

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAliasQry,.F.,.T.)

	Else

		TCQUERY ChangeQuery(cQry) NEW ALIAS (cAliasQry)

	EndIf

	aStruct := (cAliasQry)->(DbStruct())

	For nY:=1 To Len(aStruct)
		If nLinhaP94 > 1
			If oModelP94:AddLine() <> nLinhaP94
				Help( ,, 'HELP',, 'Nao incluiu linha P94' + CRLF + oModel:getErrorMessage()[6], 1, 0)
				Loop
			EndIf
		EndIf

		oModelP94:SetValue( 'P94_ITEM',StrZero(nLinhaP94,3) )
		oModelP94:SetValue( 'P94_NOMCOL',aStruct[nY][1] )
		oModelP94:SetValue( 'P94_ALINHA',Iif(aStruct[nY][2] == "N","3","2") )
		oModelP94:SetValue( 'P94_FORMAT',Iif(aStruct[nY][2] == "N","2","1")  )
		oModelP94:SetValue( 'P94_TOTAL',Iif(aStruct[nY][2] == "N",.T.,.F.) )
		oModelP94:SetValue( 'P94_NOMCAM',aStruct[nY][1] )

		nLinhaP94++
	Next nY

	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf

	oModelP94:GoLine(1)

Return()

/*/{Protheus.doc} CriaModulo
Criação dos módulos
@author Felipe Caiado
@since 22/03/2017
@version undefined
@param oView, object, descricao
@param lCopy, logical, descricao
@type function
/*/
Static Function CriaModulo(oView, lCopy)

	Local nY			:= 0
	Local oModel     	:= FWModelActive()
	Local oModelP91  	:= oModel:GetModel( 'P91DETAIL' )
	Local nLinhaP91  	:= 1
	Local aMod			:= RetModName()

	If oModelP91:Length() > 1
		ApMsgInfo("Ja existe registros no módulo, preenchimento não executado")
		Return()
	EndIf

	For nY:=1 To Len(aMod)

		If !Alltrim(aMod[nY][2]) == "SIGARPM"

			If nLinhaP91 > 1
				If oModelP91:AddLine() <> nLinhaP91
					Help( ,, 'HELP',, 'Nao incluiu linha P91' + CRLF + oModel:getErrorMessage()[6], 1, 0)
					Loop
				EndIf
			EndIf

			oModelP91:SetValue( 'P91_ACESSO',.F. )
			oModelP91:SetValue( 'P91_MODULO',Alltrim(aMod[nY][2]) )
			oModelP91:SetValue( 'P91_DESCRI',Substr(Alltrim(aMod[nY][3]),1,40) )

			nLinhaP91++

		EndIf
	Next nY

	oModelP91:GoLine(1)

Return()

/*/{Protheus.doc} fRetlat
Gerar Relatorio
@author Felipe Caiado
@since 22/03/2017
@version undefined

@type function
/*/
Static Function fRelat()
	Local oReport	//Objeto relatorio TReport (Release 4)
	Local cAliasQry := GetNextAlias()
	Local cQry 		:= Alltrim(P93->P93_SQL)
	Local aStruct  	:= {}
	Local aPerg 	:= {}
	Local aCodPerg 	:= {}
	Local aRet 		:= {}
	Local cValPar	:= ""
	Local nY		:= 0

	DbSelectArea("P92")
	P92->(DbSetOrder(1))
	If P92->(DbSeek(xFilial("P92")+P93->P93_CODIGO))
		While !P92->(Eof()) .And. xFilial("P92")+P93->P93_CODIGO == P92->(P92_FILIAL+P92_CODIGO)

			aAdd(aCodPerg,Alltrim(P92->P92_PARAM))

			aAdd( aPerg ,{1,Alltrim(P92->P92_DESCRI),Space(P92->P92_TAMANH),"@!",".T.","","",40,.F.})

			P92->(DbSkip())

		End
	EndIf

	If Len(aPerg) > 0

		If !ParamBox(aPerg ,"Parametros da Consulta",@aRet)
			Return()
		EndIf

	EndIf

	For nY:=1 To Len(aCodPerg)
		cValPar := "MV_PAR" + StrZero(nY,2)
		cQry := StrTran(cQry,Alltrim(aCodPerg[nY]),ValToSql(Alltrim(&(cValPar))))
	Next nY

	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf

	TCQUERY ChangeQuery(cQry) NEW ALIAS (cAliasQry)

	aStruct := (cAliasQry)->(dbStruct())

	(cAliasQry)->(DbGoTop())

	oReport := CUSRRELDEF(cQry, aStruct, cAliasQry)
	oReport:PrintDialog()

Return(.T.)   

/*/{Protheus.doc} CUSRRELDEF
Gerar Relatorio
@author Felipe Caiado
@since 22/03/2017
@version undefined

@type function
/*/
Static Function CUSRRELDEF(cQry, aStruct, cAliasQry)
	Local oReport				//Objeto relatorio TReport (Release 4)
	Local oSection1 			//Objeto secao 1 do relatorio 
	Local nX := 0

	DEFINE REPORT oReport NAME "RELD" TITLE "Relatorio" ACTION {|oReport| CUSRRELIMP( oReport, cQry, aStruct, cAliasQry)} DESCRIPTION "Relatório"

	oReport:SetPortrait()

	DEFINE SECTION oSection1 OF oReport TITLE "Relatório" TABLES "SA1"      // "ORIGEM"

	For nX:=1 To Len(aStruct)
		DEFINE CELL NAME aStruct[nX,1]		OF oSection1 ALIAS "" TITLE aStruct[nX,1]
	Next

Return oReport

/*/{Protheus.doc} CUSRRELIMP
Gerar Relatorio
@author Felipe Caiado
@since 22/03/2017
@version undefined

@type function
/*/
Static Function CUSRRELIMP(oReport, cQry, aStruct, cAliasQry)
	Local oSection1 := oReport:Section(1)		//Objeto secao 1 do relatorio (Cabecalho, campos da tabela SU7) 
	Local nX := 0

	(cAliasQry)->(DbGoTop())
	oReport:SetMeter((cAliasQry)->(LastRec()))
	oSection1:Init()
	While !(cAliasQry)->(Eof())
		If oReport:Cancel()
			Exit
		EndIf

/*		nX := 1
		For nX:=1 To Len(aStruct)
			oSection1:Cell(aStruct[nX,1]):SetValue((cAliasQry)->&(aStruct[nX,1]))
		Next
*/
		AEval( aStruct, { | x | oSection1:Cell(x[1]):SetValue((cAliasQry)->&(x[1])) } )

		oSection1:PrintLine()

		oReport:IncMeter()
		(cAliasQry)->(DbSkip())
	EndDo

	oSection1:Finish()

Return(.T.)

/*/{Protheus.doc} FARQUIV
Gerar Relatorio
@author Felipe Caiado
@since 22/03/2017
@version undefined

@type function
/*/
Static Function fProcArq()

	Local clin := ""
	Local cArq := ""
	Local nHdl := ""
	Local cAliasQry := GetNextAlias()
	Local cQry 		:= Alltrim(P93->P93_SQL)
	Local aStruct  	:= {}
	Local aPerg 	:= {}
	Local aCodPerg 	:= {}
	Local aRet 		:= {}
	Local cValPar	:= ""
	Local nY		:= 0
	Local cArquivo  := lower(Alltrim(P93->P93_NOMARQ) + DtoS(Date()) + StrTran(Time(),":","") + ".TXT")

	DbSelectArea("P92")
	P92->(DbSetOrder(1))
	If P92->(DbSeek(xFilial("P92")+P93->P93_CODIGO))
		While !P92->(Eof()) .And. xFilial("P92")+P93->P93_CODIGO == P92->(P92_FILIAL+P92_CODIGO)

			aAdd(aCodPerg,Alltrim(P92->P92_PARAM))

			aAdd( aPerg ,{1,Alltrim(P92->P92_DESCRI),Space(P92->P92_TAMANH),"@!",".T.","","",40,.F.})

			P92->(DbSkip())

		End
	EndIf

	If Len(aPerg) > 0

		If !ParamBox(aPerg ,"Parametros da Consulta",@aRet)
			Return()
		EndIf

	EndIf

	For nY:=1 To Len(aCodPerg)
		cValPar := "MV_PAR" + StrZero(nY,2)
		cQry := StrTran(cQry,Alltrim(aCodPerg[nY]),ValToSql(Alltrim(&(cValPar))))
	Next nY

	If Select(cAliasQry) > 0
		(cAliasQry)->(DbCloseArea())
	EndIf

	TCQUERY ChangeQuery(cQry) NEW ALIAS (cAliasQry)

	aStruct := (cAliasQry)->(dbStruct())

	(cAliasQry)->(DbGoTop())

	cArq	:= "C:\Temp\" + cArquivo
	nHdl 	:= FCreate(cArq)

	cLin := ""

	AEval( aStruct, { | x | cLin += x[1] + ";" } )

	cLin += CRLF

	fWrite(nHdl,clin,Len(clin))

	(cAliasQry)->(DbGoTop())
	While !(cAliasQry)->(Eof())

		cLin := ""

		AEval( aStruct, { | x | cLin += Iif(x[2] == "C",(cAliasQry)->&(x[1]),Alltrim(Str((cAliasQry)->&(x[1])))) + ";" } )

		cLin += CRLF

		fWrite(nHdl,clin,Len(clin))

		(cAliasQry)->(DbSkip())

	EndDo

	fClose(nHdl)

	ApMsgInfo("Arquivo gerado com sucesso. " + cArq)

Return()

/*/{Protheus.doc} FARQUIV
Gerar Relatorio
@author Felipe Caiado
@since 22/03/2017
@version undefined

@type function
/*/
Static Function fArquiv()

	FwMsgRun(Nil,{|| fProcArq() },Nil,"Aguarde, Gerando Arquivo...")

Return()