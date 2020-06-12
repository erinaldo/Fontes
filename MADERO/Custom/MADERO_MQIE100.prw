#include 'protheus.ch'
#include "FWBrowse.ch"
#Include 'FWMVCDef.ch'

static aGets

static lLoteOK
static omGetMM

#define FRIGORIFICO    "FRIGORIFICO"
#define HORTIFRUTI     "HORTIFRUTI"
#define MERCEARIA      "MERCEARIA"

static LOCATION

//CBBalToledo
//MV_A175VLD


/*/{Protheus.doc} MQIE100
Rotina de administração de pré-separação, com browse listando as separações iniciadas/finalizadas

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
user function MQIE100()

	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:setAlias( "ZI1" )
	oBrowse:setDescription( "Pré Inspeção de entrada" )
	oBrowse:setMenuDef('MADERO_MQIE100')

	oBrowse:addLegend('ZI1_STATUS == "I"','QADIMG16',"Inspeção Iniciada")
	oBrowse:addLegend('ZI1_STATUS == "E"','QIEIMG16',"Inspeção Encerrada")
	oBrowse:addLegend('ZI1_STATUS == "R"','ESTOMOVI',"Inspeção Rejeitada")

	//não faz cache na view para ocultar os campos conforme cada tipo de conferencia
	oBrowse:setCacheView(.F.)

	//não permite ver registros de outras filias, pois a tela sera operada fisicamente em locais filiais distintas
	//sendo assim não pode ver ou editar registros de outras filiais
	oBrowse:SetChgAll(.F.)
	oBrowse:SetSeeAll(.F.)

	oBrowse:activate()

return


/*/{Protheus.doc} ModelDef
Definição do Modelo

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return object, Modelo MVC

@type function
/*/
static function ModelDef()

	Local oStructInspecao := FWFormStruct(1,'ZI1', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructProdutos := FWFormStruct(1,'ZI2', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructPallets  := FWFormStruct(1,'ZI3', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructLotes    := FWFormStruct(1,'ZI4', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructNaoConf  := FWFormStruct(1,'ZI5', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructDivergs  := FWFormStruct(1,'ZI6', /*bAvalCampo*/, /*lViewUsado*/)

	Local oModel := MPFormModel():New('_MQIE100', /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields( 'INSPECAO' , /*cOwner*/ , oStructInspecao , /*bLinePre*/     ,/*bLinePost*/    , /*bPreVal*/, /*bPosVal*/)
	oModel:AddGrid  ( 'PRODUTOS' , 'INSPECAO' , oStructProdutos , /*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:AddGrid  ( 'LOTES'    , 'PRODUTOS' , oStructLotes    , /*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:AddGrid  ( 'PALLETS'  , 'PRODUTOS' , oStructPallets  , /*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:AddGrid  ( 'NAOCONF'  , 'PALLETS'  , oStructNaoConf  , /*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:AddGrid  ( 'DIVERGS'  , 'PRODUTOS' , oStructDivergs  , /*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)

	oModel:SetRelation( 'PRODUTOS' , { { 'ZI2_FILIAL', 'xFilial( "ZI2" )' } , { 'ZI2_ID', 'ZI1_ID' } } , ZI2->(IndexKey(1)) )
	oModel:SetRelation( 'LOTES'    , { { 'ZI4_FILIAL', 'xFilial( "ZI4" )' } , { 'ZI4_ID', 'ZI2_ID' }, { 'ZI4_PROD', 'ZI2_PROD' } } , ZI4->(IndexKey(1)) )
	oModel:SetRelation( 'PALLETS'  , { { 'ZI3_FILIAL', 'xFilial( "ZI3" )' } , { 'ZI3_ID', 'ZI2_ID' }, { 'ZI3_PROD', 'ZI2_PROD' } } , ZI3->(IndexKey(1)) )
	oModel:SetRelation( 'NAOCONF'  , { { 'ZI5_FILIAL', 'xFilial( "ZI5" )' } , { 'ZI5_ID', 'ZI3_ID' }, { 'ZI5_PROD', 'ZI3_PROD' }, { 'ZI5_PALLET', 'ZI3_PALLET' } } , ZI5->(IndexKey(1)) )
	oModel:SetRelation( 'DIVERGS'  , { { 'ZI6_FILIAL', 'xFilial( "ZI6" )' } , { 'ZI6_ID', 'ZI2_ID' }, { 'ZI6_PROD', 'ZI2_PROD' } } , ZI6->(IndexKey(1)) )

	oModel:SetDescription("Pré Inspeção de Entrada")

	oModel:SetPrimaryKey( { "ZI1_FILIAL", "ZI1_ID" } )

	noAll(oModel:GetModel('PRODUTOS'))
	noAll(oModel:GetModel('LOTES'))
	noAll(oModel:GetModel('PALLETS'))
	noAll(oModel:GetModel('NAOCONF'))
	noAll(oModel:GetModel('DIVERGS'))

	oModel:InstallEvent("MQIE100Event", /*cOwner*/, MQIE100Event():New())

return oModel


static function noAll(oModel)

	oModel:SetOptional(.T.)
	oModel:SetNoDeleteLine(.T.)
	oModel:SetNoInsertLine(.T.)
	oModel:SetNoUpdateLine(.T.)

return


/*/{Protheus.doc} MQIE100Event
Eventos para o Modelo MVC

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type class
/*/
class MQIE100Event from FWModelEvent
    method New()
    method After()
    method ModelPosVld()
end class


/*/{Protheus.doc} New
Metodo construtor, sem conteudo porque é obrigatório

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
method New() Class MQIE100Event
return


/*/{Protheus.doc} After
Método que é chamado pelo MVC quando ocorrer as ações do commit
 depois da gravação de cada submodelo (field ou cada linha de uma grid)

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@param oModel, object, Modelo MVC
@param cModelId, characters, Identificador do SubModelo
@param cAlias, characters, Alias do SubModelo
@param lNewRecord, logical, Indica se é novo registro
@type function
/*/
method After(oModel, cModelId, cAlias, lNewRecord) Class MQIE100Event

	//inspecao
	IF cModelId == "INSPECAO"

		SF1->( dbSetOrder(1) )
		SF1->( dbSeek( xFilial("SF1") + ZI1->(ZI1_DOC+ZI1_SERIE+ZI1_FORN+ZI1_LOJA) ) )

		IF SF1->( Found() )

			//na exclusão
			IF oModel:GetOperation() == MODEL_OPERATION_DELETE
				Reclock("SF1",.F.)
				SF1->F1_PIPSTAT := "B"
				SF1->( MsUnlock() )

				event("Inspeção Excluida","Inspeção da nota " +SF1->(F1_FILIAL+"/"+F1_DOC+"/"+F1_SERIE+"/"+F1_FORNECE+"/"+F1_LOJA)+ " - RECNO " +cValToChar(SF1->(Recno()))+" foi Excluida.")
			EndIF

			//na alteração para liberação
			IF oModel:GetOperation() == MODEL_OPERATION_UPDATE .and. IsInCallStack("u_MQIE100Lib")
				Reclock("SF1",.F.)
				SF1->F1_PIPSTAT := "L"
				SF1->( MsUnlock() )

				event("Inspeção Liberada para Classificação","Inspeção da nota " +SF1->(F1_FILIAL+"/"+F1_DOC+"/"+F1_SERIE+"/"+F1_FORNECE+"/"+F1_LOJA)+ " - RECNO " +cValToChar(SF1->(Recno()))+" foi liberada para classificação antes do inspeção de todos os Produtos.")
			EndIF

		EndIF

	EndIF

return


/*/{Protheus.doc} ModelPosVld
Método que é chamado pelo MVC quando ocorrer as ações de pos validação do Model
 Esse evento ocorre uma vez no contexto do modelo principal.

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, se o modelo é valido
@param oModel, object, Modelo Principal
@param cModelId, characters, ID do Modelo
@type function
/*/
method ModelPosVld(oModel, cModelId) class MQIE100Event

	//na exclusão na Inspeção
	IF oModel:GetOperation() == MODEL_OPERATION_DELETE

		SF1->( dbSetOrder(1) )
		SF1->( dbSeek( xFilial("SF1") + ZI1->(ZI1_DOC+ZI1_SERIE+ZI1_FORN+ZI1_LOJA) ) )

		IF SF1->( Found() ) .And. ! Empty(SF1->F1_STATUS)
			Help("",1,"PRE-INSP_CLASS",,"Não é possivel excluir a inspeção desta nota, pois já foi classificada ou está bloqueada.",4,1)
			return .F.
		EndIF

	EndIF

return .T.


/*/{Protheus.doc} ViewDef
Definição da View

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return object, View MVC

@type function
/*/
static function ViewDef()

	Local oStructInspecao := FWFormStruct(2,'ZI1', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructProdutos := FWFormStruct(2,'ZI2', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructPallets  := FWFormStruct(2,'ZI3', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructLotes    := FWFormStruct(2,'ZI4', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructNaoConf  := FWFormStruct(2,'ZI5', /*bAvalCampo*/, /*lViewUsado*/)
	Local oStructDivergs  := FWFormStruct(2,'ZI6', /*bAvalCampo*/, /*lViewUsado*/)

	Local oModel := ModelDef()
	Local oView  := FWFormView():New()

	oStructProdutos:RemoveField("ZI2_ID")
	oStructLotes:RemoveField("ZI4_ID")
	oStructLotes:RemoveField("ZI4_PROD")
	oStructPallets:RemoveField("ZI3_ID")
	oStructPallets:RemoveField("ZI3_PROD")
	oStructNaoConf:RemoveField("ZI5_ID")
	oStructNaoConf:RemoveField("ZI5_PROD")
	oStructNaoConf:RemoveField("ZI5_PALLET")
	oStructDivergs:RemoveField("ZI6_ID")
	oStructDivergs:RemoveField("ZI6_PROD")

	oView:SetModel( oModel )

	oView:AddField('vINSPECAO', oStructInspecao, 'INSPECAO')
	oView:AddGrid ('vPRODUTOS', oStructProdutos, 'PRODUTOS')
	oView:AddGrid ('vLOTES'   , oStructLotes   , 'LOTES')
	oView:AddGrid ('vPALLETS' , oStructPallets , 'PALLETS')
	oView:AddGrid ('vNAOCONF' , oStructNaoConf , 'NAOCONF')
	oView:AddGrid ('vDIVERGS' , oStructDivergs , 'DIVERGS')

	//cria um painel com um memo
	oView:AddOtherObject('vOBSERV', {|panel| makeObservPanel(panel, oModel) } )
	//atualiza o memo conforme muda de linha
	oView:SetViewProperty('vPALLETS', 'CHANGELINE', {{ |oView, cViewID| omGetMM:refresh() } })

	oView:setContinuousForm(.T.)
	oView:CreateHorizontalBox('LINE01' , 24 )
	oView:CreateHorizontalBox('LINE02' , 24 )
	oView:CreateHorizontalBox('LINE03' , 24 )
	oView:CreateHorizontalBox('LINE04' , 24 )
	oView:CreateVerticalBox('LINE03COLUMN01' , 30 ,'LINE03' )
	oView:CreateVerticalBox('LINE03COLUMN02' , 70 ,'LINE03' )
	oView:CreateVerticalBox('LINE04COLUMN01' , 50 ,'LINE04' )
	oView:CreateVerticalBox('LINE04COLUMN02' , 25 ,'LINE04' )
	oView:CreateVerticalBox('LINE04COLUMN03' , 25 ,'LINE04' )

	oView:SetOwnerView( 'vINSPECAO','LINE01' )

	oView:SetOwnerView( 'vPRODUTOS' ,'LINE02' )
	oView:EnableTitleView('vPRODUTOS' , 'Produtos da nota fiscal de entrada' )

	oView:SetOwnerView( 'vLOTES' ,'LINE03COLUMN01' )
	oView:EnableTitleView('vLOTES' , 'Lotes do produto' )

	oView:SetOwnerView( 'vPALLETS' ,'LINE03COLUMN02' )
	oView:EnableTitleView('vPALLETS' , 'Pallets do produto' )

	oView:SetOwnerView( 'vDIVERGS' ,'LINE04COLUMN01' )
	oView:EnableTitleView('vDIVERGS' , 'Divergências do Produto' )

	oView:SetOwnerView( 'vNAOCONF' ,'LINE04COLUMN02' )
	oView:EnableTitleView('vNAOCONF' , 'Não conformidades do pallet' )

	oView:SetOwnerView( 'vOBSERV' ,'LINE04COLUMN03' )
	oView:EnableTitleView('vOBSERV' , 'Observação do pallet' )

	oView:SetViewCanActivate({ |view| viewCanActivate(view) })

return oView


static function viewCanActivate(oView)

	//se não for inclusão
	IF oView:getOperation() != MODEL_OPERATION_INSERT
		//só tem SIF para frigorifico
		IF ZI1->ZI1_TIPO != Left(FRIGORIFICO,1)
			oView:getViewStruct('LOTES'):RemoveField('ZI4_SIF')
			oView:getViewStruct('PALLETS'):RemoveField('ZI3_SIF')
		EndIF
		IF ZI1->ZI1_TIPO == Left(HORTIFRUTI,1)
			oView:getViewStruct('LOTES'):RemoveField('ZI4_LTEMB')
		EndIF
	EndIF

return .T.

/*/{Protheus.doc} makeObservPanel
Criação do Painel para mostrar a observação gravado num MEMO

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@param oPanel, object, Painel
@param oModel, object, Modelo MVC
@type function
/*/
static function makeObservPanel(oPanel, oModel)

	omGetMM := tMultiget():new( 15, 3, bSetGet(oModel:GetModel('PALLETS'):getValue('ZI3_OBSERV')),  oPanel, __DlgWidth(oPanel)-5, __DlgHeight(oPanel)-15, /*fonte*/, , , , , .T.,,,/*when*/,,,.T.,/*valid*/,,,/*border*/,.T.)

return


/*/{Protheus.doc} MenuDef
Definição das opções do Menu

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return array, Lista de opções

@type function
/*/
Static Function MenuDef()

	Local aRotina := {}
	Local aInspecoes := {}

	ADD OPTION aInspecoes Title "Frigorifico" Action 'u_MQIE100Fri' OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aInspecoes Title "Mercearia"   Action 'u_MQIE100Mer' OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aInspecoes Title "Hortifruti"  Action 'u_MQIE100Hor' OPERATION MODEL_OPERATION_INSERT ACCESS 0

	ADD OPTION aRotina Title "Visualizar"  Action 'VIEWDEF.MADERO_MQIE100' OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina Title "Inspecionar" Action aInspecoes               OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina Title "Continuar Inspeção"         Action "u_MQIE100Cont" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina Title "Liberar para Classificação" Action "u_MQIE100Lib"  OPERATION MODEL_OPERATION_VIEW ACCESS 0
	ADD OPTION aRotina Title "Excluir"     Action 'VIEWDEF.MADERO_MQIE100' OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina Title "Eventos"     Action 'u_MQIE100Evt' OPERATION MODEL_OPERATION_VIEW ACCESS 0
	ADD OPTION aRotina Title "Email"     Action 'u_MMteste' OPERATION MODEL_OPERATION_VIEW ACCESS 0

Return aRotina



/*/{Protheus.doc} MQIE100Cont
Função para coninuação de uma inspeção

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
user function MQIE100Cont()

	//posiciona na nota
	SF1->( dbSetOrder(1) )
	SF1->( dbSeek( xFilial("SF1") + ZI1->(ZI1_DOC+ZI1_SERIE+ZI1_FORN+ZI1_LOJA) ) )

	IF SF1->( Found() )

		IF ZI1->ZI1_TIPO == Left(FRIGORIFICO,1)
			return u_MQIE100Fri()
		EndIF

		IF ZI1->ZI1_TIPO == Left(MERCEARIA,1)
			return u_MQIE100Mer()
		EndIF

		IF ZI1->ZI1_TIPO == Left(HORTIFRUTI,1)
			return u_MQIE100Hor()
		EndIF

	EndIF

return


/*/{Protheus.doc} MQIE100Lib
Função para liberação da Inspeção para classificação

@author Rafael Ricardo Vieceli
@since 15/05/2018
@version 1.0

@type function
/*/
user function MQIE100Lib()

	//habilita apenas salvar (liberar) e cancelar
	Local aEnableButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Liberar para Classificação"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	//verifica se já foi encerrado
	IF ZI1->ZI1_STATUS $ "ER"
		Help("",1,"MADERO_PREINSP_ENCERRADA",,"A pré inspeção já foi encerrada.",4,1)
		return
	EndIF

	//abre tela para confirmação
	FWExecView("Liberar para Classificação","MADERO_MQIE100",MODEL_OPERATION_UPDATE,/*oDlg*/,/*bCloseOnOK*/,{|| validaLiberacao() },/*nPercReducao*/,aEnableButtons,/*bCancel*/,/*cOperatId*/,/*cToolBar*/, /*oModel*/)

return

user function MQIE100Evt()

	Local oModal
	Local oBrowse

	Local oMemo, oGrid, oGet

	oModal	:= FWDialogModal():New()
	oModal:SetEscClose(.T.)
	oModal:setTitle("Eventos da Inspeção " + ZI1->ZI1_ID)
	oModal:SetBackground(.T.)
	oModal:SetFreeArea(GetScreenRes()[1]/2*.9,GetScreenRes()[2]/2*.7)
	oModal:enableFormBar(.T.)
	oModal:createDialog()

    oMemo       := tPanel():New(01,01,,oModal:getPanelMain(),,,,,,100,60)
    oMemo:Align := CONTROL_ALIGN_BOTTOM

    oGrid       := tPanel():New(01,01,,oModal:getPanelMain(),,,,,,100,20)
    oGrid:Align := CONTROL_ALIGN_ALLCLIENT

	oGet := tMultiget():new( 15, 3, bSetGet(ZI7->ZI7_OBSERV),  oMemo, 5, 5, TFont():New('Arial',,-16), , , , , .T.,,,/*when*/,,,.T.,/*valid*/,,,/*border*/,.T.)
    oGet:Align := CONTROL_ALIGN_ALLCLIENT


    oBrowse := FWBrowse():New()
	oBrowse:SetDescription("")
	oBrowse:setOwner(oGrid)
	oBrowse:setDataTable()
	oBrowse:SetAlias("ZI7")
	oBrowse:setColumns({;
		column('ZI7_DATA') ,;
		column('ZI7_HORA') ,;
		column('ZI7_USER') ,;
		column('ZI7_NOME',,{|| UsrFullName(ZI7_USER) }) ,;
		column('ZI7_DATA') ,;
		column('ZI7_EVENTO') ;
	})
	oBrowse:setFilterDefault("ZI7->ZI7_FILIAL == '"+xFilial("ZI7")+"' .And. ZI7->ZI7_ID = '"+ZI1->ZI1_ID+"'")
	oBrowse:disableReport()
	oBrowse:disableConfig()
	oBrowse:disableFilter()
	oBrowse:setChange({|| oGet:refresh() })
	oBrowse:activate()

	oModal:addCloseButton()

	oModal:activate()


return


/*/{Protheus.doc} validaLiberacao
Validação da confirmação

@author Rafael Ricardo Vieceli
@since 15/05/2018
@version 1.0
@return logical, se confirmou a liberação

@type function
/*/
static function validaLiberacao()

	Local oView		:= FWViewActive()
	Local oModel    := oView:GetModel()

	//pede confirmação para o usuário
	IF APMsgYesNo("Após a classificação da pre nota de entrada, com uma inspeção não concluida, os itens que ainda não foram inspecionados não serão liberados do CQ automaticamente e não será feito analise de diferenças, pois é feito apenas na classificação. Continua?", "Liberação para classificação")

		//modifica o campo STATUS para Encerrado
		oModel:GetModel("INSPECAO"):loadValue("ZI1_STATUS","E")

		//muda estado da view e do modelo para modificado
		oView:lModify  := .T.
		oModel:lModify := .T.

		//e retorna true
		return .T.

	EndIF

return .F.


/*/{Protheus.doc} MQIE100Fri
Inspeção frigorifico para o Menu

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
user function MQIE100Fri()

	//seta a localização
	LOCATION := FRIGORIFICO

	//e chama função de inspeção
	MQIE100Insp()

return


/*/{Protheus.doc} MQIE100Hor
Inspeção Hortifruti para o Menu

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
user function MQIE100Hor()

	//seta a localização
	LOCATION := HORTIFRUTI

	//e chama função de inspeção
	MQIE100Insp()

return


/*/{Protheus.doc} MQIE100Mer
Inspeção Mercearia para o Menu

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
user function MQIE100Mer()

	//seta a localização
	LOCATION := MERCEARIA

	//e chama função de inspeção
	MQIE100Insp()

return


/*/{Protheus.doc} MQIE100Insp
Função para abrir tela de parametro recursivamente e chamando tela de inspeção

@author Rafael Ricardo Vieceli
@since 26/04/2018
@version 1.0

@type function
/*/
static function MQIE100Insp()

	//pre inspeção desativada
	IF ! u_MDRPreInsp()
		Help("",1,"MADERO_PREINSP_DESATIVADA",,"Não é possivel fazer a pré inspeção, pois está desativada nesta Filial. Ative com parametro MDR_PREINS.",4,1)
		return
	EndIF

	//se for continuação
	IF IsInCallStack('u_MQIE100Cont')

		//se tiver sido rejeitada totalmente
		IF ZI1->ZI1_STATUS == "R"
			Aviso('REJEITADO','Inspeção foi rejeitada totalmente, por isso não é possivel retomar a inspeção.',{'Sair'},1)
			return
		EndIF

		return Inspeciona()
	EndIF

	//a tela de parametro é recursiva
	While getPreNota()

		ZI1->( dbSetOrder(1) )
		ZI1->( dbSeek( xFilial("ZI1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

		IF ZI1->( Found() )
			IF Left(LOCATION,1) != ZI1->ZI1_TIPO
				Help("",1,"MADERO_PRE_INSP",,"Não é possivel continuar uma inspeção de "+LOCATION+", pois foi iniciada como "+getTipo(ZI1->ZI1_TIPO)+".",4,1)
				Loop
			EndIF
			IF Aviso('Atenção','Está nota já teve inspeção iniciada, deseja retomar a inspeção?',{'Continuar','Voltar'},1) != 1
				Loop
			EndIF

			//se tiver sido rejeitada totalmente
			IF ZI1->ZI1_STATUS == "R"
				Aviso('REJEITADO','Inspeção foi rejeitada totalmente, por isso não é possivel retomar a inspeção.',{'Sair'},1)
				Loop
			EndIF

		Else

			begin transaction

			Reclock("ZI1",.T.)
			ZI1->ZI1_FILIAL := xFilial("ZI1")
			ZI1->ZI1_DOC    := SF1->F1_DOC
			ZI1->ZI1_SERIE  := SF1->F1_SERIE
			ZI1->ZI1_FORN   := SF1->F1_FORNECE
			ZI1->ZI1_LOJA   := SF1->F1_LOJA
			ZI1->ZI1_DTINIC := Date()
			ZI1->ZI1_HRINIC := Left(Time(),5)
			ZI1->ZI1_INSP   := RetCodUsr()
			ZI1->ZI1_INSPN  := UsrFullName()
			ZI1->ZI1_ID     := GetSX8Num("ZI1","ZI1_ID")
			ZI1->ZI1_TIPO   := Left(LOCATION,1)
			ZI1->ZI1_STATUS := 'I' //Iniciado
			ZI1->( MsUnlock() )

			ConfirmSX8()

			event("Inspeção iniciada","Inspeção iniciada para nota " +SF1->(F1_FILIAL+"/"+F1_DOC+"/"+F1_SERIE+"/"+F1_FORNECE+"/"+F1_LOJA)+ " - RECNO " +cValToChar(SF1->(Recno()))+".")

			SD1->( dbSetOrder(1) )
			SD1->( dbSeek( xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

			While ! SD1->( Eof() ) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO)
				IF SD1->D1_PIPSTAT == 'S'

					ZI2->( dbSetOrder(1) )
					ZI2->( dbSeek( xFilial("ZI2") + ZI1->ZI1_ID + SD1->D1_COD ) )

					IF ZI2->( Found() )
						Reclock("ZI2",.F.)
						ZI2->ZI2_QUANT += SD1->D1_QUANT
						ZI2->( MsUnlock() )
						event("Somado produto","Item "+SD1->D1_ITEM+" - Produto " +alltrim(SB1->B1_COD)+ " com quantidade " + cValtoChar(SD1->D1_QUANT) + ".")
					Else
						SB1->( dbSetOrder(1) )
						SB1->( dbSeek( xFilial("SB1") + SD1->D1_COD ) )

						Reclock("ZI2",.T.)
						ZI2->ZI2_FILIAL := xFilial("ZI2")
						ZI2->ZI2_ID     := ZI1->ZI1_ID
						ZI2->ZI2_PROD   := SD1->D1_COD
						ZI2->ZI2_DESC   := SB1->B1_DESC
						ZI2->ZI2_UM     := SD1->D1_UM
						ZI2->ZI2_QUANT  := SD1->D1_QUANT
						ZI2->ZI2_STATUS := 'P' //Pendente
						ZI2->( MsUnlock() )
						event("Adicionado produto","Item "+SD1->D1_ITEM+" - Produto " +alltrim(SB1->B1_COD)+ " com quantidade " + cValtoChar(SD1->D1_QUANT) + ".")

					EndIF

				EndIF
				SD1->(dbSkip())
			EndDO

			IF ZI1->ZI1_ID != ZI2->ZI2_ID
				DisarmTransaction()
			EndIF

			end transaction
		EndIF

		//rotina de inspeção
		Inspeciona()

		//se foi chamada pela tela de administração
		IF FunName() == 'MQIE100'
			//não faz loop
			return
		EndIF
	EndDO

return



/*/{Protheus.doc} Inspeciona
Função principal para Inspeção

@author Rafael Ricardo Vieceli
@since 26/04/2018
@version 1.0

@type function
/*/
static function Inspeciona()

	Local oModal
	Local oLayer
	Local oBrowse

	Local nTamTop

	//fornecedor ou cliente
	Local cAliasEntity := IIF(SF1->F1_TIPO $ "DB","SA1","SA2")

	//posiciona (mesma chave)
	(cAliasEntity)->( dbSetOrder(1) )
	(cAliasEntity)->( dbSeek( xFilial(cAliasEntity) + SF1->F1_FORNECE + SF1->F1_LOJA ) )

	oModal := FWDialogModal():New()

	oModal:SetEscClose(.T.)
	oModal:enableAllClient()
	oModal:SetTitle("MADERO  -  Recebimento de Mercadorias  -  " + LOCATION)
	oModal:CreateDialog()
	oModal:createFormBar()

	//calculo para fixar o tamanho do cabeçalho
	nTamTop := int( 80 / oModal:nFreeHeight * 100)

	oLayer := FWLayer():New()
	oLayer:Init( oModal:getPanelMain(), .F.)

	//divide a tela horizontalmente, 20% encima, 80% embaixo
	oLayer:AddLine('cabecalho'  ,nTamTop,.F.)
	oLayer:AddLine('itens',100-nTamTop,.F.)

	//depois divide a parte de cima verticalmente, meio a meio
	oLayer:addCollumn( "esquerda" , 50, .F.,"cabecalho" )
	oLayer:addCollumn( "direita", 50, .F.,"cabecalho" )

	//fornecedor/cliente
	TGet():New(10, 10, bSetGet(SF1->F1_FORNECE) ,oLayer:GetColPanel('esquerda','cabecalho'), 60, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SF1->F1_FORNECE' ,,,,,,,IIF(cAliasEntity=='SA1',"Cliente","Fornecedor"),1)
	TGet():New(10, 80, bSetGet(SF1->F1_LOJA)    ,oLayer:GetColPanel('esquerda','cabecalho'), 30, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SF1->F1_LOJA'    ,,,,,,,'Loja',1)
	IF cAliasEntity=='SA1'
		TGet():New(10,120, bSetGet(SA1->A1_NOME),oLayer:GetColPanel('esquerda','cabecalho'),160, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SA1->A1_NOME',,,,,,,'Nome',1)
	Else
		TGet():New(10,120, bSetGet(SA2->A2_NOME),oLayer:GetColPanel('esquerda','cabecalho'),160, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SA2->A2_NOME',,,,,,,'Nome',1)
	EndIF
	//inspetor
	TGet():New(45, 10, bSetGet(RetCodUsr())  ,oLayer:GetColPanel('esquerda','cabecalho'), 60, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'RetCodUsr()' ,,,,,,,"Inspetor",1)
	TGet():New(45, 80, bSetGet(UsrFullName()),oLayer:GetColPanel('esquerda','cabecalho'),160, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'UsrFullName()',,,,,,,'Nome',1)

	//dados da nota fiscal
	TGet():New(10,10, bSetGet(SF1->F1_CHVNFE) ,oLayer:GetColPanel('direita','cabecalho') ,150, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SF1->F1_CHVNFE' ,,,,,,,'Chave da NFe SEFAZ',1)
	//segunda linha
	TGet():New(45, 10, bSetGet(SF1->F1_DOC)    ,oLayer:GetColPanel('direita','cabecalho') , 60, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SF1->F1_DOC'    ,,,,,,,'Número',1)
	TGet():New(45, 80, bSetGet(SF1->F1_SERIE)  ,oLayer:GetColPanel('direita','cabecalho') , 30, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SF1->F1_SERIE'  ,,,,,,,'Série',1)
	TGet():New(45,120, bSetGet(SF1->F1_EMISSAO),oLayer:GetColPanel('direita','cabecalho') , 60, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'SF1->F1_EMISSAO',,,,,,,'Emissão',1)

	oBrowse := FWBROWSE():New()
	oBrowse:SetOwner( oLayer:GetLinePanel('itens') )
	oBrowse:SetDataTable()
	oBrowse:setAlias("ZI2")
	oBrowse:DisableReport()
	oBrowse:setFilterDefault("ZI2->ZI2_FILIAL == '"+xFilial("ZI1")+"' .And. ZI2->ZI2_ID == '"+ZI1->ZI1_ID+"'")
	oBrowse:SetDoubleClick( { || InspItem() } )
	oBrowse:addLegend('ZI2_STATUS == "P"', 'PENDENTE', 'Pré inspeção não iniciada')
	oBrowse:addLegend('ZI2_STATUS == "I"', 'QADIMG16', 'Pré Inspeção em andamento')
	oBrowse:addLegend('ZI2_STATUS == "C"', 'QIEIMG16', 'Pré Inspeção concluída')
	oBrowse:SetColumns({;
		column("ZI2_STATUS") ,;
		column("ZI2_PROD") ,;
		column("ZI2_DESC") ,;
		column("ZI2_UM") ,;
		column("ZI2_QUANT"),;
		column("ZI2_INSP"),;
		column("ZI2_INSP","Diferença",{|| ZI2_INSP - ZI2_QUANT }) })

	oBrowse:Activate()

	oModal:addButtons({{"", "Fechar"       , {|| oModal:Deactivate() }, "Clique aqui para Enviar",,.T.,.T.}})
	oModal:addButtons({{"", "Inspecionar"  , {|| InspItem(), oBrowse:Refresh(.F.) }, "Clique aqui para Enviar",,.T.,.T.}})
	oModal:addButtons({{"", "Refresh"      , {|| oBrowse:Refresh(.T.) }, "Clique aqui para Enviar",,.T.,.T.}})

	IF ! InspIniciada()
		oModal:addButtons({{"", "Rejeição Total"  , {|| IIF( RejeicaoTotal(), oModal:Deactivate(), oBrowse:Refresh(.F.) ) }, "Clique aqui para Enviar",,.T.,.T.}})
	EndIF

	oModal:activate()

return


/*/{Protheus.doc} InspItem
Inspeção por produto

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@type function
/*/
static function InspItem()

	Local oModal
	Local oLayer

	Local winProd

	Local nTamProd
	Local nTamLote := 0

	Local lTelaLote

	IF ZI2->ZI2_STATUS == "C"
		IF ZI1->ZI1_STATUS == "I" .And. empty(SF1->F1_STATUS)
			IF Aviso('Concluida','A Pré Inspeção deste item já foi concluída. Deseja retomar?',{'Sim','Sair'},1) == 2
				return
			EndIF
			Reclock("ZI2",.F.)
			ZI2->ZI2_STATUS := "I"
			ZI2->( MsUnlock() )
		Else
			Help("",1,"PRE-INSP_OK",,"A Pré Inspeção deste item já foi concluída.",4,1)
			return
		EndIF
	EndIF

	Private cSIF      := CriaVar('ZI3_SIF')
	Private dValidade := StoD('')
	Private cLote     := CriaVar('ZI4_LTEMB')

	Private cID      := ZI2->ZI2_ID
	Private cProduto := ZI2->ZI2_PROD

	//frigorifico é por QUILO, SEMPRE!
	//mercearia e hortifruti, nem sempre
	Private lPesagem := (LOCATION == FRIGORIFICO .Or. ZI2->ZI2_UM == "KG")

	lLoteOK := (LOCATION != FRIGORIFICO)

	//inicia json com variaveis estaticas
	aGets := JsonObject():new()

	//posiciona no produto
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial("SB1") + cProduto ) )

	//box com o LOTE só tem para frigorifico para mercearia quando o produto controla Lote
	lTelaLote := (LOCATION == FRIGORIFICO .Or. LOCATION == MERCEARIA .And. Rastro(SB1->B1_COD))

	oModal := FWDialogModal():New()
	oModal:SetEscClose(.F.)
	oModal:SetTitle("MADERO  -  Recebimento de Mercadorias  -  " + LOCATION + "  -   " + SB1->B1_DESC)
	oModal:enableAllClient()
	oModal:CreateDialog()
	oModal:createFormBar()

	//calculo para fixar o tamanho do cabeçalho
	nTamProd := int( 55 / oModal:nFreeHeight * 100)

	oLayer := FWLayer():New()
	oLayer:Init( oModal:getPanelMain(), .F.)

	//divide a tela horizontalmente, 20% encima, 80% embaixo
	oLayer:AddLine('cabecalho',nTamProd,.F.)
	oLayer:AddLine('resto'  ,100-nTamProd,.F.)

	oLayer:addCollumn('produto' ,100,.F., 'cabecalho')
	IF lTelaLote
		nTamLote := int( 250 / oModal:nFreeWidth * 100)
		oLayer:addCollumn('lote'    , nTamLote,.F., 'resto')
	EndIF
	oLayer:addCollumn('pallet'  , 100-nTamLote,.F., 'resto')

	//cria uma janela
	oLayer:addWindow( 'produto', "winProd","Inspeção do produto", 100, .F., .T., {||  }, 'cabecalho')
	//e pega o panel do janela
	winProd := oLayer:getWinPanel('produto',"winProd",'cabecalho')

	//produto
	TGet():New(0,  5, bSetGet(ZI2->ZI2_PROD)  , winProd ,  75, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'ZI2->ZI2_PROD'  ,,,,,,,'Produto',1)
	TGet():New(0, 90, bSetGet(ZI2->ZI2_DESC)  , winProd , 150, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'ZI2->ZI2_DESC'  ,,,,,,,'Descrição',1)
	TGet():New(0,250, bSetGet(ZI2->ZI2_UM)    , winProd ,  20, 16, "",,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'ZI2->ZI2_UM'    ,,,,,,,"Unidade",1)
	TGet():New(0,280, bSetGet(ZI2->ZI2_QUANT) , winProd ,  80, 16, PesqPict("ZI2","ZI2_QUANT"),,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'ZI2->ZI2_QUANT' ,,,,,,,'Quantidade',1)
	TGet():New(0,370, bSetGet(ZI2->ZI2_INSP)  , winProd ,  80, 16, PesqPict("ZI2","ZI2_INSP" ),,,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'ZI2->ZI2_INSP'  ,,,,,,,'Inspecionada',1)

	//frigorifico
	IF lTelaLote
		//cria uma janela com titulo
		oLayer:addWindow( 'lote', "winLote","Lotes/Embarques", 100, .F., .T., {||  }, 'resto' )

		//SIF
		telaLotes(oLayer:getWinPanel('lote',"winLote",'resto') )
	EndIF

	//cria uma janela com titulo
	oLayer:addWindow( 'pallet', "winPallet","Pallets", 100, .F., .T., {||  }, 'resto' )

	telaPallet(oLayer:getWinPanel('pallet',"winPallet",'resto'))

	oModal:addButtons({{"", "Fechar", {|| oModal:Deactivate() }, "Clique aqui para Enviar",,.T.,.T.}})
	oModal:addButtons({{"", "Encerrar Produto", {|| IIF(EncerrarProduto(),oModal:Deactivate(),) }, "Clique aqui para Enviar",,.T.,.T.}})

	IF LOCATION == FRIGORIFICO
		oModal:addButtons({{"", "Próximo S.I.F.", {|| NextSIF() }, "Clique aqui para Enviar",,.T.,.T.}})
	EndIF

	oModal:activate()

	//libera memoria
	FreeObj(aGets)

return


/*/{Protheus.doc} EncerrarProduto
Encerramento da inspeção do produto

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, se encerrou para fechar a tela de inspeção

@type function
/*/
static function EncerrarProduto()

	Local lTotal := .F.

	//pega diferença entre a nota e a inspeção
	Local nDiferenca := ZI2->(ZI2_INSP-ZI2_QUANT)

	IF lLoteOK
		//precisa ter pallets num SIF
		ZI3->( dbSetOrder(1) )
		ZI3->( dbSeek( xFilial("ZI3") + cID + cProduto + cSIF ) )

		IF ! ZI3->( Found() )
			Help("",1,"PRE-INSP_SIF",,"Para encerrar um SIF precisa ao menos um pallets pesado.",4,1)
			return .F.
		EndIF
	EndIF

	//verifica se há diferença
	IF nDiferenca != 0
		IF Aviso("Diferença","Há diferença ("+IIF(nDiferenca>0,"Excedente","Falta")+") de " + cValToChar(nDiferenca) + " "+ZI2->ZI2_UM+". Deseja continuar",{"Voltar","Continuar"}) == 1
			return .F.
		EndIF
	//se não houver diferença
	Else
		//pergunta para confirmar
		IF Aviso("Confirma","Continuar encerramento da Inspeção do Item "+alltrim(ZI2->ZI2_DESC)+" ?",{"Voltar","Continuar"}) == 1
			return .F.
		EndIF
	EndIF

	begin transaction

		Reclock("ZI2",.F.)
		ZI2->ZI2_STATUS := "C"
		ZI2->( MsUnlock() )

		event("Encerrado produto","Inspeção do produto "+alltrim(cProduto)+" foi encerrada.")

		IF ZI1->ZI1_STATUS != "E"
			//verifica se encerra a inspeção totalmente
			lTotal := EncerrarInspecao(ZI2->(Recno()))
		EndIF
	end transaction

	//da mensagem fora da transação para não bloquear registro da SF1
	IF lTotal
		Aviso("Inspeção","A Inspeção foi concluida totalmente.",{"Ok"})
	EndIF

return .T.


/*/{Protheus.doc} EncerrarInspecao
Função para verificar e encerrar a inspeção

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, se é encerrament total
@param nDesconsiderar, numeric, desconsidera o produto encerrado, pois esta dentro da transação
@type function
/*/
static function EncerrarInspecao(nDesconsiderar)

	Local cAlias := getNextAlias()
	Local lTotal := .F.

	BeginSQL Alias cAlias
		select
			count(1) as NCOUNT
		from
			%table:ZI2%
		where
			ZI2_FILIAL  = %xFilial:ZI2%
		and ZI2_ID      = %Exp: cID %
		and ZI2_STATUS <> 'C' //não concluidos
		and R_E_C_N_O_ <> %Exp: nDesconsiderar % //descondira o item encerrado
		and D_E_L_E_T_  = ' '
	EndSQL

	IF ( lTotal := (cAlias)->NCOUNT == 0)

		//marca a inspeção com encerrada
		Reclock("ZI1",.F.)
		ZI1->ZI1_STATUS := "E" //encerrado
		ZI1->( MsUnlock() )

		//e a prenota como OK
		Reclock("SF1",.F.)
		SF1->F1_PIPSTAT := "L"
		SF1->( MsUnlock() )

		event("Inspeção encerrada normalmente","Inspeção encerrada totalmente por processo Normal")
	EndIF

	(cAlias)->( dbCloseArea() )

return lTotal


/*/{Protheus.doc} NextSIF
função para atualiza tela para proximo SIF (agrupar de lotes)

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
static function NextSIF()

	//se não tem um SIF validado, não pode encerrar
	IF ! lLoteOK
		return
	EndIF

	//precisa ter pallets num SIF
	ZI3->( dbSetOrder(1) )
	ZI3->( dbSeek( xFilial("ZI3") + cID + cProduto + cSIF ) )

	IF ! ZI3->( Found() )
		Help("",1,"PRE-INSP_SIF",,"Para encerrar um SIF precisa ao menos um pallets pesado.",4,1)
		return
	EndIF

	//limpa variaveis para lote
	cSIF      := CriaVar('ZI3_SIF')
	dValidade := StoD('')
	cLote     := CriaVar('ZI4_LTEMB')

	//abre campos de lote e fecha de pesagem
	lLoteOK := .F.

	//atualiza os browse
	bpRefresh()
	blRefresh()
	//e totais
	totals()

	//e foco no campo SIF
	aGets['SIF']:setFocus()

return


/*/{Protheus.doc} telaPallet
função para montem da tela de pallets

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@param oPanel, object, painel onde sera montado
@type function
/*/
static function telaPallet(oPanel)

	//calculo para fixar o tamanho do cabeçalho
	Local nTamFormTara  := int( 70 / oPanel:nHeight * 100)
	Local nTamFormPesag	:= int( 70 / oPanel:nHeight * 100)
	Local nTamTot   	:= int( 55 / oPanel:nHeight * 100)
	Local nTamValid 	:= 0

	Local oLayer := FWLayer():New()

	Local nTaraPallet    := 0 //ZI3_TARAPL
	Local nTaraEmbalagem := 0 //ZI3_TARAEB
	Local nQuantCaixas   := 0 //ZI3_QTDCX
	Local nPesoBruto     := 0 //ZI3_PESOB
	Local nPesoLiquido   := 0 //ZI3_QUANT

	Local nQuant:= 0, nQuant2:=0, nQuantFor:=0

	//validade para Hortifruti divide com campos da pesagem
	Local lValidade :=  (LOCATION == HORTIFRUTI .And. Rastro(SB1->B1_COD))

	//MDR_BALFRI, MDR_BALHOR, MDR_BALMER
	Local lAtivaEdicao := SuperGetMV("MDR_BAL"+SubStr(LOCATION,1,3),,.F.)

	IF lValidade
		nTamValid := int( 320 / oPanel:nWidth * 100)
	EndIF

	oLayer:init( oPanel, .T. )

	oLayer:addLine( 'formtara', nTamFormTara )
	oLayer:addCollumn( "tara" , 100, .F.,"formtara" )
	oLayer:addLine( 'formpesag', nTamFormPesag )
	oLayer:addCollumn( "validade" , nTamValid, .F.,"formpesag" )
	oLayer:addCollumn( "pesagem", 100-nTamValid, .F.,"formpesag" )
	oLayer:addLine( 'grid', 100-nTamFormTara-nTamFormPesag-nTamTot )
	oLayer:addLine( 'total', nTamTot )


	//apenas para hortifruti
	IF lValidade
		//procura por um Lote, para achar a validade do produto
		ZI4->( dbSetOrder(1) )
		ZI4->( dbSeek( xFilial("ZI4") + cID + cProduto ) )

		//se achar
		IF (lLoteOK := ZI4->( Found() ))
			//assume a validade já digitada
			dValidade := ZI4->ZI4_VALID
		//se não achar e tiver prazo cadastrado no produto
		ElseIF SB1->B1_PRVALID > 0
			//preenche o campos com o prazo de validade padrão
			dValidade := date() + SB1->B1_PRVALID
		EndIF

		TGet():New(0,5, bSetGet(dValidade), oLayer:GetColPanel('validade','formpesag') ,  65, 16, "",{|| .T. },,,,.F.,,.T.,,.F.,{|| ! lLoteOK },.F.,.F.,,.F.,.F.,,'dValidade'  ,,,,,,,'Validade',1)
		TButton():New( 7.5, 80, "Confirmar", oLayer:GetColPanel('validade','formpesag'), {|| validAndStoreLote() }, 50,18,,/*oFont*/,.T.,.T.,.F.,,.F.,{|| ! lLoteOK },,.F. )
	EndIF

	//peso (unidade KG ou Frigrifico)
	IF lPesagem
		aGets['TARAP'] := TGet():New(0,  5, bSetGet(nTaraPallet)   , oLayer:GetColPanel('tara','formtara') ,  50, 16, getMask("ZI3_TARAPL"), {|| calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido) },,,,.F.,,.T.,,.F.,{|| lLoteOK },.F.,.F.,,.F.,.F.,,'nTaraPallet'   ,,,,,,,'TARA Pallet',1)
		TBtnBmp2():New( 15,110,36,36,'balanca',,,,{|| IIF(callBalance(@nTaraPallet),calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido),) },oLayer:GetColPanel('tara','formtara'),"Tara do Pallet",/*when*/,.F.,.F.)
		aGets['TARAE'] := TGet():New(0, 75, bSetGet(nTaraEmbalagem), oLayer:GetColPanel('tara','formtara') ,  50, 16, getMask("ZI3_TARAEB"), {|| calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido) },,,,.F.,,.T.,,.F.,{|| lLoteOK },.F.,.F.,,.F.,.F.,,'nTaraEmbalagem',,,,,,,'TARA Média Embs.',1)
		aGets['QTDCX'] := TGet():New(0,135, bSetGet(nQuantCaixas)  , oLayer:GetColPanel('tara','formtara') ,  25, 16, getMask("ZI3_QTDCX") , {|| calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido) },,,,.F.,,.T.,,.F.,{|| lLoteOK },.F.,.F.,,.F.,.F.,,'nQuantCaixas'  ,,,,,,,'Qtd. Cxs',1)
		aGets['PESOB'] := TGet():New(0,5, bSetGet(nPesoBruto)    , oLayer:GetColPanel('pesagem','formpesag') ,  50, 16, getMask("ZI3_PESOB") , {|| calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido) },,,,.F.,,.T.,,.F.,{|| lLoteOK },.F.,.F.,,.F.,.F.,,'nPesoBruto'    ,,,,,,,'Peso Bruto',1)
		//TBtnBmp2():New( 15,440,36,36,'balanca',,,,{|| IIF(callBalance(@nPesoBruto),calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido),) },oLayer:GetColPanel('pesagem','formpesag'),"Tara do Pallet",/*when*/,.F.,.F.)
		TBtnBmp2():New( 15,110,36,36,'balanca',,,,{|| IIF(callBalance(@nTaraPallet),calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido),) },oLayer:GetColPanel('pesagem','formpesag'),"Tara do Pallet",/*when*/,.F.,.F.)
		aGets['PESOL'] := TGet():New(0,75, bSetGet(nPesoLiquido)  , oLayer:GetColPanel('pesagem','formpesag') ,  50, 16, getMask("ZI3_QUANT") , {|| calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, @nPesoLiquido) },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'nPesoLiquido'  ,,,,,,,'Peso Liquido',1)

		TButton():New( 7, 135, "Confirmar", oLayer:GetColPanel('pesagem','formpesag'), {|| gravaPallet(@nTaraPallet, @nTaraEmbalagem, @nQuantCaixas, @nPesoBruto, @nPesoLiquido) }, 50,18,,/*oFont*/,.T.,.T.,.F.,,.F.,{|| lLoteOK },,.F. )
	//outra unidade qualquer (inclusivo grama ou tonelada)

	Else
		nLeft:=5
		DBSelectArea('SA5')  //Produto x Fornecedor
		DBSelectArea('SAH')  //Unidade de Medidas

		SA5->(DBSetOrder(1)) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
		SAH->(DBSetOrder(1)) //AH_FILIAL+AH_UNIMED

		if SAH->(DBSeek(xFilial('SAH')+SB1->B1_UM))
			aGets['UNIDADE']:= TGet():New(0 , nLeft, bSetGet(nQuant), oLayer:GetColPanel('pesagem','formpesag') ,  50, 16, getMask("ZI3_QUANT"), {|| xconvUM('UNIDADE',@nQuant,@nQuant2,@nQuantFor) },,,,.F.,,.T.,,.F.,{|| lLoteOK .and. xconvUM('UNIDADE',@nQuant,@nQuant2,@nQuantFor) },.F.,.F.,,.F.,.F.,,'nQuant',,,,,,,'Qtde em '+Alltrim(SAH->AH_UMRES),1)
			nLeft+=60
		endif

		if SAH->(DBSeek(xFilial('SAH')+SB1->B1_SEGUM))
			aGets['UN2']    := TGet():New(0, nLeft, bSetGet(nQuant2), oLayer:GetColPanel('pesagem','formpesag') ,  50, 16, getMask("ZI3_QUANT"), {||  xconvUM('UN2',@nQuant,@nQuant2,@nQuantFor)  },,,,.F.,,.T.,,.F.,{|| lLoteOK .and. xconvUM('UNIDADE',@nQuant,@nQuant2,@nQuantFor)},.F.,.F.,,.F.,.F.,,'nQuant2'     ,,,,,,,'Qtde em '+Alltrim(SAH->AH_UMRES),1)
			nLeft+=60
		endif

        if SA5->( dbSeek( xFilial("SA5") + SF1->F1_FORNECE + SF1->F1_LOJA + SB1->B1_COD ))
	        if SAH->(DBSeek(xFilial('SAH')+SA5->A5_UNID))
	        	aGets['UNFOR']  := TGet():New(0, nLeft, bSetGet(nQuantFor) , oLayer:GetColPanel('pesagem','formpesag') ,  50, 16, getMask("ZI3_QUANT"), {|| xconvUM('UNFOR',@nQuant,@nQuant2,@nQuantFor)  },,,,.F.,,.T.,,.F.,{|| lLoteOK .and. xconvUM('UNIDADE',@nQuant,@nQuant2,@nQuantFor) },.F.,.F.,,.F.,.F.,,'nQuantFor'  ,,,,,,,'Qtde em '+Alltrim(SAH->AH_UMRES),1)
				nLeft+=60
			endif
		endif

		TButton():New( 7, nLeft, "Confirmar", oLayer:GetColPanel('pesagem','formpesag'), {|| gravaPallet(,,,,,@nQuant) }, 50,18,,/*oFont*/,.T.,.T.,.F.,,.F.,{|| lLoteOK },,.F. )
	EndIF

	aGets['brwPallets'] := FWBROWSE():New()
	aGets['brwPallets']:SetOwner( oLayer:GetLinePanel('grid') )
	aGets['brwPallets']:SetDataTable()
	aGets['brwPallets']:setAlias("ZI3")
	aGets['brwPallets']:DisableReport()
	aGets['brwPallets']:setFilterDefault("ZI3->ZI3_FILIAL == '"+xFilial("ZI3")+"' .And. ZI3->ZI3_ID == '" + cID + "' .And. ZI3->ZI3_PROD == '" + cProduto + "' .And. ZI3->ZI3_SIF == '" + cSIF + "'")
//	aGets['brwPallets']:AddStatusColumns({|| "br_cancel" }, {|| delPallet(aGets['brwPallets']) })
	aGets['brwPallets']:SetColumns({;
		column("ZI3_PALLET") ,;
		column("ZI3_QUANT",IIF(lPesagem,"Peso Liquido","Quantidade")) ,;
		column("ZI3_CONDIC") })
	aGets['brwPallets']:SetTotalDefault('ZI3_FILIAL','COUNT','Lotes')
	aGets['brwPallets']:Activate()

	//totalizadores
	TGet():New(5, 05, bSetGet(aGets['TOT_PROD']) , oLayer:getLinePanel('total') ,  50, 10, getMask("ZI2_QUANT"), {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,,,,,,,,'Total do Produto ',1)
	TGet():New(5,105, bSetGet(aGets['TOT_SALDO']), oLayer:getLinePanel('total') ,  50, 10, getMask("ZI2_QUANT"), {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,,,,,,,,'Saldo do Produto ',1)

	IF LOCATION == FRIGORIFICO
		TGet():New(5,205, bSetGet(aGets['TOT_SIF'])  , oLayer:getLinePanel('total') ,  50, 10, getMask("ZI2_QUANT"), {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,,,,,,,,'Total do SIF ',1)
	EndIF

	//inicializa os totalizadores
	totals()

return


/*--------------------------------------------------------------------------+
|  xconvUM - Converte as Unidades de Medidas                                 |
----------------------------------------------------------------------------*/
static function xconvUM(cField,nQuant,nQuant2,nQuantFor)
	Local lRet:=.F.

	DO CASE
		CASE cField=='UNIDADE'
			IF SB1->B1_TIPCONV=='M'
				nQuant2:=nQuant*SB1->B1_CONV
			else
				nQuant2:=nQuant/SB1->B1_CONV
			endif

			if SA5->A5_XTPCUNF=='M' //M=Multiplicador;D=Divisor
				nQuantFor:=nQuant*SA5->A5_XCVUNF	//Fator de Conversão
			else
				nQuantFor:=nQuant/SA5->A5_XCVUNF //Fator de Conversão
			endif
			lRet:= Positivo(nQuant)
		CASE cField=='UN2'
			IF SB1->B1_TIPCONV=='M'
				nQuant:=nQuant2/SB1->B1_CONV
			else
				nQuant:=nQuant2*SB1->B1_CONV
			endif

			if SA5->A5_XTPCUNF=='M' //M=Multiplicador;D=Divisor
				nQuantFor:=nQuant*SA5->A5_XCVUNF	//Fator de Conversão
			else
				nQuantFor:=nQuant/SA5->A5_XCVUNF //Fator de Conversão
			endif

		    lRet:= Positivo(nQuant2)
		CASE cField=='UNFOR'
			if SA5->A5_XTPCUNF=='M' //M=Multiplicador;D=Divisor
				nQuant:=nQuantFor/SA5->A5_XCVUNF	//Fator de Conversão
			else
				nQuant:=nQuantFor*SA5->A5_XCVUNF //Fator de Conversão
			endif

			IF SB1->B1_TIPCONV=='M'
				nQuant2:=nQuant*SB1->B1_CONV
			else
				nQuant2:=nQuant/SB1->B1_CONV
			endif

		    lRet:= Positivo(nQuantFor)
	ENDCASE
return lRet

static function callBalance(nPeso)

	Local aPeso := u_ToledoGet()

	IF aPeso[1]
		nPeso := aPeso[2]
	EndIF

return aPeso[1]


/*/{Protheus.doc} gravaPallet
função para gravação do pallet

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@param nTaraPallet, numeric, Tara pallet (pesagem)
@param nTaraEmbalagem, numeric, Tara embalagens (pesagem)
@param nQuantCaixas, numeric, Quantidade de embalagens (pesagem)
@param nPesoBruto, numeric, Peso Bruto (pesagem)
@param nPesoLiquido, numeric, Peso Liquido (pesagem)
@param nQuant, numeric, Quantiadde (unidade)
@type function
/*/
static function gravaPallet(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, nPesoLiquido, nQuant)

	Local cCondicao := ''
	Local cObservacao := ''
	Local aNC := {}

	Local nNC

	Local cPallet

	Local newRecno, saveArea

	//peso liquido zerado
	IF lPesagem .And. nPesoLiquido <= 0
		return
	EndIF

	//quantidade zerado
	IF ! lPesagem .And. nQuant <= 0
		return
	EndIF

	IF confirmaPallet(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, nPesoLiquido, nQuant, @cCondicao, @cObservacao, @aNC)

		//nova numeração de pallet
		cPallet := makeNewPallet()

		begin transaction

			Reclock("ZI3",.T.)
			ZI3->ZI3_FILIAL := xFilial("ZI3")
			ZI3->ZI3_ID     := cID
			ZI3->ZI3_PROD   := cProduto
			ZI3->ZI3_PALLET := cPallet
			ZI3->ZI3_SIF    := cSIF
			ZI3->ZI3_CONDIC := cCondicao
			ZI3->ZI3_OBSERV := cObservacao
			IF lPesagem
				ZI3->ZI3_QUANT  := nPesoLiquido
				ZI3->ZI3_TARAPL := nTaraPallet
				ZI3->ZI3_TARAEB := nTaraEmbalagem
				ZI3->ZI3_QTDCX  := nQuantCaixas
				ZI3->ZI3_PESOB  := nPesoBruto
			else
				ZI3->ZI3_QUANT  := nQuant
			EndIF
			//aguardando classificação
			ZI3->ZI3_STATUS := "AC"
			ZI3->( MsUnlock() )

			newRecno := ZI3->( Recno() )

			Reclock("ZI2",.F.)
			ZI2->ZI2_INSP   += ZI3->ZI3_QUANT
			ZI2->ZI2_STATUS := 'I' //Inspecionando
			ZI2->( MsUnlock() )

			For nNC := 1 to len(aNC)

				SAG->( dbSetOrder(1) )
				SAG->( dbSeek( xFilial("SAG") + aNC[nNC] ) )

				Reclock("ZI5",.T.)
				ZI5->ZI5_FILIAL := xFilial("ZI5")
				ZI5->ZI5_ID     := ZI3->ZI3_ID
				ZI5->ZI5_PROD   := ZI3->ZI3_PROD
				ZI5->ZI5_PALLET := ZI3->ZI3_PALLET
				ZI5->ZI5_CODNC  := SAG->AG_NAOCON
				ZI5->ZI5_DESCNC := SAG->AG_DESCPO
				ZI5->( MsUnlock() )

			Next nNC

		end transaction

		//atualiza grid de pallets
		aGets['brwPallets']:Refresh(.T.)
		//aGets['brwPallets']:GoBottom()
		aGets['brwPallets']:goTo( newRecno, .T. )

		//atualiza os totalizadores
		totals()

		IF lPesagem
			//zera os valores
			nTaraPallet := nTaraEmbalagem := nQuantCaixas := nPesoBruto := nPesoLiquido := 0
			//e posiciona no campo TARA Pallet
			aGets['TARAP']:setFocus()
		Else
			nQuant := 0
			aGets['UNIDADE']:setFocus()
		EndIF

        saveArea := saveAreas({'ZI1','ZI2','ZI3','ZI4','SA2','SB1'})
        // Impressão da Etiqueta Recebimento
		U_ETQ013(cID)
		restoreAreas(saveArea)

	EndIF

return

static function saveAreas(aAreas)
	Local nArea
	Local aSaves := {}
	For nArea := 1 to len(aAreas)
		aAdd( aSaves, { aAreas[nArea], ;
		  (aAreas[nArea])->( IndexOrd() ) , ;
		  (aAreas[nArea])->( Recno() ) } )
	Next
return aSaves

static function restoreAreas(aRestore)
	Local nArea
	For nArea := 1 to len(aRestore)
		(aRestore[nArea][1])->( dbSetOrder( aRestore[nArea][2] ) )
		(aRestore[nArea][1])->( dbGoTo( aRestore[nArea][3] ) )
	Next
return


/*/{Protheus.doc} confirmaPallet
Cria tela para confirmação do pallet, com as informações digitadas e aprovação/rejeição

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, validação da tela
@param nTaraPallet, numeric, Tara pallet (pesagem)
@param nTaraEmbalagem, numeric, Tara embalagens (pesagem)
@param nQuantCaixas, numeric, Quantidade de embalagens (pesagem)
@param nPesoBruto, numeric, Peso Bruto (pesagem)
@param nPesoLiquido, numeric, Peso Liquido (pesagem)
@param nQuant, numeric, Quantiadde (unidade)
@param cCondicao, characters, @Condição do Pallet (sera informado aqui)
@param cObserv, characters, @Observação (sera informado aqui)
@param aNC, array, Não conformidades (sera informado aqui)
@type function
/*/
static function confirmaPallet(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, nPesoLiquido, nQuant, cCondicao, cObserv, aNC, lRejeicaoTotal)

	Local lContinue := .F.
	Local aMarkNC := {}
	Local oModal
	Local oLayer, oPanel, oBrowse
	Local nCondicao  := 1
	Local aCondicao := {'Aprovado','Reprovado','Quarentena'}
	Local cObservacao := ''

	Default lRejeicaoTotal := .F.

	oModal	:= FWDialogModal():New()
	oModal:SetEscClose(.T.)
	oModal:setTitle("Confirmação do pallet")
	oModal:setSize(250, 300)
	oModal:enableFormBar(.T.)
	oModal:createDialog()


	oLayer := FWLayer():New()

	oLayer:init( oModal:getPanelMain(), .T. )

	IF lRejeicaoTotal

		oLayer:addLine( 'mensagem'  , 10 )
		oLayer:addLine( 'observacao', 30 )
		oLayer:addLine( 'naoConf'   , 60 )

		TSay():New(5,5,{|| "<b>Confirma a rejeição total da Nota?</b>"},oLayer:getLinePanel('mensagem'),,TFont():New(,,-14),,,,.T.,,,240,9,,,,,,.T.)

		//rejeitado
		nCondicao := 2
	Else
		oLayer:addLine( 'mensagem'  , 10 )
		oLayer:addLine( 'pesos'     , 15 )
		oLayer:addLine( 'condicao'  , 15 )
		oLayer:addLine( 'observacao', 20 )
		oLayer:addLine( 'naoConf'   , 40 )

		TSay():New(5,5,{|| "<b>Confirma a gravação do Pallet?</b>"},oLayer:getLinePanel('mensagem'),,TFont():New(,,-14),,,,.T.,,,240,9,,,,,,.T.)

		IF lPesagem
			TGet():New(0,  5, bSetGet(nTaraPallet)   , oLayer:getLinePanel('pesos') ,  50, 16, getMask("ZI3_TARAPL"), {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'nTaraPallet'   ,,,,,,,'TARA Pallet',1)
			TGet():New(0, 65, bSetGet(nTaraEmbalagem), oLayer:getLinePanel('pesos') ,  50, 16, getMask("ZI3_TARAEB"), {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'nTaraEmbalagem',,,,,,,'TARA Média Embs.',1)
			TGet():New(0,125, bSetGet(nQuantCaixas)  , oLayer:getLinePanel('pesos') ,  25, 16, getMask("ZI3_QTDCX") , {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'nQuantCaixas'  ,,,,,,,'Qtd. Cxs',1)
			TGet():New(0,160, bSetGet(nPesoBruto)    , oLayer:getLinePanel('pesos') ,  50, 16, getMask("ZI3_PESOB") , {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'nPesoBruto'    ,,,,,,,'Peso Bruto',1)
			TGet():New(0,220, bSetGet(nPesoLiquido)  , oLayer:getLinePanel('pesos') ,  50, 16, getMask("ZI3_QUANT") , {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'nPesoLiquido'  ,,,,,,,'Peso Liquido',1)
		Else
			TGet():New(0,  5, bSetGet(nQuant)   , oLayer:getLinePanel('pesos') ,  50, 16, getMask("ZI3_QUANT"), {|| .T. },,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,'nQuant'   ,,,,,,,'Quantidade',1)
		EndIF

		TSay():New(0,5,{|| "<b>Qual a Condição do Pallet?<b>"},oLayer:getLinePanel('condicao'),,TFont():New(,,-14),,,,.T.,,,240,9,,,,,,.T.)

		TRadMenu():New ( 15,05,aCondicao,bSetGet(nCondicao),oLayer:getLinePanel('condicao'),,,,,,,,240,12,,,,.T.,.T.)
	EndIF

	oPanel := oLayer:getLinePanel('observacao')
	tMultiget():new( 0, 5, bSetGet(cObservacao),  oPanel, __DlgWidth(oPanel)-10, __DlgHeight(oPanel)-10, /*fonte*/, , , , , .T.,,,/*when*/,,,/*read*/,/*valid*/,,,/*border*/,.T.,"Observação",1)

    oBrowse := FWBrowse():New()
	oBrowse:SetDescription("")
	oBrowse:setOwner(oLayer:getLinePanel('naoConf'))
	oBrowse:setDataTable()
	oBrowse:SetAlias("SAG")
	oBrowse:SetDoubleClick( { || markArray(@aMarkNC, AG_NAOCON) } )
	oBrowse:AddMarkColumns({|| IIF( aScan(aMarkNC,{|cod| cod == AG_NAOCON }) > 0 , "LBOK", "LBNO" ) },{|| markArray(@aMarkNC, AG_NAOCON) },{||})
	oBrowse:setColumns({;
		column('AG_NAOCON',"Codigo") ,;
		column('AG_DESCPO',"Nao Conformidade") ;
	})
	oBrowse:disableReport()
	oBrowse:disableConfig()
	oBrowse:disableFilter()
	oBrowse:activate()

	oModal:addButtons({{"", "Confirmar", {||  IIF(validConfirmacao(nCondicao, cObservacao, aMarkNC), (lContinue := .T., oModal:Deactivate()),) }, "Clique aqui para Enviar",,.T.,.T.}})
	oModal:addButtons({{"", "Voltar", {||  lContinue := .F., oModal:Deactivate() }, "Clique aqui para Enviar",,.T.,.T.}})
	oModal:activate()

	IF lContinue
		cCondicao := left(aCondicao[nCondicao],1)
		cObserv   := cObservacao
		aNC       := aClone(aMarkNC)
	EndIF

return lContinue


/*/{Protheus.doc} validConfirmacao
Validação na confirmação do Pallet

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, se validou
@param nCondicao, numeric, condição do pallet
@param cObservacao, characters, Observação
@param aMarkNC, array, Lista de marcação
@type function
/*/
static function validConfirmacao(nCondicao, cObservacao, aMarkNC)

	//se for Rejeitado
	IF nCondicao == 2
		IF empty(cObservacao)
			Help("",1,"PRE-INSP_OBS",,"Para situação 'Reprovado' a Observação é obrigatória.",4,1)
			return .F.
		EndIF
		IF len(aMarkNC) == 0
			Help("",1,"PRE-INSP_OBS",,"Para situação 'Reprovado' a marcação de pelo menos uma não conformidade é obrigatória.",4,1)
			return .F.
		EndIF
	EndIF

return .T.


/*/{Protheus.doc} markArray
Função para marcação de MarkBrowse em array, ao invés de usar campo OK, adiciona e exclui chave em um array
 !! Não tem opção de inversão

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, sempre verdadeiro
@param aArray, array, Lista de marcado
@param cCodigo, characters, chave
@type function
/*/
static function markArray(aArray, cCodigo)

	Local nPos := aScan(aArray,{|cod| cod == cCodigo })

	IF nPos == 0
		aAdd(aArray,cCodigo)
	Else
		aDel(aArray,nPos)
		aSize(aArray,len(aArray)-1)
	EndIF

return .T.


/*/{Protheus.doc} makeNewPallet
Função para criar um novo ID de pallet

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return character, ID do Pallet

@type function
/*/
static function makeNewPallet()

	Local cPallet := ''
	Local cAlias  := getNextAlias()

	//o codigo do pallet é formado por
	//[SIF].[VENCIMENTO].[NOTAFISCAL].[sequencial]
	//[SIF][VENCIMENTO][NOTAFISCAL][sequencial]
	IF LOCATION == FRIGORIFICO
		/*
		cPallet := alltrim(cSIF)
		//cPallet += '.'
		//dia(2)+mes(2)+ano(2)
		//cPallet += left(DtoS(dValidade),4) + right(DtoS(dValidade),2)
		cPallet += right(DtoS(dValidade),6)
		//cPallet += '.'
		cPallet += noZeroOrSpaceOnLeft(ZI1->ZI1_DOC)
	//	cPallet += alltrim(ZI1->ZI1_SERIE)
		//cPallet += '.'
		*/
		//NOVO ESCOPO DE STRING DO LOTECTL: dtavenc(dd/mm).sequencialpallet(9999).
		cPallet := strZero( day(dValidade), 2 )
		cPallet += strZero( month(dValidade), 2 )
		cPallet += '.'

		BeginSQL Alias cAlias

			select max(ZI3_PALLET) as ZI3_PALLET
			from %table:ZI3%

			where
				ZI3_FILIAL = %xFilial:ZI3%
			and ZI3_ID     = %Exp: cID %
			and ZI3_PROD   = %Exp: cProduto %
			//and ZI3_SIF    = %Exp: cSIF %
			and D_E_L_E_T_ = ' '
		EndSQL

		IF ! empty( (cAlias)->ZI3_PALLET )
			cPallet += soma1( right( alltrim((cAlias)->ZI3_PALLET), 3 ) )
		Else
			cPallet += '001'
		EndIF

		//fecha
		(cAlias)->( dbCloseArea() )
	Else
		//gera numeração do LOTE
		cPallet := NextLote(SB1->B1_COD,"L")
	EndIF

return cPallet


/*/{Protheus.doc} noZeroOrSpaceOnLeft
Função para retirar os zeros ou espaços a esquerda de uma string

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return character, string sem zeros a esquerda
@param cString, characters, string para tratamento
@type function
/*/
Static Function noZeroOrSpaceOnLeft(cString)
	While left(cString,1) $ "0 "
		cString := substr(cString,2)
	EndDO
Return alltrim(cString)



/*/{Protheus.doc} calcPesoLiquido
Função para calcular o peso Liquido

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, sempre true (a validação é no botão)
@param nTaraPallet, numeric, Tara do Pallet
@param nTaraEmbalagem, numeric, Tara média das embalagens
@param nQuantCaixas, numeric, Quantiade de embalagens
@param nPesoBruto, numeric, Peso Bruto
@param nPesoLiquido, numeric, @ Peso Liquido
@type function
/*/
static function calcPesoLiquido(nTaraPallet, nTaraEmbalagem, nQuantCaixas, nPesoBruto, nPesoLiquido)

	//subtrai a tara do pallet do peso bruto
	Local nPeso := (nPesoBruto - nTaraPallet)

	//subtrai do peso, a multiplicação da tara media das embalagens pela quantidade de caixas
	nPeso -= (nTaraEmbalagem * nQuantCaixas)

	//se o peso for menor que zero
	IF nPeso < 0
		//zera
		nPeso := 0
	EndIF

	//e atualiza o campo peso liquido
	nPesoLiquido := nPeso

return .T.



/*/{Protheus.doc} telaLotes
Função para montagem da tela de lotes dentro da tela de inspeção

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@param oPanel, object, painel onde será montado
@type function
/*/
static function telaLotes(oPanel)

	//calculo para fixar o tamanho do cabeçalho
	Local nTamForm
	Local oFont  := TFont():New('Arial',,-26)
	Local oLayer := FWLayer():New()

	Local aColumns := {}

	oLayer:init( oPanel, .T. )

	cSIF      := CriaVar('ZI3_SIF')
	dValidade := StoD('')
	cLote     := CriaVar('ZI4_LTEMB')

	//se for frigorifico, buscar sifs abertos
	IF LOCATION == FRIGORIFICO
		lLoteOK := getOpenSif()
	EndIF

	//tela para FRIGORIFICO (com mais campos)
	IF LOCATION == FRIGORIFICO
		nTamForm := int( 140 / oPanel:nHeight * 100)
		oLayer:addLine( 'form', nTamForm )

		aGets['SIF'] := TGet():New(0,  5, bSetGet(cSIF)     , oLayer:getLinePanel('form') ,  85, 20, "",{|| .T. },,,oFont,.F.,,.T.,,.F.,{|| ! lLoteOK },.F.,.F.,,.F.,.F.,,'cSIF'  ,,,,,,,'S.I.F.',1)
		TGet():New(0,100, bSetGet(dValidade), oLayer:getLinePanel('form') ,  85, 20, "",{|| .T. },,,oFont,.F.,,.T.,,.F.,{|| ! lLoteOK },.F.,.F.,,.F.,.F.,,'dValidade'  ,,,,,,,'Validade',1)
		aGets['LOTE'] := TGet():New(35, 5, bSetGet(cLote)     , oLayer:getLinePanel('form') ,  85, 16, "",{|| .T. },,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,'cLote'  ,,,,,,,'Lote ou Embarque',1)
		TButton():New( 42.5, 100, "Confirmar", oLayer:getLinePanel('form'), {|| validAndStoreLote(@cLote) }, 50,18,,/*oFont*/,.T.,.T.,.F.,,.F.,{|| .T. },,.F. )

		aAdd( aColumns, column("ZI4_SIF") )
		aAdd( aColumns, column("ZI4_LTEMB", "Lote/Embarque") )
	EndIF

	//tela para MERCEARIA (com menos campos)
	IF LOCATION == MERCEARIA
		nTamForm := int( 70 / oPanel:nHeight * 100)
		oLayer:addLine( 'form', nTamForm )

		aGets['LOTE'] := TGet():New(0, 5, bSetGet(cLote)     , oLayer:getLinePanel('form') ,  65, 16, "",{|| .T. },,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,'cLote'  ,,,,,,,'Lote',1)
		TGet():New(0,80, bSetGet(dValidade), oLayer:getLinePanel('form') ,  65, 16, "",{|| .T. },,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,'dValidade'  ,,,,,,,'Validade',1)
		TButton():New( 7.5, 155, "Confirmar", oLayer:getLinePanel('form'), {|| validAndStoreLote(@cLote) }, 50,18,,/*oFont*/,.T.,.T.,.F.,,.F.,{|| .T. },,.F. )

		aAdd( aColumns, column("ZI4_LTEMB", "Lote") )
		aAdd( aColumns, column("ZI4_VALID", "Validade") )
	EndIF

	//hortifruti esta no telaPallets porque só tem validade (e apenas uma, sem grid)

	//e monta o grid de lotes
	oLayer:addLine( 'grid', 100-nTamForm )

	aGets['brwLotes'] := FWBROWSE():New()
	aGets['brwLotes']:SetOwner( oLayer:GetLinePanel('grid') )
	aGets['brwLotes']:SetDataTable()
	aGets['brwLotes']:setAlias("ZI4")
	aGets['brwLotes']:DisableReport()
	aGets['brwLotes']:setFilterDefault("ZI4->ZI4_FILIAL == '"+xFilial("ZI4")+"' .And. ZI4->ZI4_ID == '"+ cID +"' .And. ZI4->ZI4_PROD == '"+ cProduto +"' .And. ZI4->ZI4_SIF == '"+cSIF+"'")
	aGets['brwLotes']:AddStatusColumns({|| "br_cancel" }, {|| delLote() })
	aGets['brwLotes']:SetColumns(aColumns)
	aGets['brwLotes']:SetTotalDefault('ZI4_FILIAL','COUNT','Lotes')
	aGets['brwLotes']:Activate()

return



/*/{Protheus.doc} delLote
Função para excluir lotes

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
static function delLote()

	Local lExcluiLote := .F.
	Local lExcluiPallet := .F.

	//se for o unico lote do SIF
	IF sifExists() == 1

		//e existir pallets
		ZI3->( dbSetOrder(1) )
		ZI3->( dbSeek( xFilial("ZI3") + cID + cProduto + cSIF ) )

		IF ZI3->( Found() )
			//precisa excçuir os pallets
			lExcluiPallet := Aviso('Excluir','Para excluir o ultimo lote do SIF, precisa excluir os pallets pasedos, Confirmar a excluisão do Lote/Embarque ' + alltrim(ZI4->ZI4_LTEMB) + ' e dos pallets?',{'Confirmar','Cancelar'},1) == 1
			IF ! lExcluiPallet
				return
			EndIF
		EndIF
	EndIF

	IF ! lExcluiPallet
		lExcluiLote := Aviso('Excluir','Confirmar a excluisão do Lote/Embarque ' + alltrim(ZI4->ZI4_LTEMB) + '?',{'Confirmar','Cancelar'},1) == 1
	EndIF

	IF lExcluiLote .Or. lExcluiPallet

		begin transaction

		event("Lote excluido","O Lote/Embarque " + alltrim(ZI4->ZI4_LTEMB)+ " foi excluído" +IIF(LOCATION==FRIGORIFICO," SIF " + alltrim(cSIF), "")+ "." )

		Reclock("ZI4",.F.)
		ZI4->( dbDelete() )
		ZI4->( MsUnlock() )

		aGets['brwLotes']:refresh(.T.)

		IF lExcluiPallet
			While ! ZI3->( Eof() ) .And. ZI3->(ZI3_FILIAL+ZI3_ID+ZI3_PROD+ZI3_SIF) == xFilial("ZI3") + cID + cProduto + cSIF

				Reclock("ZI2",.F.)
				ZI2->ZI2_INSP   -= ZI3->ZI3_QUANT
				ZI2->ZI2_STATUS := 'I' //Inspecionando
				ZI2->( MsUnlock() )

				Reclock("ZI3",.F.)
				ZI3->( dbDelete() )
				ZI3->( MsUnlock() )

				ZI3->(dbSkip())
			EndDO

			cSIF      := CriaVar('ZI3_SIF')
			dValidade := StoD('')
			lLoteOK := .F.

			//atualiza browse de pallets
			bpRefresh()

			//e atualiza os totalizadores
			totals()

			//volta o foco para o campo SIF
			aGets['SIF']:SetFocus()

		EndIF

		end transaction
	EndIF

return


/*/{Protheus.doc} validAndStoreLote
Validação e gravação de lotes para todos os tipos de inspeção
 Frigorifico (SIF, Lote e Validade)
 Mercearia (Lote e Validade)
 Hortifruti (apenas Validade)

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@param cLote, characters, Numero do Lote
@type function
/*/
static function validAndStoreLote(cLote)

	Local newRecno

	//se algum campo estiver vazio, ja retorna
	IF empty(dValidade)
		return
	EndIF

	//não tem lote no Hortifruti
	IF LOCATION != HORTIFRUTI .And. empty(cLote)
		return
	EndIF

	//valida o SIF apenas no Frigorifico
	IF LOCATION == FRIGORIFICO .And. empty(cSIF)
		return
	EndIF

	//SIF novo
	IF LOCATION == FRIGORIFICO .And. ( lLoteOK == nil .Or. ! lLoteOK ) .And. sifExists() > 0
		//mensagem
		Help("",1,"PRE-INSP_SIF",,"O SIF "+alltrim(cSIF)+" já foi inspecionado.",4,1)
		//volta no campo SIF
		aGets['SIF']:SetFocus()
		//e retorna
		return
	EndIF

	//grava o embarque
	Reclock("ZI4",.T.)
	ZI4->ZI4_FILIAL := xFilial("ZI4")
	ZI4->ZI4_ID     := ZI1->ZI1_ID
	ZI4->ZI4_PROD   := ZI2->ZI2_PROD
	ZI4->ZI4_SIF    := cSIF
	ZI4->ZI4_VALID  := dValidade
	IF ! empty(cLote)
		ZI4->ZI4_LTEMB  := cLote
	EndIF
	ZI4->( MsUnlock() )

	newRecno := ZI4->(Recno())

	Reclock("ZI2",.F.)
	ZI2->ZI2_STATUS := 'I' //Inspecionando
	ZI2->( MsUnlock() )

	//e não permite que altere o SIF/validade
	lLoteOK := .T.

	 //hortifruti não tem lote, logo não tem grid
	IF LOCATION != HORTIFRUTI
		//limpa o lote/embarque
		cLote := CriaVar('ZI4_LTEMB')

		aGets['LOTE']:Refresh()
		aGets['LOTE']:SetFocus()


		//e posiciona no registro novo
		aGets['brwLotes']:setFilterDefault("ZI4->ZI4_FILIAL == '"+xFilial("ZI4")+"' .And. ZI4->ZI4_ID == '" + cID + "' .And. ZI4->ZI4_PROD == '" + cProduto + "' .And. ZI4->ZI4_SIF == '" + cSIF + "'")
		aGets['brwLotes']:goTo( newRecno, .T. )

		bpRefresh()
	EndIF

return


/*/{Protheus.doc} getOpenSif
Função para selecionar um SIF ja iniciado

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return logical, se selecionou um SIF
@type function
/*/
static function getOpenSif()

	Local lContinue := .F.

	Local oModal
	Local oHeader
	Local oPanel

	Local oBrowse

	ZI4->( dbSetOrder(1) )
	ZI4->( dbSeek( xFilial("ZI4") + ZI1->ZI1_ID + ZI2->ZI2_PROD ) )

	IF ! ZI4->( Found() )
		return .F.
	EndIF

	oModal	:= FWDialogModal():New()
	oModal:SetEscClose(.T.)
	oModal:setTitle("S.I.F.s existentes para o produto")
	oModal:setSize(200, 280)
	oModal:enableFormBar(.T.)
	oModal:createDialog()

    oHeader       := tPanel():New(01,01,,oModal:getPanelMain(),,,,,,100,20)
    oHeader:Align := CONTROL_ALIGN_TOP

	TSay():New(5,5,{|| "<b>Existem S.I.F.s já iniciados para este produto, duplo clique para continuar um deles</b>"},oHeader,,TFont():New(,,-14),,,,.T.,,,240,9,,,,,,.T.)

    oPanel       := tPanel():New(01,01,,oModal:getPanelMain(),,,,,,100,20)
    oPanel:Align := CONTROL_ALIGN_ALLCLIENT

    oBrowse := FWBrowse():New()
	oBrowse:SetDescription("")
	oBrowse:setOwner(oPanel)
	oBrowse:setDataQuery()
	oBrowse:SetAlias( getNextAlias() )
	oBrowse:setQuery(makeQuerySIF())
	oBrowse:setColumns({;
		column('ZI4_SIF') ,;
		column('ZI4_VALID',,{|| StoD(ZI4_VALID) }) ;
	})
	oBrowse:disableReport()
	oBrowse:disableConfig()
	oBrowse:disableFilter()
	oBrowse:SetDoubleClick( { || ZI4->( DbGoTo( (oBrowse:alias())->ZI4RECNO ) ), lContinue := .T. , oModal:Deactivate() } )
	oBrowse:activate()

	oModal:addButtons({{"", "Novo S.I.F.", {|| oModal:Deactivate() }, "Clique aqui para Enviar",,.T.,.T.}})
	oModal:addButtons({{"", "Continuar"  , {|| ZI4->( DbGoTo( (oBrowse:alias())->ZI4RECNO ) ), lContinue := .T. , oModal:Deactivate() }, "Clique aqui para Enviar",,.T.,.T.}})

	oModal:activate()

	IF lContinue
		cSIF      := ZI4->ZI4_SIF
		dValidade := ZI4->ZI4_VALID
	EndIF

return lContinue


/*/{Protheus.doc} makeQuerySIF
Monta consulta agrupando os registros por SIF e Validade

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return character, query

@type function
/*/
static function makeQuerySIF()

	Local cQuery := ''

	cQuery += "select ZI4_SIF, ZI4_VALID, max(R_E_C_N_O_) ZI4RECNO"
	cQuery += " from " + retSqlName("ZI4")
	cQuery += " where"
	cQuery += "     ZI4_FILIAL = '" + xFilial("ZI4") + "'"
	cQuery += " and ZI4_ID     = '" + ZI1->ZI1_ID + "'"
	cQuery += " and ZI4_PROD   = '" + ZI2->ZI2_PROD + "'"
	cQuery += " and D_E_L_E_T_ = ' '"
	cQuery += " group by ZI4_SIF, ZI4_VALID"

return cQuery




/*/{Protheus.doc} getPreNota
Tela para usuário selecionar a nota

@author Rafael Ricardo Vieceli
@since 26/04/2018
@version 1.0
@return logical, se selecionou uma nota valida
@type function
/*/
static function getPreNota()

	Local lContinue := .F.
	Local oModal

	Local oFont := TFont():New('Arial',,-16)

	Local cChavNFE := CriaVar('F1_CHVNFE')

	Local cDocumento  := CriaVar('F1_DOC')
	Local cSerie      := CriaVar('F1_SERIE')
	Local cFornecedor := CriaVar('F1_FORNECE')
	Local cLoja       := CriaVar('F1_LOJA')

	Local oGet

	oModal	:= FWDialogModal():New()
	oModal:SetEscClose(.T.)
	oModal:setTitle("Chave pré nota de entrada | " + LOCATION)
	oModal:setSize(100, 250)
	oModal:enableFormBar(.T.)
	oModal:createDialog()

	//para hortifruti, precisa informar Documento e Fornecedor
	IF LOCATION == HORTIFRUTI
		oGet := TGet():New(10, 20, bSetGet(cDocumento) , oModal:getPanelMain() , 60, 16, "",,,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,"SF1PIN",'SF1->F1_DOC'    ,,,,,,,'Número',1)
		TGet():New(10, 90, bSetGet(cSerie)     , oModal:getPanelMain() , 20, 16, "",,,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,'SF1->F1_SERIE'  ,,,,,,,'Série',1)
		TGet():New(10,120, bSetGet(cFornecedor), oModal:getPanelMain() , 60, 16, "",,,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,'SF1->F1_FORNECE' ,,,,,,,"Fornecedor",1)
		TGet():New(10,190, bSetGet(cLoja)      , oModal:getPanelMain() , 30, 16, "",,,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,'SF1->F1_LOJA'    ,,,,,,,'Loja',1)
	Else
		oGet := TGet():New(10,20, bSetGet(cChavNFE),oModal:getPanelMain(), 210, 20 , "@S44",,,,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cChavNFE',,,,,,,'Chave da NFe SEFAZ',1,oFont)
	EndIF

	oModal:addButtons({{"", "Confirmar", {|| IIF( lContinue := validaChaveNFE(@cChavNFE, @cDocumento, @cSerie, @cFornecedor, @cLoja), oModal:Deactivate(), ) }, "Clique aqui para Enviar",,.T.,.T.}})
	oModal:addButtons({{"", "Fechar", {|| oModal:Deactivate() }, "Clique aqui para Enviar",,.T.,.T.}})

	oModal:setInitBlock({|| oGet:setFocus() })
	oModal:Activate()

return lContinue


/*/{Protheus.doc} validaChaveNFE
Validação da chave nfe da nota ou documento + fornecedor

@author Rafael Ricardo Vieceli
@since 26/04/2018
@version 1.0
@return logical, se a chave é valida
@param cChave, characters, Chave NFE
@param cDocumento, characters, Documento
@param cSerie, characters, Serie
@param cFornecedor, characters, Fornecedor
@param cLoja, characters, Loja
@type function
/*/
static function validaChaveNFE(cChave, cDocumento, cSerie, cFornecedor, cLoja)

	IF LOCATION == HORTIFRUTI .And. ( empty(cDocumento) .Or. empty(cSerie) .Or. empty(cFornecedor) .Or. empty(cLoja) )
		return .F.
	EndIF

	IF LOCATION != HORTIFRUTI .And. empty(cChave)
		return .F.
	EndIF

	IF LOCATION == HORTIFRUTI

		//procura a nota pelo documento + fornecedor
		SF1->( dbSetOrder(1) )
		SF1->( dbSeek( xFilial("SF1") + cDocumento + cSerie + cFornecedor + cLoja ) )

		//limpa a chave
		cDocumento  := CriaVar('F1_DOC')
		cSerie      := CriaVar('F1_SERIE')
		cFornecedor := CriaVar('F1_FORNECE')
		cLoja       := CriaVar('F1_LOJA')

		IF ! SF1->( Found() )
			Help("",1,"PRE-INSP_NAOEXISTE",,"A nota não foi encontrada com o documento informado.",4,1)
			return .F.
		EndIF

	Else

		//procura a nota pela chave
		SF1->( dbSetOrder(8) )
		SF1->( dbSeek( xFilial("SF1") + cChave ) )

		//limpa a chave
		cChave := CriaVar('F1_CHVNFE')

		IF ! SF1->( Found() )
			Help("",1,"PRE-INSP_NAOEXISTE",,"A nota não foi encontrada com esta chave.",4,1)
			return .F.
		EndIF

	EndIF

	//valida se há itens para inspeção
	IF Empty(SF1->F1_PIPSTAT)
		Help("",1,"PRE-INSP_NAO",,"Não é possivel fazer a inspeção desta nota, pois não há produtos configurados para inspeção.",4,1)
		return .F.
	EndIF

	//valida se já se a inspeção já foi finalizada
	IF SF1->F1_PIPSTAT != "B"
		Help("",1,"PRE-INSP_JA",,"Não é possivel fazer a inspeção desta nota, pois a nota "+alltrim(SF1->F1_DOC)+"/"+alltrim(SF1->F1_SERIE)+" já foi inspecionada.",4,1)
		return .F.
	EndIF

	//valida se a nota já foi classificada
	IF ! Empty(SF1->F1_STATUS)
		Help("",1,"PRE-INSP_NFECLASS",,"Não é possivel fazer a inspeção desta nota, pois já foi classificada ou está bloqueada.",4,1)
		return .F.
	EndIF

return .T.



/*/{Protheus.doc} column
Função para montar colunas para FWBrowse

@author Rafael Ricardo Vieceli
@since 18/04/2018
@version 1.0
@return object, classe FWBrwColumn
@param cField, characters, Nome do campo
@param cTitle, characters, Descrição para o campo (opctional)
@type function
/*/
static function column(cField, cTitle, bData)

	Local oFWColumn := FWBrwColumn():New()

	SX3->( dbSetOrder(2) )
	SX3->( dbSeek( cField ) )

	default cTitle := X3Titulo()
	default bData := &('{ || ' + cField + ' }')

	oFWColumn:SetTitle(cTitle)
	oFWColumn:SetData(bData)
	oFWColumn:SetType(SX3->X3_TIPO)
	oFWColumn:SetPicture(SX3->X3_PICTURE)
	oFWColumn:SetSize(SX3->X3_TAMANHO)
	oFWColumn:SetDecimal(SX3->X3_DECIMAL)
	oFWColumn:SetAlign( IIF(SX3->X3_TIPO == "N",COLUMN_ALIGN_RIGHT,IIF(SX3->X3_TIPO == "D",COLUMN_ALIGN_CENTER,COLUMN_ALIGN_LEFT)) )

	IF ! empty( X3CBOX() )
		oFWColumn:setOptions(StrTokArr( X3CBOX(), ';' ))
	EndIF

return oFWColumn



/*/{Protheus.doc} getTipo
Função facilitadora para pegar o define com o tipo (ZI1_TIPO)

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return character, tipo conforme define
@param cTipo, characters, tipo conforme campo
@type function
/*/
static function getTipo(cTipo)
	IF cTipo == "F"
		return FRIGORIFICO
	EndIF
	IF cTipo == "H"
		return HORTIFRUTI
	EndIF
return MERCEARIA


/*/{Protheus.doc} MDRPreInsp
Função para verificar se a Pre Inspeção customizada do Madero esta Ativa

@author Rafael Ricardo Vieceli
@since 25/04/2018
@version 1.0
@return logical, ativa

@type function
/*/
user function MDRPreInsp()
return SuperGetMV("MDR_PREINS",,.F.)


/*/{Protheus.doc} sifExists
Verifica quantos lotes existem para aquele SIF (agrupador de lotes)

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return numeric, quantidade de lotes para o SIF

@type function
/*/
static function sifExists()

	Local cAlias  := getNextAlias()
	Local nExists := 0

	BeginSQL Alias cAlias
		SELECT count(1) as NR
		FROM %table:ZI4%
		WHERE
			ZI4_FILIAL = %xFilial:ZI4%
		AND ZI4_ID     = %Exp: cID %
		AND ZI4_PROD   = %Exp: cProduto %
		AND ZI4_SIF    = %Exp: cSIF %
		AND D_E_L_E_T_ = ' '
	EndSQL

	nExists := (cAlias)->NR

	(cAlias)->( dbCloseArea() )

return nExists


/*/{Protheus.doc} totals
Função para totalizar o grid de pallets

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
static function totals()

	Local cAlias   := getNextAlias()

	//faz consulta sobre o produto
	//sem problemas para Mercearia e Hortifruti
	//para Frigorifico, faz o sum com case para somar apenas no SIF
	BeginSQL Alias cAlias
		%noparser%
		select sum(ZI3_QUANT) PROD, sum(case ZI3_SIF when %Exp: cSIF % then ZI3_QUANT else 0 end) as SIF
		from %table:ZI3%
		where
			ZI3_FILIAL = %xFilial:ZI3%
		and ZI3_ID     = %Exp: cID %
		and ZI3_PROD   = %Exp: cProduto %
		and D_E_L_E_T_ = ' '
	EndSQL

	aGets['TOT_PROD']  := (cAlias)->PROD
	aGets['TOT_SALDO'] := (cAlias)->PROD-ZI2->ZI2_QUANT

	IF LOCATION == FRIGORIFICO
		aGets['TOT_SIF']   := (cAlias)->SIF
	EndIF

	(cAlias)->( dbCloseArea() )

return


/*/{Protheus.doc} getMask
Função para buscar a mascara usando apenas o campo, sem o alias

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return character, retorna da função PesqPict
@param cField, characters, campo para busca
@type function
/*/
static function getMask(cField)

	Local cAlias := AliasCpo(cField)

	IF empty(cAlias) .Or. (cAlias)->( FieldPOS(cField) ) == 0
		return "@E 999,999.9999"
	EndIF

return PesqPict(cAlias,cField)


/*/{Protheus.doc} bpRefresh
Faz refresh do browse de pallets, após atualiza do filtro padrão

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
static function bpRefresh()

	//atualiza browse de pallets
	aGets['brwPallets']:setFilterDefault("ZI3->ZI3_FILIAL == '"+xFilial("ZI3")+"' .And. ZI3->ZI3_ID == '" + cID + "' .And. ZI3->ZI3_PROD == '" + cProduto + "' .And. ZI3->ZI3_SIF == '" + cSIF + "'")
	aGets['brwPallets']:refresh(.T.)

return


/*/{Protheus.doc} blRefresh
Faz refresh do browse de lotes, após atualiza do filtro padrão

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0

@type function
/*/
static function blRefresh()

	//atualiza browse de pallets
	aGets['brwLotes']:setFilterDefault("ZI4->ZI4_FILIAL == '"+xFilial("ZI4")+"' .And. ZI4->ZI4_ID == '" + cID + "' .And. ZI4->ZI4_PROD == '" + cProduto + "' .And. ZI4->ZI4_SIF == '" + cSIF + "'")
	aGets['brwLotes']:refresh(.T.)

return


/*/{Protheus.doc} ZI2StatusComboBox
Função para definir as opções do combobox do campo ZI2_STATUS, pois o tamanho do campo X3_CBOX não cabe

@author Rafael Ricardo Vieceli
@since 05/2018
@version 1.0
@return character, opções do combo box

@type function
/*/
user function ZI3StatusComboBox()

	Local cBox := ''

//	cBox += 'PD=Pendente;'
//	cBox += 'EI=Em Inspeção;'
	cBox += 'AC=Aguardando Classificação;'
	cBox += 'AD=Aguardando Devolução;'
	cBox += 'AE=Aguardando Excedente;'
	cBox += 'MO=Movimentado;'
	cBox += 'BX=Baixado Manualmente;'
	cBox += 'BN=Baixado via NFEntrada ou NFDevolução'

Return cBox



/*/{Protheus.doc} event
Registros eventos durante a inspeção, salvando QUEM, QUANDO e O QUE FEZ

@author Rafael Ricardo Vieceli
@since 15/05/2018
@version 1.0
@param cEvento, characters, Nome do evento
@param cObservacao, characters, Observação do evento
@type function
/*/
static function event(cEvento, cObservacao)

	Reclock("ZI7",.T.)
	ZI7->ZI7_FILIAL := xFilial("ZI1")
	ZI7->ZI7_ID     := ZI1->ZI1_ID
	ZI7->ZI7_DATA   := date()
	ZI7->ZI7_HORA   := time()
	ZI7->ZI7_USER   := RetCodUsr()
	ZI7->ZI7_EVENTO := cEvento
	ZI7->ZI7_OBSERV := cObservacao
	ZI7->( MsUnlock() )

return





user function QIE100Estorna()

	//pre inspeção ativa
	IF ! u_MDRPreInsp()
		return
	EndIF

	//estorno da classificação
	IF ! IsInCallStack("A140EstCla")
		return
	EndIF

	//procura a inspeção
	ZI1->( dbSetOrder(1) )
	ZI1->( dbSeek( xFilial("ZI1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

	IF ! ZI1->( Found() )
		return
	EndiF

	ZI6->( dbSetOrder(1) )
	ZI6->( dbSeek( xFilial("ZI6") + ZI1->ZI1_ID   ) )

	While ! ZI6->( Eof() ) .And. ZI6->(ZI6_FILIAL+ZI6_ID) == xFilial("ZI6") + ZI1->ZI1_ID
		Reclock("ZI6",.F.)
		ZI6->( dbDelete() )
		ZI6->( MsUnlock() )
		ZI6->(dbSkip())
	EndDO

	ZI3->( dbSetOrder(1) )
	ZI3->( dbSeek( xFilial("ZI3") + ZI1->ZI1_ID ) )

	While ! ZI3->( Eof() ) .And. ZI3->(ZI3_FILIAL+ZI3_ID) == xFilial("ZI3") + ZI1->ZI1_ID
		Reclock("ZI3",.F.)
		ZI3->ZI3_STATUS := "AC"
		ZI3->( MsUnlock() )
       	ZI3->( dbSkip() )
	EndDO

	//log
	event("Estorno de Classificação", "A nota " +SF1->(F1_FILIAL+"/"+F1_DOC+"/"+F1_SERIE+"/"+F1_FORNECE+"/"+F1_LOJA)+ " - RECNO " +cValToChar(SF1->(Recno()))+" teve a classficação estornada.")

return


user function QIE100Analize()

	Local aArea := {}
	Local nQuant
	Local aItem := {}

	Local aItensMail := {}

	//pre inspeção ativa
	IF ! u_MDRPreInsp()
		return
	EndIF

	//procura a inspeção
	ZI1->( dbSetOrder(1) )
	ZI1->( dbSeek( xFilial("ZI1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

	IF ! ZI1->( Found() )
		return
	EndiF

	aEval({'SD1','SF1','SA2','SB1'},{|alias| aAdd(aArea, getArea(alias))})

	ZI2->( dbSetOrder(1) )
	ZI2->( dbSeek( xFilial("ZI2") + ZI1->ZI1_ID ) )

	While ! ZI2->( Eof() ) .And. ZI2->(ZI2_FILIAL+ZI2_ID) == xFilial("ZI2") + ZI1->ZI1_ID

		nQuant := 0
		aItem  := {}

		SD1->( dbSetOrder(1) )
		SD1->( dbSeek( xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) + ZI2->ZI2_PROD ) )

		While ! SD1->( Eof() ) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO+D1_COD) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO)+ZI2->ZI2_PROD
			IF SD1->D1_PIPSTAT == 'S'
				nQuant += SD1->D1_QUANT
				aAdd(aItem, SD1->( Recno() ) )
			EndIF
			SD1->(dbSkip())
		EndDO

		//se a inspeção do item não foi concluido
		IF ZI2->ZI2_STATUS != "C"
			//(A)lerta de (I)nspeção Não Concluida
			newDivg("AI",0)
			//e salva evento
			event('Inspeção não concluida do item', "Documento classificado, mas a inspeção do produto "+alltrim(ZI2->ZI2_PROD)+" não foi concluida.")
		EndIF

		//inspeção concluida para o item
		IF ZI2->ZI2_STATUS == "C"

			//validação da divergencia
			IF ZI2->ZI2_QUANT != nQuant
				//(A)lerta de (D)divergencia na Classificação
				newDivg("AD",(nQuant-ZI2->ZI2_QUANT))
				//e salva evento
				event('Diferença Quantidade Prenota X Documento', "A inspeção foi criada com quantidade " +cValToChar(ZI2->ZI2_QUANT)+ " da prenota, porém foi classificado com a quantidade " + cValToChar(nQuant) + ".")
			EndIF

			//se a quantidade da nota for menor que a quantidade inspecionada
			//gera divergencia de excedente
			IF nQuant < ZI2->ZI2_INSP
				//(D)ivergencia de (E)Excedente
				newDivg("DE",(ZI2->ZI2_INSP-nQuant))
				//e salva evento
				event('Excedente Inspeção x Documento', "A inspeção do produto "+alltrim(ZI2->ZI2_PROD)+" inspecionou " +cValToChar(ZI2->ZI2_INSP)+ " " + ZI2->ZI2_UM + ", porém foi classificado a quantidade " + cValToChar(nQuant) + ".")
			EndIF

			//se a quantidade da nota for maior que a quantidade inspecionada
			//gera divergencia de excedente
			IF nQuant > ZI2->ZI2_INSP
				//(D)ivergencia de (D)Déficit
				newDivg("DD",(ZI2->ZI2_INSP-nQuant))
				//e salva evento
				event('Déficit Inspeção x Documento', "A inspeção do produto "+alltrim(ZI2->ZI2_PROD)+" inspecionou " +cValToChar(ZI2->ZI2_INSP)+ " " + ZI2->ZI2_UM + ", porém foi classificado a quantidade " + cValToChar(nQuant) + ".")
			EndIF

			//libera lotes do CQ
			liberarLotes(aItem)

		EndIF

		ZI2->(dbSkip())
	EndDO

	event("Classificação da prenota", "A prenota " +SF1->(F1_FILIAL+"/"+F1_DOC+"/"+F1_SERIE+"/"+F1_FORNECE+"/"+F1_LOJA)+ " - RECNO " +cValToChar(SF1->(Recno()))+" foi classificada.")

	//envia e-mail de divergencias
	makeAndSendMail()

	aEval(aArea,{|area| restArea(area)} )

return


static function liberarLotes(aItem)

	Local aMata175 := {}
	Local nItem

	//busca os pallets para o produto
	Local aPallets := getPallets()
	Local nPallet
	Local nSaldo
	Local nQuant

	Local aChangeStatus := {}

	IF len(aPallets) == 0
		return
	EndIF

	//SB1->( dbSetOrder(1) )
	//SB1->( dbSeek( xFilial("SB1") + SD1->D1_COD ) )

	For nItem := 1 to len(aItem)

		//posiciona no item
		SD1->( dbGoTo( aItem[nItem] ) )

		SB1->( dbSetOrder(1) )
		SB1->( dbSeek( xFilial("SB1") + SD1->D1_COD ) )

		//se o NumCQ estiver preenchido
		//IF ! Empty(SD1->D1_NUMCQ)

			aMata175 := {}
			nSaldo   := SD1->D1_QUANT

			SD7->( dbSetOrder("D7EXCQ") )
			SD7->( dbSeek( xFilial("SD7") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD ) )

			IF SD7->( Found() )

				For nPallet := 1 to len(aPallets)

					//se possição 2 [quantidade] e 3 [baixado] estiver igual, já foi baixado totalmente
					IF aPallets[nPallet][2] == aPallets[nPallet][3]
						Loop
					EndIF

					ZI3->( dbGoTo( aPallets[nPallet][4] ) )

					aAdd(aMata175, {})
					//rejeitado
					IF ZI3->ZI3_CONDIC == "R"
						aAdd( aTail(aMata175), { "D7_TIPO"   ,2 ,nil})
					//aprovado/querentena
					Else
						aAdd( aTail(aMata175), { "D7_TIPO"   ,1 ,nil})
					EndIF

					//a quantidade é o Minimo entre saldo o Pallet ( quantidade - usado em outro item da nota) e o Saldo do Item
					nQuant := min(ZI3->ZI3_QUANT - aPallets[nPallet][3],nSaldo)

	                aAdd( aTail(aMata175), { "D7_DATA"   , dDataBase,nil})
	                aAdd( aTail(aMata175), { "D7_QTDE"   , nQuant , nil })
	                aAdd( aTail(aMata175), { "D7_OBS"    , ZI3->ZI3_OBSERV ,nil})
	                aAdd( aTail(aMata175), { "D7_PALLET" , ZI3->ZI3_PALLET , nil})
	                aAdd( aTail(aMata175), { "D7_QTSEGUM", 0 , nil})
	                aAdd( aTail(aMata175), { "D7_MOTREJE", "" , nil})
					//rejeitado
					IF ZI3->ZI3_CONDIC == "R"
						aAdd( aTail(aMata175), { "D7_LOCDEST", GetMV("MDR_CQ",,"98") , nil})
					//aprovado/querentena
					Else
						aAdd( aTail(aMata175), { "D7_LOCDEST", SB1->B1_LOCPAD , nil})
					EndIF
	                aAdd( aTail(aMata175), { "D7_SALDO"  , nil ,nil})
	                aAdd( aTail(aMata175), { "D7_ESTORNO", nil ,nil})

	                aPallets[nPallet][3] += nQuant
	                nSaldo -= nQuant

	                aAdd(aChangeStatus, aPallets[nPallet][4])

	                IF nSaldo <= 0
	                	Exit
	                EndIF
				Next nPallet

				IF len(aMata175) != 0
					//controle de erro
					Private lMsErroAuto := .F.
					//erro em array
					Private lAutoErrNoFile := .T.
					//executa a baixa
					MSExecAuto({|x,y| mata175(x,y)}, aMata175, 4 )
					//se não deu erro
					IF ! lMsErroAuto
						//grava os registro como baixados automaticamente
						aEval(aChangeStatus,{|nRecno| changeStatus(nRecno) })
					Else
						//se deu erro salva no
						event('Erro na baixa do CQ', "Detalhes do erro" + CRLF + getErroAuto() + CRLF + CRLF + "Para os itens"+CRLF+VarInfo('itens',aMata175))
					EndIF
                EndIF

			EndIF
		//EndIF

	Next nItem

return


static function changeStatus(nRecno)

	ZI3->( dbGoTo( nRecno ) )

	Reclock("ZI3",.F.)
	ZI3->ZI3_STATUS := IIF(ZI3->ZI3_CONDIC=="R","AD","MO")
	ZI3->( MsUnlock() )

return


static function getErroAuto()

	Local cErro := ''

	aEval( GetAutoGRLog(), {|line| cErro += (line + CRLF) })

return cErro


static function getPallets()

	Local aPallets := {}

	ZI3->( dbSetOrder(1) )
	ZI3->( dbSeek( xFilial("ZI3") + ZI1->ZI1_ID + ZI2->ZI2_PROD ) )

	While ! ZI3->( Eof() ) .And. ZI3->(ZI3_FILIAL+ZI3_ID+ZI3_PROD) == xFilial("ZI3") + ZI1->ZI1_ID + ZI2->ZI2_PROD
		aAdd( aPallets, { ZI3->ZI3_PALLET, ZI3->ZI3_QUANT, 0, ZI3->( Recno() ) })
       	ZI3->( dbSkip() )
	EndDO

return aPallets


static function newDivg(cTipo, nQuant)

	Reclock("ZI6",.T.)
	ZI6->ZI6_FILIAL := xFilial('ZI6')
	ZI6->ZI6_ID     := ZI2->ZI2_ID
	ZI6->ZI6_PROD   := ZI2->ZI2_PROD
	//AD=Divergencia de Classificação
	//AI=Inspeção Não Concluida
	//DE=Excedente;
	//DD=Déficit
	ZI6->ZI6_TIPO   := cTipo
	ZI6->ZI6_QUANT  := nQuant
	ZI6->( MsUnlock() )

return


static function makeAndSendMail()

	Local cAssunto, cPara, cMensagem

	//posiciona (mesma chave)
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek( xFilial("SA2") + SF1->F1_FORNECE ) )

	IF SA2->( FieldPOS("A2_MAILDIV") ) == 0 .Or. empty(SA2->A2_MAILDIV)
		return
	EndIF

	ZI6->( dbSetOrder(1) )
	ZI6->( dbSeek( xFilial("ZI6") + ZI1->ZI1_ID ) )

	IF ZI6->( Found() )

		cAssunto  := "Divergência Inspeção #"+ZI1->ZI1_ID
		cPara     := alltrim(SA2->A2_MAILDIV)
		cMensagem := L_MQIE100()

		//função do CRM para envio de e-mail conforme parametros padrão do sistema
		IF CRMXEnvMail(/*cFrom*/, cPara, /*cCc*/, /*cBcc*/, cAssunto, cMensagem, /*cAlias*/, /*cCodEnt*/, .T., /*cUserAut*/, /*cPassAut*/)
			event("E-mail de divegencia enviado com Sucesso","E-mail de divergências foi enviado com sucesso para "+cPara+".")
		Else
			event("Falha no envio do e-mail de Divergências","Não foi possivel enviar e-mail de divergências para "+cPara+".")
		EndIF

	EndIF

return


/*/{Protheus.doc} RejeicaoTotal
Função para rejeição total de inspeção

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0

@type function
/*/
static function RejeicaoTotal()

	Local cObserv := {}
	Local aNC := {}, nNC

	IF InspIniciada()
		Help("",1,"PRE-INSP_REJ_TOTAL",,"Não é possivel Rejeitar Totalmente uma inspeção que já foi iniada, exclua e faça novamente.",4,1)
		return .F.
	EndIF

	IF ! confirmaPallet(,,,,,,, @cObserv, @aNC, .T.)
		return .F.
	EndIF

	begin transaction

	//marca a inspeção como Rejeitada
	Reclock("ZI1",.F.)
	ZI1->ZI1_STATUS := 'R'
	ZI1->( MsUnlock() )

	//libera a nota
	Reclock("SF1",.F.)
	SF1->F1_PIPSTAT := "L"
	SF1->( MsUnlock() )

	ZI2->( dbSetOrder(1) )
	ZI2->( dbSeek( xFilial("ZI2") + ZI1->ZI1_ID ) )

	While ! ZI2->( Eof() ) .And. ZI2->(ZI2_FILIAL+ZI2_ID) == xFilial("ZI2") + ZI1->ZI1_ID

		Reclock("ZI2",.F.)
		ZI2->ZI2_INSP   := ZI2->ZI2_QUANT
		ZI2->ZI2_STATUS := "C" //concluido
		ZI2->( MsUnlock() )

		SD1->( dbSeek( xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) + ZI2->ZI2_PROD ) )

		While ! SD1->( Eof() ) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO+D1_COD) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO)+ZI2->ZI2_PROD
			IF SD1->D1_PIPSTAT == 'S'
				Reclock("ZI3",.T.)
				ZI3->ZI3_FILIAL := xFilial("ZI3")
				ZI3->ZI3_ID     := ZI1->ZI1_ID
				ZI3->ZI3_PROD   := SD1->D1_COD
				ZI3->ZI3_PALLET := SD1->D1_LOTECTL
				ZI3->ZI3_SIF    := ""
				ZI3->ZI3_CONDIC := "R" //reprovado
				ZI3->ZI3_OBSERV := cObserv
				ZI3->ZI3_QUANT  := SD1->D1_QUANT
				//aguardando classificação
				ZI3->ZI3_STATUS := "AC"
				ZI3->( MsUnlock() )

				For nNC := 1 to len(aNC)
					SAG->( dbSetOrder(1) )
					SAG->( dbSeek( xFilial("SAG") + aNC[nNC] ) )

					Reclock("ZI5",.T.)
					ZI5->ZI5_FILIAL := xFilial("ZI5")
					ZI5->ZI5_ID     := ZI3->ZI3_ID
					ZI5->ZI5_PROD   := ZI3->ZI3_PROD
					ZI5->ZI5_PALLET := ZI3->ZI3_PALLET
					ZI5->ZI5_CODNC  := SAG->AG_NAOCON
					ZI5->ZI5_DESCNC := SAG->AG_DESCPO
					ZI5->( MsUnlock() )
				Next nNC
			EndIF
			SD1->(dbSkip())
		EndDO

		ZI2->(dbSkip())
	EndDO

	event("Rejeição Total","A nota " +SF1->(F1_FILIAL+"/"+F1_DOC+"/"+F1_SERIE+"/"+F1_FORNECE+"/"+F1_LOJA)+ " - RECNO " +cValToChar(SF1->(Recno()))+" foi Rejeitada Totalmente:" + CRLF + cObserv)

	end transaction

return .T.


/*/{Protheus.doc} InspIniciada
Verifica se a Inspeção foi Iniciada.

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0
@return Logical, Iniciada

@type function
/*/
static function InspIniciada()

	Local lIniciado := .F.

	ZI3->( dbSetOrder(1) )
	ZI3->( dbSeek( xFilial("ZI3") + ZI1->ZI1_ID ) )

	lIniciado := ZI3->( found() )

	IF ! lIniciado
		ZI4->( dbSetOrder(1) )
		ZI4->( dbSeek( xFilial("ZI3") + ZI1->ZI1_ID ) )

		lIniciado := ZI4->( found() )
	EndIF

return lIniciado


/*/{Protheus.doc} MDRTransf2Lote
Função para transferencia de lotes

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0
@return logical, se conseguiu transferir

@type function
/*/
user function MDRTransf2Lote()

	Local aMata261 := {}

	aAdd( aMata261,{})
	aAdd( aTail(aMata261), GETSX8NUM("SD3","D3_DOC") ) //documento
	aAdd( aTail(aMata261), DDataBase ) //e data de emissao

	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial("SB1") + SD7->D7_PRODUTO ) )

	SB8->( dbSetOrder(1) )
	SB8->( dbSeek( xFilial("SB8") + SD7->D7_PRODUTO + SD7->D7_LOCDEST + SD7->D7_LOTECTL ) )

	ZI3->( dbSetOrder(3) )
	ZI3->( dbSeek( xFilial("ZI3") + SD7->D7_PALLET ) )

	ZI4->( dbSetOrder(1) )
	ZI4->( dbSeek( xFilial("ZI4") + ZI3->ZI3_ID + ZI3->ZI3_PROD + ZI3->ZI3_SIF ) )

	//limpa o vetor de itens
	aAdd( aMata261, {})
	aAdd( aTail(aMata261), SB1->B1_COD)           		 	//--01.Produto Origem
	aAdd( aTail(aMata261), SB1->B1_DESC)            	 	//--02.Descricao
	aAdd( aTail(aMata261), SB1->B1_UM)            		 	//--03.Unidade de Medida
	aAdd( aTail(aMata261), SD7->D7_LOCDEST) 				//--04.Local Origem
	aAdd( aTail(aMata261), CriaVar("D3_LOCALIZ",.F.))	 	//--05.Endereco Origem
	aAdd( aTail(aMata261), SB1->B1_COD)           		 	//--06.Produto Destino
	aAdd( aTail(aMata261), SB1->B1_DESC)            	 	//--07.Descricao
	aAdd( aTail(aMata261), SB1->B1_UM)            		 	//--08.Unidade de Medida
	aAdd( aTail(aMata261), SD7->D7_LOCDEST) 				//--09.Armazem Destino
	aAdd( aTail(aMata261), CriaVar("D3_LOCALIZ",.F.))	 	//--10.Endereco Destino
	aAdd( aTail(aMata261), CriaVar("D3_NUMSERI",.F.))	 	//--11.Numero de Serie
	aAdd( aTail(aMata261), SD7->D7_PALLET)	 				//--12.Lote Origem
	aAdd( aTail(aMata261), CriaVar("D3_NUMLOTE",.F.))	 	//--13.Sublote
	aAdd( aTail(aMata261), SB8->B8_DTVALID)	 				//--14.Data de Validade
	aAdd( aTail(aMata261), CriaVar("D3_POTENCI",.F.))	 	//--15.Potencia do Lote
	aAdd( aTail(aMata261), SD7->D7_QTDE)  					//--16.Quantidade
	aAdd( aTail(aMata261), CriaVar("D3_QTSEGUM",.F.))	 	//--17.Quantidade na 2 UM
	aAdd( aTail(aMata261), CriaVar("D3_ESTORNO",.F.))		//--18.Estorno
	aAdd( aTail(aMata261), CriaVar("D3_NUMSEQ" ,.F.))	 	//--19.NumSeq
	aAdd( aTail(aMata261), SD7->D7_PALLET)	 				//--20.Lote Destino
	aAdd( aTail(aMata261), ZI4->ZI4_VALID)	 				//--21.Data de Validade
	IF SuperGetMV("MV_INTDL",,"N") == "S"
		aAdd( aTail(aMata261), CriaVar("D3_SERVIC" ,.F.))	// 22.Cod.Servic
	EndIF
	aAdd( aTail(aMata261), CriaVar("D3_ITEMGRD",.F.))		// 23.Item de Grade
	//aAdd( aTail(aMata261), CriaVar("D3_OBSERVA",.F.))		// 23.Item de Grade

	//tem que fazer o dbSelectArea, senão pode dar erro
	dbSelectArea("SD3")

	//volta pra ordem original
	SD3->( dbSetOrder(1) )

	//controle de erro
	Private lMsErroAuto := .F.
	//erro em array
	Private lAutoErrNoFile := IsInCallStack("u_QIE100Analize")

	//antes de chamar o execAuto
	MSExecAuto({|x,y| mata261(x,y)},aMata261,3)

	//se não deu erro
	IF lMsErroAuto
		IF lAutoErrNoFile
			event("Erro na tranferencia de Lote","Erro na transferencia do Pallet " + alltrim(SD7->D7_PALLET) + CRLF+CRLF + getErroAuto())
		Else
			MostraErro()
		EndIF
	EndIF

return ! lMsErroAuto


/*/{Protheus.doc} MDREstor2Lote
Estorno de Transferencia de lote

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0
@return logical, Se conseguiu estornar

@type function
/*/
user function MDREstor2Lote()

	Local aMata261 := {}

	aAdd( aMata261, {})
	aAdd( aTail(aMata261), {"D3_COD"	, SD3->D3_COD , nil})
	aAdd( aTail(aMata261), {"D3_CHAVE" 	, 'E9' , nil})
	aAdd( aTail(aMata261), {"D3_NUMSEQ" , SD3->D3_NUMSEQ, nil })
	aAdd( aTail(aMata261), {"INDEX"		, 4,})

	//controle de erro
	Private lMsErroAuto := .F.

	MSExecAuto({|x,y| Mata261(x,y)},aMata261,6)

	IF lMsErroAuto
		mostraErro()
	EndIF

return ! lMsErroAuto