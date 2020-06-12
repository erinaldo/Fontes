#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | AF010INC    | Autor     | Fabio Zanchim  | Data |    08/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | P.E. após inclusao do Ativo                                 	|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function AF010INC()                             
Local aArea:=GetArea()

If ApMsgYesNo('Deseja cadastrar o vínculo de Ativo X Centro de Custo ?')

	FWExecView ('Cadastro de Ativo X CC', "ATF10PAG_MVC", MODEL_OPERATION_INSERT, ,{||.T.}  , , 20, ,  )//Executa a View do Model em ATF10PAG_MVC.prw

EndIf         

RestArea(aArea)
Return