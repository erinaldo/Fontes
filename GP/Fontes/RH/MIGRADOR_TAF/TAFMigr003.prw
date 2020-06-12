#Include "Protheus.ch"
#Include 'FWMVCDef.ch'
#Include 'FWBrowse.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} TAFMigr003
Browse com as funcionalidades do migrador
@author  Victor A. Barbosa
@since   19/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Function TAFMigr003()

Local oBrowse := FWmBrowse():New()

oBrowse:SetDescription( "Migrador TAF" )
oBrowse:SetAlias("V2A")
oBrowse:SetMenuDef("TAFMIGR003")

oBrowse:AddLegend( "V2A_STATUS=='1'", "BR_AZUL"			, "Pendente (Somente XML)"  ) 
oBrowse:AddLegend( "V2A_STATUS=='2'", "BR_AMARELO"		, "Pendente (Somente Recibo)"  ) 
oBrowse:AddLegend( "V2A_STATUS=='3'", "BR_CINZA"		, "Pendente (Completo)"  ) 
oBrowse:AddLegend( "V2A_STATUS=='4'", "BR_VERDE_ESCURO"	, "XML Integrado (Sem Recibo)"  ) 
oBrowse:AddLegend( "V2A_STATUS=='5'", "BR_VERDE"		, "XML + Recibo Integrado (Com Recibo)"  ) 
oBrowse:AddLegend( "V2A_STATUS=='6'", "BR_VERMELHO"		, "Erro na Integração"  ) 

oBrowse:Activate()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Definição do Menu
@author  Victor A. Barbosa
@since   31/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title "Pesquisar"	    Action "PesqBrw"             	OPERATION 1 ACCESS 0
ADD OPTION aRotina Title "Visualizar"	    Action "VIEWDEF.TAFMIGR003"  	OPERATION 2 ACCESS 0
ADD OPTION aRotina Title "Processar"	    Action "TAFMIGR001"  			OPERATION 3 ACCESS 0
ADD OPTION aRotina Title "Relatório"	    Action "TAFRMig01"  		 	OPERATION 4 ACCESS 0
ADD OPTION aRotina Title "Gerar p/ Smart"	Action "TAFMIGXML"  		 	OPERATION 8 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo
@author  Victor A. Barbosa
@since   31/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

Local oModel  := Nil
Local oStruct := FWFormStruct(1, "V2A")

oModel := MPFormModel():New("MODEL_V2A", /*bPre*/, /*bTudoOk*/ ) 
oModel:AddFields("V2AMASTER",,oStruct)
  
//Setando as descrições
oModel:SetDescription("Migrador de dados TAF eSocial")
oModel:GetModel("V2AMASTER"):SetDescription("Migrador eSocial")

oModel:SetPrimaryKey({"V2A_FILIAL", "V2A_CHVERP", "V2A_CHVGOV", "V2A_STATUS", "V2A_CNPJ" })

Return(oModel)

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Monta a view
@author  Victor A. Barbosa
@since   31/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

Local oView   := Nil
Local oStruct := FWFormStruct(2, "V2A")

Local oModel   := FWLoadModel("TAFMIGR003")

//Criando a View
oView := FWFormView():New()
oView:SetModel(oModel)
 
//Adicionando os campos do cabeçalho e o grid dos filhos
oView:AddField("VIEW_V2A", oStruct, "V2AMASTER")
 
//Amarrando a view com as box
oView:CreateHorizontalBox("CABEC", 100)
oView:SetOwnerView("VIEW_V2A", "CABEC")
 
//Habilitando título
oView:EnableTitleView("VIEW_V2A","Migrador de dados TAF eSocial")

Return oView