#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} CFINA90
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
user function CFINA90()

Local aArea   := GetArea()
Local oBrowse
Local cFunBkp := FunName()

// Instanciamento da Classe de Browse
oBrowse := FWMBrowse():New()

// Definição da tabela do Browse
oBrowse:SetAlias('ZAG')

// Titulo da Browse
oBrowse:SetDescription('XML-Analitico Aprendizes FL')

oBrowse:SetMenuDef("CFINA90")

// Ativação da Classe
oBrowse:Activate()

SetFunName(cFunBkp)
RestArea(aArea)
	
return nil

/*/{Protheus.doc} MenuDef
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
Static Function MenuDef()

Private aRotina := {}

ADD OPTION aRotina TITLE "Visualizar" ACTION 'VIEWDEF.CFINA90' 	OPERATION MODEL_OPERATION_VIEW 		ACCESS 0 //OPERATION 1
ADD OPTION aRotina TITLE "Incluir"    ACTION 'VIEWDEF.CFINA90'	OPERATION MODEL_OPERATION_INSERT 	ACCESS 0 //OPERATION 3
ADD OPTION aRotina TITLE "Alterar"    ACTION 'VIEWDEF.CFINA90' 	OPERATION MODEL_OPERATION_UPDATE 	ACCESS 0 //OPERATION 4
ADD OPTION aRotina TITLE "Excluir"    ACTION 'VIEWDEF.CFINA90' 	OPERATION MODEL_OPERATION_DELETE 	ACCESS 0 //OPERATION 5

Return aRotina

/*/{Protheus.doc} ModelDef
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
Static Function ModelDef()

//Criacao do objeto do modelo de dados
Local oModel := Nil

//Criacao da estrutura de dados utilizado na interface
Local oStruZAG := FWFormStruct( 1, 'ZAG' )

//Instanciando o modelo de dados
oModel := MPFormModel():New( 'CFINA90_MVC' )

oModel:AddFields( 'ZA0MASTER', /*cOwner*/, oStruZAG )

oModel:SetDescription("Modelo da dados")

oModel:GetModel( 'ZA0MASTER' ):SetDescription( 'Cadastro' )

Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
Static Function ViewDef()

Local oModel := FWLoadModel( "CFINA90" )

Local oStruZAG := FWFormStruct(2,"ZAG")

Local oView := Nil

oView := FWFormView():New()
oView:SetModel( oModel )

oView:AddField( 'VIEW_ZAG', oStruZAG, 'ZA0MASTER' )

oView:CreateHorizontalBox("TELA",100)

oView:EnableTitleView('VIEW_ZAG','Teste-View')

//oView:SetCloseOnOk({||.T.})

oView:SetOwnerView("VIEW_ZAG","TELA")

Return oView