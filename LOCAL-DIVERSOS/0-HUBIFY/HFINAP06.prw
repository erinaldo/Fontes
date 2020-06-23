#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} HFINAP06
//Notas Fiscais - digitacao manual
@author emerson.natali
@since 28/05/2018
@version undefined
@type function
/*/

User Function HFINAP06()

Local aArea   := GetArea()
Local oBrowse := FWMBrowse():New() // Instanciamento da Classe de Browse

// Definição da tabela do Browse
oBrowse:SetAlias('ZAC')
// Titulo da Browse
oBrowse:SetDescription('Notas Fiscais')
// Ativação da Classe
oBrowse:Activate()

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

ADD OPTION aRotina TITLE "Pesquisar"  ACTION "AxPesqui" 	    OPERATION 1	ACCESS 0 		
ADD OPTION aRotina TITLE "Visualizar" ACTION 'VIEWDEF.HFINAP06' OPERATION 2	ACCESS 0 //MODEL_OPERATION_VIEW
ADD OPTION aRotina TITLE "Incluir"    ACTION 'VIEWDEF.HFINAP06' OPERATION 3	ACCESS 0 //MODEL_OPERATION_INSERT
ADD OPTION aRotina TITLE "Alterar"    ACTION 'VIEWDEF.HFINAP06' OPERATION 4	ACCESS 0 //MODEL_OPERATION_UPDATE
ADD OPTION aRotina TITLE "Excluir"    ACTION 'VIEWDEF.HFINAP06' OPERATION 5	ACCESS 0 //MODEL_OPERATION_DELETE

Return aRotina

/*/{Protheus.doc} ModelDef
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
Static Function ModelDef()

//Criacao da estrutura de dados utilizado na interface
Local oStruZAC := FWFormStruct( 1, 'ZAC' )
//Criacao do objeto do modelo de dados
Private oModel := MPFormModel():New( 'HAP06', /*bPreValidacao*/, /*bPosVld*/, /*bCommit*/, /*bCancel*/ ) //Instanciando o modelo de dados

oModel:AddFields( 'ZACMASTER', /*cOwner*/, oStruZAC ) //Atribuindo formulários para o modelo
oModel:SetPrimaryKey({'ZAC_REFER'}) //Setando a chave primária da rotina
oModel:SetDescription("Notas Fiscais") //Adicionando descrição ao modelo

Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
Static Function ViewDef()

Local oModel 	:= FWLoadModel( 'HFINAP06' )
Local oView 	:= FWFormView():New()
Local oStruZAC 	:= FWFormStruct(2,"ZAC")

oView:SetModel( oModel )
oView:AddField( 'VIEW_ZAC', oStruZAC, 'ZACMASTER' )
oView:CreateHorizontalBox("TELA",100)
oView:SetOwnerView("VIEW_ZAC","TELA")

oView:SetCloseOnOk({||.T.}) //utilizado para que quando gravado feche o registro

Return oView