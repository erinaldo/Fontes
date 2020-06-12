#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} AWS002
//TODO Rotina para visualizar Log de Integração WS
@author Mario L. B. Faria
@since 25/05/2018
@version 1.0
/*/
User Function AWS002()
	
	Local oBrowse := Nil

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZWS")
	oBrowse:SetDescription("Log de Processos")
	oBrowse:SetMenuDef("MADERO_AWS002")
	oBrowse:Activate()

Return

Static Function MenuDef()

	Local aRotina := {}

	aAdd(aRotina,{'Visualizar'	,'VIEWDEF.MADERO_AWS002'	,0,2,0,NIL})
//	aAdd(aRotina,{'Incluir'		,'VIEWDEF.MADERO_AWS002'	,0,3,0,NIL})
//	aAdd(aRotina,{'Alterar'		,'VIEWDEF.MADERO_AWS002'	,0,4,0,NIL})
//	aAdd(aRotina,{'Excluir'		,'VIEWDEF.MADERO_AWS002'	,0,5,0,NIL})
//	aAdd(aRotina,{'Imprimir' 	,'VIEWDEF.MADERO_AWS002'	,0,8,0,NIL})
//	aAdd(aRotina,{'Copiar'		,'VIEWDEF.MADERO_AWS002'	,0,9,0,NIL})

Return( aRotina )

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Mario L. B. Faria

@since 28/04/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()

	Local oModel 
	Local oStr1:= FWFormStruct(1,'ZWS')
	
	oModel := MPFormModel():New('MAIN_AWS002')
	oModel:SetDescription('Log de Processos')
	oModel:addFields('MODEL_ZWS',,oStr1)
	oModel:SetPrimaryKey({ 'ZWS_FILIAL', 'ZWS_PROCES', 'ZWS_DATA' })



Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Mario L. B. Faria

@since 28/04/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()

	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZWS')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('VIEW_ZWS' , oStr1,'MODEL_ZWS' ) 
	oView:CreateHorizontalBox( 'BOX_ZWS', 100)
	oView:SetOwnerView('VIEW_ZWS','BOX_ZWS')

Return oView