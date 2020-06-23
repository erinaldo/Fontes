#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
/*/ {Protheus.doc} f0102001()

@Project     MAN00000011501_EF_020
@author      Jackson Capelato        
@since       21/09/2015
@version     P12.5
@Return      Cadastro tabela PA4
@Obs         Cadastro de Grupos de Orçamento Folha
@menu		 Cadastro de Grupos de Orcamento Folha
/*/
User Function F0102001()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('PA4')
	oBrowse:SetDescription('Cadastro de Grupos de Orcamento Folha')
	oBrowse:Activate()

Return NIL

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina Title 'Visualizar' 	Action 'VIEWDEF.F0102001' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir' 		Action 'VIEWDEF.F0102001' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar' 		Action 'VIEWDEF.F0102001' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir' 		Action 'VIEWDEF.F0102001' OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
	Local oStruMod 	:= FWFormStruct(1,'PA4')
	Local oModel	:= MPFormModel():New('M0102001') 
	oModel:AddFields('COMMASTER',, oStruMod)
	oModel:SetPrimaryKey({})
	oModel:SetDescription('Cadastro de Grupos de Orcamento Folha')
	oModel:GetModel('COMMASTER'):SetDescription('Cadastro de Grupos de Orcamento Folha')
	
Return oModel

Static Function ViewDef()
	Local oModel 	:= FWLoadModel('F0102001')
	Local oStruView := FWFormStruct(2,'PA4')
	Local oView		:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('VIEW_COM', oStruView, 'COMMASTER')
	oView:CreateHorizontalBox('SUPERIOR', 100 )
	oView:SetOwnerView('VIEW_COM', 'SUPERIOR')

Return oView