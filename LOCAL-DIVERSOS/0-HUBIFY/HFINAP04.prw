#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} HFINAP04
//Cadastro de Cliente MVC
@author emerson.natali
@since 28/05/2018
@version undefined
@type function
/*/

User Function HFINAP04()

Local aArea   := GetArea()
Local oBrowse := FWMBrowse():New() // Instanciamento da Classe de Browse

// Definição da tabela do Browse
oBrowse:SetAlias('ZAA')
// Titulo da Browse
oBrowse:SetDescription('Cadastro de Cliente - HUBIFY')
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
ADD OPTION aRotina TITLE "Visualizar" ACTION 'VIEWDEF.HFINAP04' OPERATION 2	ACCESS 0 //MODEL_OPERATION_VIEW
ADD OPTION aRotina TITLE "Incluir"    ACTION 'VIEWDEF.HFINAP04' OPERATION 3	ACCESS 0 //MODEL_OPERATION_INSERT
ADD OPTION aRotina TITLE "Alterar"    ACTION 'VIEWDEF.HFINAP04' OPERATION 4	ACCESS 0 //MODEL_OPERATION_UPDATE
ADD OPTION aRotina TITLE "Excluir"    ACTION 'VIEWDEF.HFINAP04' OPERATION 5	ACCESS 0 //MODEL_OPERATION_DELETE
ADD OPTION aRotina TITLE "Processar"  ACTION "U_H06M02PR" 		OPERATION 3	ACCESS 0 //Processo integracao API Lista de Clientes

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
Local oStruZAA := FWFormStruct( 1, 'ZAA' )
//Criacao do objeto do modelo de dados
Private oModel := MPFormModel():New( 'HAP04', /*bPreValidacao*/, /*bPosVld*/, /*bCommit*/, /*bCancel*/ ) //Instanciando o modelo de dados

oModel:AddFields( 'ZAAMASTER', /*cOwner*/, oStruZAA ) //Atribuindo formulários para o modelo
oModel:SetPrimaryKey({'ZAA_CODCLI'}) //Setando a chave primária da rotina
oModel:SetDescription("Cadastro de Cliente - HUBIFY") //Adicionando descrição ao modelo

Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
Static Function ViewDef()

Local oModel 	:= FWLoadModel( 'HFINAP04' )
Local oView 	:= FWFormView():New()
Local oStruZAA 	:= FWFormStruct(2,"ZAA")

oView:SetModel( oModel )
oView:AddField( 'VIEW_ZAA', oStruZAA, 'ZAAMASTER' )
oView:CreateHorizontalBox("TELA",100)
oView:SetOwnerView("VIEW_ZAA","TELA")

oView:SetCloseOnOk({||.T.}) //utilizado para que quando gravado feche o registro

Return oView

/*/{Protheus.doc} H06M02PR
Rotina para realizar o processamento do Cadastro de Clientes
@author emerson.natali
@since 04/06/2018
@version undefined

@type function
/*/
User Function H06M02PR()

_lRet := .F.

IF MSGYESNO("Confirma o processamento do IUGU?")

	FWMsgRun(,{|| _lRet := U_HFINAP03(2) },,"Relizando processamento lista de Clientes, aguarde..." )
			
	If _lRet
		MSGINFO("Processamento Finalizado!")
	Else
		MSGALERT("Processamento Cancelado!!!")
	EndIf

ELSE
	MSGALERT("Processamento Cancelado!!!")
ENDIF

RETURN