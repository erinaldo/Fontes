#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
//#INCLUDE "GCPA130.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} GCPA130()
Habilitação de fornecedores - Fornecedores X Edital
@author antenor.silva	
@since 10/09/2013
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------

User Function XGCPA130()
Local oBrowse	:= Nil

Private aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse :SetAlias("COR")

oBrowse:AddLegend("COR_STATUS=='1'","YELLOW",	"Em Aberto")	//"Em Aberto"
oBrowse:AddLegend("COR_STATUS=='2'","GREEN",	"Habilitado")	//"Habilitado"
oBrowse:AddLegend("COR_STATUS=='3'","RED",	"Inabilitado")	//"Inabilitado"

oBrowse:SetDescription("Habilitação de Fornecedores")	//"Habilitação de Fornecedores"

oBrowse:Activate()

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Menu Funcional

@author antenor.silva
@since 10/09/2013
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina	:= {}

//ADD OPTION aRotina TITLE 'Visualizar'ACTION	'VIEWDEF.GCPA130'	OPERATION 2 ACCESS 0 //'Visualizar' 
//ADD OPTION aRotina TITLE 'Incluir'	ACTION 'VIEWDEF.GCPA130'	OPERATION 3 ACCESS 0 //'Incluir'	
ADD OPTION aRotina TITLE 'Alterar'	ACTION 'VIEWDEF._XGCPA130'	OPERATION 4 ACCESS 0 //'Alterar'
//ADD OPTION aRotina TITLE 'Excluir'	ACTION 'VIEWDEF.GCPA130'	OPERATION 5 ACCESS 0 //'Excluir'
//ADD OPTION aRotina TITLE 'Imprimir'	ACTION 'VIEWDEF.GCPA130'	OPERATION 8 ACCESS 0 //'Imprimir'
//ADD OPTION aRotina TITLE STR0010	ACTION 'GCP130Doc' 			OPERATION 6 ACCESS 0 //'Incluir Documento'

Return aRotina

//------------------------------------------------------------------
/*/{Protheus.doc} ModelDef()
Definicao do Modelo
@author antenor.silva
@since 10/09/2013
@version 1.0
@return oModel
/*/
//-------------------------------------------------------------------
Static Function ModelDef()       

Local oModel	:= MPFormModel():New("_XGCPA130",/*bPreValid*/,{|oModel|XGCP130TdOk(oModel)}/*bPosValid*/,{|oModel|GCPGrvLZM0(oModel)}/*bCommit*/,/*bCancel*/)
Local oStruMain	:= FWFormStruct(1,"COR") //Estrutura pai
Local oStruLZ	:= Nil
Local oStruM0 	:= Nil

//------------------------------------------------
//		Cria a estrutura basica manualmente
//------------------------------------------------
oStruLZ := FWFormModelStruct():New()
oStruM0 := FWFormModelStruct():New()

//-- Campo Habilitação da primeira grid - Habilitações
oStruLZ:AddField(	"Habilitação" 										   			,;	// 	[01]  C   Titulo do campo  
				 	"Documentação relativa."										,;	// 	[02]  C   ToolTip do campo 
				 	"LZ_HABILI"														,;	// 	[03]  C   Id do Field
				 	"C"																,;	// 	[04]  C   Tipo do campo
				 	06																,;	// 	[05]  N   Tamanho do campo
				 	0																,;	// 	[06]  N   Decimal do campo
				 	NIL																,;	// 	[07]  B   Code-block de validação do campo
				 	NIL																,;	// 	[08]  B   Code-block de validação When do campo
				 	NIL																,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
					NIL																,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
				 	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.																)	// 	[14]  L   Indica se o campo é virtual

//-- Campo Descrição da primeira grid - Habilitações
oStruLZ:AddField(	"Descrição" 													,;	// 	[01]  C   Titulo do campo  //
					"Descrição da documentação."									,;	// 	[02]  C   ToolTip do campo //
				 	"LZ_DESCR"														,;	// 	[03]  C   Id do Field
				 	"C"																,;	// 	[04]  C   Tipo do campo
				 	55																,;	// 	[05]  N   Tamanho do campo
				 	0																,;	// 	[06]  N   Decimal do campo
				 	NIL																,;	// 	[07]  B   Code-block de validação do campo
				 	NIL																,;	// 	[08]  B   Code-block de validação When do campo
				 	NIL																,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
				 	NIL																,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
				 	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.																)	// 	[14]  L   Indica se o campo é virtual

//
//
//-- Campo Check da segunda grid - Itens das habilitações
oStruM0:AddField(	"" 																,;	// 	[01]  C   Titulo do campo  
				 	"Check"															,;	// 	[02]  C   ToolTip do campo
				 	"M0_CHK"														,;	// 	[03]  C   Id do Field
				 	"L"																,;	// 	[04]  C   Tipo do campo
				 	1																,;	// 	[05]  N   Tamanho do campo
				 	0																,;	// 	[06]  N   Decimal do campo
				 	NIL																,;	// 	[07]  B   Code-block de validação do campo
					NIL																,;	// 	[08]  B   Code-block de validação When do campo
					NIL																,;	//	[09]  A   Lista de valores permitido do campo
					.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
					NIL																,;	//	[11]  B   Code-block de inicializacao do campo
					NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
					NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.																)	// 	[14]  L   Indica se o campo é virtual

//-- Campo Habilitação da primeira grid - Habilitações
oStruM0:AddField(	"Habilitação" 													,;	// 	[01]  C   Titulo do campo  
				 	"Documentação relativa."										,;	// 	[02]  C   ToolTip do campo
				 	"M0_HABILI"														,;	// 	[03]  C   Id do Field
				 	"C"																,;	// 	[04]  C   Tipo do campo
				 	06																,;	// 	[05]  N   Tamanho do campo
				 	0																,;	// 	[06]  N   Decimal do campo
				 	NIL																,;	// 	[07]  B   Code-block de validação do campo
				 	NIL																,;	// 	[08]  B   Code-block de validação When do campo
				 	NIL																,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
					NIL																,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
				 	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.																)	// 	[14]  L   Indica se o campo é virtual

//-- Campo Item da segunda grid - Itens das habilitações
oStruM0:AddField(	"Item" 															,;	// 	[01]  C   Titulo do campo
				 	"Item"															,;	// 	[02]  C   ToolTip do campo
				 	"M0_DESCR"														,;	// 	[03]  C   Id do Field
				 	"C"																,;	// 	[04]  C   Tipo do campo
				 	55																,;	// 	[05]  N   Tamanho do campo
				 	0																,;	// 	[06]  N   Decimal do campo
				 	NIL																,;	// 	[07]  B   Code-block de validação do campo
				 	NIL																,;	// 	[08]  B   Code-block de validação When do campo
				 	NIL																,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
				 	NIL																,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
				 	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.																)	// 	[14]  L   Indica se o campo é virtual

//-- campo especifico
oStruM0:AddField(	"Data Limite"													,;	// 	[01]  C   Titulo do campo
				 	"Data Limite"													,;	// 	[02]  C   ToolTip do campo
				 	"M0_XDTLIM"														,;	// 	[03]  C   Id do Field
				 	"D"																,;	// 	[04]  C   Tipo do campo
				 	08																,;	// 	[05]  N   Tamanho do campo
				 	0																,;	// 	[06]  N   Decimal do campo
				 	NIL																,;	// 	[07]  B   Code-block de validação do campo
				 	NIL																,;	// 	[08]  B   Code-block de validação When do campo
				 	NIL																,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
				 	NIL																,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
				 	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.																)	// 	[14]  L   Indica se o campo é virtual
				 
//------------------------------------------------------
//		Adiciona o componente de formulario no model 
//     Nao sera usado, mas eh obrigatorio ter
//------------------------------------------------------						
oModel:AddFields("CORMASTER"	 ,/*cOwner*/,oStruMain ,/*Pre-Validacao*/,/*Pos-Validacao*/, /*bLoad*/)
oModel:AddGrid  ("LZ_DETAILS" ,"CORMASTER",oStruLZ ,/*Pre-Validacao*/,/*Pos-Validacao*/,/*bPre*/,/*bPost*/,{ |oModel| A130LoadLZ(oModel) }) //-- Carrega no load a tabela LZ do SX5. 
oModel:AddGrid  ("M0_DETAILS" ,"LZ_DETAILS",oStruM0 ,/*Pre-Validacao*/,/*Pos-Validacao*/,/*bPre*/,/*bPost*/,{ |oModel| A130LoadM0(oModel) }) //-- Carrega no load a tabela M0 do SX5.

//--------------------------------------
//		Configura o model
//--------------------------------------
oModel:SetPrimaryKey( {} ) //Obrigatorio setar a chave primaria (mesmo que vazia)

oModel:SetDescription("Fornecedores X Edital") //"Fornecedores X Edital"
oModel:GetModel("CORMASTER"	 ):SetDescription("Fornecedores Habilitados") //"Fornecedores Habilitados"
oModel:GetModel("LZ_DETAILS" ):SetDescription("Habilitação")//"Habilitação"
oModel:GetModel("M0_DETAILS" ):SetDescription("Itens da Habilitação")//"Itens da Habilitação"

// especifico prodam
oModel:GetModel("CORMASTER"	 ):SetOnlyView(.T.)
oModel:GetModel("LZ_DETAILS" ):SetOnlyView(.T.)

oStruM0:SetProperty("M0_XDTLIM",MODEL_FIELD_WHEN,{|oMdl| oMdl:GetValue("M0_CHK") == .T. .and. oModel:GetValue("CORMASTER","COR_STATUS") == "2"}) //,{|| oModel:GetValue("ZZCDETAIL","ZZC_OPCQRY") == "1"})
oStruM0:SetProperty("M0_XDTLIM",MODEL_FIELD_VALID,{|| Vazio() .or. M->M0_XDTLIM >= dDatabase})
// ate aqui

//--------------------------------------
//		Realiza carga dos grids antes da exibicao
//--------------------------------------
oModel:SetActivate( { |oModel| XGCP130Act( oModel ) } )

Return oModel


//--------------------------------------------------------------------
/*/{Protheus.doc} ViewDef()
Definicao da View
@author antenor.silva
@since 10/09/2013
@version 1.0
@return oView
/*/
//--------------------------------------------------------------------
Static Function ViewDef()
Local oModel	  	:= FWLoadModel("_XGCPA130")
Local oView	  	:= FWFormView():New()
Local oStruMain	:= FWFormStruct(2,"COR") //Estrutura pai
Local oStruLZ		:= Nil
Local oStruM0 	:= Nil

//----------------------------------------------------------
//		Cria a estrutura View
//----------------------------------------------------------
oStruLZ  :=FWFormViewStruct():New()  
oStruM0  :=FWFormViewStruct():New()  
			
//--------------------------------------
//		Associa o View ao Model
//--------------------------------------
oView:SetModel(oModel)  //-- Define qual o modelo de dados será utilizado
oView:SetUseCursor(.F.) //-- Remove cursor de registros'
		 	
//-- Campo Habilitação da primeira grid - Habilitações
oStruLZ:AddField(	"LZ_HABILI"														,;	// [01]  C   Nome do Campo
				"01"																,;	// [02]  C   Ordem
				"Habilitação" 														,;	// [03]  C   Titulo do campo
				"Habilitação do Fornecedor."										,;	// [04]  C   Descricao do campo//
				NIL																	,;	// [05]  A   Array com Help
				"C"																	,;	// [06]  C   Tipo do campo
				""																	,;	// [07]  C   Picture
				NIL																	,;	// [08]  B   Bloco de Picture Var
				NIL																	,;	// [09]  C   Consulta F3
				.F.																	,;	// [10]  L   Indica se o campo é alteravel
				NIL																	,;	// [11]  C   Pasta do campo
				NIL																	,;	// [12]  C   Agrupamento do campo
				NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
				NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
				NIL																	,;	// [15]  C   Inicializador de Browse
				.F.																	,;	// [16]  L   Indica se o campo é virtual
				NIL																	,;	// [17]  C   Picture Variavel
				NIL																	)	// [18]  L   Indica pulo de linha após o campo
		 	
//-- Campo Descrição da primeira grid - Habilitações
oStruLZ:AddField(	"LZ_DESCR"														,;	// [01]  C   Nome do Campo
				"02"																,;	// [02]  C   Ordem
				"Descrição" 														,;	// [03]  C   Titulo do campo
				"Descrição da documentação."										,;	// [04]  C   Descricao do campo
				NIL																	,;	// [05]  A   Array com Help
				"C"																	,;	// [06]  C   Tipo do campo
				""																	,;	// [07]  C   Picture
				NIL																	,;	// [08]  B   Bloco de Picture Var
				NIL																	,;	// [09]  C   Consulta F3
				.F.																	,;	// [10]  L   Indica se o campo é alteravel
				NIL																	,;	// [11]  C   Pasta do campo
				NIL																	,;	// [12]  C   Agrupamento do campo
				NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
				NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
				NIL																	,;	// [15]  C   Inicializador de Browse
				.F.																	,;	// [16]  L   Indica se o campo é virtual
				NIL																	,;	// [17]  C   Picture Variavel
				NIL																	)	// [18]  L   Indica pulo de linha após o campo	 			 

//-- Campo Check da segunda grid - Itens das habilitações
oStruM0:AddField(	"M0_CHK"														,;	// [01]  C   Nome do Campo
				"01"																,;	// [02]  C   Ordem
				"" 																	,;	// [03]  C   Titulo do campo
				""																	,;	// [04]  C   Descricao do campo
				NIL																	,;	// [05]  A   Array com Help
				"L"																	,;	// [06]  C   Tipo do campo
				""																	,;	// [07]  C   Picture
				NIL																	,;	// [08]  B   Bloco de Picture Var
				NIL																	,;	// [09]  C   Consulta F3
				/*.T. especifico prodam*/.F.																	,;	// [10]  L   Indica se o campo é alteravel
				NIL																	,;	// [11]  C   Pasta do campo
				NIL																	,;	// [12]  C   Agrupamento do campo
				NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
				NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
				NIL																	,;	// [15]  C   Inicializador de Browse
				.F.																	,;	// [16]  L   Indica se o campo é virtual
				NIL																	,;	// [17]  C   Picture Variavel
				NIL																	)	// [18]  L   Indica pulo de linha após o campo

//-- Campo Parágrafo da segunda grid - Itens das habilitações
oStruM0:AddField(	"M0_HABILI"														,;	// [01]  C   Nome do Campo
				"02"																,;	// [02]  C   Ordem
				"Parágrafo"															,;	// [03]  C   Titulo do campo//
				""																	,;	// [04]  C   Descricao do campo
				NIL																	,;	// [05]  A   Array com Help
				"C"																	,;	// [06]  C   Tipo do campo
				""																	,;	// [07]  C   Picture
				NIL																	,;	// [08]  B   Bloco de Picture Var
				NIL																	,;	// [09]  C   Consulta F3
				.F.																	,;	// [10]  L   Indica se o campo é alteravel
				NIL																	,;	// [11]  C   Pasta do campo
				NIL																	,;	// [12]  C   Agrupamento do campo
				NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
				NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
				NIL																	,;	// [15]  C   Inicializador de Browse
				.F.																	,;	// [16]  L   Indica se o campo é virtual
				NIL																	,;	// [17]  C   Picture Variavel
				NIL																	)	// [18]  L   Indica pulo de linha após o campo					


//-- Campo Item da segunda grid - Itens das habilitações
oStruM0:AddField(	"M0_DESCR"														,;	// [01]  C   Nome do Campo
				"03"																,;	// [02]  C   Ordem
				"Item" 																,;	// [03]  C   Titulo do campo
				"Item"																,;	// [04]  C   Descricao do campo
				NIL																	,;	// [05]  A   Array com Help
				"C"																	,;	// [06]  C   Tipo do campo
				""																	,;	// [07]  C   Picture
				NIL																	,;	// [08]  B   Bloco de Picture Var
				NIL																	,;	// [09]  C   Consulta F3
				.F.																	,;	// [10]  L   Indica se o campo é alteravel
				NIL																	,;	// [11]  C   Pasta do campo
				NIL																	,;	// [12]  C   Agrupamento do campo
				NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
				NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
				NIL																	,;	// [15]  C   Inicializador de Browse
				.F.																	,;	// [16]  L   Indica se o campo é virtual
				NIL																	,;	// [17]  C   Picture Variavel
				NIL																	)	// [18]  L   Indica pulo de linha após o campo	

// campo especifico
oStruM0:AddField( 	"M0_XDTLIM"														,;	// [01]  C   Nome do Campo
					"04"															,;	// [02]  C   Ordem
					"Data Limite" 													,;	// [03]  C   Titulo do campo
					"Data Limite"													,;	// [04]  C   Descricao do campo
					NIL																,;	// [05]  A   Array com Help
					"D"																,;	// [06]  C   Tipo do campo	
					""																,;	// [07]  C   Picture
					NIL																,;	// [08]  B   Bloco de Picture Var
					NIL																,;	// [09]  C   Consulta F3
					.T.																,;	// [10]  L   Indica se o campo é alteravel
					NIL																,;	// [11]  C   Pasta do campo
					NIL																,;	// [12]  C   Agrupamento do campo
					NIL																,;	// [13]  A   Lista de valores permitido do campo (Combo)
					NIL																,;	// [14]  N   Tamanho maximo da maior opção do combo
					NIL																,;	// [15]  C   Inicializador de Browse
					.F.																,;	// [16]  L   Indica se o campo é virtual
					NIL																,;	// [17]  C   Picture Variavel
					NIL																)	// [18]  L   Indica pulo de linha após o campo	
	
//--------------------------------------
//		Insere os componentes na view
//--------------------------------------
oView:AddField("VIEW_MASTER",oStruMain	,"CORMASTER")
oView:AddGrid ("VIEW_LZ"	,oStruLZ	,"LZ_DETAILS")
oView:AddGrid ("VIEW_M0" 	,oStruM0	,"M0_DETAILS")

//--------------------------------------
//		Cria os Box's
//--------------------------------------
oView:CreateHorizontalBox("CABEC"	,20)
oView:CreateHorizontalBox("GRIDLZ"	,30)
oView:CreateHorizontalBox("GRIDM0"	,50)

//--------------------------------------
//		Associa os componentes
//--------------------------------------
oView:SetOwnerView("VIEW_MASTER","CABEC")
oView:SetOwnerView("VIEW_LZ","GRIDLZ")
oView:SetOwnerView("VIEW_M0","GRIDM0")

Return oView


//--------------------------------------------------------------------
/*/{Protheus.doc} GCP130Act()
Carga inicial do modelo.
@author antenor.silva
@since 12/09/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------
Static Function XGCP130Act(oModel)
Local oModelLZ	:= oModel:GetModel("LZ_DETAILS")
Local oModelM0	:= oModel:GetModel("M0_DETAILS")
Local nLinLz		:= 0
Local nLinM0		:= 0
Local nOperation	:= oModel:GetOperation()

If (nOperation == MODEL_OPERATION_INSERT)
	//---------------------------------------------
	//		Configura modelo SX5
	//---------------------------------------------
	oModelLZ:SetNoInsertLine( .F. )
	oModelLZ:SetNoDeleteLine( .F. )
	
	oModelM0:SetNoInsertLine( .F. )
	oModelM0:SetNoDeleteLine( .F. )
	
	//---------------------------------------------
	// Pesquisa na tabela de Habilitação
	//---------------------------------------------
	BeginSQL Alias "SX5LZ"
		SELECT *
	   	FROM %Table:SX5% SX5
	   	WHERE SX5.X5_FILIAL=%xFilial:SX5% AND SX5.X5_TABELA="LZ" AND SX5.%NotDel%
	EndSQL
	
	//---------------------------------------------
	// Pesquisa na tabela de Itens da Habilitação
	//---------------------------------------------
	BeginSQL Alias "SX5M0"
		SELECT *
	   	FROM %Table:SX5% SX5
	   	WHERE SX5.X5_FILIAL=%xFilial:SX5% AND SX5.X5_TABELA="M0" AND SX5.%NotDel%
	EndSQL
	
	//---------------------------------------------
	// Preenche a tabela de Habilitação
	//---------------------------------------------
	While !SX5LZ->(EOF())
		nLinLz++
		If nLinLz # 1
			oModelLZ:AddLine()
		EndIf
		oModelLZ:SetValue("LZ_HABILI"	, AllTrim(SX5LZ->X5_CHAVE))
		oModelLZ:SetValue("LZ_DESCR"	, SX5LZ->X5_DESCRI)
	
		//---------------------------------------------
		// Verifica se a o item da habilitação está contida na habilitação 
		// para preencher a tabela de item da Habilitação
		//---------------------------------------------
		nLinM0 := 0
		While !SX5M0->(EOF())
			If AllTrim(SX5LZ->X5_CHAVE) == AllTrim(Substr(SX5M0->X5_CHAVE,1,Len(AllTrim(SX5M0->X5_CHAVE))-1))
				nLinM0++
				If nLinM0 # 1
					oModelM0:AddLine()
				EndIf
				oModelM0:SetValue("M0_CHK"		, .F. )
				oModelM0:SetValue("M0_HABILI"	, AllTrim(SX5M0->X5_CHAVE))
				oModelM0:SetValue("M0_DESCR"	, SX5M0->X5_DESCRI)
			EndIf
			SX5M0->(dbSkip())
		EndDo
		SX5LZ->(dbSkip())
		SX5M0->(dbGoTop())
	EndDo
	
	oModelLZ:GoLine(1)
	oModelM0:GoLine(1)
	
	SX5LZ->(dbCloseArea())
	SX5M0->(dbCloseArea())
	
	oModelLZ:GoLine( 1 )
	oModelM0:GoLine( 1 )
EndIf	

	//--------------------------------------
	//		Configura permissao dos modelos
	//--------------------------------------
	oModelLZ:SetNoInsertLine( .T. )
	oModelLZ:SetNoDeleteLine( .T. )
	
	//--------------------------------------
	//		Configura permissao dos modelos
	//--------------------------------------
	oModelM0:SetNoInsertLine( .T. )
	oModelM0:SetNoDeleteLine( .T. )

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} GCPGrvLZM0(oModel)
Realiza gravacao manual dos campos na tabela COS - Fornecedor X Habilitação
@author antenor.silva
@since 12/09/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------
Static Function GCPGrvLZM0(oModel)
Local oMaster		:= oModel:GetModel("CORMASTER")
Local oModelLZ	:= oModel:GetModel("LZ_DETAILS")
Local oModelM0	:= oModel:GetModel("M0_DETAILS")
Local nZ			:= 0
Local n0			:= 0
Local nOperation	:= oModel:GetOperation()

Begin TRANSACTION

If(nOperation == MODEL_OPERATION_INSERT)
	If FWFormCommit(oModel)
		For nZ := 1 To oModelLZ:GetQtdLine()
			oModelLZ:GoLine( nz )
			For n0 := 1 To oModelM0:GetQtdLine()			
				oModelM0:GoLine( n0 )
				If oModelM0:GetValue("M0_CHK") 				
					Reclock("COS",.T.)		
					COS_FILIAL	:= xFilial("COS")
					COS_CODFOR	:= oMaster:GetValue("COR_CODFOR")
					COS_LOJFOR	:= oMaster:GetValue("COR_LOJFOR")
					COS_HABILI	:= oModelLZ:GetValue("LZ_HABILI")
					COS_ITEMHB	:= oModelM0:GetValue("M0_HABILI")
					COS_MARK	:= oModelM0:GetValue("M0_CHK")
					MsUnlock()					
				EndIf
			Next n0
		Next nZ
	Endif
ElseIf (nOperation == MODEL_OPERATION_DELETE)
	If FWFormCommit(oModel)
		For nZ := 1 To oModelLZ:GetQtdLine()
			oModelLZ:GoLine( nz )
			For n0 := 1 To oModelM0:GetQtdLine()			
				oModelM0:GoLine( n0 )
				dbSelectArea("COS")
				dbSetOrder(1)
				If (dbSeek(xFilial("COS")+oMaster:GetValue("COR_CODFOR")+oMaster:GetValue("COR_LOJFOR")+PadR(oModelLZ:GetValue("LZ_HABILI"),6)+oModelM0:GetValue("M0_HABILI")))
					RecLock("COS",.F.)
					dbDelete()
  					MsUnLock()  	
				EndIf
			Next n0
		Next nZ	
	EndIf	
ElseIf (nOperation == MODEL_OPERATION_UPDATE)
	For nZ := 1 To oModelLZ:GetQtdLine()
		oModelLZ:GoLine( nz )
		For n0 := 1 To oModelM0:GetQtdLine()			
			oModelM0:GoLine( n0 )
			dbSelectArea("COS")
			dbSetOrder(1)
			// especifico prodam
			If oModelM0:GetValue("M0_CHK") .And. (dbSeek(xFilial("COS")+oMaster:GetValue("COR_CODFOR")+oMaster:GetValue("COR_LOJFOR")+PadR(oModelLZ:GetValue("LZ_HABILI"),6)+oModelM0:GetValue("M0_HABILI")))
				RecLock("COS",.F.)
				COS->COS_XDTLIM := oModelM0:GetValue("M0_XDTLIM")
		  		MsUnLock()  	
			EndIf
			// ate aqui
			/*
			If !oModelM0:GetValue("M0_CHK") .And. (dbSeek(xFilial("COS")+oMaster:GetValue("COR_CODFOR")+oMaster:GetValue("COR_LOJFOR")+PadR(oModelLZ:GetValue("LZ_HABILI"),6)+oModelM0:GetValue("M0_HABILI")))
				oMaster:SetValue('COR_STATUS' , '1')
				RecLock("COS",.F.)
				dbDelete()
		  		MsUnLock()  	
			EndIf
			If oModelM0:GetValue("M0_CHK") .And. !(dbSeek(xFilial("COS")+oMaster:GetValue("COR_CODFOR")+oMaster:GetValue("COR_LOJFOR")+PadR(oModelLZ:GetValue("LZ_HABILI"),6)+oModelM0:GetValue("M0_HABILI")))				
				oMaster:SetValue('COR_STATUS' , '1')
				Reclock("COS",.T.)		
				COS_FILIAL	:= xFilial("COS")
				COS_CODFOR	:= oMaster:GetValue("COR_CODFOR")
				COS_LOJFOR	:= oMaster:GetValue("COR_LOJFOR")
				COS_HABILI	:= oModelLZ:GetValue("LZ_HABILI")
				COS_ITEMHB	:= oModelM0:GetValue("M0_HABILI")
				COS_MARK	:= oModelM0:GetValue("M0_CHK")
				MsUnlock()					
			EndIf
			*/
		Next n0
	Next nZ
	FWFormCommit(oModel)	

EndIf

END TRANSACTION()

Return .T.


//-------------------------------------------------------------------
/*/{Protheus.doc} GCP130TdOk(oModel)
Verifica se o campo de justificativa está prenchido quando o status for igual a Inabilitado.
@author antenor.silva
@since 13/09/2013
@version 1.0
@return aReturn
/*/
//--------------------------------------------------------------------
Static Function XGCP130TdOk(oModel)
Local lRet 		:= .T.
Local oMaster		:= oModel:GetModel("CORMASTER")
Local nStatus		:= oMaster:GetValue('COR_STATUS')

If nStatus == "3" .And. Empty(oMaster:GetValue("COR_JUSTIF"))
	Help('',1,'GCPA130INA') // "Insira uma justificativa do porquê o fornecedor será inabilitado"
	lRet := .F.
EndIf     

if !ExistCpo("SA2",oMaster:GetValue('COR_CODFOR')+oMaster:GetValue('COR_LOJFOR'))
	Help('',1,'GCPA130FORERR') // "Loja do fornecedor informado não encontrada."
	lRet := .F.
EndIf

If lRet .AND.  !(oMaster:GetValue('COR_DTHABI')> dDataBase .AND. oMaster:GetValue('COR_DTHABI')<= dDataBase+365)
	If nStatus == '2'  
		Help(" ",1,'GCPDATAFORA')	// A data informada está fora da faixa.
		lRet := .F.
	EndIf
EndIf     
                                           
Return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} A130LoadLZ(oModel)
Carrega o load da tabela LZ do arquivo SX5.
@author antenor.silva
@since 17/09/2013
@version 1.0
@return aRet
/*/
//--------------------------------------------------------------------
Static Function A130LoadLZ(oModel)
Local aRet		:= {}
Local aLine	:= {}

//-------------------------------------------------------------------
// Pesquisa na tabela de habilitações
//-------------------------------------------------------------------
BeginSQL Alias "SX5LZ"
	SELECT *
   	FROM %Table:SX5% SX5
   	WHERE SX5.X5_FILIAL=%xFilial:SX5% AND SX5.X5_TABELA="LZ" AND SX5.%NotDel%
EndSQL
//-------------------------------------------------------------------
// Preenche as linhas do Grid com novos dados
//-------------------------------------------------------------------
While !SX5LZ->(EOF())			
	Aadd(aLine, AllTrim(SX5LZ->X5_CHAVE))
	Aadd(aLine, SX5LZ->X5_DESCRI)
	Aadd(aRet,{ SX5LZ->(Recno()),aLine})
	aLine	:= {}
	SX5LZ->(dbSkip())
EndDo

SX5LZ->(dbCloseArea())

oModel:SetNoInsertLine(.T.)
oModel:SetNoDeleteLine(.T.)


Return aRet


//-------------------------------------------------------------------
/*/{Protheus.doc} A130LoadM0(oModel)
Carrega o load da tabela M0 do arquivo SX5.
@author antenor.silva
@since 17/09/2013
@version 1.0
@return aRet
/*/
//--------------------------------------------------------------------
Static Function A130LoadM0(oModel)
Local aRet			:= {}
Local oModelLZ	:= oModel:GetModel():GetModel("LZ_DETAILS")
Local aLine		:= {}

//---------------------------------------------
// Pesquisa na tabela de Itens da Habilitação
//---------------------------------------------
BeginSQL Alias "SX5M0"
	SELECT *
   	FROM %Table:SX5% SX5
   	WHERE SX5.X5_FILIAL=%xFilial:SX5% AND SX5.X5_TABELA="M0" AND SX5.%NotDel%
EndSQL

//---------------------------------------------
// Verifica se o item da habilitação está contida na habilitação 
// para preencher a tabela de item da Habilitação
//---------------------------------------------	
While !SX5M0->(EOF())		
	If oModelLZ:GetValue("LZ_HABILI") == AllTrim(Substr(SX5M0->X5_CHAVE,1,Len(AllTrim(SX5M0->X5_CHAVE))-1))
		COS->(dbSetOrder(1))
		If COS->(dbSeek(xFilial("COS")+COR->COR_CODFOR+COR->COR_LOJFOR+PadR(oModelLZ:GetValue("LZ_HABILI"),6)+SX5M0->X5_CHAVE))			
			Aadd(aLine, .T.)				
		Else
			Aadd(aLine, .F.)			
		EndIf
		Aadd(aLine, SX5M0->X5_CHAVE )
		Aadd(aLine, SX5M0->X5_DESCRI)
		aAdd(aLine, IIf(COS->(Found()),COS->COS_XDTLIM,cTod(""))) 
		Aadd(aRet,{ SX5M0->(Recno()),aLine})
		aLine	:= {}					
	EndIf
	SX5M0->(dbSkip())
EndDo

SX5M0->(dbCloseArea())

oModel:SetNoInsertLine(.T.)
oModel:SetNoDeleteLine(.T.)


Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GCP130Doc()
Visualiza o banco de conhecimento conforme permissão usuario.

@author antenor.silva
@return Nil
@since 17/09/2013
@version 1.0
/*/
//------------------------------------------------------------------
Static Function XGCP130Doc(oModel)
//VARIAVEIS ADICIONADAS DEVIDO A UTILIZAÇÃO NA FUNÇÃO MSDOCUMENT.
Private aRotina	:= MenuDef()
Private cCadastro	:= "Documentos"//"Documentos"

MsDocument( 'COR', COR->( Recno() ), 2 ) 

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} GCPVldFor()
Valida se fornecedor está habilitado, recebendo como parâmetro o código
do fornecedor e a loja.
@author antenor.silva
@return Nil
@since 17/09/2013
@version 1.0
/*/
//------------------------------------------------------------------
Static Function GCPVldFor(cFor, cLoj)
Local lRet := .T.

COR->(dbSeek(xFilial("COR")+cFor+cLoj))
If COR->COR_STATUS <> "2"
	lRet := .F.		
EndIf 

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GCP130VFor()
Valida Fornecedor e loja para preenchimento de campo virtual COR_NOMFOR
@author Rodrigo Toledo
@since 14/11/2013
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function XGCP130VFor()
Local oModel 	:= FWModelActive()
Local oMaster	:= oModel:GetModel("CORMASTER")
Local lRet  	:= .T.
Local lF3		:= IsInCallStack('GETLKRET') //Verifica se foi feito a consulta atraves do F3
Local cForn 	:= IIF(lF3,SA2->A2_COD , oMaster:GetValue("COR_CODFOR") )
Local cLoja 	:= IIF(lF3,SA2->A2_LOJA ,oMaster:GetValue("COR_LOJFOR") )

if Empty(cLoja)
	lRet := ExistCpo("SA2",cForn)
Else
	lRet := ExistCpo("SA2",cForn+cLoja)
EndIf

If lRet
	If COR->(dbSeek(xFilial("COR")+cForn+cLoja) )
		lRet:= .F.
		Help('',1,'JAGRAVADO') // JAGRAVADO
	Else
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))
			oMaster:LoadValue('COR_CODFOR',cForn)
			oMaster:LoadValue('COR_LOJFOR',cLoja)
			oMaster:LoadValue('COR_NOMFOR',PadR(SA2->A2_NOME,TamSX3("COR_NOMFOR")[1]))
		EndIf
	EndIf
EndIf

Return lRet
