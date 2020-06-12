#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  |ATF10PAG_MVC | Autor     | Fabio Zanchim  | Data |    08/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Cadastro de Ativos X Centro de Custo                       	|
|           | 														 		|            
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function ATF10PAG_MVC()

Local oBrowse		:= Nil

oBrowse:=FWmBrowse():New()
oBrowse:SetAlias('PAG')    
oBrowse:SetDescription('Cadastro de Ativo X CC')

oBrowse:Activate()

Return()

Static Function MenuDef()
Local aRotina := {}

aAdd( aRotina, { "Pesquisar"	,"PesqBrw"   		    , 0, 1, 0, .T. } ) // "Pesquisar"
aAdd( aRotina, { "Visualizar"	,"VIEWDEF.ATF10PAG_MVC"	, 0, 2, 0, NIL } ) // "Visualizar"
aAdd( aRotina, { "Incluir"		,"VIEWDEF.ATF10PAG_MVC"	, 0, 3, 0, NIL } ) // "Incluir"
aAdd( aRotina, { "Alterar"		,"VIEWDEF.ATF10PAG_MVC"	, 0, 4, 0, NIL } ) // "Alterar"
aAdd( aRotina, { "Excluir"		,"VIEWDEF.ATF10PAG_MVC"	, 0, 5, 0, NIL } ) // "Excluir"

Return aRotina
            
/*----------------------------------------------------------------
*
* ModelDef()
* Definicao do modelo de dados
*
----------------------------------------------------------------*/
Static Function ModelDef()

Local oStructCab := Nil
Local oStructItem:= Nil
Local oModel     := Nil

oStructCab := FWFormStruct(1,"PAG",{|cCampo| AllTrim(cCampo)+"|" $ "PAG_CBASE|PAG_ITEM|PAG_DESC|PAG_CUSBEM|"})
oStructItem := FWFormStruct(1,"PAG",{|cCampo| !AllTrim(cCampo)+"|" $ "PAG_CBASE|PAG_ITEM|PAG_DESC|PAG_CUSBEM|"})

If IsInCallStack('ATFA010')              
	//Não edita pois ja traz conteudo automaticamente.
	oStructCab:SetProperty( 'PAG_CBASE', MODEL_FIELD_WHEN, {|| .F.} )  
	oStructCab:SetProperty( 'PAG_ITEM', MODEL_FIELD_WHEN, {|| .F.} )  
EndIf      

oModel:= MPFormModel():New("ATF10MODEL")
//oModel:= MPFormModel():New("ATF10MODEL",{|| ATF10Pre(oModel)})
oModel:SetDescription("Ativo X CC")

oModel:AddFields("ATF10PAG_CAB",,oStructCab)
oModel:GetModel("ATF10PAG_CAB"):SetDescription("Código do Ativo")

oModel:AddGrid("ATF10PAG_IT", "ATF10PAG_CAB", oStructItem , ,{|x| ATFCCLinOk(x)},/*bPre*/,{|x| ATFCCTOk(x)}/*bPost*/,/*Carga*/)
oModel:GetModel("ATF10PAG_IT"):SetUniqueLine({"PAG_CUSTO"})
oModel:GetModel("ATF10PAG_IT"):SetDescription("Centros de Custo")
//oModel:GetModel("ATF10PAG_IT"):SetNoDeleteLine(.T.)//Nao permite deletar linhas na grid
                          
//Somatorio do percentuial digitado, somente para CC ativos
oModel:AddCalc('ATF10CALC',"ATF10PAG_CAB","ATF10PAG_IT","PAG_PERC","PAGCALC","SUM",{|oMd| oMd:GetModel("ATF10PAG_IT"):GetValue('PAG_STATUS')=="1" })

oModel:SetPrimaryKey({"PAG_FILIAL","PAG_CBASE"})

oModel:SetRelation("ATF10PAG_IT",{{"PAG_FILIAL",'xFilial("PAG")'},{"PAG_CBASE","PAG_CBASE"},{"PAG_ITEM","PAG_ITEM"}},PAG->(IndexKey(1)))

oStructItem:AddTrigger("PAG_PERC","PAG_AUTIL",{|| .T.},{ |oModel| AtfGatAU(oModel) })
                                                                 
//Preenche campos automaticamente quando posicionado no Ativo
oModel:SetActivate({|oModel,oOwner| At10ActMod(oModel,oOwner)  })

Return oModel


/*----------------------------------------------------------------
*
* ViewDef()
* Definicao da interface
*
----------------------------------------------------------------*/
Static Function ViewDef()

Local oView
Local oStructCAB
Local oStructIt
Local oModel  := FWLoadModel("ATF10PAG_MVC")

//oStructCab:= FWFormStruct(2,"PAG")
//oStructIt := FWFormStruct(2,"PAG") 
oStructCab:= FWFormStruct(2,"PAG",{|cCampo| AllTrim(cCampo)+"|" $ "PAG_CBASE|PAG_ITEM|PAG_DESC|PAG_CUSBEM|"})
oStructIt := FWFormStruct(2,"PAG",{|cCampo| !AllTrim(cCampo)+"|" $ "PAG_CBASE|PAG_ITEM|PAG_DESC|PAG_CUSBEM|"})
         
oView := FWFormView():New()
oView:SetModel(oModel)                               
oView:AddField("VIEW_CAB",oStructCab,"ATF10PAG_CAB")
oView:AddGrid("VIEW_IT",oStructIt,"ATF10PAG_IT")

//Totalizador do percentual digitado
oCalc:=FwCalcStruct(oModel:GetModel('ATF10CALC'))
oCalc:SetProperty("PAGCALC",MVC_VIEW_TITULO,'Percentual total (ATIVOS):')
oView:AddField("VIEW_CALC",oCalc,'ATF10CALC')

oView:CreateHorizontalBox("CABEC",30)
oView:CreateHorizontalBox("GRID",55) 
oView:CreateHorizontalBox("TOTPERC",15) 

oView:SetOwnerView( "VIEW_CAB","CABEC")
oView:SetOwnerView( "VIEW_IT","GRID")
oView:SetOwnerView( "VIEW_CALC","TOTPERC")

oView:EnableControlBar(.T.)

//oView:SetViewAction( 'BUTTONOK', { |oView|  PLS790OST() } )
If IsInCallStack('ATFA010') 
	oView:SetCloseOnOk({|| .T.})//Força o fechamento após Ok.
EndIf

Return oView

/*--------------------------------------------------------------------------------
*
* ATF10Pre()
* Pre validacao do modelo - Executa antes de carregar a tela
*
--------------------------------------------------------------------------------*/
Static Function ATF10Pre(oModel)
//Fabio - Bloco de pre validacao nao da refresh na tela, o proposito é outro.. Precisa utilizar o oModel:SetActivate

Local oModelCab:=oModel:GetModel("ATF10PAG_CAB")
//Se for chamada do ponto de entrada, carrega os dados do CBASE ee ITEM
If IsInCallStack('ATFA010')                                   

	//LoadValue Nao executa validação nem trigger
	//oModel:LoadValue("ATF10PAG_CAB","PAG_CBASE",SN1->N1_CBASE)
	//oModel:LoadValue("ATF10PAG_CAB","PAG_ITEM",SN1->N1_ITEM)

	//SetValue Executa validação e trigger		
	//oModelCab:SetValue("PAG_CBASE",SN1->N1_CBASE)
	//oModelCab:SetValue("PAG_ITEM",SN1->N1_ITEM)
	
EndIf

Return(.T.)
         

/*--------------------------------------------------------------------------------
*
* ATFCCLinOk()
* VAlidacao da linha do Grid                     
*
--------------------------------------------------------------------------------*/
Static Function ATFCCLinOk(oModelIt)

Local lRet:=.T. 
Local nPerc:=0
//Local oModelIt	:= oModel:GetModel("ATF10PAG_IT")
Local aSaveLines := FWSaveRows()

For nA := 1 To oModelIt:Length()  
//oModelIt:GetQtdLine()
	oModelIt:GoLine( nA )
	
	If !oModelIt:IsDeleted() .And. oModelIt:GetValue('PAG_STATUS')=="1"//Ativo
	
		nPerc	+= oModelIt:GetValue('PAG_PERC')
	EndIf
Next nA  
If nPerc>100  
	lRet:=.F.
	Help(,,'Help',,'O percentual total digitado é maior que 100%',1,0)
EndIf

FWRestRows( aSaveLines )

Return(lRet)
             
//TudoOk - Valida para que o total digitado seja até 100 %
Static Function ATFCCTOk(oModel) 
Return(ATFCCLinOk(oModel))                                                        

/*--------------------------------------------------------------------------------
*
* AtfCCGat()
* Gatilho do PAG_PERC
*
--------------------------------------------------------------------------------*/
Static Function AtfGatAU(oModel)

Local nAUtil := 0                               
Local aArea:=GetArea()
Local nPerc:=M->PAG_PERC

Local oModel1:=FWModelActive()

Local oModelCab:=oModel1:GetModel("ATF10PAG_CAB")
Local cBase:=oModelCab:GetValue("PAG_CBASE")
Local cItem:=oModelCab:GetValue("PAG_ITEM")

dbSelectAreA('SN1')
dbSetOrder(1)
If dbSeek(xFilial('SN1')+cBase+cItem)
	nAUtil:=(nPerc/100)*N1_AUTIL
EndIf         

RestArea(aArea)
Return(nAUtil)

/*--------------------------------------------------------------------------------
*
* At10ActMod()
* Função executada na ativação do Model
*
--------------------------------------------------------------------------------*/
Static Function At10ActMod(oModel,oOwner) 
                        
Local cCC:=""
Local nOperation:=oModel:GetOperation()

If FunName()=='ATFA010' 
	If nOperation==MODEL_OPERATION_INSERT
	
		cCC:=Posicione('SN3',1,xFilial('SN3')+SN1->N1_CBASE+SN1->N1_ITEM,"N3_CUSTBEM")
		
		oModel:LoadValue("ATF10PAG_CAB","PAG_CBASE",SN1->N1_CBASE)
		oModel:LoadValue("ATF10PAG_CAB","PAG_ITEM",SN1->N1_ITEM)
		oModel:LoadValue("ATF10PAG_CAB","PAG_DESC",SN1->N1_DESCRIC)
		oModel:LoadValue("ATF10PAG_CAB","PAG_CUSBEM",cCC)
		
	EndIf
EndIf

Return