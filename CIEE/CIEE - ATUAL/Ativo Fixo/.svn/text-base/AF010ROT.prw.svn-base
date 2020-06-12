#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | AF010ROT    | Autor     | Fabio Zanchim  | Data |    08/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | P.E. adiciona botao no browse                                	|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/  
User Function AF010ROT()
Local _aRot:=Paramixb[1]

Aadd(_aRot,{'Ativo X C.Custo','u_AF010Cus',0,4})

Return(_aRot)

User Function AF010Cus()
Local _nOpc:=3
Local aArea:=GetArea()    
//Local oModel:=FwLoadModel("ATF10PAG_MVC") 
                                                       
dbSelectArea('PAG')
dbSetOrder(1)
If dbSeek(xFilial('PAG')+SN1->N1_CBASE+SN1->N1_ITEM)
//	oModel:SetOperation(MODEL_OPERATION_UPDATE)
//	oModel:Activate()
//	FWExecView ('Cadastro de Ativo X CC', "ATF10PAG_MVC", MODEL_OPERATION_UPDATE, ,{||.T.} , , 40, , ,,,oModel)//Executa a View do Model em ATF10PAG_MVC.prw
	FWExecView ('Cadastro de Ativo X CC', "ATF10PAG_MVC", MODEL_OPERATION_UPDATE, ,{||.T.} , , 20)//Executa a View do Model em ATF10PAG_MVC.prw	
Else
 //	oModel:SetOperation(MODEL_OPERATION_INSERT)
//	oModel:Activate()
//	FWExecView ('Cadastro de Ativo X CC', "ATF10PAG_MVC", MODEL_OPERATION_INSERT, ,{||.T.} , , 40, , ,,,oModel )//Executa a View do Model em ATF10PAG_MVC.prw
	FWExecView ('Cadastro de Ativo X CC', "ATF10PAG_MVC", MODEL_OPERATION_INSERT, ,{||.T.} , , 20)//Executa a View do Model em ATF10PAG_MVC.prw
EndIf

RestArea(aArea)
Return