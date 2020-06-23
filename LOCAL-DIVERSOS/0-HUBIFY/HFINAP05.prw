#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} HFINAP05
//Iugu Extrato Financeiro
@author emerson.natali
@since 28/05/2018
@version undefined
@type function
/*/

User Function HFINAP05()

Local aArea   := GetArea()
Local oBrowse := FWMBrowse():New() // Instanciamento da Classe de Browse

// Definição da tabela do Browse
oBrowse:SetAlias('ZAB')
// Titulo da Browse
oBrowse:SetDescription('Iugu Extrato Financeiro')
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

ADD OPTION aRotina TITLE "Pesquisar"  			ACTION "AxPesqui" 	    OPERATION 1	ACCESS 0 		
ADD OPTION aRotina TITLE "Visualizar" 			ACTION 'VIEWDEF.HFINAP05' OPERATION 2	ACCESS 0 //MODEL_OPERATION_VIEW
ADD OPTION aRotina TITLE "Incluir"    			ACTION 'VIEWDEF.HFINAP05' OPERATION 3	ACCESS 0 //MODEL_OPERATION_INSERT
ADD OPTION aRotina TITLE "Alterar"    			ACTION 'VIEWDEF.HFINAP05' OPERATION 4	ACCESS 0 //MODEL_OPERATION_UPDATE
ADD OPTION aRotina TITLE "Excluir"    			ACTION 'VIEWDEF.HFINAP05' OPERATION 5	ACCESS 0 //MODEL_OPERATION_DELETE
ADD OPTION aRotina TITLE "Processar Fat.IUGU"   ACTION "U_H06M01PR" 		OPERATION 3	ACCESS 0 //Processo integracao API IUGU das Faturas
ADD OPTION aRotina TITLE "Processar Cli.Fat"    ACTION "U_H06M01CL" 		OPERATION 3	ACCESS 0 //Processo integracao API IUGU das Faturas

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
Local oStruZAB := FWFormStruct( 1, 'ZAB' )
//Criacao do objeto do modelo de dados
Private oModel := MPFormModel():New( 'HAP05', /*bPreValidacao*/, /*bPosVld*/, /*bCommit*/, /*bCancel*/ ) //Instanciando o modelo de dados

oModel:AddFields( 'ZABMASTER', /*cOwner*/, oStruZAB ) //Atribuindo formulários para o modelo
oModel:SetPrimaryKey({'ZAB_REFER'}) //Setando a chave primária da rotina
oModel:SetDescription("Iugu Extrato Financeiro") //Adicionando descrição ao modelo

Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descrição auto-gerada.
@author emerson.natali
@since 18/07/2017
@version undefined

@type function
/*/
Static Function ViewDef()

Local oModel 	:= FWLoadModel( 'HFINAP05' )
Local oView 	:= FWFormView():New()
Local oStruZAB 	:= FWFormStruct(2,"ZAB")

oView:SetModel( oModel )
oView:AddField( 'VIEW_ZAB', oStruZAB, 'ZABMASTER' )
oView:CreateHorizontalBox("TELA",100)
oView:SetOwnerView("VIEW_ZAB","TELA")

oView:SetCloseOnOk({||.T.}) //utilizado para que quando gravado feche o registro

Return oView
/*/{Protheus.doc} H06M01PR
Rotina para realizar o processamento das Faturas IUGU
@author emerson.natali
@since 04/06/2018
@version undefined

@type function
/*/
User Function H06M01PR()

_lRet := .F.

IF MSGYESNO("Confirma o processamento do IUGU?")
			
	FWMsgRun(,{|| _lRet := U_HFINAP01(2) },,"Relizando processamento do periodo informado, aguarde..." )
			
	If _lRet
		MSGINFO("Faturamento realizado com sucesso!")
	Else
		MSGALERT("Processamento Cancelado!!!")
	EndIf

ELSE
	MSGALERT("Processamento Cancelado!!!")
ENDIF

RETURN

/*/{Protheus.doc} H06M01CL
//Rotina para realizar a atualizacao de Cliente nas Faturas
@author emerson.natali
@since 12/06/2018
@version undefined

@type function
/*/
User Function H06M01CL

_lRet := .F.

IF MSGYESNO("Confirma o processamento do IUGU?")
	
	FWMsgRun(,{|| _lRet := u_HFINAP02() },,"Relizando processamento do periodo informado, aguarde..." )
	
	If _lRet
		MSGINFO("Faturamento realizado com sucesso!")
	Else
		MSGALERT("Processamento Cancelado!!!")
	EndIf

ELSE
	MSGALERT("Processamento Cancelado!!!")
ENDIF

Return