#include "protheus.ch"
#include "fwmvcdef.ch"


/*/{Protheus.doc} MATA114MDR
Rotina de Grupos de aprovação 'estendida' para adicionar novos submodelos

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0

@type function
/*/
user function MATA114MDR()

	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SAL")
	oBrowse:SetDescription("Grupos de aprovação")

	oBrowse:Activate()

Return oBrowse


/*/{Protheus.doc} ModelDef
Definição do Modelo

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0
@return object, Model

@type function   
/*/
Static Function ModelDef()

	Local oModel := FWLoadModel("MATA114")

	Local oStruZ33 := FWFormStruct(1,'Z33')
	Local oStruZ34 := FWFormStruct(1,'Z34')

	oModel:addGrid('DetailZ33', 'ModelSAL', oStruZ33 )
	oModel:addGrid('DetailZ34', 'ModelSAL', oStruZ34 )

	oModel:SetRelation('DetailZ33', { { 'Z33_FILIAL', 'xFilial("Z33")' }, { 'Z33_GRUPO', 'AL_COD' } }, Z33->(IndexKey(1)) )
	oModel:SetRelation('DetailZ34', { { 'Z34_FILIAL', 'xFilial("Z34")' }, { 'Z34_GRUPO', 'AL_COD' } }, Z34->(IndexKey(1)) )

	oModel:GetModel( 'DetailZ33' ):SetUniqueLine( { 'Z33_GRPCOM' } )
	oModel:GetModel( 'DetailZ34' ):SetUniqueLine( { 'Z34_GRPUSU', 'Z34_USUAR' } )

	oModel:getModel('DetailZ33'):SetDescription("Grupos de compras")
	oModel:getModel('DetailZ34'):SetDescription("Solicitantes \ Usuários")

	oModel:getModel('DetailZ33'):SetOptional(.T.)
	oModel:getModel('DetailZ34'):SetOptional(.T.)

Return oModel



/*/{Protheus.doc} ViewDef
Definição da Visão

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0
@return object, View

@type function
/*/
Static Function ViewDef()

	Local oView := FWLoadView("MATA114")

	Local oStruZ33 := FWFormStruct(2,'Z33')
	Local oStruZ34 := FWFormStruct(2,'Z34')

	//refresh do Modelo customizado na View
	oView:SetModel(ModelDef())

	oStruZ33:RemoveField( 'Z33_GRUPO' )
	oStruZ34:RemoveField( 'Z34_GRUPO' )

	oView:AddGrid('Detail_Z33' , oStruZ33, 'DetailZ33')
	oView:AddGrid('Detail_Z34' , oStruZ34, 'DetailZ34')

	oView:AddSheet('FOLDER','FLD03',"Grupos de compras")
	oView:AddSheet('FOLDER','FLD04',"Solicitantes \ Usuários")

	oView:CreateHorizontalBox( 'MDRZ33', 100, , , 'FOLDER', 'FLD03')
	oView:CreateHorizontalBox( 'MDRZ34', 100, , , 'FOLDER', 'FLD04')

	oView:SetOwnerView('Detail_Z33','MDRZ33')
	oView:SetOwnerView('Detail_Z34','MDRZ34')

	oView:AddIncrementField('Detail_Z33' , 'Z33_ITEM' )
	oView:AddIncrementField('Detail_Z34' , 'Z34_ITEM' )

Return oView



/*/{Protheus.doc} MenuDef
Definição do Menu

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0
@return array, lista de opções

@type function
/*/
static function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar"				ACTION "VIEWDEF.MATA114MDR"	OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"					ACTION "VIEWDEF.MATA114MDR"	OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"					ACTION "VIEWDEF.MATA114MDR"	OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"					ACTION "VIEWDEF.MATA114MDR"	OPERATION 5	ACCESS 3
	ADD OPTION aRotina TITLE "Imprimir"					ACTION "VIEWDEF.MATA114MDR"	OPERATION 8	ACCESS 0
	ADD OPTION aRotina TITLE "Subst. de Aprovadores"	ACTION "A114SubApr()"	 	OPERATION 8 ACCESS 0

return aRotina
